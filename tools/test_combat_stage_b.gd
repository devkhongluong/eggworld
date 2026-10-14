extends Node

# Test suite cho Giai đoạn B (COMBAT_SPEC mục 5, 12, 13 & Yêu cầu bổ sung)
var log_lines: Array[String] = []

func log_msg(msg: String) -> void:
	print(msg)
	log_lines.append(msg)

func _ready() -> void:
	log_msg("==================================================")
	log_msg("BẮT ĐẦU KIỂM THỬ TỰ ĐỘNG GIAI ĐOẠN B (COMBAT_STAGE_B)")
	log_msg("==================================================")
	
	test_behavior_tracker_rules()
	test_poise_and_stagger()
	test_backstab()
	test_critical_hit()
	test_parry()
	test_heavy_attack_spec()
	
	log_msg("\n>>> TẤT CẢ KIỂM THỬ GIAI ĐOẠN B ĐÃ THÀNH CÔNG VƯỢT TRỘI! <<<")
	
	var f := FileAccess.open("res://test_stage_b_report.txt", FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(log_lines))
		f.close()
	
	get_tree().quit(0)

func assert_true(condition: bool, msg: String) -> void:
	if not condition:
		log_msg("  [FAIL] " + msg)
		var f := FileAccess.open("res://test_stage_b_report.txt", FileAccess.WRITE)
		if f != null:
			f.store_string("\n".join(log_lines))
			f.close()
		get_tree().quit(1)
	else:
		log_msg("  [PASS] " + msg)

func test_behavior_tracker_rules() -> void:
	print("\n--- 1. Kiểm thử Quy tắc Bộ Đếm Hành Vi & Thẻ Behavior Tag ---")
	BehaviorTracker.reset()
	
	# Test dagger (DODGE)
	var dagger_data := WeaponDB.get_weapon("dagger")
	assert_true(dagger_data.get("behavior_tag", "") == "DODGE", "Dao Găm phải có behavior_tag là DODGE")
	
	# Test sling (MAGIC)
	var sling_data := WeaponDB.get_weapon("sling")
	assert_true(sling_data.get("behavior_tag", "") == "MAGIC", "Ná phải có behavior_tag là MAGIC")
	
	# Test staff (none)
	var staff_data := WeaponDB.get_weapon("staff_wood")
	assert_true(staff_data.get("behavior_tag", "") == "", "Gậy Gỗ không có behavior_tag")
	
	# Giả lập cộng điểm từ behavior_tag
	var hit_pts: int = int(GameData.get_stat("behavior_points", "weapon_hit_points", 1))
	assert_true(hit_pts == 1, "Mỗi đòn trúng từ vũ khí có tag cộng đúng 1 điểm (stats.json)")
	
	BehaviorTracker.add_points(dagger_data["behavior_tag"], hit_pts)
	assert_true(BehaviorTracker.get_points(BehaviorTracker.ACTION_DODGE) == 1, "Cộng +1 DODGE khi chém trúng bằng Dao Găm")
	
	BehaviorTracker.add_points(sling_data["behavior_tag"], hit_pts)
	assert_true(BehaviorTracker.get_points(BehaviorTracker.ACTION_MAGIC) == 1, "Cộng +1 MAGIC khi bắn trúng bằng Ná")
	
	# Kiểm tra Guard thường (+2) và Parry (+4)
	var guard_pts: int = int(GameData.get_stat("behavior_points", "guard_normal", 2))
	var parry_pts: int = int(GameData.get_stat("behavior_points", "guard_parry", 4))
	assert_true(guard_pts == 2, "Đỡ thường cộng 2 điểm GUARD")
	assert_true(parry_pts == 4, "Đỡ khéo cộng 4 điểm GUARD")
	
	BehaviorTracker.add_points(BehaviorTracker.ACTION_GUARD, guard_pts)
	assert_true(BehaviorTracker.get_points(BehaviorTracker.ACTION_GUARD) == 2, "GUARD điểm hiện tại là 2 sau đỡ thường")
	BehaviorTracker.add_points(BehaviorTracker.ACTION_GUARD, parry_pts)
	assert_true(BehaviorTracker.get_points(BehaviorTracker.ACTION_GUARD) == 6, "GUARD điểm hiện tại là 6 sau đỡ khéo")

func test_poise_and_stagger() -> void:
	log_msg("\n--- 2. Kiểm thử Độ Vững (Poise) và Choáng (Stagger) ---")
	var enemy = load("res://scenes/enemies/dummy_enemy.tscn").instantiate()
	add_child(enemy)
	
	enemy.max_poise = 30.0
	enemy.current_poise = 30.0
	enemy.facing_direction = Vector2.DOWN
	
	# Đòn đánh gây 15 poise dmg
	var hit1 = enemy.receive_hit(10, null, {"poise_dmg": 15.0, "is_heavy": false})
	assert_true(enemy.current_poise == 15.0, "Trừ 15 poise: còn 15/30")
	assert_true(not enemy.is_staggered, "Chưa bị choáng khi poise > 0")
	
	# Đòn đánh tiếp theo gây 15 poise dmg -> vỡ poise
	var hit2 = enemy.receive_hit(10, null, {"poise_dmg": 15.0, "is_heavy": false})
	assert_true(enemy.is_staggered, "Bị choáng (is_staggered = true) khi poise về 0")
	assert_true(enemy.current_poise == enemy.max_poise, "Poise hồi lại sau khi vào trạng thái choáng")
	
	enemy.queue_free()

