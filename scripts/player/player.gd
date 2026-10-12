extends CharacterBody2D
class_name Player

# Player: Nhân vật Trứng (khởi đầu) trong game "Vỡ Vỏ"
# Tuân thủ nghiêm ngặt GDD:
# - Mọi chỉ số lấy từ GameData.stats (data/stats.json)
# - Mọi màu lấy từ Palette (scripts/autoload/palette.gd)
# - Input hoàn toàn qua Input Map (không đọc phím trực tiếp)

signal hp_changed(new_hp: int, max_hp: int)
signal stamina_changed(new_stamina: float, max_stamina: float)
signal player_died()
signal player_respawned()

@onready var visual_node: Node2D = $EggVisual
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Area2D = $Hurtbox

# Chỉ số lấy từ stats.json
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

# Trạng thái người chơi
var facing_direction: Vector2 = Vector2.DOWN
var is_dodging: bool = false
var is_invulnerable: bool = false
var can_dodge: bool = true
var is_dead: bool = false

var dodge_timer: float = 0.0
var dodge_cooldown_timer: float = 0.0
var stamina_delay_timer: float = 0.0
var dodge_direction: Vector2 = Vector2.ZERO

var spawn_position: Vector2 = Vector2.ZERO
var respawn_timer: float = 0.0
var flash_timer: float = 0.0

func _ready() -> void:
	load_stats_from_data()
	spawn_position = global_position
	current_hp = max_hp
	current_stamina = max_stamina
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)

func load_stats_from_data() -> void:
	max_hp = int(GameData.get_stat("player", "max_hp", 100))
	max_stamina = float(GameData.get_stat("player", "max_stamina", 100.0))
	move_speed = float(GameData.get_stat("player", "move_speed", 95.0))
	dodge_speed_multiplier = float(GameData.get_stat("player", "dodge_speed_multiplier", 1.85))
	dodge_duration = float(GameData.get_stat("player", "dodge_duration", 0.25))
	dodge_cooldown = float(GameData.get_stat("player", "dodge_cooldown", 0.2))
	dodge_stamina_cost = float(GameData.get_stat("player", "dodge_stamina_cost", 20.0))
	stamina_recovery_rate = float(GameData.get_stat("player", "stamina_recovery_rate", 30.0))
	stamina_recovery_delay = float(GameData.get_stat("player", "stamina_recovery_delay", 0.35))

func _physics_process(delta: float) -> void:
	if is_dead:
		process_death(delta)
		return
	
	process_cooldowns(delta)
	process_input_and_movement(delta)
	process_stamina(delta)
	process_visual_effects(delta)

func process_cooldowns(delta: float) -> void:
	if dodge_cooldown_timer > 0.0:
		dodge_cooldown_timer -= delta
		if dodge_cooldown_timer <= 0.0:
			can_dodge = true
	
	if stamina_delay_timer > 0.0:
		stamina_delay_timer -= delta

func process_input_and_movement(delta: float) -> void:
	if is_dodging:
		dodge_timer -= delta
		velocity = dodge_direction * (move_speed * dodge_speed_multiplier)
		move_and_slide()
		if dodge_timer <= 0.0:
			end_dodge()
		return
	
	# Đọc hướng di chuyển 8 hướng qua Input Map
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector.normalized()
		velocity = input_vector * move_speed
		stamina_delay_timer = maxf(stamina_delay_timer, stamina_recovery_delay)
	else:
		velocity = Vector2.ZERO
	
	# Kiểm tra lệnh lăn né
	if Input.is_action_just_pressed("dodge"):
		try_dodge(input_vector)
	
	move_and_slide()

func try_dodge(input_vector: Vector2) -> void:
	if not can_dodge or is_dodging:
		return
	
	# Quy tắc điều chỉnh #4: Không đủ Stamina thì không được lăn
	if current_stamina < dodge_stamina_cost:
		print("[PLAYER] Không đủ Stamina để lăn né! (Cần %.1f, có %.1f)" % [dodge_stamina_cost, current_stamina])
		return
	
	# Bắt đầu lăn né
	current_stamina -= dodge_stamina_cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_dodging = true
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
	is_invulnerable = false
	dodge_cooldown_timer = dodge_cooldown

func process_stamina(delta: float) -> void:
	# Stamina chỉ hồi dần khi đứng yên và không trong thời gian delay
	if not is_dodging and velocity == Vector2.ZERO and stamina_delay_timer <= 0.0:
		if current_stamina < max_stamina:
			current_stamina = minf(max_stamina, current_stamina + stamina_recovery_rate * delta)
			stamina_changed.emit(current_stamina, max_stamina)

func process_visual_effects(delta: float) -> void:
	if flash_timer > 0.0:
		flash_timer -= delta
		if flash_timer <= 0.0:
			modulate = Color.WHITE

func receive_hit(damage: int, attack_source: Node) -> Dictionary:
	if is_dead:
		return {"hit": false, "dodged": false}
	
	# Nếu đang trong thời gian bất tử khi lăn né -> né thành công
	if is_invulnerable:
		print("[COMBAT] Né thành công đòn đánh! +2 điểm DODGE")
		BehaviorTracker.add_points(BehaviorTracker.ACTION_DODGE, 2)
		return {"hit": false, "dodged": true}
	
	# Nhận sát thương
	current_hp = maxi(0, current_hp - damage)
	hp_changed.emit(current_hp, max_hp)
	print("[COMBAT] Player nhận %d sát thương! HP còn: %d/%d" % [damage, current_hp, max_hp])
	
	# Nhấp nháy báo bị thương
	modulate = Palette.DO_GACH
	flash_timer = 0.15
	
	if current_hp <= 0:
		die()
	
	return {"hit": true, "dodged": false}

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	is_dodging = false
	is_invulnerable = false
	respawn_timer = 1.5
	modulate = Palette.XAM_SAT
	print("[PLAYER] VỎ ĐÃ VỠ... Bắt đầu chuẩn bị hồi sinh.")
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
	is_dodging = false
	is_invulnerable = false
	can_dodge = true
	dodge_cooldown_timer = 0.0
	modulate = Color.WHITE
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	print("[PLAYER] Trứng đã hồi sinh tại điểm bắt đầu!")
	player_respawned.emit()
