extends Node

# Autoload SaveManager: Nơi DUY NHẤT được ghi file save vào user://
# Đảm bảo lưu/tải an toàn toàn bộ tiến trình người chơi và 5 bộ đếm hành vi dưới dạng JSON.

const SAVE_PATH: String = "user://savegame.json"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(extra_data: Dictionary = {}) -> bool:
	var save_dict: Dictionary = {
		"version": 1,
		"timestamp": Time.get_unix_time_from_system(),
		"behavior_counters": BehaviorTracker.export_data(),
		"extra": extra_data
	}
	
	var json_str := JSON.stringify(save_dict, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		var err := FileAccess.get_open_error()
		push_error("SaveManager: Lỗi khi mở file save để ghi: %d" % err)
		return false
	
	file.store_string(json_str)
	file.close()
	print("SaveManager: Đã lưu game thành công vào " + SAVE_PATH)
	return true

func load_game() -> Dictionary:
	if not has_save():
		print("SaveManager: Chưa có file save tại " + SAVE_PATH)
		return {}
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: Không thể mở file save để đọc")
		return {}
	
	var content := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var err := json.parse(content)
	if err != OK:
		push_error("SaveManager: Lỗi parse file save: %s" % json.get_error_message())
		return {}
	
	var data = json.data
	if not data is Dictionary:
		push_error("SaveManager: Nội dung file save không hợp lệ")
		return {}
	
	if data.has("behavior_counters") and data["behavior_counters"] is Dictionary:
		BehaviorTracker.import_data(data["behavior_counters"])
	
	print("SaveManager: Đã nạp dữ liệu save thành công.")
	return data

func delete_save() -> bool:
	if has_save():
		var err := DirAccess.remove_absolute(SAVE_PATH)
		return err == OK
	return true
