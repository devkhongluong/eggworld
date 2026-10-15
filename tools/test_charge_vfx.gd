extends Node

# Test suite for Heavy Attack Charge VFX Integration

var tests_passed: int = 0
var tests_failed: int = 0

func assert_true(cond: bool, msg: String) -> void:
	if cond:
		tests_passed += 1
		print("  [PASS] %s" % msg)
	else:
		tests_failed += 1
		printerr("  [FAIL] %s" % msg)

func assert_false(cond: bool, msg: String) -> void:
	assert_true(not cond, msg)

func assert_eq(a: Variant, b: Variant, msg: String) -> void:
	assert_true(a == b, "%s (Gia tri: %s == %s)" % [msg, str(a), str(b)])

func _ready() -> void:
	print("==================================================")
	print("BAT DAU KIEM THU: HEAVY CHARGE VFX INTEGRATION")
	print("==================================================")
	
	test_config_and_manifest()
	test_charge_thresholds()
	test_player_charge_progression_and_signals()
	test_early_release_cancel()
	test_release_effects_per_weapon()
	test_damage_and_hitbox_invariance()
	test_cancel_cleanup()
	
	print("\n==================================================")
	print("KET QUA KIEM THU: %d PASS, %d FAIL" % [tests_passed, tests_failed])
	print("==================================================")
	if tests_failed > 0:
		get_tree().quit(1)
	else:
		get_tree().quit(0)

func test_config_and_manifest() -> void:
	print("\n--- 1. Kiểm thử cấu hình vfx_charge.json và manifest.json ---")
	assert_true(not GameData.vfx_charge.is_empty(), "GameData đã nạp thành công vfx_charge.json")
	var weapons: Dictionary = GameData.vfx_charge.get("weapons", {})
	assert_true(weapons.has("staff_wood"), "vfx_charge có cấu hình cho staff_wood")
	assert_true(weapons.has("dagger"), "vfx_charge có cấu hình cho dagger")
	assert_true(weapons.has("sling"), "vfx_charge có cấu hình cho sling")
	
	for w_id in ["staff_wood", "dagger", "sling"]:
		var w_cfg: Dictionary = weapons[w_id]
		assert_true(w_cfg.has("offsets"), "Vũ khí %s có khai báo offsets" % w_id)
		var offs: Dictionary = w_cfg["offsets"]
		assert_true(offs.has("side") and offs.has("up") and offs.has("down"), "Vũ khí %s có đủ 3 hướng side, up, down" % w_id)

func test_charge_thresholds() -> void:
	print("\n--- 2. Kiểm thử 3 mức tụ lực (Stage 1, Stage 2, Stage 3) ---")
	var vfx := ChargeVfx.new()
	add_child(vfx)
	
	# Staff Wood: min ~0.27, stage 2 = 0.6, stage 3 = 1.0
	assert_eq(vfx.get_stage_from_ratio("staff_wood", 0.15), 0, "Staff ratio 0.15 là Stage 0 (chưa đạt min)")
	assert_eq(vfx.get_stage_from_ratio("staff_wood", 0.35), 1, "Staff ratio 0.35 là Stage 1")
	assert_eq(vfx.get_stage_from_ratio("staff_wood", 0.65), 2, "Staff ratio 0.65 là Stage 2")
	assert_eq(vfx.get_stage_from_ratio("staff_wood", 1.0), 3, "Staff ratio 1.0 là Stage 3 (Đầy)")
	
	# Dagger
	assert_eq(vfx.get_stage_from_ratio("dagger", 0.10), 0, "Dagger ratio 0.10 là Stage 0")
	assert_eq(vfx.get_stage_from_ratio("dagger", 0.30), 1, "Dagger ratio 0.30 là Stage 1")
	assert_eq(vfx.get_stage_from_ratio("dagger", 0.70), 2, "Dagger ratio 0.70 là Stage 2")
	assert_eq(vfx.get_stage_from_ratio("dagger", 1.0), 3, "Dagger ratio 1.0 là Stage 3")
	
	# Sling
	assert_eq(vfx.get_stage_from_ratio("sling", 0.20), 0, "Sling ratio 0.20 là Stage 0")
	assert_eq(vfx.get_stage_from_ratio("sling", 0.35), 1, "Sling ratio 0.35 là Stage 1")
	assert_eq(vfx.get_stage_from_ratio("sling", 0.65), 2, "Sling ratio 0.65 là Stage 2")
	assert_eq(vfx.get_stage_from_ratio("sling", 1.0), 3, "Sling ratio 1.0 là Stage 3")
	
	vfx.queue_free()

