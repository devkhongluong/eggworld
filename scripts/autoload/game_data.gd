extends Node

# Autoload GameData: Quản lý nạp toàn bộ file cấu hình JSON trong thư mục data/
# Đảm bảo không hard-code bất kỳ chỉ số cân bằng nào vào mã nguồn.

var stats: Dictionary = {}

func _ready() -> void:
	load_all_data()

func load_all_data() -> void:
	stats = load_json_file("res://data/stats.json")
	if stats.is_empty():
		push_error("GameData: Không thể nạp dữ liệu từ stats.json!")
	else:
		print("GameData: Nạp thành công stats.json.")

func load_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("GameData: Không tìm thấy file JSON tại " + path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("GameData: Không thể mở file " + path)
		return {}
	var content := file.get_as_text()
	var json := JSON.new()
	var parse_result := json.parse(content)
	if parse_result != OK:
		push_error("GameData: Lỗi parse JSON tại %s (dòng %d): %s" % [path, json.get_error_line(), json.get_error_message()])
		return {}
	if json.data is Dictionary:
		return json.data
	push_warning("GameData: Dữ liệu JSON trong %s không phải là Dictionary!" % path)
	return {}

func get_stat(category: String, key: String, default_value: Variant = null) -> Variant:
	if stats.has(category) and stats[category] is Dictionary and stats[category].has(key):
		return stats[category][key]
	return default_value
