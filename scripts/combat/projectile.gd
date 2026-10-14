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

var _traveled_time: float = 0.0

func setup(p_direction: Vector2, p_speed: float, p_damage: int, p_lifetime: float, p_attacker: Node, p_radius: float = 3.0, p_hit_spec: Dictionary = {}) -> void:
	direction = p_direction.normalized()
	speed = p_speed
	damage = p_damage
	lifetime = p_lifetime
	attacker = p_attacker
	radius = p_radius
	hit_spec = p_hit_spec

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
	if _traveled_time >= lifetime:
		queue_free()

func _draw() -> void:
	# Vẽ viên sỏi pixel (Palette chuẩn GDD)
	draw_circle(Vector2.ZERO, radius, Palette.XAM_SAT)
	draw_circle(Vector2(-1, -1), radius * 0.5, Palette.KEM)

func _on_area_entered(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if target != null and target != attacker and target.has_method("receive_hit"):
		var _res: Dictionary = target.receive_hit(damage, attacker, hit_spec)
		var tag: String = str(hit_spec.get("behavior_tag", "MAGIC"))
		if tag != "":
			var pts: int = int(GameData.get_stat("behavior_points", "weapon_hit_points", 1))
			BehaviorTracker.add_points(tag, pts)
		var show_log: bool = bool(GameData.get_stat("debug", "show_combat_log", true))
		if show_log:
			print("[PROJECTILE] Đạn Ná bắn trúng %s! Gây %d sát thương." % [target.name, damage])
		queue_free()
