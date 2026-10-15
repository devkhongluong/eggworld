extends Area2D
class_name Projectile

# Projectile: Đạn bắn tầm xa (dùng cho Ná - Sling, phép thuật...)
# Bay theo hướng xác định, va chạm Hurtbox kẻ thù (Layer 16)
# Khi trúng đích: gây sát thương, cộng +2 điểm MAGIC cho BehaviorTracker

var direction: Vector2 = Vector2.DOWN
var speed: float = 220.0
var damage: int = 10
var lifetime: float = 0.8
var attacker: Node = null
var radius: float = 3.0
var hit_spec: Dictionary = {}
var trail_stage: int = 0

var _traveled_time: float = 0.0
static var _trail_textures: Dictionary = {}

func setup(p_direction: Vector2, p_speed: float, p_damage: int, p_lifetime: float, p_attacker: Node, p_radius: float = 3.0, p_hit_spec: Dictionary = {}) -> void:
	direction = p_direction.normalized()
	speed = p_speed
	damage = p_damage
	lifetime = p_lifetime
	attacker = p_attacker
	radius = p_radius
	hit_spec = p_hit_spec
	trail_stage = int(hit_spec.get("charge_stage", 0))
	_ensure_trail_textures()

static func _ensure_trail_textures() -> void:
	if _trail_textures.is_empty():
		var t1 = load("res://assets/vfx/charge/release_sling_trail_s1.png")
		var t2 = load("res://assets/vfx/charge/release_sling_trail_s2.png")
		var t3 = load("res://assets/vfx/charge/release_sling_trail_s3.png")
		if t1 != null: _trail_textures[1] = {"tex": t1, "fw": 16, "fh": 6, "frames": 3, "anchor": Vector2(8, 3), "dur": 0.22}
		if t2 != null: _trail_textures[2] = {"tex": t2, "fw": 24, "fh": 6, "frames": 3, "anchor": Vector2(12, 3), "dur": 0.28}
		if t3 != null: _trail_textures[3] = {"tex": t3, "fw": 32, "fh": 6, "frames": 3, "anchor": Vector2(16, 3), "dur": 0.35}

func _ready() -> void:
	collision_layer = 0
	collision_mask = 16 # Lớp Hurtbox của kẻ thù
	monitoring = true
	monitorable = false
	
	area_entered.connect(_on_area_entered)
	
	# Tạo shape va chạm
	var col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	col.shape = circle
	add_child(col)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	_traveled_time += delta
	if trail_stage > 0:
		queue_redraw()
	if _traveled_time >= lifetime:
		queue_free()

func _draw() -> void:
	# 1. Vẽ vệt đuôi đạn theo mức nếu có (release_sling_trail_s1/s2/s3)
	if trail_stage > 0 and _trail_textures.has(trail_stage):
		var cfg: Dictionary = _trail_textures[trail_stage]
		var dur: float = float(cfg.get("dur", 0.25))
		if _traveled_time < dur:
			var total_f: int = int(cfg.get("frames", 3))
			var f_idx: int = mini(total_f - 1, int((_traveled_time / dur) * float(total_f)))
			var tex: Texture2D = cfg["tex"]
			var fw: int = int(cfg["fw"])
			var fh: int = int(cfg["fh"])
			var anc: Vector2 = cfg["anchor"]
			var src_rect := Rect2(f_idx * fw, 0, fw, fh)
			
			var flip_left: bool = (direction.x < 0)
			var trail_offset := -direction * (float(fw) * 0.45 + radius)
			var dst_x: float = round(trail_offset.x - anc.x)
			var dst_y: float = round(trail_offset.y - anc.y)
			
			if flip_left:
				draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
				draw_texture_rect_region(tex, Rect2(-round(trail_offset.x) - (fw - anc.x), dst_y, fw, fh), src_rect)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				draw_texture_rect_region(tex, Rect2(dst_x, dst_y, fw, fh), src_rect)

	# 2. Vẽ viên sỏi pixel (Palette chuẩn GDD)
	draw_circle(Vector2.ZERO, radius, Palette.XAM_SAT)
	draw_circle(Vector2(-1, -1), radius * 0.5, Palette.KEM)

func _on_area_entered(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if target != null and target != attacker and target.has_method("receive_hit"):
		var _res: Dictionary = target.receive_hit(damage, attacker, hit_spec)
		var tag: String = str(hit_spec.get("behavior_tag", "MAGIC"))
		if tag != "":
			var pts: int = 1
			var root = Engine.get_main_loop()
			if root != null and root.root != null and root.root.has_node("GameData"):
				pts = int(root.root.get_node("GameData").get_stat("behavior_points", "weapon_hit_points", 1))
			if root != null and root.root != null and root.root.has_node("BehaviorTracker"):
				root.root.get_node("BehaviorTracker").add_points(tag, pts)
		var show_log: bool = true
		var root_node = Engine.get_main_loop()
		if root_node != null and root_node.root != null and root_node.root.has_node("GameData"):
			show_log = bool(root_node.root.get_node("GameData").get_stat("debug", "show_combat_log", true))
		if show_log:
			print("[PROJECTILE] Đạn Ná bắn trúng %s! Gây %d sát thương." % [target.name, damage])
		queue_free()