func test_player_charge_progression_and_signals() -> void:
	print("\n--- 3. Kiểm thử tiến trình tụ lực & Tín hiệu charge_stage_reached ---")
	var player_scene = load("res://scenes/player/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	player.current_stamina = 100.0
	player.equip_weapon_to_active_slot("staff_wood")
	
	var received_stages: Array[int] = []
	player.charge_stage_reached.connect(func(w_id: String, stage: int):
		received_stages.append(stage)
	)
	
	player.start_heavy_charge()
	assert_true(player.is_charging_heavy, "Player bắt đầu gồng đòn nặng")
	assert_eq(player.charge_vfx.current_stage, 0, "Ban đầu là stage 0")
	
	# Giữ nút attack khi gồng
	Input.action_press("attack")
	
	# Giả lập gồng tới Stage 1 (0.35s)
	player.process_heavy_charge(0.35)
	assert_eq(player.charge_vfx.current_stage, 1, "Sau 0.35s đạt Stage 1")
	assert_true(1 in received_stages, "Tín hiệu charge_stage_reached phát ra với stage 1")
	
	# Giả lập gồng tới Stage 2 (thêm 0.25s -> tổng 0.60s / 0.9s = 0.67)
	player.process_heavy_charge(0.25)
	assert_eq(player.charge_vfx.current_stage, 2, "Sau 0.60s đạt Stage 2")
	assert_true(2 in received_stages, "Tín hiệu charge_stage_reached phát ra với stage 2")
	
	# Giả lập gồng tới Stage 3 (thêm 0.20s -> tổng 0.80s / 0.9s = 0.89 >= stage 3 0.85)
	player.process_heavy_charge(0.20)
	assert_eq(player.charge_vfx.current_stage, 3, "Sau 0.80s đạt Stage 3")
	assert_true(3 in received_stages, "Tín hiệu charge_stage_reached phát ra với stage 3")
	
	# Kiểm tra thân Trứng rung +-1 px ở mức 3 (khi vẫn đang gồng)
	assert_true(player.is_charging_heavy, "Vẫn đang trong trạng thái gồng ở Stage 3")
	var shake: Vector2 = player.charge_vfx.get_egg_shake_offset()
	assert_true(abs(shake.x) == 1.0, "Thân Trứng rung +-1 px ở Stage 3 (shake.x = %.1f)" % shake.x)
	
	# Nhả nút để ra đòn
	Input.action_release("attack")
	player.process_heavy_charge(0.01)
	assert_false(player.is_charging_heavy, "Thoát trạng thái gồng sau khi nhả nút")
	assert_true(player.is_heavy_attack, "Tung ra đòn nặng thành công")
	
	player.queue_free()

func test_early_release_cancel() -> void:
	print("\n--- 4. Kiểm thử Buông Sớm (Early Release) -> Hủy Tích Lực & Puff Cancel ---")
	var player_scene = load("res://scenes/player/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	player.current_stamina = 100.0
	player.equip_weapon_to_active_slot("staff_wood")
	
	player.start_heavy_charge()
	# Giả lập giữ chỉ 0.08s (nhỏ hơn c_min 0.25s)
	player.heavy_charge_timer = 0.08
	
	# Nhả nút: gọi process_heavy_charge với button_down = false
	Input.action_release("attack")
	player.process_heavy_charge(0.01)
	
	assert_false(player.is_charging_heavy, "Đã thoát gồng đòn nặng do buông sớm")
	assert_false(player.is_attacking, "Không tung ra đòn nặng khi buông sớm")
	assert_eq(player.combat_state.current_state, CombatState.State.IDLE, "Trạng thái quay về IDLE sạch sẽ")
	
	player.queue_free()

func test_release_effects_per_weapon() -> void:
	print("\n--- 5. Kiểm thử Hiệu ứng Thả Đòn (Release VFX) Cho Từng Vũ Khí ---")
	var player_scene = load("res://scenes/player/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	player.current_stamina = 100.0
	
	# Gậy Gỗ (Staff)
	player.equip_weapon_to_active_slot("staff_wood")
	player.start_heavy_charge()
	Input.action_press("attack")
	player.process_heavy_charge(0.60) # Stage 2
	Input.action_release("attack")
	var child_count_before := get_child_count()
	player.release_heavy_attack()
	assert_true(player.is_heavy_attack, "Tung đòn nặng Gậy Gỗ")
	assert_true(get_child_count() > child_count_before, "Đã sinh OneShotVfx release_staff_dust trên sân")
	
	# Dao Găm (Dagger)
	player.is_attacking = false
	player.equip_weapon_to_active_slot("dagger")
	player.start_heavy_charge()
	Input.action_press("attack")
	player.process_heavy_charge(0.45) # Stage 2
	Input.action_release("attack")
	child_count_before = get_child_count()
	player.release_heavy_attack()
	assert_true(player.is_heavy_attack, "Tung đòn nặng Dao Găm")
	assert_true(get_child_count() > child_count_before, "Đã sinh OneShotVfx release_dagger_speed phía sau")
	
	# Ná (Sling)
	player.is_attacking = false
	player.equip_weapon_to_active_slot("sling")
	player.start_heavy_charge()
	Input.action_press("attack")
	player.process_heavy_charge(0.65) # Stage 2
	Input.action_release("attack")
	player.release_heavy_attack()
	assert_eq(player.last_heavy_charge_stage, 2, "Ghi nhận last_heavy_charge_stage = 2 cho Ná")
	
	player.queue_free()

func test_damage_and_hitbox_invariance() -> void:
	print("\n--- 6. Kiểm thử Sát Thương & Hitbox Bất Biến Trước/Sau Khi Có VFX ---")
	for w_id in ["staff_wood", "dagger", "sling"]:
		var w = WeaponDB.get_weapon(w_id)
		var h: Dictionary = w["heavy"]
		
		# Sát thương Stage 1 (min charge ratio = 0.0 trong công thức)
		var dmg_s1 = WeaponDB.calculate_damage(w, h, {"STR": 10, "DEX": 10}, 0.0)
		# Sát thương Stage 3 (max charge ratio = 1.0)
		var dmg_s3 = WeaponDB.calculate_damage(w, h, {"STR": 10, "DEX": 10}, 1.0)
		
		assert_true(dmg_s3 >= dmg_s1, "Vũ khí %s: Sát thương Stage 3 (%d) >= Stage 1 (%d)" % [w_id, dmg_s3, dmg_s1])
		assert_true(h.has("hitbox"), "Hitbox đòn nặng %s được bảo toàn nguyên vẹn" % w_id)

func test_cancel_cleanup() -> void:
	print("\n--- 7. Kiểm thử Dọn Sạch Trạng Thái Khi Bị Choáng / Né / Hủy ---")
	var player_scene = load("res://scenes/player/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	player.current_stamina = 100.0
	player.equip_weapon_to_active_slot("staff_wood")
	
	# Hủy bằng Dodge
	player.start_heavy_charge()
	player.process_heavy_charge(0.4)
	player.cancel_heavy_charge()
	assert_false(player.is_charging_heavy, "is_charging_heavy là false sau cancel")
	assert_false(player.charge_vfx.is_charging, "charge_vfx.is_charging là false")
	assert_eq(player.charge_vfx.current_stage, 0, "current_stage reset về 0")
	assert_eq(player.charge_vfx.get_egg_shake_offset(), Vector2.ZERO, "Độ rung Trứng reset về 0")
	
	player.queue_free()
