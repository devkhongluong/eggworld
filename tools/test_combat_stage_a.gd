extends SceneTree

# Test verification script for Combat Stage A

func _init() -> void:
	print("--- BAT DAU TEST STAGE A: WEAPONS & COMBAT ---")
	
	# 1. Test WeaponDB
	var weapons: Dictionary = WeaponDB.get_all_weapons()
	assert(weapons.has("staff_wood"), "Thieu staff_wood!")
	assert(weapons.has("dagger"), "Thieu dagger!")
	assert(weapons.has("sling"), "Thieu sling!")
	assert(weapons.has("fist"), "Thieu fist!")
	print("[PASS] 1. WeaponDB da tai day du 4 loai vu khi tu weapons.json.")
	
	# 2. Test Stats & Damage Calculation
	var stats := { "STR": 10, "DEX": 10, "INT": 10, "FAI": 10, "VIT": 10, "LUK": 10 }
	var staff_data: Dictionary = WeaponDB.get_weapon("staff_wood")
	var staff_spec_1: Dictionary = staff_data["light_chain"][0]
	var dmg_staff_1: int = WeaponDB.calculate_damage(staff_data, staff_spec_1, stats)
	var sta_staff_1: float = WeaponDB.calculate_stamina_cost(staff_spec_1, staff_data, stats)
	print("[PASS] 2. Sát thương Gậy Gỗ đòn 1 = %d, Stamina = %.1f" % [dmg_staff_1, sta_staff_1])
	assert(dmg_staff_1 == 12, "Sat thuong don 1 Gay Go phai la 12!")
	assert(is_equal_approx(sta_staff_1, 8.0), "Stamina don 1 Gay Go phai la 8.0!")
	
	var dagger_data: Dictionary = WeaponDB.get_weapon("dagger")
	var dagger_spec_1: Dictionary = dagger_data["light_chain"][0]
	var dmg_dagger_1: int = WeaponDB.calculate_damage(dagger_data, dagger_spec_1, stats)
	var sta_dagger_1: float = WeaponDB.calculate_stamina_cost(dagger_spec_1, dagger_data, stats)
	print("[PASS] 3. Sát thương Dao Găm đòn 1 = %d, Stamina = %.1f" % [dmg_dagger_1, sta_dagger_1])
	assert(dmg_dagger_1 == 6, "Sat thuong don 1 Dao Gam phai la 6 (9 * 0.7)!")
	assert(is_equal_approx(sta_dagger_1, 4.0), "Stamina don 1 Dao Gam phai la 4.0!")
	
	var sling_data: Dictionary = WeaponDB.get_weapon("sling")
	var sling_spec_1: Dictionary = sling_data["light_chain"][0]
	var dmg_sling_1: int = WeaponDB.calculate_damage(sling_data, sling_spec_1, stats)
	var sta_sling_1: float = WeaponDB.calculate_stamina_cost(sling_spec_1, sling_data, stats)
	print("[PASS] 4. Sát thương Ná đòn 1 = %d, Stamina = %.1f" % [dmg_sling_1, sta_sling_1])
	assert(dmg_sling_1 == 9, "Sat thuong don 1 Na phai la 9 (10 * 0.9)!")
	assert(is_equal_approx(sta_sling_1, 7.0), "Stamina don 1 Na phai la 7.0!")
	
	# 3. Test Requirement Penalty
	var low_stats := { "STR": 5, "DEX": 5, "INT": 10, "FAI": 10, "VIT": 10, "LUK": 10 }
	var dmg_pen: int = WeaponDB.calculate_damage(staff_data, staff_spec_1, low_stats)
	var sta_pen: float = WeaponDB.calculate_stamina_cost(staff_spec_1, staff_data, low_stats)
	print("[PASS] 5. Penalty thiếu chỉ số: Sát thương = %d (giảm), Stamina = %.1f (tăng)" % [dmg_pen, sta_pen])
	assert(dmg_pen < dmg_staff_1, "Sát thương phai bi phat khi thieu chi so!")
	assert(sta_pen > sta_staff_1, "Stamina phai tang khi thieu chi so!")
	
	# 4. Test CombatState 60 FPS Logic
	var cs := CombatState.new()
	assert(not cs.is_attacking(), "Ban dau khong duoc o trang thai attacking!")
	cs.attack_phase = CombatState.AttackPhase.STARTUP
	assert(cs.is_attacking(), "Phai la attacking o pha startup!")
	assert(not cs.can_cancel_to_dodge(3), "Khong the cancel dodge o pha startup!")
	
	cs.attack_phase = CombatState.AttackPhase.RECOVERY
	cs.attack_frame = 2
	assert(not cs.can_cancel_to_dodge(3), "Chua toi khung 3 thi chua the cancel dodge!")
	cs.attack_frame = 3
	assert(cs.can_cancel_to_dodge(3), "Khung 3 recovery phai duoc cancel dodge!")
	assert(cs.can_chain_combo(3), "Khung 3 recovery phai duoc chain combo!")
	print("[PASS] 6. CombatState: 3 pha logic va cancel_from hoat dong chinh xac.")
	
	# 5. Test HitboxService Shapes
	var test_area := Area2D.new()
	var col_shape := CollisionShape2D.new()
	test_area.add_child(col_shape)
	
	HitboxService.configure_hitbox(test_area, { "shape": "arc", "radius": 18 }, "down", false)
	assert(col_shape.shape is CircleShape2D, "Hitbox arc phai co CircleShape2D!")
	assert(is_equal_approx(col_shape.shape.radius, 18.0), "Radius arc phai la 18!")
	
	HitboxService.configure_hitbox(test_area, { "shape": "line", "reach": 24, "thickness": 6 }, "side", false)
	assert(col_shape.shape is RectangleShape2D, "Hitbox line phai co RectangleShape2D!")
	
	HitboxService.configure_hitbox(test_area, { "shape": "rect", "size": [14, 14] }, "up", false)
	assert(col_shape.shape is RectangleShape2D, "Hitbox rect phai co RectangleShape2D!")
	print("[PASS] 7. HitboxService: Cấu hình chính xác các hình dạng arc, line, rect.")
	
	print("--- TAT CA CAC TEST UNIT CUA STAGE A DA VUOT QUA THANH CONG! ---")
	quit(0)
