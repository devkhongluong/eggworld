extends Node2D

# EggVisual: Quản lý hiệu ứng hình ảnh mở rộng trên người chơi
# 1. Vết nứt trên vỏ trứng (to dần theo lượng máu giảm)
# 2. Hiệu ứng văng mảnh vỏ (egg shell debris particles) khi trúng đòn
# 3. Hoạt ảnh vung kiếm/dao/ná sống động (Dynamic weapon attack swing/thrust/shoot)
# 4. Vệt chém combo đòn đánh tương ứng từng vũ khí
# 5. Hình khối vũ khí giắt bên hông khi nghỉ

var attack_slash_total_time: float = 0.22
var attack_slash_timer: float = 0.0
var attack_slash_dir: Vector2 = Vector2.DOWN
var attack_slash_step: int = 0
var attack_weapon_type: String = "staff_wood"
var is_attacking_visual: bool = false
var show_placeholder_body: bool = false

# Dữ liệu vết nứt vỏ trứng (tính theo tỉ lệ hp: 1.0 -> 0.0)
var current_hp_ratio: float = 1.0

# Danh sách mảnh vỏ đang văng
var shell_shards: Array[Dictionary] = []

# Trạng thái đỡ đòn
var is_guarding: bool = false
var guard_dir: Vector2 = Vector2.DOWN

var is_dead_visual: bool = false
var equipped_weapon_id: String = "staff_wood"
var facing_dir: Vector2 = Vector2.DOWN

func _ready() -> void:
	set_process(true)

func set_guarding(guarding: bool, dir: Vector2) -> void:
	if is_guarding != guarding or guard_dir != dir:
		is_guarding = guarding
		guard_dir = dir
		queue_redraw()

func set_dead(dead: bool) -> void:
	is_dead_visual = dead
	if dead:
		is_attacking_visual = false
		attack_slash_timer = 0.0
	queue_redraw()

func set_hp_ratio(ratio: float) -> void:
	current_hp_ratio = clampf(ratio, 0.0, 1.0)
	queue_redraw()

func set_equipped_weapon(w_id: String, dir: Vector2) -> void:
	equipped_weapon_id = w_id
	facing_dir = dir
	queue_redraw()

func spawn_shell_burst(amount: int = 6) -> void:
	for i in range(amount):
		var angle := randf_range(0.0, TAU)
		var speed := randf_range(40.0, 110.0)
		var vel := Vector2(cos(angle), sin(angle)) * speed
		vel.y -= randf_range(20.0, 50.0)
		
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

func start_attack_visual(dir: Vector2, step: int, weapon_id: String = "staff_wood", custom_duration: float = -1.0) -> void:
	attack_slash_dir = dir.normalized()
	if attack_slash_dir == Vector2.ZERO:
		attack_slash_dir = Vector2.DOWN
	facing_dir = attack_slash_dir
	attack_slash_step = step
	attack_weapon_type = weapon_id
	
	if custom_duration > 0.0:
		attack_slash_total_time = custom_duration
	elif weapon_id == "dagger":
		attack_slash_total_time = 0.14
	elif weapon_id == "sling":
		attack_slash_total_time = 0.18
	else:
		attack_slash_total_time = 0.22
	
	attack_slash_timer = attack_slash_total_time
	is_attacking_visual = true
	queue_redraw()

func stop_attack_visual() -> void:
	is_attacking_visual = false
	attack_slash_timer = 0.0
	queue_redraw()

func _process(delta: float) -> void:
	var needs_redraw: bool = false
	
	if attack_slash_timer > 0.0:
		attack_slash_timer -= delta
		if attack_slash_timer <= 0.0:
			is_attacking_visual = false
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
				shard["vel"].y += 220.0 * delta
			idx -= 1
		needs_redraw = true
	
	if needs_redraw:
		queue_redraw()

