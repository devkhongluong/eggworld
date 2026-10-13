extends Node
class_name HitboxService

# HitboxService: Quản lý vị trí, kích thước và kích hoạt vùng va chạm tấn công
# Nhận diện mục tiêu và chuyển giao sát thương cho đối tượng trúng đòn

static func update_attack_hitbox_position(hitbox: Area2D, dir_suffix: String, flip_left: bool) -> void:
	if hitbox == null:
		return
	
	match dir_suffix:
		"down":
			hitbox.position = Vector2(0, 6)
		"up":
			hitbox.position = Vector2(0, -24)
		"side":
			if flip_left:
				hitbox.position = Vector2(-16, -10)
			else:
				hitbox.position = Vector2(16, -10)

static func configure_hitbox(hitbox: Area2D, hitbox_spec: Dictionary, dir_suffix: String, flip_left: bool) -> void:
	if hitbox == null:
		return
	
	var radius: float = float(hitbox_spec.get("radius", 18.0))
	
	# Đặt vị trí dựa theo kích thước bán kính của vũ khí
	match dir_suffix:
		"down":
			hitbox.position = Vector2(0, maxf(6.0, radius * 0.4))
		"up":
			hitbox.position = Vector2(0, -maxf(20.0, radius * 1.1))
		"side":
			if flip_left:
				hitbox.position = Vector2(-maxf(14.0, radius * 0.9), -10)
			else:
				hitbox.position = Vector2(maxf(14.0, radius * 0.9), -10)
	
	# Cập nhật kích thước vùng va chạm nếu có CollisionShape2D
	var shape_owner := hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_owner != null:
		if shape_owner.shape is RectangleShape2D:
			var rect: RectangleShape2D = shape_owner.shape
			rect.size = Vector2(radius * 1.5, radius * 1.5)
		elif shape_owner.shape is CircleShape2D:
			var circle: CircleShape2D = shape_owner.shape
			circle.radius = radius

static func check_and_process_overlaps(hitbox: Area2D, attacker: Node, damage: int, already_hit: Array[Node], on_hit_callback: Callable = Callable()) -> void:
	if hitbox == null or not hitbox.monitoring:
		return
	
	var areas := hitbox.get_overlapping_areas()
	for area in areas:
		process_single_target(area, attacker, damage, already_hit, on_hit_callback)

static func process_single_target(area: Area2D, attacker: Node, damage: int, already_hit: Array[Node], on_hit_callback: Callable = Callable()) -> void:
	var target: Node = area.get_parent()
	if target != null and target != attacker and not target in already_hit:
		if target.has_method("receive_hit"):
			already_hit.append(target)
			var res: Dictionary = target.receive_hit(damage, attacker)
			if on_hit_callback.is_valid():
				on_hit_callback.call(target, damage, res)
