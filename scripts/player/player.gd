extends CharacterBody2D
class_name Player

# Player: Nhân vật Trứng trong game "Vỡ Vỏ"
# Đầy đủ cơ chế:
# - Di chuyển 8 hướng theo tốc độ từ stats.json
# - Lăn né tiêu hao Stamina, i-frame 0.25s, chặn né khi thiếu thể lực
# - Hệ thống tấn công cận chiến Combo 3 đòn theo facing_direction (Điểm 2, 3)
# - AnimatedSprite2D nạp SpriteFrames từ animations.json, bật/tắt Hitbox qua frame_changed (Điểm 4)
# - Kích thước Collision 10x6 sát chân, Hurtbox 10x14 giữa thân từ stats.json (Điểm 5)

signal hp_changed(new_hp: int, max_hp: int)
signal stamina_changed(new_stamina: float, max_stamina: float)
signal player_died()
signal player_respawned()
signal combo_stepped(current_step: int)
signal weapon_swapped(active_slot: int, weapon_id: String, weapon_name: String)
signal shards_dropped(position: Vector2, amount: int)

@onready var visual_node: Node2D = $EggVisual
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_hitbox_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Chỉ số từ stats.json
var max_hp: int = 100
var current_hp: int = 100
var max_stamina: float = 100.0
var current_stamina: float = 100.0

var move_speed: float = 95.0
var dodge_speed_multiplier: float = 1.85
var dodge_duration: float = 0.25
var dodge_cooldown: float = 0.2
var dodge_stamina_cost: float = 20.0
var stamina_recovery_rate: float = 30.0
var stamina_recovery_delay: float = 0.35

# Thông số combo cận chiến từ stats.json
var attack_combo_damage: Array = [15, 18, 28]
var attack_cooldowns: Array = [0.15, 0.15, 0.45]
var combo_window: float = 0.55
var attack_stamina_costs: Array = [10.0, 12.0, 18.0]

# Trạng thái di chuyển & né
var facing_direction: Vector2 = Vector2.DOWN
var is_dodging: bool = false
var is_invulnerable: bool = false
var can_dodge: bool = true
var is_dead: bool = false

var dodge_timer: float = 0.0
var dodge_cooldown_timer: float = 0.0
var stamina_delay_timer: float = 0.0
var dodge_direction: Vector2 = Vector2.ZERO

# Trạng thái combo tấn công
var combat_state: CombatState = CombatState.new()
var is_attacking: bool = false
var can_attack: bool = true
var combo_step: int = 0 # 0, 1, 2 tương ứng các đòn trong chuỗi

# Hệ thống vũ khí (Giai đoạn A: 3 ô vũ khí trang bị)
var weapon_slots: Array[String] = ["staff_wood", "dagger", "sling"]
var active_slot_idx: int = 0
var current_weapon_id: String = "staff_wood"
var current_weapon_data: Dictionary = {}
var player_stats: Dictionary = {}
var debug_combat_log: bool = true

const LOGIC_FRAME_TIME: float = 1.0 / 60.0
var attack_frame_accumulator: float = 0.0
var attack_cooldown_timer: float = 0.0
var combo_window_timer: float = 0.0
var already_hit_enemies: Array[Node] = []
var has_awarded_behavior_this_attack: bool = false

# Poise & Stagger của Player (COMBAT_SPEC mục 5)
var max_poise: float = 40.0
var current_poise: float = 40.0
var poise_recover_delay: float = 2.0
var poise_recover_rate: float = 15.0
var poise_delay_timer: float = 0.0
var player_stagger_duration: float = 0.8

# Đòn nặng & gồng lực (Heavy Attack Charge)
var is_charging_heavy: bool = false
var heavy_charge_timer: float = 0.0
var heavy_charge_ratio: float = 0.0
var is_heavy_attack: bool = false
var attack_button_held_time: float = 0.0
var heavy_hold_threshold: float = 0.18

# Trạng thái đỡ đòn (Guard)
var is_guarding: bool = false
var is_stunned: bool = false
var stun_timer: float = 0.0
var guard_damage_reduction: float = 0.75
var guard_stamina_cost_per_hit: float = 25.0
var guard_speed_multiplier: float = 0.45
var guard_break_stun_duration: float = 0.8
var guard_arc_degrees: float = 180.0

# Hoạt ảnh và hit_frames
var animations_config: Dictionary = {}
var current_hit_frames: Array = []
var is_in_hit_frame: bool = false
var is_hurt: bool = false   # đang phát hurt animation → block update_animations

var spawn_position: Vector2 = Vector2.ZERO
var respawn_timer: float = 0.0
var flash_timer: float = 0.0

func _ready() -> void:
	load_stats_from_data()
	setup_animations()
	spawn_position = global_position
	current_hp = max_hp
	current_stamina = max_stamina
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	
	if attack_hitbox != null:
		attack_hitbox.monitoring = true
		attack_hitbox.monitorable = false
		attack_hitbox.area_entered.connect(_on_attack_hitbox_area_entered)
	
	if animated_sprite != null:
		animated_sprite.frame_changed.connect(_on_sprite_frame_changed)
		animated_sprite.animation_finished.connect(_on_sprite_animation_finished)
	
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_signal("stats_changed"):
			inv.stats_changed.connect(apply_leveled_stats)
	
	update_animations()

func apply_leveled_stats() -> void:
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_method("get_effective_stats"):
			player_stats = inv.get_effective_stats()
	
	var old_max_hp: int = max_hp
	var old_max_stamina: float = max_stamina
	max_hp = StatsCalc.calc_max_hp(player_stats)
	max_stamina = StatsCalc.calc_max_stamina(player_stats)
	
	if max_hp > old_max_hp:
		current_hp = mini(max_hp, current_hp + (max_hp - old_max_hp))
	else:
		current_hp = mini(current_hp, max_hp)
	
	if max_stamina > old_max_stamina:
		current_stamina = minf(max_stamina, current_stamina + (max_stamina - old_max_stamina))
	else:
		current_stamina = minf(current_stamina, max_stamina)
	
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	print("[PLAYER] Đã áp dụng chỉ số mới: HP tối đa %d, Thể lực tối đa %.1f" % [max_hp, max_stamina])

