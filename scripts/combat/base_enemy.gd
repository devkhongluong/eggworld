extends CharacterBody2D
class_name BaseEnemy

# BaseEnemy: Lớp cơ sở cho toàn bộ kẻ thù trong "Vỡ Vỏ" (bao gồm Quạ Gác Tổ sau này)
# Các trạng thái:
# - IDLE: Chờ / quan sát
# - CHASE: Đuổi theo người chơi khi trong bán kính phát hiện
# - TELEGRAPH: Dừng lại, nhấp nháy Đỏ Gạch (DO_GACH) báo trước đòn đánh
# - ATTACK: Kích hoạt vùng sát thương
# - RECOVERY: Hồi chiêu sau đòn đánh
# - STUNNED: Choáng khi bị Player tấn công trúng
# - DEAD: Chết, rơi Mảnh Vỏ Vụn (EXP) và biến mất

enum State { IDLE, CHASE, TELEGRAPH, ATTACK, RECOVERY, STUNNED, DEAD }

@export var enemy_id: String = "common_enemy"

@onready var visual_node: Node2D = $EnemyVisual
@onready var attack_area: Area2D = $AttackArea
@onready var hurtbox_area: Area2D = $Hurtbox

var max_hp: int = 45
var current_hp: int = 45
var damage: int = 18
var move_speed: float = 55.0
var detection_radius: float = 140.0
var attack_radius: float = 24.0

var telegraph_duration: float = 0.35
var attack_active_duration: float = 0.15
var recovery_duration: float = 0.4
var stun_duration: float = 0.25
var exp_drop: int = 15

var current_state: State = State.IDLE
var state_timer: float = 0.0
var flash_timer: float = 0.0
var hurt_flash_timer: float = 0.0
var is_flashing_red: bool = false
var has_resolved_player_this_attack: bool = false

var target_player: CharacterBody2D = null

func _ready() -> void:
	load_stats()
	current_hp = max_hp
	current_state = State.IDLE
	state_timer = 0.5
	find_player()

func load_stats() -> void:
	max_hp = int(GameData.get_stat(enemy_id, "max_hp", 45))
	damage = int(GameData.get_stat(enemy_id, "damage", 18))
	move_speed = float(GameData.get_stat(enemy_id, "move_speed", 55.0))
	detection_radius = float(GameData.get_stat(enemy_id, "detection_radius", 140.0))
	attack_radius = float(GameData.get_stat(enemy_id, "attack_radius", 24.0))
	telegraph_duration = float(GameData.get_stat(enemy_id, "telegraph_duration", 0.35))
	attack_active_duration = float(GameData.get_stat(enemy_id, "attack_active_duration", 0.15))
	recovery_duration = float(GameData.get_stat(enemy_id, "recovery_duration", 0.4))
	stun_duration = float(GameData.get_stat(enemy_id, "stun_duration", 0.25))
	exp_drop = int(GameData.get_stat(enemy_id, "exp_drop", 15))

func find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		target_player = players[0]

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	if target_player == null or not is_instance_valid(target_player):
		find_player()
	
	state_timer -= delta
	
	if hurt_flash_timer > 0.0:
		hurt_flash_timer -= delta
		if hurt_flash_timer <= 0.0:
			modulate = Color.WHITE
	
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			move_and_slide()
			if target_player != null:
				var dist: float = global_position.distance_to(target_player.global_position)
				if dist <= detection_radius:
					start_chase()
		
		State.CHASE:
			if target_player == null:
				start_idle()
				return
			
			var dist: float = global_position.distance_to(target_player.global_position)
			if dist <= attack_radius:
				start_telegraph()
			elif dist > detection_radius * 1.3:
				start_idle()
			else:
				var dir: Vector2 = (target_player.global_position - global_position).normalized()
				velocity = dir * move_speed
				move_and_slide()
		
		State.TELEGRAPH:
			velocity = Vector2.ZERO
			move_and_slide()
			process_telegraph_flash(delta)
			if state_timer <= 0.0:
				execute_attack()
		
		State.ATTACK:
			velocity = Vector2.ZERO
			move_and_slide()
			check_attack_hitbox()
			if state_timer <= 0.0:
				end_attack()
		
		State.RECOVERY:
			velocity = Vector2.ZERO
			move_and_slide()
			if state_timer <= 0.0:
				start_chase()
		
		State.STUNNED:
			velocity = Vector2.ZERO
			move_and_slide()
			if state_timer <= 0.0:
				start_chase()

