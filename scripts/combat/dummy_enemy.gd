extends CharacterBody2D

# Kẻ thù giả để kiểm tra né đòn và nhận sát thương.
# Tuân thủ:
# - Báo hiệu nhấp nháy Đỏ Gạch (DO_GACH) đúng 0.3 giây trước khi gây sát thương (GDD Mục 3 & 7)
# - Chỉ cộng DODGE tối đa 1 lần cho mỗi lượt tung đòn (Quy tắc điều chỉnh #3)
# - Số liệu cân bằng lấy từ data/stats.json
# - Màu sắc 100% từ Palette

enum State { IDLE, TELEGRAPH, ATTACK, RECOVERY, STAGGER }

@onready var visual_node: Node2D = $EnemyVisual
@onready var attack_area: Area2D = $AttackArea

var max_hp: int = 50
var current_hp: int = 50
var damage: int = 20
var telegraph_duration: float = 0.3
var attack_interval: float = 2.2
var attack_radius: float = 28.0

var facing_direction: Vector2 = Vector2.LEFT
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

# Đảm bảo mỗi lượt vung đòn chỉ tương tác với người chơi đúng 1 lần (Quy tắc điều chỉnh #3)
var has_resolved_player_this_attack: bool = false
var attack_active_duration: float = 0.15

func _ready() -> void:
	load_stats()
	current_hp = max_hp
	state_timer = attack_interval - telegraph_duration
	current_state = State.IDLE

func load_stats() -> void:
	max_hp = int(GameData.get_stat("dummy_enemy", "max_hp", 50))
	damage = int(GameData.get_stat("dummy_enemy", "damage", 20))
	telegraph_duration = float(GameData.get_stat("dummy_enemy", "telegraph_duration", 0.3))
	attack_interval = float(GameData.get_stat("dummy_enemy", "attack_interval", 2.2))
	attack_radius = float(GameData.get_stat("dummy_enemy", "attack_radius", 28.0))
	
	max_poise = float(GameData.get_stat("dummy_enemy", "max_poise", GameData.get_stat("combat_stage_b", "enemy_default_poise", 30.0)))
	current_poise = max_poise
	poise_recover_delay = float(GameData.get_stat("combat_stage_b", "enemy_poise_recover_delay", 2.5))
	poise_recover_rate = float(GameData.get_stat("combat_stage_b", "enemy_poise_recover_rate", 10.0))
	stagger_duration = float(GameData.get_stat("combat_stage_b", "enemy_stagger_duration", 1.2))

func _physics_process(delta: float) -> void:
	state_timer -= delta
	
	# Hồi phục Poise nếu không bị đánh
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
			if state_timer <= 0.0:
				start_telegraph()
		
		State.TELEGRAPH:
			process_telegraph_flash(delta)
			if state_timer <= 0.0:
				execute_attack()
		
		State.ATTACK:
			check_attack_hitbox()
			if state_timer <= 0.0:
				end_attack()
		
		State.RECOVERY:
			if state_timer <= 0.0:
				start_idle()
		
		State.STAGGER:
			stagger_timer -= delta
			if stagger_timer <= 0.0:
				is_staggered = false
				current_poise = max_poise
				start_idle()

func start_telegraph() -> void:
	current_state = State.TELEGRAPH
	state_timer = telegraph_duration
	flash_timer = 0.0
	is_flashing_red = true
	visual_node.queue_redraw()

func process_telegraph_flash(delta: float) -> void:
	flash_timer += delta
	# Nhấp nháy tần số nhanh (0.07s) bằng màu Đỏ Gạch
	if flash_timer >= 0.07:
		flash_timer = 0.0
		is_flashing_red = not is_flashing_red
		visual_node.queue_redraw()

func execute_attack() -> void:
	current_state = State.ATTACK
	state_timer = attack_active_duration
	has_resolved_player_this_attack = false
	is_flashing_red = true
	visual_node.queue_redraw()
	print("[ENEMY] Tung đòn tấn công! (Sát thương: %d, Bán kính: %.1f)" % [damage, attack_radius])
	check_attack_hitbox()

func check_attack_hitbox() -> void:
	# Nếu đợt vung đòn này đã giải quyết với Player rồi thì bỏ qua (Quy tắc #3)
	if has_resolved_player_this_attack:
		return
	
	var overlapping_areas := attack_area.get_overlapping_areas()
	for area in overlapping_areas:
		# Chỉ kiểm tra va chạm với Hurtbox, không tương tác với thân vật lý
		if area.name == "Hurtbox":
			var parent: Node = area.get_parent()
			if parent != null and parent.has_method("receive_hit"):
				has_resolved_player_this_attack = true
				var res = parent.receive_hit(damage, self)
				if res is Dictionary and res.get("parried", false):
					trigger_stagger()
				break

func end_attack() -> void:
	current_state = State.RECOVERY
	state_timer = 0.3
	is_flashing_red = false
	visual_node.queue_redraw()

func start_idle() -> void:
	current_state = State.IDLE
	state_timer = maxf(0.5, attack_interval - telegraph_duration - 0.3)
	is_flashing_red = false
	visual_node.queue_redraw()

func trigger_stagger() -> void:
	is_staggered = true
	current_state = State.STAGGER
	stagger_timer = stagger_duration
	current_poise = max_poise
	is_flashing_red = false
	modulate = Palette.VANG_CO
	hurt_flash_timer = 0.2
	CombatFeedback.spawn_floating_text(get_parent(), "CHOÁNG!", global_position + Vector2(0, -12), Palette.VANG_CO, true)
	if visual_node != null:
		visual_node.queue_redraw()
	print("[DUMMY] BỊ CHOÁNG (STAGGER) trong %.2fs!" % stagger_duration)

func receive_hit(amount: int, attack_source: Node, hit_spec: Dictionary = {}) -> Dictionary:
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
		current_state = State.IDLE
	
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
	
	current_hp = maxi(0, current_hp - final_damage)
	print("[DUMMY] Nhận %d sát thương từ Player! HP còn: %d/%d" % [final_damage, current_hp, max_hp])
	
	if current_hp <= 0:
		print("[DUMMY] Kẻ thù bị tiêu diệt! Rơi 30 Mảnh Vỏ Vụn & tự động hồi phục.")
		spawn_exp_drop()
		current_hp = max_hp
		current_poise = max_poise
		is_staggered = false
		start_idle()
		return {"hit": true, "damage": final_damage, "killed": true, "critical": is_critical, "backstab": is_backstab}
	
	return {"hit": true, "damage": final_damage, "killed": false, "critical": is_critical, "backstab": is_backstab}

func spawn_exp_drop() -> void:
	var pickup := Area2D.new()
	pickup.set_script(load("res://scripts/combat/shell_shard_pickup.gd"))
	pickup.set("shard_amount", 30)
	pickup.global_position = global_position + Vector2(randf_range(-6.0, 6.0), randf_range(-6.0, 6.0))
	
	var col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0
	col.shape = circle
	pickup.add_child(col)
	
	get_parent().call_deferred("add_child", pickup)

