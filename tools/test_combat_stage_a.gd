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
	print("[PASS] WeaponDB da tai day du 4 loai vu khi tu weapons.json.")
	
	# 2. Test Stats & Damage Calculation
	var stats := { "STR": 10, "DEX": 10, "INT": 10, "FAI": 10, "VIT": 10, "LUK": 10 }
	var staff_data: Dictionary = WeaponDB.get_weapon("staff_wood")
	var staff_spec_1: Dictionary = staff_data["light_chain"][0]
	var dmg_staff_1: int = WeaponDB.calculate_damage(staff_data, staff_spec_1, stats)
	var sta_staff_1: float = WeaponDB.calculate_stamina_cost(staff_spec_1, staff_data, stats)
	print("[STAFF] Don 1: Sát thương = %d, Stamina = %.1f" % [dmg_staff_1, sta_staff_1])
	assert(dmg_staff_1 == 12, "Sat thuong don 1 Gay Go phai la 12!")
	assert(is_equal_approx(sta_staff_1, 8.0), "Stamina don 1 Gay Go phai la 8.0!")
	
	var dagger_data: Dictionary = WeaponDB.get_weapon("dagger")
	var dagger_spec_1: Dictionary = dagger_data["light_chain"][0]
	var dmg_dagger_1: int = WeaponDB.calculate_damage(dagger_data, dagger_spec_1, stats)
	var sta_dagger_1: float = WeaponDB.calculate_stamina_cost(dagger_spec_1, dagger_data, stats)
	print("[DAGGER] Don 1: Sát thương = %d, Stamina = %.1f" % [dmg_dagger_1, sta_dagger_1])
	assert(dmg_dagger_1 == 6, "Sat thuong don 1 Dao Gam phai la 6 (9 * 0.7)!")
	assert(is_equal_approx(sta_dagger_1, 4.0), "Stamina don 1 Dao Gam phai la 4.0!")
	
	var sling_data: Dictionary = WeaponDB.get_weapon("sling")
	var sling_spec_1: Dictionary = sling_data["light_chain"][0]
	var dmg_sling_1: int = WeaponDB.calculate_damage(sling_data, sling_spec_1, stats)
	var sta_sling_1: float = WeaponDB.calculate_stamina_cost(sling_spec_1, sling_data, stats)
	print("[SLING] Don 1: Sát thương = %d, Stamina = %.1f" % [dmg_sling_1, sta_sling_1])
	assert(dmg_sling_1 == 9, "Sat thuong don 1 Na phai la 9 (10 * 0.9)!")
	assert(is_equal_approx(sta_sling_1, 7.0), "Stamina don 1 Na phai la 7.0!")
	
	# 3. Test Requirement Penalty
	var low_stats := { "STR": 5, "DEX": 5, "INT": 10, "FAI": 10, "VIT": 10, "LUK": 10 }
	var dmg_pen: int = WeaponDB.calculate_damage(staff_data, staff_spec_1, low_stats)
	var sta_pen: float = WeaponDB.calculate_stamina_cost(staff_spec_1, staff_data, low_stats)
	print("[PENALTY] Gay Go voi STR 5, DEX 5 (thieu 6 diem): Sát thương = %d (giam), Stamina = %.1f (tang)" % [dmg_pen, sta_pen])
	assert(dmg_pen < dmg_staff_1, "Sát thương phai bi phat khi thieu chi so!")
	assert(sta_pen > sta_staff_1, "Stamina phai tang khi thieu chi so!")
	
	print("--- TAT CA CAC TEST UNIT CUA STAGE A DA VUOT QUA THANH CONG! ---")
	quit(0)
