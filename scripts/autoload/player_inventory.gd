extends Node

# PlayerInventory: Autoload quản lý tiền tệ Mảnh Vỏ Vụn (EXP) và chỉ số nhân vật
# Đáp ứng COMBAT_SPEC mục 9: Lên cấp tự cộng điểm, tính chi phí và lưu trữ dữ liệu.

signal shards_changed(new_amount: int)
signal stats_changed()

var shell_shards: int = 0
var base_stats: Dictionary = {
	"VIT": 10,
	"STR": 10,
	"DEX": 10,
	"INT": 10,
	"FAI": 10,
	"LUK": 10
}
var added_points: Dictionary = {
	"VIT": 0,
	"STR": 0,
	"DEX": 0,
	"INT": 0,
	"FAI": 0,
	"LUK": 0
}
var total_added_points: int = 0
var level: int = 1

func _ready() -> void:
	_init_stats()

func _init_stats() -> void:
	var stats_data = GameData.get_category("base_stats", {})
	if not stats_data.is_empty():
		for s in stats_data:
			base_stats[s] = int(stats_data[s])
	
	for s in ["VIT", "STR", "DEX", "INT", "FAI", "LUK"]:
		if not base_stats.has(s):
			base_stats[s] = int(GameData.get_stat("base_stats", s, 10))
		if not added_points.has(s):
			added_points[s] = 0
	
	_recalculate_level()

func _recalculate_level() -> void:
	total_added_points = 0
	for s in added_points:
		total_added_points += int(added_points[s])
	level = StatsCalc.calc_level(total_added_points)

func add_shards(amount: int) -> void:
	if amount <= 0:
		return
	shell_shards += amount
	print("[INVENTORY] Nhận được %d Mảnh Vỏ Vụn (Hiện có: %d)" % [amount, shell_shards])
	shards_changed.emit(shell_shards)

func spend_shards(amount: int) -> bool:
	if amount < 0 or shell_shards < amount:
		return false
	shell_shards -= amount
	shards_changed.emit(shell_shards)
	return true

func spend_all_shards() -> int:
	var dropped: int = shell_shards
	shell_shards = 0
	shards_changed.emit(shell_shards)
	return dropped

func get_effective_stats() -> Dictionary:
	var effective: Dictionary = {}
	for s in base_stats:
		effective[s] = int(base_stats[s]) + int(added_points.get(s, 0))
	return effective

func can_level_up() -> bool:
	return shell_shards >= get_level_cost()

func get_level_cost() -> int:
	return StatsCalc.calc_level_cost(level)

func get_cost_for_next_level(level_offset: int) -> int:
	return StatsCalc.calc_level_cost(level + level_offset)

func apply_stat_point(stat_name: String) -> bool:
	if not base_stats.has(stat_name):
		return false
	var cost: int = get_level_cost()
	if not spend_shards(cost):
		return false
	
	added_points[stat_name] = int(added_points.get(stat_name, 0)) + 1
	_recalculate_level()
	print("[INVENTORY] Lên cấp %d! Điểm cộng vào %s (Tổng %s: %d)" % [
		level, stat_name, stat_name, int(base_stats[stat_name]) + int(added_points[stat_name])
	])
	stats_changed.emit()
	return true

func apply_multiple_stats(pending_adds: Dictionary) -> bool:
	var total_new_pts: int = 0
	for s in pending_adds:
		total_new_pts += maxi(0, int(pending_adds[s]))
	
	if total_new_pts <= 0:
		return true
	
	var total_cost: int = 0
	for i in range(total_new_pts):
		total_cost += StatsCalc.calc_level_cost(level + i)
	
	if shell_shards < total_cost:
		print("[INVENTORY] Không đủ Mảnh Vỏ Vụn để nâng cấp! Cần %d, có %d" % [total_cost, shell_shards])
		return false
	
	shell_shards -= total_cost
	for s in pending_adds:
		var pts: int = maxi(0, int(pending_adds[s]))
		if pts > 0:
			added_points[s] = int(added_points.get(s, 0)) + pts
	
	_recalculate_level()
	print("[INVENTORY] Đã nâng thành công %d điểm! Cấp hiện tại: %d, Mảnh Vỏ còn lại: %d" % [
		total_new_pts, level, shell_shards
	])
	shards_changed.emit(shell_shards)
	stats_changed.emit()
	return true

func export_data() -> Dictionary:
	return {
		"shell_shards": shell_shards,
		"added_points": added_points.duplicate(),
		"total_added_points": total_added_points,
		"level": level
	}

func import_data(data: Dictionary) -> void:
	if data.has("shell_shards"):
		shell_shards = int(data["shell_shards"])
	if data.has("added_points") and data["added_points"] is Dictionary:
		for s in data["added_points"]:
			added_points[s] = int(data["added_points"][s])
	_recalculate_level()
	shards_changed.emit(shell_shards)
	stats_changed.emit()
	print("[INVENTORY] Đã tải dữ liệu Inventory: Cấp %d, %d Mảnh Vỏ." % [level, shell_shards])
