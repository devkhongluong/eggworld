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

var facing_direction: Vector2 = Vector2.DOWN
var is_parryable: bool = true

var max_poise: float = 30.0
var current_poise: float = 30.0
var poise_recover_delay: float = 2.5
var poise_recover_rate: float = 10.0
var poise_delay_timer: float = 0.0
var is_staggered: bool = false
var stagger_duration: float = 1.2
var stagger_timer: float = 0.0

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
	
	max_poise = float(GameData.get_stat(enemy_id, "max_poise", GameData.get_stat("combat_stage_b", "enemy_default_poise", 30.0)))
	current_poise = max_poise
	poise_recover_delay = float(GameData.get_stat("combat_stage_b", "enemy_poise_recover_delay", 2.5))
	poise_recover_rate = float(GameData.get_stat("combat_stage_b", "enemy_poise_recover_rate", 10.0))
	stagger_duration = float(GameData.get_stat("combat_stage_b", "enemy_stagger_duration", 1.2))

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
	
	# Hồi phục Poise tự nhiên nếu không bị đánh
	if not is_staggered and current_poise < max_poise:
		if poise_delay_timer > 0.0:
			poise_delay_timer -= delta
		else:
			current_poise = minf(max_poise, current_poise + poise_recover_rate * delta)
	
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
				if dir != Vector2.ZERO:
					facing_direction = dir
				velocity = dir * move_speed
				move_and_slide()
		
		State.TELEGRAPH:
			velocity = Vector2.ZERO
			move_and_slide()
			if target_player != null:
				var dir: Vector2 = (target_player.global_position - global_position).normalized()
				if dir != Vector2.ZERO:
					facing_direction = dir
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
			if is_staggered:
				stagger_timer -= delta
				if stagger_timer <= 0.0:
					is_staggered = false
					current_poise = max_poise
					start_chase()
			else:
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
				var res = parent.receive_hit(damage, self)
				if res is Dictionary and res.get("parried", false):
					# Bị người chơi đỡ khéo (Parry)! Kẻ thù bị choáng ngay lập tức
					trigger_stagger()
				break

func end_attack() -> void:
	current_state = State.RECOVERY
	state_timer = recovery_duration
	is_flashing_red = false
	if visual_node != null:
		visual_node.queue_redraw()

func trigger_stagger() -> void:
	is_staggered = true
	current_state = State.STUNNED
	stagger_timer = stagger_duration
	current_poise = max_poise
	is_flashing_red = false
	modulate = Palette.VANG_CO
	hurt_flash_timer = 0.2
	CombatFeedback.spawn_floating_text(get_parent(), "CHOÁNG!", global_position + Vector2(0, -12), Palette.VANG_CO, true)
	if visual_node != null:
		visual_node.queue_redraw()
	print("[%s] BỊ CHOÁNG (STAGGER) trong %.2fs! Sẵn sàng cho đòn kết liễu!" % [name, stagger_duration])