func load_stats_from_data() -> void:
	debug_combat_log = bool(GameData.get_stat("debug", "show_combat_log", true))
	
	var effective_stats: Dictionary = {}
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_method("get_effective_stats"):
			effective_stats = inv.get_effective_stats()
	
	if effective_stats.is_empty():
		effective_stats = {
			"STR": int(GameData.get_stat("base_stats", "STR", 10)),
			"DEX": int(GameData.get_stat("base_stats", "DEX", 10)),
			"INT": int(GameData.get_stat("base_stats", "INT", 10)),
			"FAI": int(GameData.get_stat("base_stats", "FAI", 10)),
			"VIT": int(GameData.get_stat("base_stats", "VIT", 10)),
			"LUK": int(GameData.get_stat("base_stats", "LUK", 10))
		}
	
	player_stats = effective_stats
	max_hp = StatsCalc.calc_max_hp(player_stats)
	max_stamina = StatsCalc.calc_max_stamina(player_stats)
	current_weapon_data = WeaponDB.get_weapon(current_weapon_id)
	
	move_speed = float(GameData.get_stat("player", "move_speed", 95.0))
	dodge_speed_multiplier = float(GameData.get_stat("player", "dodge_speed_multiplier", 1.85))
	dodge_duration = float(GameData.get_stat("player", "dodge_duration", 0.25))
	dodge_cooldown = float(GameData.get_stat("player", "dodge_cooldown", 0.2))
	dodge_stamina_cost = float(GameData.get_stat("player", "dodge_stamina_cost", 16.0))
	stamina_recovery_rate = float(GameData.get_stat("player", "stamina_recovery_rate", 26.0))
	stamina_recovery_delay = float(GameData.get_stat("player", "stamina_recovery_delay", 0.35))
	
	attack_combo_damage = GameData.get_stat("player", "attack_combo_damage", [15, 18, 28])
	attack_cooldowns = GameData.get_stat("player", "attack_cooldowns", [0.15, 0.15, 0.45])
	combo_window = float(GameData.get_stat("player", "combo_window", 0.55))
	attack_stamina_costs = GameData.get_stat("player", "attack_stamina_costs", [8.0, 10.0, 14.0])
	
	guard_damage_reduction = float(GameData.get_stat("player", "guard_damage_reduction", 0.75))
	guard_stamina_cost_per_hit = float(GameData.get_stat("player", "guard_stamina_cost_per_hit", 20.0))
	guard_speed_multiplier = float(GameData.get_stat("player", "guard_speed_multiplier", 0.45))
	guard_break_stun_duration = float(GameData.get_stat("player", "guard_break_stun_duration", 0.8))
	guard_arc_degrees = float(GameData.get_stat("player", "guard_arc_degrees", 180.0))
	
	max_poise = float(GameData.get_stat("combat_stage_b", "player_max_poise", 40.0))
	current_poise = max_poise
	poise_recover_delay = float(GameData.get_stat("combat_stage_b", "player_poise_recover_delay", 2.0))
	poise_recover_rate = float(GameData.get_stat("combat_stage_b", "player_poise_recover_rate", 15.0))
	player_stagger_duration = float(GameData.get_stat("combat_stage_b", "player_stagger_duration", 0.8))
	heavy_hold_threshold = float(GameData.get_stat("combat_stage_b", "heavy_hold_threshold", 0.18))
	
	# Nạp kích thước Collision & Hurtbox từ stats.json (Điểm 5)
	var col_size: Array = GameData.get_stat("player", "collision_size", [10.0, 6.0])
	var col_offset: Array = GameData.get_stat("player", "collision_offset", [0.0, -3.0])
	var hurt_size: Array = GameData.get_stat("player", "hurtbox_size", [10.0, 14.0])
	var hurt_offset: Array = GameData.get_stat("player", "hurtbox_offset", [0.0, -10.0])
	
	if collision_shape != null:
		var col_rect := RectangleShape2D.new()
		col_rect.size = Vector2(col_size[0], col_size[1])
		collision_shape.shape = col_rect
		collision_shape.position = Vector2(col_offset[0], col_offset[1])
	
	if hurtbox != null:
		var hurt_col: CollisionShape2D = hurtbox.get_node_or_null("CollisionShape2D")
		if hurt_col != null:
			var hurt_rect := RectangleShape2D.new()
			hurt_rect.size = Vector2(hurt_size[0], hurt_size[1])
			hurt_col.shape = hurt_rect
			hurt_col.position = Vector2(hurt_offset[0], hurt_offset[1])

