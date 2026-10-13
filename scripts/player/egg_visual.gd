extends Node2D

# EggVisual: Quản lý hiệu ứng hình ảnh mở rộng trên người chơi
# 1. Vết nứt trên vỏ trứng (to dần theo lượng máu giảm)
# 2. Hiệu ứng văng mảnh vỏ (egg shell debris particles) khi trúng đòn
# 3. Vệt chém combo cận chiến

var attack_slash_timer: float = 0.0
var attack_slash_dir: Vector2 = Vector2.DOWN
var attack_slash_step: int = 0
var show_placeholder_body: bool = false

# Dữ liệu vết nứt vỏ trứng (tính theo tỉ lệ hp: 1.0 -> 0.0)
var current_hp_ratio: float = 1.0

# Danh sách mảnh vỏ đang văng: { pos: Vector2, vel: Vector2, color: Color, size: Vector2, life: float, max_life: float }
var shell_shards: Array[Dictionary] = []

func _ready() -> void:
	set_process(true)

func set_hp_ratio(ratio: float) -> void:
	current_hp_ratio = clampf(ratio, 0.0, 1.0)
	queue_redraw()

func spawn_shell_burst(amount: int = 6) -> void:
	# Bắn các mảnh vỏ trứng từ tâm thân nhân vật (y ~ -14)
	for i in range(amount):
		var angle := randf_range(0.0, TAU)
		var speed := randf_range(40.0, 110.0)
		var vel := Vector2(cos(angle), sin(angle)) * speed
		vel.y -= randf_range(20.0, 50.0) # Văng hướng lên trên nhẹ
		
		var colors := [Palette.GIAY_DA, Palette.CAT, Palette.NAU_HAM, Palette.KEM]
		var col: Color = colors[randi() % colors.size()]
		var sz := Vector2(randf_range(1.5, 3.0), randf_range(1.5, 3.0))
		var life := randf_range(0.3, 0.55)
		
		shell_shards.append({
			"pos": Vector2(randf_range(-4.0, 4.0), randf_range(-18.0, -10.0)),
			"vel": vel,
			"color": col,
			"size": sz,
			"life": life,
			"max_life": life
		})
	queue_redraw()

func start_attack_visual(dir: Vector2, step: int) -> void:
	attack_slash_dir = dir
	attack_slash_step = step
	attack_slash_timer = 0.18
	queue_redraw()

func _process(delta: float) -> void:
	var needs_redraw: bool = false
	
	if attack_slash_timer > 0.0:
		attack_slash_timer -= delta
		needs_redraw = true
	
	if not shell_shards.is_empty():
		var idx := shell_shards.size() - 1
		while idx >= 0:
			var shard: Dictionary = shell_shards[idx]
			shard["life"] -= delta
			if shard["life"] <= 0.0:
				shell_shards.remove_at(idx)
			else:
				shard["pos"] += shard["vel"] * delta
				shard["vel"].y += 220.0 * delta # Trọng lực rơi xuống
			idx -= 1
		needs_redraw = true
	
	if needs_redraw:
		queue_redraw()

func _draw() -> void:
	# 1. Vẽ các vết nứt trên vỏ theo mức độ mất máu
	# Nhân vật cao từ y = -22 đến y = -2, tâm khoảng x=0, y=-12
	# Khi HP < 80%: Bắt đầu có vết rạn nhỏ ở đỉnh
	# Khi HP < 50%: Nứt to và rẽ nhánh
	# Khi HP < 25%: Nứt chằng chịt, lộ lòng vàng nhẹ
	if current_hp_ratio < 0.8:
		# Vết nứt đỉnh đầu (giai đoạn 1)
		draw_line(Vector2(-1, -22), Vector2(1, -19), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(1, -19), Vector2(0, -17), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.6:
		# Nhánh nứt kéo dài qua thân trên (giai đoạn 2)
		draw_line(Vector2(0, -17), Vector2(3, -14), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(3, -14), Vector2(2, -11), Palette.NAU_HAM, 1.0)
		# Vết nứt sườn trái
		draw_line(Vector2(-5, -17), Vector2(-2, -15), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(-2, -15), Vector2(-4, -12), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.35:
		# Vết nứt to toác (giai đoạn 3)
		draw_line(Vector2(2, -11), Vector2(5, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(-4, -12), Vector2(-2, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(0, -17), Vector2(-2, -14), Palette.CAT, 1.0)
		# Chấm vàng lộ lòng trứng bên trong kẽ nứt
		draw_rect(Rect2(0, -15, 2, 2), Palette.VANG_CO)
		draw_rect(Rect2(2, -12, 1, 2), Palette.VANG_CO)
	
	# 2. Vẽ các mảnh vỏ trứng đang văng khi dính đòn
	for shard in shell_shards:
		var alpha: float = clampf(shard["life"] / shard["max_life"], 0.0, 1.0)
		var c: Color = shard["color"]
		c.a = alpha
		var sz: Vector2 = shard["size"]
		var p: Vector2 = shard["pos"]
		draw_rect(Rect2(p.x - sz.x * 0.5, p.y - sz.y * 0.5, sz.x, sz.y), c)
	
	# 3. Vệt chém combo đòn đánh cận chiến
	if attack_slash_timer > 0.0:
		var slash_center := Vector2(0, -10) + attack_slash_dir.normalized() * 14.0
		var slash_color: Color = Palette.KEM if attack_slash_step == 2 else Palette.XAM_DA
		var arc_radius: float = 12.0 if attack_slash_step == 2 else 9.0
		var base_angle: float = attack_slash_dir.angle()
		var start_ang: float = base_angle - PI * 0.45
		var end_ang: float = base_angle + PI * 0.45
		draw_arc(slash_center, arc_radius, start_ang, end_ang, 12, slash_color, 2.0)
		draw_arc(slash_center, arc_radius - 2.0, start_ang, end_ang, 12, Palette.NAU_HAM, 1.0)
