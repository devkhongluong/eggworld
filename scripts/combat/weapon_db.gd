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
	
	var path := "res://data/weapons.json"
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				_weapons_cache = json.data
				print("[WeaponDB] Đã tải thành công weapons.json (%d vũ khí)." % _weapons_cache.size())
				return
	
	# Fallback mặc định
	_weapons_cache = {}
