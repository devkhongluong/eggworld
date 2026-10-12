extends Node

# Autoload BehaviorTracker: 5 bộ đếm hành vi ẩn của Trứng (GDD Mục 6.1)
# GUARD, DODGE, MAGIC, EXPLORE, SUPPORT
# Dùng để quyết định nhánh tiến hóa tại các mốc mà người chơi không thấy số điểm trực tiếp.

signal points_changed(action_name: String, new_points: int, total_points: int)

const ACTION_GUARD: String = "GUARD"
const ACTION_DODGE: String = "DODGE"
const ACTION_MAGIC: String = "MAGIC"
const ACTION_EXPLORE: String = "EXPLORE"
const ACTION_SUPPORT: String = "SUPPORT"

const VALID_ACTIONS: Array[String] = [
	ACTION_GUARD,
	ACTION_DODGE,
	ACTION_MAGIC,
	ACTION_EXPLORE,
	ACTION_SUPPORT
]

var _counters: Dictionary = {
	ACTION_GUARD: 0,
	ACTION_DODGE: 0,
	ACTION_MAGIC: 0,
	ACTION_EXPLORE: 0,
	ACTION_SUPPORT: 0
}

func add_points(action_name: String, points: int) -> void:
	if not _counters.has(action_name):
		push_warning("BehaviorTracker: Hành động không hợp lệ: " + action_name)
		return
	if points <= 0:
		return
	_counters[action_name] += points
	var total: int = get_total_points()
	points_changed.emit(action_name, _counters[action_name], total)
	print("[BehaviorTracker] +%d %s (Hiện tại: %d, Tổng: %d)" % [points, action_name, _counters[action_name], total])

func get_points(action_name: String) -> int:
	return _counters.get(action_name, 0)

func get_total_points() -> int:
	var total: int = 0
	for key in _counters:
		total += int(_counters[key])
	return total

func get_ratios() -> Dictionary:
	var total: int = get_total_points()
	var ratios: Dictionary = {}
	for key in _counters:
		if total > 0:
			ratios[key] = float(_counters[key]) / float(total)
		else:
			ratios[key] = 0.0
	return ratios

func reset() -> void:
	for key in _counters:
		_counters[key] = 0

func export_data() -> Dictionary:
	return _counters.duplicate()

func import_data(data: Dictionary) -> void:
	for action_name in VALID_ACTIONS:
		if data.has(action_name):
			_counters[action_name] = int(data[action_name])
