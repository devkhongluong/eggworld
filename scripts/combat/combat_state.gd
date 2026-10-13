extends RefCounted
class_name CombatState

# CombatState: Quản lý trạng thái và chu kỳ đòn đánh của nhân vật
# Hỗ trợ FSM trạng thái: IDLE, MOVE, ATTACKING, DODGING, GUARDING, STUNNED, DEAD

enum State {
	IDLE,
	MOVE,
	ATTACKING,
	DODGING,
	GUARDING,
	STUNNED,
	DEAD
}

var current_state: State = State.IDLE

var combo_step: int = 0
var is_in_hit_frame: bool = false
var already_hit_enemies: Array[Node] = []

var attack_cooldown_timer: float = 0.0
var combo_window_timer: float = 0.0
var stun_timer: float = 0.0

func reset_combo() -> void:
	combo_step = 0
	is_in_hit_frame = false
	combo_window_timer = 0.0
	already_hit_enemies.clear()

func process_timers(delta: float, is_attacking: bool) -> void:
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
	
	if combo_window_timer > 0.0:
		combo_window_timer -= delta
		if combo_window_timer <= 0.0 and not is_attacking:
			combo_step = 0
	
	if stun_timer > 0.0:
		stun_timer -= delta
		if stun_timer <= 0.0 and current_state == State.STUNNED:
			current_state = State.IDLE
