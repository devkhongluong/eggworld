extends RefCounted
class_name WeaponDB

# WeaponDB: Dịch vụ truy vấn và quản lý dữ liệu vũ khí
# Tải cấu hình từ data/weapons.json (nếu có) hoặc fallback dữ liệu mặc định

static var _weapons_cache: Dictionary = {}

static func get_weapon(weapon_id: String) -> Dictionary:
	_ensure_loaded()
	if _weapons_cache.has(weapon_id):
		return _weapons_cache[weapon_id]
	return {}

static func get_all_weapons() -> Dictionary:
	_ensure_loaded()
	return _weapons_cache

static func _ensure_loaded() -> void:
	if not _weapons_cache.is_empty():
		return
	
	# Đọc dữ liệu qua GameData (Autoload) theo yêu cầu COMBAT_SPEC
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var gd = root.root.get_node_or_null("GameData")
		if gd != null and not gd.weapons.is_empty():
			_weapons_cache = gd.weapons
			return
	
	# Fallback nếu chạy trong môi trường SceneTree độc lập chưa có Autoload
	var path := "res://data/weapons.json"
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				_weapons_cache = json.data
				return
	
	_weapons_cache = {}

const SCALING_COEFF: Dictionary = {
	"S": 0.08,
	"A": 0.06,
	"B": 0.045,
	"C": 0.03,
	"D": 0.02,
	"E": 0.01,
	"-": 0.0
}

static func calculate_damage(weapon: Dictionary, attack_spec: Dictionary, stats: Dictionary) -> int:
	var base_dmg: float = float(weapon.get("base_damage", 10))
	var mv: float = float(attack_spec.get("damage_mv", 1.0))
	
	# Tính scaling
	var scaling: Dictionary = weapon.get("scaling", {})
	var scaling_sum: float = 0.0
	for stat_name in scaling:
		var grade: String = str(scaling[stat_name])
		var coeff: float = float(SCALING_COEFF.get(grade, 0.0))
		var stat_val: int = int(stats.get(stat_name, 10))
		var stat_diff: int = maxi(0, stat_val - 10)
		scaling_sum += coeff * float(stat_diff)
	
	var dmg: float = base_dmg * mv * (1.0 + scaling_sum)
	
	# Kiểm tra thiếu chỉ số yêu cầu (Requirements penalty)
	var reqs: Dictionary = weapon.get("requirements", {})
	var missing_pts: int = 0
	for stat_name in reqs:
		var req_val: int = int(reqs[stat_name])
		var stat_val: int = int(stats.get(stat_name, 10))
		if stat_val < req_val:
			missing_pts += (req_val - stat_val)
	
	if missing_pts > 0:
		var penalty_mult: float = maxf(0.5, 1.0 - 0.05 * float(missing_pts))
		dmg *= penalty_mult
	
	return maxi(1, int(round(dmg)))

static func calculate_stamina_cost(attack_spec: Dictionary, weapon: Dictionary, stats: Dictionary) -> float:
	var base_cost: float = float(attack_spec.get("stamina", 8.0))
	
	var reqs: Dictionary = weapon.get("requirements", {})
	var missing_pts: int = 0
	for stat_name in reqs:
		var req_val: int = int(reqs[stat_name])
		var stat_val: int = int(stats.get(stat_name, 10))
		if stat_val < req_val:
			missing_pts += (req_val - stat_val)
	
	if missing_pts > 0:
		base_cost *= (1.0 + 0.04 * float(missing_pts))
	
	return base_cost