func receive_hit(amount: int, attack_source: Node, hit_spec: Dictionary = {}) -> Dictionary:
	if current_state == State.DEAD:
		return {"hit": false, "damage": 0}
	
	# 1. Kiểm tra Đâm lén (Backstab): góc sau lưng 90 độ
	var is_backstab: bool = false
	if attack_source != null and "global_position" in attack_source:
		var to_source: Vector2 = (attack_source.global_position - global_position).normalized()
		if facing_direction != Vector2.ZERO and to_source != Vector2.ZERO:
			var rear_dir: Vector2 = -facing_direction.normalized()
			var bs_angle_deg: float = float(GameData.get_stat("combat_stage_b", "backstab_angle_degrees", 90.0))
			var min_dot: float = cos(deg_to_rad(bs_angle_deg * 0.5))
			if to_source.dot(rear_dir) >= min_dot:
				is_backstab = true
	
	# 2. Kiểm tra Đòn kết liễu (Critical / Riposte) khi đang choáng
	var is_critical: bool = is_staggered
	if is_critical:
		is_staggered = false
		stagger_timer = 0.0
	
	# 3. Tính toán sát thương
	var final_damage: int = amount
	if is_critical:
		var crit_mult: float = float(GameData.get_stat("combat_stage_b", "critical_hit_damage_mult", 2.5))
		final_damage = int(round(float(final_damage) * crit_mult))
	elif is_backstab:
		var bs_mult: float = float(GameData.get_stat("combat_stage_b", "backstab_damage_mult", 2.0))
		final_damage = int(round(float(final_damage) * bs_mult))
	
	# 4. Trừ độ vững (Poise damage)
	var is_heavy: bool = bool(hit_spec.get("is_heavy", false))
	var poise_dmg: float = float(hit_spec.get("poise_dmg", 10.0 if not is_heavy else 25.0))
	if not is_critical and not is_staggered:
		current_poise = maxf(0.0, current_poise - poise_dmg)
		poise_delay_timer = poise_recover_delay
		if current_poise <= 0.0:
			trigger_stagger()
	
	# 5. Cảm giác đánh (Game Feel): Hit-stop, Rung camera, Nhấp nháy trắng, Đẩy lùi
	if is_critical:
		CombatFeedback.trigger_hit_stop(get_tree(), float(GameData.get_stat("game_feel", "hit_stop_critical_duration", 0.14)))
	elif is_heavy:
		CombatFeedback.trigger_hit_stop(get_tree(), float(GameData.get_stat("game_feel", "hit_stop_heavy_duration", 0.08)))
	else:
		CombatFeedback.trigger_hit_stop(get_tree(), float(GameData.get_stat("game_feel", "hit_stop_light_duration", 0.04)))
	
	if attack_source != null and attack_source.has_method("shake_camera"):
		if is_critical:
			attack_source.shake_camera(float(GameData.get_stat("game_feel", "camera_shake_critical_duration", 0.28)), float(GameData.get_stat("game_feel", "camera_shake_critical_intensity", 7.0)))
		elif is_heavy or is_backstab:
			attack_source.shake_camera(float(GameData.get_stat("game_feel", "camera_shake_heavy_duration", 0.22)), float(GameData.get_stat("game_feel", "camera_shake_heavy_intensity", 5.0)))
	
	if bool(GameData.get_stat("game_feel", "enemy_flash_enabled", true)):
		modulate = Palette.KEM
		hurt_flash_timer = float(GameData.get_stat("game_feel", "enemy_flash_duration", 0.12))
	
	if bool(GameData.get_stat("game_feel", "knockback_enabled", true)) and attack_source != null and "global_position" in attack_source:
		var knockback_dir: Vector2 = (global_position - attack_source.global_position).normalized()
		var kb_speed: float = float(GameData.get_stat("game_feel", "knockback_light_speed", 75.0))
		if is_critical:
			kb_speed = float(GameData.get_stat("game_feel", "knockback_critical_speed", 230.0))
		elif is_heavy:
			kb_speed = float(GameData.get_stat("game_feel", "knockback_heavy_speed", 180.0))
		velocity = knockback_dir * kb_speed
		move_and_slide()
	
	# Floating text
	CombatFeedback.spawn_floating_text(get_parent(), str(final_damage), global_position, Palette.KEM)
	if is_critical:
		CombatFeedback.spawn_floating_text(get_parent(), "KẾT LIỄU!", global_position + Vector2(0, -14), Palette.DO_GACH, true)
	elif is_backstab:
		CombatFeedback.spawn_floating_text(get_parent(), "ĐÂM LÉN!", global_position + Vector2(0, -14), Palette.XANH_REU, true)
	
	# Điểm thưởng hành vi Đâm lén (+2 DODGE)
	if is_backstab:
		var bs_pts: int = int(GameData.get_stat("behavior_points", "backstab", 2))
		BehaviorTracker.add_points(BehaviorTracker.ACTION_DODGE, bs_pts)
	
	# 6. Trừ HP và xử lý trạng thái
	current_hp = maxi(0, current_hp - final_damage)
	print("[%s] Nhận %d sát thương (HP còn: %d/%d)" % [name, final_damage, current_hp, max_hp])
	
	if current_hp <= 0:
		die()
		return {"hit": true, "damage": final_damage, "killed": true, "critical": is_critical, "backstab": is_backstab}
	else:
		if not is_staggered:
			current_state = State.STUNNED
			state_timer = stun_duration
			is_flashing_red = false
			if visual_node != null:
				visual_node.queue_redraw()
	
	return {"hit": true, "damage": final_damage, "killed": false, "critical": is_critical, "backstab": is_backstab}

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
