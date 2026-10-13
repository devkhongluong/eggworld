extends RefCounted
class_name CombatState

# CombatState: Quản lý trạng thái và chu kỳ đòn đánh của nhân vật
# Hỗ trợ FSM trạng thái: IDLE, MOVE, ATTACK_STARTUP, ATTACK_ACTIVE, ATTACK_RECOVERY, DODGING, GUARDING, STUNNED, DEAD
# Quản lý 3 pha logic 60 FPS: startup -> active -> recovery (với cancel_from)

enum State {
	IDLE,
	MOVE,
	ATTACKING,
	ATTACK_STARTUP,
	ATTACK_ACTIVE,
	ATTACK_RECOVERY,
	DODGING,
	GUARDING,
	STUNNED,
	DEAD
}

enum AttackPhase {
	NONE,
	STARTUP,
	ACTIVE,
	RECOVERY
}

var current_state: State = State.IDLE
var attack_phase: AttackPhase = AttackPhase.NONE

var combo_step: int = 0
var attack_frame: int = 0
var combo_window_frames: int = 0
var combo_buffered: bool = false

var is_in_hit_frame: bool = false
var already_hit_enemies: Array[Node] = []

var attack_cooldown_timer: float = 0.0
var combo_window_timer: float = 0.0
var stun_timer: float = 0.0

func is_attacking() -> bool:
	return attack_phase != AttackPhase.NONE or current_state == State.ATTACKING or \
		current_state == State.ATTACK_STARTUP or current_state == State.ATTACK_ACTIVE or \
		current_state == State.ATTACK_RECOVERY

func can_cancel_to_dodge(cancel_from: int) -> bool:
	# Chỉ được hủy sang né khi đang ở pha recovery và đã qua khung cancel_from
	return attack_phase == AttackPhase.RECOVERY and attack_frame >= cancel_from

func can_chain_combo(cancel_from: int) -> bool:
	# Cho phép nối chuỗi combo từ khung cancel_from của pha recovery
	return attack_phase == AttackPhase.RECOVERY and attack_frame >= cancel_from

func reset_combo() -> void:
	combo_step = 0
	attack_phase = AttackPhase.NONE
	attack_frame = 0
	combo_window_frames = 0
	combo_buffered = false
	is_in_hit_frame = false
	combo_window_timer = 0.0
	already_hit_enemies.clear()

func process_timers(delta: float, attacking_flag: bool) -> void:
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
	
	if combo_window_timer > 0.0:
		combo_window_timer -= delta
		if combo_window_timer <= 0.0 and not attacking_flag:
			combo_step = 0
	
	if stun_timer > 0.0:
		stun_timer -= delta
		if stun_timer <= 0.0 and current_state == State.STUNNED:
			current_state = State.IDLE