func _draw() -> void:
	# 1. Vẽ các vết nứt trên vỏ theo mức độ mất máu
	if current_hp_ratio < 0.8:
		draw_line(Vector2(-1, -22), Vector2(1, -19), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(1, -19), Vector2(0, -17), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.6:
		draw_line(Vector2(0, -17), Vector2(3, -14), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(3, -14), Vector2(2, -11), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(-5, -17), Vector2(-2, -15), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(-2, -15), Vector2(-4, -12), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.35:
		draw_line(Vector2(2, -11), Vector2(5, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(-4, -12), Vector2(-2, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(0, -17), Vector2(-2, -14), Palette.CAT, 1.0)
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
	
	# 3. Vẽ thế Đỡ Đòn (Guard)
	if is_guarding:
		var shield_center := Vector2(0, -10) + guard_dir.normalized() * 11.0
		var guard_angle: float = guard_dir.angle()
		var g_start: float = guard_angle - PI * 0.40
		var g_end: float = guard_angle + PI * 0.40
		draw_arc(shield_center, 9.0, g_start, g_end, 10, Palette.NAU_HAM, 3.5)
		draw_arc(shield_center, 9.0, g_start, g_end, 10, Palette.XAM_SAT, 2.0)
		draw_circle(shield_center, 2.0, Palette.VANG_CO)
	
	# 4. Vẽ diễn hoạt vũ khí & đòn đánh (Hoạt ảnh động)
	_draw_dynamic_weapon()

func _draw_dynamic_weapon() -> void:
	if is_guarding or is_dead_visual:
		return
	
	var pivot := Vector2(0, -10)
	var aim := facing_dir.normalized()
	if aim == Vector2.ZERO:
		aim = Vector2.DOWN
	var base_angle := aim.angle()
	var flip_sign: float = -1.0 if facing_dir.x < 0 else 1.0
	
	if is_attacking_visual:
		# --- TRẠNG THÁI RA ĐÒN: VŨ KHÍ CHUYỂN ĐỘNG THEO PHA ---
		var progress: float = clampf(1.0 - (attack_slash_timer / maxf(0.01, attack_slash_total_time)), 0.0, 1.0)
		
		match attack_weapon_type:
			"staff_wood", "staff":
				# Gậy gỗ vung xoay vòng cung
				var reverse_swing: bool = (attack_slash_step % 2 == 1)
				var start_ang: float = base_angle + PI * 0.52 if reverse_swing else base_angle - PI * 0.52
				var end_ang: float = base_angle - PI * 0.52 if reverse_swing else base_angle + PI * 0.52
				var cur_ang: float = lerp_angle(start_ang, end_ang, progress)
				
				var staff_dir := Vector2(cos(cur_ang), sin(cur_ang))
				var staff_base := pivot + staff_dir * 3.0
				var staff_tip := pivot + staff_dir * 24.0
				
				# Vệt chém hình vòng cung vàng rực bám theo sau mũi gậy
				var arc_rad: float = 23.0 if attack_slash_step == 2 else 19.0
				var a1 := minf(start_ang, cur_ang)
				var a2 := maxf(start_ang, cur_ang)
				draw_arc(pivot, arc_rad, a1, a2, 14, Palette.KEM, 3.0)
				draw_arc(pivot, arc_rad - 2.0, a1, a2, 14, Palette.VANG_CO, 2.0)
				
				# Thân gậy vung
				draw_line(staff_base, staff_tip, Palette.NAU_DA, 3.0)
				draw_circle(staff_tip, 2.5, Palette.KEM)
				draw_circle(staff_base, 1.5, Palette.NAU_HAM)
			
			"dagger":
				# Dao găm đâm thẳng vọt tới trước cực nhanh
				var thrust_dist: float = 4.0
				if progress < 0.20:
					thrust_dist = lerpf(4.0, 0.0, progress / 0.20)
				elif progress < 0.60:
					thrust_dist = lerpf(0.0, 22.0, (progress - 0.20) / 0.40)
				else:
					thrust_dist = lerpf(22.0, 4.0, (progress - 0.60) / 0.40)
				
				var hilt := pivot + aim * thrust_dist
				var tip := pivot + aim * (thrust_dist + 14.0)
				
				# Vệt đâm nhọn ánh sáng lướt theo dao
				draw_line(pivot + aim * 2.0, tip + aim * 5.0, Palette.KEM, 2.5)
				draw_line(pivot + aim * 2.0 + Vector2(-aim.y, aim.x) * 2.5, tip, Palette.XAM_SAT, 1.5)
				draw_line(pivot + aim * 2.0 + Vector2(aim.y, -aim.x) * 2.5, tip, Palette.XAM_SAT, 1.5)
				
				# Lưỡi dao
				draw_line(hilt, tip, Palette.KEM, 2.5)
				draw_line(hilt, tip, Palette.XAM_SAT, 1.5)
				# Chuôi dao
				draw_circle(hilt, 2.0, Palette.NAU_HAM)
				draw_line(hilt + Vector2(-aim.y, aim.x) * 3.0, hilt + Vector2(aim.y, -aim.x) * 3.0, Palette.VANG_CO, 2.0)
			
			"sling":
				# Ná giương chạc và bung dây thun
				var fork_pos := pivot + aim * 9.0
				var fork_l := fork_pos + Vector2(-aim.y, aim.x) * 4.5 + aim * 3.0
				var fork_r := fork_pos + Vector2(aim.y, -aim.x) * 4.5 + aim * 3.0
				var pull_pos := pivot - aim * 3.0 if progress < 0.45 else fork_pos + aim * 2.0
				
				# Cán ná gỗ
				draw_line(pivot, fork_pos, Palette.CAT, 2.5)
				draw_line(fork_pos, fork_l, Palette.CAT, 2.0)
				draw_line(fork_pos, fork_r, Palette.CAT, 2.0)
				# Dây thun
				draw_line(fork_l, pull_pos, Palette.GIAY_DA, 1.5)
				draw_line(fork_r, pull_pos, Palette.GIAY_DA, 1.5)
				if progress < 0.45:
					draw_circle(pull_pos, 2.0, Palette.XAM_SAT)
			
			"unarmed", _:
				var p_dist: float = lerpf(2.0, 14.0, sin(progress * PI))
				draw_circle(pivot + aim * p_dist, 4.0, Palette.KEM)
	else:
		# --- TRẠNG THÁI NGHỈ: VŨ KHÍ NẰM GỌN BÊN HÔNG / TAY ---
		var hand_pos: Vector2 = Vector2(7.0 * flip_sign, -8.0)
		if abs(facing_dir.y) > abs(facing_dir.x):
			hand_pos = Vector2(7.0, -8.0 if facing_dir.y > 0 else -10.0)
		
		match equipped_weapon_id:
			"staff_wood", "staff":
				draw_line(hand_pos + Vector2(0, 5), hand_pos + Vector2(3 * flip_sign, -13), Palette.NAU_DA, 2.5)
				draw_circle(hand_pos + Vector2(3 * flip_sign, -13), 1.5, Palette.KEM)
				draw_circle(hand_pos + Vector2(0, 5), 1.5, Palette.NAU_HAM)
			"dagger":
				var d_aim := aim * 8.0
				draw_line(hand_pos, hand_pos + d_aim, Palette.XAM_SAT, 2.0)
				draw_line(hand_pos, hand_pos + d_aim * 0.7, Palette.KEM, 1.0)
				draw_circle(hand_pos, 2.0, Palette.NAU_HAM)
			"sling":
				draw_line(hand_pos, hand_pos + Vector2(0, -5), Palette.CAT, 2.0)
				draw_line(hand_pos + Vector2(0, -5), hand_pos + Vector2(3 * flip_sign, -8), Palette.CAT, 1.5)
				draw_line(hand_pos + Vector2(0, -5), hand_pos + Vector2(-3 * flip_sign, -8), Palette.CAT, 1.5)
			"fist", _:
				pass
