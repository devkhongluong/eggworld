extends CharacterBody2D

# Kẻ thù giả để kiểm tra né đòn và nhận sát thương.
# Tuân thủ:
# - Báo hiệu nhấp nháy Đỏ Gạch (DO_GACH) đúng 0.3 giây trước khi gây sát thương (GDD Mục 3 & 7)
# - Chỉ cộng DODGE tối đa 1 lần cho mỗi lượt tung đòn (Quy tắc điều chỉnh #3)
# - Số liệu cân bằng lấy từ data/stats.json
# - Màu sắc 100% từ Palette

enum State { IDLE, TELEGRAPH, ATTACK, RECOVERY }

@onready var visual_node: Node2D = $EnemyVisual
@onready var attack_area: Area2D = $AttackArea

var max_hp: int = 50
var current_hp: int = 50
var damage: int = 20
var telegraph_duration: float = 0.3
var attack_interval: float = 2.2
var attack_radius: float = 28.0

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

func _physics_process(delta: float) -> void:
	state_timer -= delta
	
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
				parent.receive_hit(damage, self)
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

func receive_hit(amount: int, _attack_source: Node) -> Dictionary:
	current_hp = maxi(0, current_hp - amount)
	print("[ENEMY] Nhận %d sát thương từ Player! HP còn: %d/%d" % [amount, current_hp, max_hp])
	modulate = Palette.KEM
	hurt_flash_timer = 0.15
	if current_hp <= 0:
		print("[ENEMY] Kẻ thù bị tiêu diệt! Tự động hồi phục sau 1.5 giây.")
		current_hp = max_hp
	return {"hit": true, "damage": amount}
