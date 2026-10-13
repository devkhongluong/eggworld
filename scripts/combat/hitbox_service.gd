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
