extends Node
class_name HitboxService

# HitboxService: Quản lý vị trí, kích thước, hình dạng và kích hoạt vùng va chạm tấn công
# Hỗ trợ các hình dạng theo COMBAT_SPEC: arc (cung), rect (chữ nhật), line (đường đâm), projectile (đạn bay)
# Định vị và lật theo facing_direction và flip_h

const ProjectileScript = preload("res://scripts/combat/projectile.gd")

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

static func configure_hitbox(hitbox: Area2D, hitbox_spec: Dictionary, dir_suffix: String, flip_left: bool, facing_dir: Vector2 = Vector2.ZERO) -> void:
	if hitbox == null:
		return
	
	var shape_type: String = str(hitbox_spec.get("shape", "arc"))
	var radius: float = float(hitbox_spec.get("radius", 18.0))
	var shape_owner: CollisionShape2D = null
	for child in hitbox.get_children():
		if child is CollisionShape2D:
			shape_owner = child
			break
	if shape_owner == null:
		shape_owner = hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D
	
	match shape_type:
		"line":
			# Đường đâm thẳng dài và hẹp theo hướng nhìn
			var reach: float = float(hitbox_spec.get("reach", radius * 1.3))
			var thickness: float = float(hitbox_spec.get("thickness", 8.0))
			match dir_suffix:
				"down":
					hitbox.position = Vector2(0, reach * 0.5)
					if shape_owner != null:
						var rect := RectangleShape2D.new()
						rect.size = Vector2(thickness, reach)
						shape_owner.shape = rect
				"up":
					hitbox.position = Vector2(0, -reach * 0.9)
					if shape_owner != null:
						var rect := RectangleShape2D.new()
						rect.size = Vector2(thickness, reach)
						shape_owner.shape = rect
				"side":
					var offset_x: float = -reach * 0.6 if flip_left else reach * 0.6
					hitbox.position = Vector2(offset_x, -10)
					if shape_owner != null:
						var rect := RectangleShape2D.new()
						rect.size = Vector2(reach, thickness)
						shape_owner.shape = rect
		
		"rect":
			# Vùng va chạm hình chữ nhật cố định
			var sz: Array = hitbox_spec.get("size", [radius * 1.2, radius * 1.2])
			var w: float = float(sz[0])
			var h: float = float(sz[1]) if sz.size() > 1 else w
			match dir_suffix:
				"down":
					hitbox.position = Vector2(0, h * 0.4)
				"up":
					hitbox.position = Vector2(0, -h * 0.9)
				"side":
					hitbox.position = Vector2(-w * 0.7 if flip_left else w * 0.7, -10)
			if shape_owner != null:
				var rect := RectangleShape2D.new()
				rect.size = Vector2(w, h)
				shape_owner.shape = rect
				
		"arc", _:
			# Cung quét vung vũ khí cận chiến
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
			
			if shape_owner != null:
				var circle := CircleShape2D.new()
				circle.radius = radius
				shape_owner.shape = circle

static func spawn_projectile(parent: Node, hitbox_spec: Dictionary, facing_dir: Vector2, spawn_pos: Vector2, attacker: Node, damage: int, hit_spec: Dictionary = {}) -> Area2D:
	if parent == null:
		return null
	var proj: Area2D = ProjectileScript.new()
	var spd: float = float(hitbox_spec.get("speed", 220.0))
	var life: float = float(hitbox_spec.get("life", 0.75))
	var rad: float = float(hitbox_spec.get("radius", 3.0))
	proj.setup(facing_dir, spd, damage, life, attacker, rad, hit_spec)
	proj.global_position = spawn_pos
	parent.add_child(proj)
	return proj

static func deactivate_hitbox(hitbox: Area2D) -> void:
	if hitbox != null:
		hitbox.monitoring = false

static func check_and_process_overlaps(hitbox: Area2D, attacker: Node, damage: int, already_hit: Array[Node], on_hit_callback: Callable = Callable(), hit_spec: Dictionary = {}) -> void:
	if hitbox == null or not hitbox.monitoring:
		return
	
	var areas := hitbox.get_overlapping_areas()
	for area in areas:
		process_single_target(area, attacker, damage, already_hit, on_hit_callback, hit_spec)

static func process_single_target(area: Area2D, attacker: Node, damage: int, already_hit: Array[Node], on_hit_callback: Callable = Callable(), hit_spec: Dictionary = {}) -> void:
	var target: Node = area.get_parent()
	if target != null and target != attacker and not target in already_hit:
		if target.has_method("receive_hit"):
			already_hit.append(target)
			var res: Dictionary = target.receive_hit(damage, attacker, hit_spec)
			if on_hit_callback.is_valid():
				on_hit_callback.call(target, damage, res)