func start_idle() -> void:
	current_state = State.IDLE
	state_timer = 0.5
	is_flashing_red = false
	if visual_node != null:
		visual_node.queue_redraw()

func start_chase() -> void:
	current_state = State.CHASE
	is_flashing_red = false
	if visual_node != null:
		visual_node.queue_redraw()

func start_telegraph() -> void:
	current_state = State.TELEGRAPH
	state_timer = telegraph_duration
	flash_timer = 0.0
	is_flashing_red = true
	if visual_node != null:
		visual_node.queue_redraw()

func process_telegraph_flash(delta: float) -> void:
	flash_timer += delta
	if flash_timer >= 0.07:
		flash_timer = 0.0
		is_flashing_red = not is_flashing_red
		if visual_node != null:
			visual_node.queue_redraw()

func execute_attack() -> void:
	current_state = State.ATTACK
	state_timer = attack_active_duration
	has_resolved_player_this_attack = false
	is_flashing_red = true
	if visual_node != null:
		visual_node.queue_redraw()
	print("[%s] Tung đòn tấn công! Sát thương: %d" % [name, damage])
	check_attack_hitbox()

func check_attack_hitbox() -> void:
	if has_resolved_player_this_attack:
		return
	
	if attack_area == null:
		return
	
	var overlapping_areas := attack_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.name == "Hurtbox":
			var parent: Node = area.get_parent()
			if parent != null and parent.has_method("receive_hit") and parent != self:
				has_resolved_player_this_attack = true
				parent.receive_hit(damage, self)
				break

func end_attack() -> void:
	current_state = State.RECOVERY
	state_timer = recovery_duration
	is_flashing_red = false
	if visual_node != null:
		visual_node.queue_redraw()

func receive_hit(amount: int, attack_source: Node) -> Dictionary:
	if current_state == State.DEAD:
		return {"hit": false, "damage": 0}
	
	current_hp = maxi(0, current_hp - amount)
	print("[%s] Bị đánh trúng! Nhận %d sát thương (HP còn: %d/%d)" % [name, amount, current_hp, max_hp])
	
	modulate = Palette.KEM
	hurt_flash_timer = 0.15
	
	# Bị đẩy lùi nhẹ nếu có hướng nguồn đánh
	if attack_source != null and "global_position" in attack_source:
		var knockback_dir: Vector2 = (global_position - attack_source.global_position).normalized()
		velocity = knockback_dir * 80.0
		move_and_slide()
	
	if current_hp <= 0:
		die()
		return {"hit": true, "damage": amount, "killed": true}
	else:
		# Choáng ngắn (Stun) khi bị trúng đòn
		current_state = State.STUNNED
		state_timer = stun_duration
		is_flashing_red = false
		if visual_node != null:
			visual_node.queue_redraw()
	
	return {"hit": true, "damage": amount, "killed": false}

func die() -> void:
	current_state = State.DEAD
	velocity = Vector2.ZERO
	is_flashing_red = false
	print("[%s] Đã bị tiêu diệt! Rơi %d Mảnh Vỏ Vụn." % [name, exp_drop])
	
	# Tạo vật phẩm nhặt EXP tại chỗ chết
	spawn_exp_drop()
	queue_free()

func spawn_exp_drop() -> void:
	var pickup := Area2D.new()
	pickup.set_script(load("res://scripts/combat/shell_shard_pickup.gd"))
	pickup.set("shard_amount", exp_drop)
	pickup.global_position = global_position
	
	var col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0
	col.shape = circle
	pickup.add_child(col)
	
	get_parent().call_deferred("add_child", pickup)