func setup_animations() -> void:
	var anim_path := "res://assets/sprites/player/animations.json"
	if FileAccess.file_exists(anim_path):
		var file := FileAccess.open(anim_path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				if json.data.has("player_egg") and json.data["player_egg"].has("animations"):
					animations_config = json.data["player_egg"]["animations"]
	
	var sprite_frames := SpriteFrames.new()
	for anim_name in animations_config:
		var cfg: Dictionary = animations_config[anim_name]
		var frame_count: int = int(cfg.get("frames", 4))
		var fps: float = float(cfg.get("fps", 12))
		var loop: bool = bool(cfg.get("loop", true))
		
		sprite_frames.add_animation(anim_name)
		sprite_frames.set_animation_speed(anim_name, fps)
		sprite_frames.set_animation_loop(anim_name, loop)
		
		var file_name: String = str(cfg.get("file", ""))
		var full_img_path := "res://assets/sprites/player/" + file_name
		
		if ResourceLoader.exists(full_img_path):
			var texture: Texture2D = load(full_img_path)
			for i in range(frame_count):
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2(i * 32, 0, 32, 32)
				sprite_frames.add_frame(anim_name, atlas)
		else:
			var img := Image.create(32, 32, false, Image.FORMAT_RGBA8)
			var placeholder_tex := ImageTexture.create_from_image(img)
			for i in range(frame_count):
				sprite_frames.add_frame(anim_name, placeholder_tex)
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.offset = Vector2(0, -16)

func _physics_process(delta: float) -> void:
	if is_dead:
		process_death(delta)
		return
	
	# Xử lý cửa sổ đỡ khéo (parry window 8 frames)
	if combat_state.is_parry_window:
		combat_state.parry_frame += 1
		var max_parry_f: int = int(GameData.get_stat("combat_stage_b", "parry_window_frames", 8))
		if combat_state.parry_frame >= max_parry_f:
			combat_state.is_parry_window = false
	
	process_cooldowns(delta)
	process_input_and_movement(delta)
	process_stamina(delta)
	process_attack_logic(delta)
	process_visual_effects(delta)
	update_animations()

func update_animations() -> void:
	if is_dead:
		return
	
	# Ẩn hoàn toàn hình khối tạm – sprite đã đủ
	if visual_node != null and "show_placeholder_body" in visual_node:
		visual_node.show_placeholder_body = false
	animated_sprite.visible = true
	
	if is_attacking:
		return  # hoạt ảnh attack đã được bật trong try_attack()
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	animated_sprite.flip_h = flip_left
	
	if is_dodging:
		var roll_anim := "roll_" + dir_suffix
		if animated_sprite.animation != roll_anim or not animated_sprite.is_playing():
			animated_sprite.play(roll_anim)
		return
	
	if velocity == Vector2.ZERO:
		var anim_name := "idle_" + dir_suffix
		if animated_sprite.animation != anim_name or not animated_sprite.is_playing():
			animated_sprite.play(anim_name)
	else:
		var run_anim := "run_" + dir_suffix
		if animated_sprite.animation != run_anim or not animated_sprite.is_playing():
			animated_sprite.play(run_anim)

func process_cooldowns(delta: float) -> void:
	if dodge_cooldown_timer > 0.0:
		dodge_cooldown_timer -= delta
		if dodge_cooldown_timer <= 0.0:
			can_dodge = true
	
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0.0:
			can_attack = true
	
	if combo_window_timer > 0.0:
		combo_window_timer -= delta
		if combo_window_timer <= 0.0 and not is_attacking:
			combo_step = 0
	
	if stun_timer > 0.0:
		stun_timer -= delta
		if stun_timer <= 0.0:
			is_stunned = false
	
	if stamina_delay_timer > 0.0:
		stamina_delay_timer -= delta

func process_input_and_movement(delta: float) -> void:
	if is_stunned:
		is_guarding = false
		if visual_node != null and visual_node.has_method("set_guarding"):
			visual_node.set_guarding(false, facing_direction)
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if is_dodging:
		is_guarding = false
		if visual_node != null and visual_node.has_method("set_guarding"):
			visual_node.set_guarding(false, facing_direction)
		dodge_timer -= delta
		velocity = dodge_direction * (move_speed * dodge_speed_multiplier)
		move_and_slide()
		if dodge_timer <= 0.0:
			end_dodge()
		return
	
	if is_charging_heavy:
		is_guarding = false
		if visual_node != null and visual_node.has_method("set_guarding"):
			visual_node.set_guarding(false, facing_direction)
		velocity = Vector2.ZERO
		move_and_slide()
		process_heavy_charge(delta)
		return
	
	if is_attacking:
		is_guarding = false
		if visual_node != null and visual_node.has_method("set_guarding"):
			visual_node.set_guarding(false, facing_direction)
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Kiểm tra trạng thái Giữ Guard & Cửa sổ Đỡ Khéo (Parry Window 8 frames)
	var wants_guard: bool = Input.is_action_pressed("guard") and current_stamina > 0.0
	if Input.is_action_just_pressed("guard") and current_stamina > 0.0:
		combat_state.is_parry_window = true
		combat_state.parry_frame = 0
	
	is_guarding = wants_guard
	if not is_guarding:
		combat_state.is_parry_window = false
	if visual_node != null and visual_node.has_method("set_guarding"):
		visual_node.set_guarding(is_guarding, facing_direction)
	
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector.normalized()
		if visual_node != null and visual_node.has_method("set_equipped_weapon"):
			visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
		var speed: float = move_speed
		if is_guarding:
			speed *= guard_speed_multiplier
		velocity = input_vector * speed
		stamina_delay_timer = maxf(stamina_delay_timer, stamina_recovery_delay)
	else:
		velocity = Vector2.ZERO
	
	if not is_guarding and not is_dodging:
		if Input.is_action_just_pressed("swap_weapon"):
			swap_weapon()
		
		# Hỗ trợ phím số 1, 2, 3 để chọn nhanh 3 ô vũ khí, phím 4 là đòn tay không
		if Input.is_physical_key_pressed(KEY_1) or Input.is_key_pressed(KEY_1):
			_switch_to_slot(0)
		elif Input.is_physical_key_pressed(KEY_2) or Input.is_key_pressed(KEY_2):
			_switch_to_slot(1)
		elif Input.is_physical_key_pressed(KEY_3) or Input.is_key_pressed(KEY_3):
			_switch_to_slot(2)
		elif Input.is_physical_key_pressed(KEY_4) or Input.is_key_pressed(KEY_4):
			equip_weapon_to_active_slot("fist")
		elif Input.is_action_just_pressed("cycle_item"):
			var all_keys := ["staff_wood", "dagger", "sling", "fist"]
			var cur_i := all_keys.find(current_weapon_id)
			var nxt_i := (cur_i + 1) % all_keys.size() if cur_i != -1 else 0
			equip_weapon_to_active_slot(all_keys[nxt_i])
	
	if not is_guarding:
		if Input.is_physical_key_pressed(KEY_U) or Input.is_action_just_pressed("heavy_attack"):
			start_heavy_charge()
		elif Input.is_action_just_pressed("attack"):
			try_attack()
	
	if Input.is_action_just_pressed("dodge"):
		try_dodge(input_vector)
	
	move_and_slide()

# --- Hệ thống Vũ khí & Đổi vũ khí (Giai đoạn A) ---

func swap_weapon() -> void:
	if is_attacking or is_dodging or is_dead or is_stunned:
		return
	
	# Đổi xoay vòng giữa 3 ô vũ khí trang bị (Gậy Gỗ -> Dao Găm -> Ná)
	active_slot_idx = (active_slot_idx + 1) % weapon_slots.size()
	current_weapon_id = weapon_slots[active_slot_idx]
	current_weapon_data = WeaponDB.get_weapon(current_weapon_id)
	
	combat_state.reset_combo()
	combo_step = 0
	
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	if debug_combat_log:
		print("[PLAYER] Đổi ô vũ khí: Ô %d/%d -> %s (%s)" % [active_slot_idx + 1, weapon_slots.size(), w_name, current_weapon_id])
	weapon_swapped.emit(active_slot_idx, current_weapon_id, w_name)

func _switch_to_slot(slot_idx: int) -> void:
	if slot_idx < 0 or slot_idx >= weapon_slots.size():
		return
	if active_slot_idx == slot_idx:
		return
	active_slot_idx = slot_idx
	current_weapon_id = weapon_slots[active_slot_idx]
	current_weapon_data = WeaponDB.get_weapon(current_weapon_id)
	combat_state.reset_combo()
	combo_step = 0
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	if debug_combat_log:
		print("[PLAYER] Chọn nhanh Ô %d: %s (%s)" % [active_slot_idx + 1, w_name, current_weapon_id])
	weapon_swapped.emit(active_slot_idx, current_weapon_id, w_name)

func equip_weapon_to_active_slot(weapon_id: String) -> void:
	if is_attacking or is_dodging or is_dead or is_stunned:
		return
	if current_weapon_id == weapon_id:
		return
	var w_data := WeaponDB.get_weapon(weapon_id)
	if w_data.is_empty():
		return
	weapon_slots[active_slot_idx] = weapon_id
	current_weapon_id = weapon_id
	current_weapon_data = w_data
	combat_state.reset_combo()
	combo_step = 0
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	if debug_combat_log:
		print("[PLAYER] Trang bị vào Ô %d: %s (%s)" % [active_slot_idx + 1, w_name, current_weapon_id])
	weapon_swapped.emit(active_slot_idx, current_weapon_id, w_name)

# --- Đòn nặng và Gồng lực (Heavy Attack Charge) ---

func start_heavy_charge() -> void:
	if is_dodging or is_dead or is_stunned or is_guarding or is_attacking or is_charging_heavy:
		return
	
	var heavy_spec: Dictionary = current_weapon_data.get("heavy", {})
	if heavy_spec.is_empty():
		return
	
	var cost: float = WeaponDB.calculate_stamina_cost(heavy_spec, current_weapon_data, player_stats)
	if current_stamina < cost:
		if debug_combat_log:
			print("[PLAYER] Không đủ Stamina để gồng đòn nặng! (Cần %.1f, có %.1f)" % [cost, current_stamina])
		return
	
	is_charging_heavy = true
	heavy_charge_timer = 0.0
	heavy_charge_ratio = 0.0
	combat_state.current_state = CombatState.State.HEAVY_CHARGE
	
	if visual_node != null and visual_node.has_method("set_heavy_charging"):
		visual_node.set_heavy_charging(true, 0.0)
	
	if debug_combat_log:
		print("[PLAYER] Bắt đầu gồng đòn nặng (%s)..." % current_weapon_id)

func process_heavy_charge(delta: float) -> void:
	if not is_charging_heavy:
		return
	
	heavy_charge_timer += delta
	var heavy_spec: Dictionary = current_weapon_data.get("heavy", {})
	var c_min: float = float(heavy_spec.get("charge_min", 0.25))
	var c_max: float = float(heavy_spec.get("charge_max", 0.8))
	
	heavy_charge_ratio = clampf((heavy_charge_timer - c_min) / maxf(0.01, c_max - c_min), 0.0, 1.0)
	if visual_node != null and visual_node.has_method("set_heavy_charging"):
		visual_node.set_heavy_charging(true, heavy_charge_ratio)
	
	# Nhả phím hoặc đạt ngưỡng tối đa thì ra đòn
	var button_down: bool = Input.is_action_pressed("attack") or Input.is_physical_key_pressed(KEY_U) or Input.is_action_pressed("heavy_attack")
	if not button_down or heavy_charge_timer >= c_max:
		release_heavy_attack()

func release_heavy_attack() -> void:
	if not is_charging_heavy:
		return
	
	is_charging_heavy = false
	if visual_node != null and visual_node.has_method("set_heavy_charging"):
		visual_node.set_heavy_charging(false, 0.0)
	
	var heavy_spec: Dictionary = current_weapon_data.get("heavy", {})
	if heavy_spec.is_empty():
		combat_state.current_state = CombatState.State.IDLE
		return
	
	var cost: float = WeaponDB.calculate_stamina_cost(heavy_spec, current_weapon_data, player_stats)
	if current_stamina < cost:
		combat_state.current_state = CombatState.State.IDLE
		return
	
	current_stamina -= cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_attacking = true
	is_heavy_attack = true
	can_attack = false
	has_awarded_behavior_this_attack = false
	
	combat_state.current_state = CombatState.State.ATTACK_STARTUP
	combat_state.attack_phase = CombatState.AttackPhase.STARTUP
	combat_state.attack_frame = 0
	combat_state.is_heavy = true
	combat_state.charge_ratio = heavy_charge_ratio
	attack_frame_accumulator = 0.0
	already_hit_enemies.clear()
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var anim_name := "attack_" + dir_suffix
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	animated_sprite.flip_h = flip_left
	
	if animated_sprite != null and animations_config.has(anim_name):
		animated_sprite.stop()
		animated_sprite.frame = 0
		animated_sprite.play(anim_name)
	
	var total_frames: int = int(heavy_spec.get("startup", 6)) + int(heavy_spec.get("active", 3)) + int(heavy_spec.get("recovery", 10))
	var attack_duration: float = float(total_frames) * LOGIC_FRAME_TIME
	if visual_node != null and visual_node.has_method("start_attack_visual"):
		visual_node.start_attack_visual(facing_direction, 2, current_weapon_id, attack_duration, true)
	
	if debug_combat_log:
		print("[PLAYER] TUNG ĐÒN NẶNG (%s)! Tỉ lệ gồng: %.0f%%, Tiêu hao: %.1f Stamina" % [
			current_weapon_data.get("name", current_weapon_id), heavy_charge_ratio * 100.0, cost
		])

# --- Chuỗi đòn nhẹ 60 FPS Logic (Startup -> Active -> Recovery) ---

const ProjectileScript = preload("res://scripts/combat/projectile.gd")

func try_attack() -> void:
	if is_dodging or is_dead or is_stunned or is_guarding:
		return
	
	# Nếu đang trong pha recovery và đã qua mốc cancel_from, cho phép nối combo ngay
	if is_attacking:
		var chain: Array = current_weapon_data.get("light_chain", [])
		if combo_step < chain.size():
			var spec: Dictionary = chain[combo_step]
			var cancel_from: int = int(spec.get("cancel_from", 3))
			if combat_state.can_chain_combo(cancel_from):
				_advance_combo()
				return
		combat_state.combo_buffered = true
		return
	
	_start_attack_step(combo_step)

func _start_attack_step(step: int) -> void:
	var chain: Array = current_weapon_data.get("light_chain", [])
	if chain.is_empty():
		return
	
	if step >= chain.size():
		step = 0
	combo_step = step
	is_heavy_attack = false
	attack_button_held_time = 0.0
	has_awarded_behavior_this_attack = false
	
	var spec: Dictionary = chain[combo_step]
	var cost: float = WeaponDB.calculate_stamina_cost(spec, current_weapon_data, player_stats)
	
	if current_stamina < cost:
		print("[PLAYER] Không đủ Stamina để tấn công đòn %d! (Cần %.1f, có %.1f)" % [combo_step + 1, cost, current_stamina])
		combat_state.reset_combo()
		combo_step = 0
		return
	
	current_stamina -= cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_attacking = true
	can_attack = false
	combat_state.is_heavy = false
	combat_state.current_state = CombatState.State.ATTACK_STARTUP
	combat_state.attack_phase = CombatState.AttackPhase.STARTUP
	combat_state.attack_frame = 0
	combat_state.combo_step = combo_step
	combat_state.combo_buffered = false
	attack_frame_accumulator = 0.0
	already_hit_enemies.clear()
	combo_stepped.emit(combo_step)
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var anim_name := "attack_" + dir_suffix
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	animated_sprite.flip_h = flip_left
	
	if animated_sprite != null and animations_config.has(anim_name):
		animated_sprite.stop()
		animated_sprite.frame = 0
		animated_sprite.play(anim_name)
	
	# Khởi động diễn hoạt vũ khí động (vung gậy / đâm dao / kéo ná)
	var total_frames: int = int(spec.get("startup", 4)) + int(spec.get("active", 3)) + int(spec.get("recovery", 6))
	var attack_duration: float = float(total_frames) * LOGIC_FRAME_TIME
	if visual_node != null and visual_node.has_method("start_attack_visual"):
		visual_node.start_attack_visual(facing_direction, combo_step, current_weapon_id, attack_duration, false)
	
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	print("[PLAYER] Tung đòn combo %d/%d (%s)! Startup: %d khung, Tiêu hao: %.1f Stamina" % [
		combo_step + 1, chain.size(), w_name, int(spec.get("startup", 4)), cost
	])

func process_attack_logic(delta: float) -> void:
	if not is_attacking:
		return
	
	# Kiểm tra nếu giữ nút attack trong giai đoạn startup của đòn nhẹ -> chuyển sang gồng đòn nặng
	if not is_heavy_attack and combat_state.attack_phase == CombatState.AttackPhase.STARTUP:
		if Input.is_action_pressed("attack"):
			attack_button_held_time += delta
			if attack_button_held_time >= heavy_hold_threshold:
				end_attack(false)
				start_heavy_charge()
				return
	
	attack_frame_accumulator += delta
	while attack_frame_accumulator >= LOGIC_FRAME_TIME:
		attack_frame_accumulator -= LOGIC_FRAME_TIME
		_tick_attack_frame()

func _tick_attack_frame() -> void:
	if not is_attacking:
		return
	
	var spec: Dictionary = {}
	if is_heavy_attack:
		spec = current_weapon_data.get("heavy", {})
		if spec.is_empty():
			end_attack(true)
			return
	else:
		var chain: Array = current_weapon_data.get("light_chain", [])
		if combo_step < 0 or combo_step >= chain.size():
			end_attack(true)
			return
		spec = chain[combo_step]
	
	var startup_frames: int = int(spec.get("startup", 4))
	var active_frames: int = int(spec.get("active", 3))
	var recovery_frames: int = int(spec.get("recovery", 6))
	var cancel_from: int = int(spec.get("cancel_from", 3))
	
	match combat_state.attack_phase:
		CombatState.AttackPhase.STARTUP:
			combat_state.attack_frame += 1
			if combat_state.attack_frame >= startup_frames:
				combat_state.attack_phase = CombatState.AttackPhase.ACTIVE
				combat_state.current_state = CombatState.State.ATTACK_ACTIVE
				combat_state.attack_frame = 0
				_enter_active_phase(spec)
				
		CombatState.AttackPhase.ACTIVE:
			combat_state.attack_frame += 1
			var hitbox_spec: Dictionary = spec.get("hitbox", {})
			if str(hitbox_spec.get("shape", "arc")) != "projectile":
				check_melee_overlaps()
				
			if combat_state.attack_frame >= active_frames:
				combat_state.attack_phase = CombatState.AttackPhase.RECOVERY
				combat_state.current_state = CombatState.State.ATTACK_RECOVERY
				combat_state.attack_frame = 0
				_enter_recovery_phase()
				
		CombatState.AttackPhase.RECOVERY:
			combat_state.attack_frame += 1
			
			# Hủy sang né (dodge cancel) từ khung cancel_from
			if combat_state.can_cancel_to_dodge(cancel_from) and Input.is_action_just_pressed("dodge"):
				end_attack(false)
				var input_vec := Input.get_vector("move_left", "move_right", "move_up", "move_down")
				try_dodge(input_vec)
				return
			
			# Nối chuỗi combo từ khung cancel_from (chỉ đòn nhẹ)
			if not is_heavy_attack and combat_state.can_chain_combo(cancel_from):
				if combat_state.combo_buffered or Input.is_action_just_pressed("attack"):
					combat_state.combo_buffered = false
					_advance_combo()
					return
			
			if combat_state.attack_frame >= recovery_frames:
				if is_heavy_attack:
					end_attack(true)
				else:
					var chain: Array = current_weapon_data.get("light_chain", [])
					_finish_attack_recovery(spec, chain)

func _enter_active_phase(spec: Dictionary) -> void:
	is_in_hit_frame = true
	already_hit_enemies.clear()
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	var hitbox_spec: Dictionary = spec.get("hitbox", {})
	var shape_type: String = str(hitbox_spec.get("shape", "arc"))
	var dmg: int = WeaponDB.calculate_damage(current_weapon_data, spec, player_stats, heavy_charge_ratio if is_heavy_attack else 0.0)
	
	var hit_spec: Dictionary = {
		"is_heavy": is_heavy_attack,
		"poise_dmg": float(spec.get("poise_dmg", 10.0 if not is_heavy_attack else 35.0)),
		"behavior_tag": str(current_weapon_data.get("behavior_tag", ""))
	}
	
	if shape_type == "projectile":
		# Bắn đạn tầm xa (Ná) qua HitboxService
		var spawn_pos: Vector2 = global_position + Vector2(0, -10) + facing_direction * 8.0
		HitboxService.spawn_projectile(get_parent(), hitbox_spec, facing_direction, spawn_pos, self, dmg, hit_spec)
	else:
		# Cận chiến: tạo/cấu hình Hitbox theo hình dạng (arc, line, rect)
		HitboxService.configure_hitbox(attack_hitbox, hitbox_spec, dir_suffix, flip_left, facing_direction)
		attack_hitbox.monitoring = true
		check_melee_overlaps()

func _enter_recovery_phase() -> void:
	is_in_hit_frame = false
	HitboxService.deactivate_hitbox(attack_hitbox)

func _advance_combo() -> void:
	var chain: Array = current_weapon_data.get("light_chain", [])
	if combo_step + 1 < chain.size():
		_start_attack_step(combo_step + 1)
	else:
		_start_attack_step(0)

func _finish_attack_recovery(spec: Dictionary, chain: Array) -> void:
	var combo_win: int = int(spec.get("combo_window", 0))
	if combo_step + 1 < chain.size() and combo_win > 0:
		is_attacking = false
		combat_state.attack_phase = CombatState.AttackPhase.NONE
		combat_state.current_state = CombatState.State.IDLE
		can_attack = true
		combo_step += 1
		combat_state.combo_step = combo_step
		combo_window_timer = float(combo_win) / 60.0
	else:
		end_attack(true)

func end_attack(reset_step: bool = true) -> void:
	is_attacking = false
	is_heavy_attack = false
	is_in_hit_frame = false
	combat_state.is_heavy = false
	attack_button_held_time = 0.0
	HitboxService.deactivate_hitbox(attack_hitbox)
	combat_state.attack_phase = CombatState.AttackPhase.NONE
	combat_state.current_state = CombatState.State.IDLE
	can_attack = true
	attack_frame_accumulator = 0.0
	if visual_node != null and visual_node.has_method("stop_attack_visual"):
		visual_node.stop_attack_visual()
	if reset_step:
		combo_step = 0
		combat_state.combo_step = 0
		combo_window_timer = 0.0
		combat_state.combo_buffered = false

func _on_sprite_frame_changed() -> void:
	pass

func _on_sprite_animation_finished() -> void:
	pass

func update_attack_hitbox_transform(dir_suffix: String, flip_left: bool) -> void:
	HitboxService.update_attack_hitbox_position(attack_hitbox, dir_suffix, flip_left)

func check_melee_overlaps() -> void:
	var spec: Dictionary = {}
	if is_heavy_attack:
		spec = current_weapon_data.get("heavy", {})
		if spec.is_empty():
			return
	else:
		var chain: Array = current_weapon_data.get("light_chain", [])
		if combo_step >= chain.size():
			return
		spec = chain[combo_step]
	
	var dmg: int = WeaponDB.calculate_damage(current_weapon_data, spec, player_stats, heavy_charge_ratio if is_heavy_attack else 0.0)
	var hit_spec: Dictionary = {
		"is_heavy": is_heavy_attack,
		"poise_dmg": float(spec.get("poise_dmg", 10.0 if not is_heavy_attack else 35.0)),
		"behavior_tag": str(current_weapon_data.get("behavior_tag", ""))
	}
	HitboxService.check_and_process_overlaps(attack_hitbox, self, dmg, already_hit_enemies, _on_enemy_hit, hit_spec)

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if is_in_hit_frame:
		var spec: Dictionary = {}
		if is_heavy_attack:
			spec = current_weapon_data.get("heavy", {})
			if spec.is_empty():
				return
		else:
			var chain: Array = current_weapon_data.get("light_chain", [])
			if combo_step >= chain.size():
				return
			spec = chain[combo_step]
		
		var dmg: int = WeaponDB.calculate_damage(current_weapon_data, spec, player_stats, heavy_charge_ratio if is_heavy_attack else 0.0)
		var hit_spec: Dictionary = {
			"is_heavy": is_heavy_attack,
			"poise_dmg": float(spec.get("poise_dmg", 10.0 if not is_heavy_attack else 35.0)),
			"behavior_tag": str(current_weapon_data.get("behavior_tag", ""))
		}
		HitboxService.process_single_target(area, self, dmg, already_hit_enemies, _on_enemy_hit, hit_spec)

func _on_enemy_hit(target: Node, dmg: int, _res: Dictionary) -> void:
	if debug_combat_log:
		var atk_type := "Đòn nặng" if is_heavy_attack else ("Đòn %d" % (combo_step + 1))
		print("[COMBAT] %s của %s đánh trúng %s! Gây %d sát thương." % [
			atk_type, current_weapon_data.get("name", current_weapon_id), target.name, dmg
		])
	
	# Cộng điểm hành vi theo behavior_tag của vũ khí (tối đa 1 lần mỗi đòn đánh)
	var tag: String = str(current_weapon_data.get("behavior_tag", ""))
	if tag != "" and not has_awarded_behavior_this_attack:
		has_awarded_behavior_this_attack = true
		var hit_pts: int = int(GameData.get_stat("behavior_points", "weapon_hit_points", 1))
		BehaviorTracker.add_points(tag, hit_pts)
		if debug_combat_log:
			print("[COMBAT] +%d điểm %s từ vũ khí %s!" % [hit_pts, tag, current_weapon_id])

func get_direction_suffix(dir: Vector2) -> String:
	if abs(dir.x) >= abs(dir.y):
		return "side"
	elif dir.y > 0:
		return "down"
	else:
		return "up"

func try_dodge(input_vector: Vector2) -> void:
	if not can_dodge or is_dodging or is_attacking:
		return
	
	if current_stamina < dodge_stamina_cost:
		print("[PLAYER] Không đủ Stamina để lăn né! (Cần %.1f, có %.1f)" % [dodge_stamina_cost, current_stamina])
		return
	
	current_stamina -= dodge_stamina_cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_dodging = true
	combat_state.current_state = CombatState.State.DODGING
	is_invulnerable = true
	can_dodge = false
	dodge_timer = dodge_duration
	
	if input_vector != Vector2.ZERO:
		dodge_direction = input_vector.normalized()
	else:
		dodge_direction = facing_direction
	
	print("[PLAYER] Lăn né! Khung bất tử: %.2fs, tốn %.1f Stamina" % [dodge_duration, dodge_stamina_cost])

func end_dodge() -> void:
	is_dodging = false
	combat_state.current_state = CombatState.State.IDLE
	is_invulnerable = false
	dodge_cooldown_timer = dodge_cooldown

func process_stamina(delta: float) -> void:
	if not is_dodging and not is_attacking and not is_guarding and not is_stunned and not is_charging_heavy and velocity == Vector2.ZERO and stamina_delay_timer <= 0.0:
		if current_stamina < max_stamina:
			current_stamina = minf(max_stamina, current_stamina + stamina_recovery_rate * delta)
			stamina_changed.emit(current_stamina, max_stamina)
	
	# Hồi phục Poise tự nhiên cho Player
	if current_poise < max_poise and not is_stunned:
		if poise_delay_timer > 0.0:
			poise_delay_timer -= delta
		else:
			current_poise = minf(max_poise, current_poise + poise_recover_rate * delta)

func shake_camera(duration: float, intensity: float) -> void:
	var cam := get_node_or_null("Camera2D") as Camera2D
	if cam != null:
		CombatFeedback.shake_camera(cam, duration, intensity)

var hurt_invulnerable_timer: float = 0.0

func process_visual_effects(delta: float) -> void:
	if hurt_invulnerable_timer > 0.0:
		hurt_invulnerable_timer -= delta
		if hurt_invulnerable_timer <= 0.0:
			is_invulnerable = false
	
	if flash_timer > 0.0:
		flash_timer -= delta
		if flash_timer <= 0.0:
			modulate = Color.WHITE

func receive_hit(damage: int, attack_source: Node) -> Dictionary:
	if is_dead:
		return {"hit": false, "dodged": false, "guarded": false}
	
	if is_invulnerable:
		if is_dodging:
			print("[COMBAT] Né thành công đòn đánh! +2 điểm DODGE")
			BehaviorTracker.add_points(BehaviorTracker.ACTION_DODGE, 2)
			return {"hit": false, "dodged": true, "guarded": false}
		else:
			# Đang trong thời gian chớp miễn nhiễm sau khi bị thương (i-frame)
			return {"hit": false, "dodged": false, "guarded": false}
	
	# Kiểm tra cơ chế Đỡ Đòn (Guard) & Đỡ Khéo (Parry)
	var guarded_successfully: bool = false
	var parried_successfully: bool = false
	var final_damage: int = damage
	
	if (is_guarding or combat_state.is_parry_window) and not is_stunned:
		# Xác định hướng từ Player tới nguồn tấn công
		var incoming_dir := facing_direction
		if attack_source != null and "global_position" in attack_source:
			var diff: Vector2 = (attack_source.global_position - global_position)
			if diff != Vector2.ZERO:
				incoming_dir = diff.normalized()
		
		# Tính góc giữa hướng nhìn của Player và hướng của đòn tấn công
		var angle_diff_rad: float = abs(facing_direction.angle_to(incoming_dir))
		var max_allowed_rad: float = deg_to_rad(guard_arc_degrees * 0.5)
		
		if angle_diff_rad <= max_allowed_rad:
			var can_parry: bool = bool(attack_source.get("is_parryable")) if attack_source != null and "is_parryable" in attack_source else true
			if combat_state.is_parry_window and can_parry:
				# ĐỠ KHÉO (PARRY) THÀNH CÔNG!
				parried_successfully = true
				guarded_successfully = true
				final_damage = 0
				
				# Kẻ thù bị choáng ngay
				if attack_source != null and attack_source.has_method("trigger_stagger"):
					attack_source.trigger_stagger()
				
				# Cộng điểm GUARD đỡ khéo (+4)
				var parry_pts: int = int(GameData.get_stat("behavior_points", "guard_parry", 4))
				BehaviorTracker.add_points(BehaviorTracker.ACTION_GUARD, parry_pts)
				
				# Game Feel
				CombatFeedback.trigger_hit_stop(get_tree(), 0.12)
				shake_camera(float(GameData.get_stat("game_feel", "camera_shake_parry_duration", 0.25)), float(GameData.get_stat("game_feel", "camera_shake_parry_intensity", 6.0)))
				CombatFeedback.spawn_floating_text(get_parent(), "ĐỠ KHÉO!", global_position + Vector2(0, -14), Palette.VANG_CO, true)
				
				modulate = Palette.KEM
				flash_timer = 0.15
				print("[COMBAT] ĐỠ KHÉO (PARRY) THÀNH CÔNG! Triệt tiêu toàn bộ sát thương (+4 GUARD) và làm choáng kẻ tấn công!")
				return {"hit": false, "dodged": false, "guarded": true, "parried": true}
			elif is_guarding:
				# Đỡ thường
				if current_stamina >= guard_stamina_cost_per_hit:
					current_stamina -= guard_stamina_cost_per_hit
					stamina_changed.emit(current_stamina, max_stamina)
					stamina_delay_timer = stamina_recovery_delay
					
					final_damage = int(round(float(damage) * (1.0 - guard_damage_reduction)))
					guarded_successfully = true
					
					var guard_pts: int = int(GameData.get_stat("behavior_points", "guard_normal", 2))
					BehaviorTracker.add_points(BehaviorTracker.ACTION_GUARD, guard_pts)
					print("[COMBAT] Đỡ đòn thành công! Giảm sát thương từ %d xuống %d (-%.1f Stamina, +%d GUARD)" % [
						damage, final_damage, guard_stamina_cost_per_hit, guard_pts
					])
					
					# Hiệu ứng nảy lùi nhẹ & nháy sáng Xám Sắt
					modulate = Palette.XAM_SAT
					flash_timer = 0.12
				else:
					# Vỡ thế đỡ (Guard Break): Hết stamina khi đỡ
					current_stamina = 0.0
					stamina_changed.emit(current_stamina, max_stamina)
					stamina_delay_timer = stamina_recovery_delay * 1.5
					
					is_guarding = false
					is_stunned = true
					combat_state.current_state = CombatState.State.STUNNED
					stun_timer = guard_break_stun_duration
					final_damage = damage # Nhận trọn sát thương
					
					if visual_node != null and visual_node.has_method("set_guarding"):
						visual_node.set_guarding(false, facing_direction)
					
					print("[COMBAT] VỠ THẾ ĐỠ (Guard Break)! Choáng trong %.2fs và nhận trọn %d sát thương!" % [
						guard_break_stun_duration, final_damage
					])
		else:
			print("[COMBAT] Bị đánh từ phía sau / ngoài cung đỡ (góc: %.1f độ)! Không thể đỡ đòn." % rad_to_deg(angle_diff_rad))
	
	# Nếu đang gồng đòn nặng mà bị đánh trúng -> ngắt gồng
	if is_charging_heavy:
		is_charging_heavy = false
		if visual_node != null and visual_node.has_method("set_heavy_charging"):
			visual_node.set_heavy_charging(false, 0.0)
	
	# Trừ poise của Player nếu không đỡ thành công
	if not guarded_successfully:
		current_poise = maxf(0.0, current_poise - 15.0)
		poise_delay_timer = poise_recover_delay
		if current_poise <= 0.0:
			current_poise = max_poise
			is_stunned = true
			stun_timer = player_stagger_duration
			combat_state.current_state = CombatState.State.STAGGER
			CombatFeedback.spawn_floating_text(get_parent(), "CHOÁNG!", global_position + Vector2(0, -14), Palette.DO_GACH, true)
			print("[COMBAT] Player bị vỡ poise! Choáng trong %.2fs!" % player_stagger_duration)
		
		# Rung camera và floating text khi Player nhận đòn
		shake_camera(float(GameData.get_stat("game_feel", "camera_shake_player_hurt_duration", 0.20)), float(GameData.get_stat("game_feel", "camera_shake_player_hurt_intensity", 3.5)))
		CombatFeedback.spawn_floating_text(get_parent(), str(final_damage), global_position, Palette.DO_GACH)
	
	current_hp = maxi(0, current_hp - final_damage)
	hp_changed.emit(current_hp, max_hp)
	print("[COMBAT] Player nhận %d sát thương! HP còn: %d/%d" % [final_damage, current_hp, max_hp])
	
	# Cập nhật tỉ lệ máu cho EggVisual để vẽ vết nứt to dần
	if visual_node != null and visual_node.has_method("set_hp_ratio"):
		visual_node.set_hp_ratio(float(current_hp) / float(maxi(1, max_hp)))
	
	# Bắn hiệu ứng mảnh vỏ văng tung tóe (nếu đỡ thành công văng ít hơn)
	if visual_node != null and visual_node.has_method("spawn_shell_burst"):
		visual_node.spawn_shell_burst(3 if guarded_successfully else 7)
	
	if current_hp <= 0:
		die()
		return {"hit": true, "dodged": false, "guarded": guarded_successfully}
	
	if not guarded_successfully:
		# Khung bất tử ngắn (i-frame 0.25s) và chớp đỏ phản hồi trúng đòn
		is_invulnerable = true
		hurt_invulnerable_timer = 0.25
		flash_timer = 0.18
		modulate = Palette.DO_GACH
	
	return {"hit": true, "dodged": false, "guarded": guarded_successfully}

func die() -> void:
	is_dead = true
	combat_state.current_state = CombatState.State.DEAD
	is_hurt = false
	is_guarding = false
	is_stunned = false
	stun_timer = 0.0
	velocity = Vector2.ZERO
	is_dodging = false
	is_invulnerable = false
	is_attacking = false
	combo_step = 0
	respawn_timer = 1.5
	modulate = Color.WHITE
	if visual_node != null and visual_node.has_method("set_guarding"):
		visual_node.set_guarding(false, facing_direction)
	if visual_node != null and visual_node.has_method("stop_attack_visual"):
		visual_node.stop_attack_visual()
	if visual_node != null and visual_node.has_method("set_dead"):
		visual_node.set_dead(true)
	print("[PLAYER] VỎ ĐÃ VỠ... Bắt đầu chuẩn bị hồi sinh.")
	
	# Rơi đống Mảnh Vỏ Vụn tại chỗ chết nếu Player có Mảnh Vỏ
	var root = Engine.get_main_loop()
	var current_shards: int = 0
	var inv_node = null
	if root != null and root.root != null:
		inv_node = root.root.get_node_or_null("PlayerInventory")
		if inv_node != null and "shell_shards" in inv_node:
			current_shards = int(inv_node.shell_shards)
	
	if current_shards > 0:
		LostShard.spawn_at(get_parent(), global_position, current_shards)
		if inv_node != null and inv_node.has_method("spend_all_shards"):
			inv_node.spend_all_shards()
		shards_dropped.emit(global_position, current_shards)
		print("[PLAYER] Đã đánh rơi %d Mảnh Vỏ Vụn tại %s!" % [current_shards, global_position])
	
	# Phát death animation
	var dir_suffix := get_direction_suffix(facing_direction)
	var death_anim := "death_" + dir_suffix
	if animated_sprite != null and animations_config.has(death_anim):
		animated_sprite.play(death_anim)
	
	player_died.emit()

func process_death(delta: float) -> void:
	respawn_timer -= delta
	if respawn_timer <= 0.0:
		respawn()

func respawn() -> void:
	global_position = spawn_position
	current_hp = max_hp
	current_stamina = max_stamina
	is_dead = false
	combat_state.current_state = CombatState.State.IDLE
	is_hurt = false
	is_guarding = false
	is_stunned = false
	stun_timer = 0.0
	is_dodging = false
	is_invulnerable = false
	hurt_invulnerable_timer = 0.0
	is_attacking = false
	can_dodge = true
	can_attack = true
	combo_step = 0
	dodge_cooldown_timer = 0.0
	attack_cooldown_timer = 0.0
	modulate = Color.WHITE
	if visual_node != null and visual_node.has_method("set_guarding"):
		visual_node.set_guarding(false, facing_direction)
	if visual_node != null and visual_node.has_method("set_hp_ratio"):
		visual_node.set_hp_ratio(1.0)
	if visual_node != null and visual_node.has_method("set_dead"):
		visual_node.set_dead(false)
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	print("[PLAYER] Trứng đã hồi sinh tại điểm bắt đầu!")
	player_respawned.emit()