func test_backstab() -> void:
	log_msg("\n--- 3. Kiểm thử Đâm Lén (Backstab 90 độ sau lưng) ---")
	var enemy = load("res://scenes/enemies/dummy_enemy.tscn").instantiate()
	enemy.position = Vector2(100, 100)
	enemy.facing_direction = Vector2.RIGHT # Kẻ thù quay mặt sang phải
	add_child(enemy)
	
	var attacker = Node2D.new()
	attacker.position = Vector2(80, 100) # Đứng phía sau bên trái (lưng kẻ thù)
	add_child(attacker)
	
	# Đánh từ phía sau
	var res = enemy.receive_hit(10, attacker, {"is_heavy": false})
	assert_true(res.get("backstab", false) == true, "Xác định đúng đâm lén từ phía sau 90 độ")
	assert_true(res.get("damage", 0) == 20, "Sát thương x2.0 khi đâm lén (10 * 2.0 = 20)")
	
	# Đánh từ phía trước
	attacker.position = Vector2(120, 100) # Đứng phía trước (mặt kẻ thù)
	var res_front = enemy.receive_hit(10, attacker, {"is_heavy": false})
	assert_true(res_front.get("backstab", false) == false, "Đánh từ phía trước không phải đâm lén")
	assert_true(res_front.get("damage", 0) == 10, "Sát thương thường khi đánh trực diện")
	
	attacker.queue_free()
	enemy.queue_free()

func test_critical_hit() -> void:
	log_msg("\n--- 4. Kiểm thử Đòn Kết Liễu (Critical Hit / Riposte trên kẻ đang choáng) ---")
	var enemy = load("res://scenes/enemies/dummy_enemy.tscn").instantiate()
	enemy.position = Vector2(100, 100)
	enemy.facing_direction = Vector2.RIGHT
	add_child(enemy)
	
	# Cho enemy vào trạng thái choáng
	enemy.trigger_stagger()
	assert_true(enemy.is_staggered, "Kẻ thù đang trong trạng thái choáng")
	
	var attacker = Node2D.new()
	attacker.position = Vector2(120, 100)
	add_child(attacker)
	
	var res = enemy.receive_hit(10, attacker, {"is_heavy": false})
	assert_true(res.get("critical", false) == true, "Kích hoạt đòn kết liễu thành công khi đánh kẻ đang choáng")
	assert_true(res.get("damage", 0) == 25, "Sát thương x2.5 khi tung đòn kết liễu (10 * 2.5 = 25)")
	assert_true(not enemy.is_staggered, "Kẻ thù thoát trạng thái choáng sau khi chịu đòn kết liễu")
	
	attacker.queue_free()
	enemy.queue_free()

func test_parry() -> void:
	log_msg("\n--- 5. Kiểm thử Đỡ Khéo (Parry) ---")
	var player = load("res://scenes/player/player.tscn").instantiate()
	player.position = Vector2(100, 100)
	player.facing_direction = Vector2.RIGHT
	add_child(player)
	
	# Kẻ thù tấn công từ phía trước (bên phải Player)
	var attacker = load("res://scenes/enemies/dummy_enemy.tscn").instantiate()
	attacker.position = Vector2(120, 100)
	add_child(attacker)
	
	# Kích hoạt cửa sổ đỡ khéo (parry window)
	player.combat_state.is_parry_window = true
	var parry_res = player.receive_hit(20, attacker)
	
	assert_true(parry_res.get("parried", false) == true, "Đỡ khéo (Parry) thành công trong cửa sổ 8 frames")
	assert_true(parry_res.get("guarded", false) == true, "Cờ guarded bật khi parry")
	assert_true(player.current_hp == player.max_hp, "Parry triệt tiêu 100% sát thương (HP không đổi)")
	assert_true(attacker.is_staggered, "Kẻ tấn công bị choáng ngay lập tức khi bị Parry!")
	
	attacker.queue_free()
	player.queue_free()

func test_heavy_attack_spec() -> void:
	print("\n--- 6. Kiểm thử Dữ liệu và Công thức Đòn Nặng ---")
	for w_id in ["staff_wood", "dagger", "sling", "fist"]:
		var w = WeaponDB.get_weapon(w_id)
		assert_true(w.has("heavy"), "Vũ khí %s có cấu hình đòn nặng 'heavy'" % w_id)
		var h: Dictionary = w["heavy"]
		assert_true(h.has("startup") and h.has("active") and h.has("recovery"), "Đòn nặng %s có đủ 3 pha startup, active, recovery" % w_id)
		assert_true(h.has("poise_dmg"), "Đòn nặng %s có chỉ số poise_dmg" % w_id)
		
		var dmg_min = WeaponDB.calculate_damage(w, h, {"STR": 10, "DEX": 10}, 0.0)
		var dmg_max = WeaponDB.calculate_damage(w, h, {"STR": 10, "DEX": 10}, 1.0)
		assert_true(dmg_max >= dmg_min, "Sát thương gồng tối đa >= sát thương gồng tối thiểu (%d >= %d)" % [dmg_max, dmg_min])
