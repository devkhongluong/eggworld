extends Node

# Test verification script for Leveling System (COMBAT_SPEC Section 9)

func _ready() -> void:
	print("--- BAT DAU TEST HE THONG LEN CAP (LEVELING SYSTEM) ---")
	
	# 1. Test StatsCalc Formulas
	var base_stats := { "VIT": 10, "STR": 10, "DEX": 10, "INT": 10, "FAI": 10, "LUK": 10 }
	var hp := StatsCalc.calc_max_hp(base_stats)
	var sta := StatsCalc.calc_max_stamina(base_stats)
	var ec := StatsCalc.calc_equip_capacity(base_stats)
	var mp := StatsCalc.calc_max_mp(base_stats)
	
	assert(hp == 100, "HP tai VIT 10 phai la 100 (60 + 10*4), nhan duoc: %d" % hp)
	assert(is_equal_approx(sta, 80.0), "Stamina tai VIT 10 phai la 80.0, nhan duoc: %f" % sta)
	assert(is_equal_approx(ec, 55.0), "Equip capacity tai VIT 10 phai la 55.0, nhan duoc: %f" % ec)
	assert(mp == 50, "MP tai INT 10 phai la 50, nhan duoc: %d" % mp)
	print("[PASS] 1. Cong thuc HP, Stamina, Sức tải, MP tinh chinh xac.")
	
	# Test StatsCalc with leveled stats (VIT 15)
	var leveled_stats := { "VIT": 15, "STR": 12, "DEX": 10, "INT": 12, "FAI": 10, "LUK": 10 }
	assert(StatsCalc.calc_max_hp(leveled_stats) == 120, "HP tai VIT 15 phai la 120 (60 + 15*4)!")
	assert(is_equal_approx(StatsCalc.calc_max_stamina(leveled_stats), 90.0), "Stamina tai VIT 15 phai la 90.0!")
	assert(is_equal_approx(StatsCalc.calc_equip_capacity(leveled_stats), 62.5), "Equip cap tai VIT 15 phai la 62.5!")
	assert(StatsCalc.calc_max_mp(leveled_stats) == 56, "MP tai INT 12 phai la 56!")
	print("[PASS] 2. Cong thuc StatsCalc cho chi so sau khi nang cap tinh chinh xac.")
	
	# 2. Test Level Cost Formulas
	# cost(level) = round(40 * 1.18^(level-1))
	var c1 := StatsCalc.calc_level_cost(1)
	var c2 := StatsCalc.calc_level_cost(2)
	var c3 := StatsCalc.calc_level_cost(3)
	assert(c1 == 40, "Chi phi level 1 phai la 40, nhan duoc: %d" % c1)
	assert(c2 == 47, "Chi phi level 2 phai la 47 (round(40*1.18)), nhan duoc: %d" % c2)
	assert(c3 == 56, "Chi phi level 3 phai la 56 (round(40*1.18^2)), nhan duoc: %d" % c3)
	print("[PASS] 3. Chi phi len cap theo cap do tinh chinh xac (c1=%d, c2=%d, c3=%d)." % [c1, c2, c3])
	
	# 3. Test Weapon Damage with StatsCalc
	var w_data := WeaponDB.get_weapon("staff_wood")
	var spec: Dictionary = w_data["light_chain"][0]
	var dmg_base := StatsCalc.calc_weapon_damage(w_data, spec, base_stats)
	assert(dmg_base == 12, "Sat thuong Gay Go don 1 tai STR 10 phai la 12, nhan duoc: %d" % dmg_base)
	
	var high_str_stats := { "VIT": 10, "STR": 20, "DEX": 10, "INT": 10, "FAI": 10, "LUK": 10 }
	var dmg_high := StatsCalc.calc_weapon_damage(w_data, spec, high_str_stats)
	# scaling C = 0.03. diff = 10 -> 1 + 0.03*10 = 1.30. 12 * 1.30 = 15.6 -> 16.
	assert(dmg_high > dmg_base, "Sat thuong phai tang khi nang STR!")
	print("[PASS] 4. StatsCalc.calc_weapon_damage scaling theo STR chinh xac (10 STR: %d -> 20 STR: %d)." % [dmg_base, dmg_high])
	
	# 4. Test PlayerInventory Autoload Logic
	var inv_script = load("res://scripts/autoload/player_inventory.gd")
	var inv = inv_script.new()
	add_child(inv)
	
	assert(inv.level == 1, "Level khoi dau phai la 1!")
	assert(inv.shell_shards == 0, "Mảnh vỏ khoi dau phai la 0!")
	
	inv.add_shards(100)
	assert(inv.shell_shards == 100, "Sau khi them 100 shards, tong phai la 100!")
	assert(inv.can_level_up(), "Voi 100 shards va cost 40, can_level_up phai la true!")
	
	# Nang 1 cap don le
	var success: bool = inv.apply_stat_point("VIT")
	assert(success, "apply_stat_point phai thanh cong!")
	assert(inv.level == 2, "Sau khi nang 1 diem, level phai la 2!")
	assert(inv.shell_shards == 60, "100 - 40 = 60 shards!")
	assert(inv.added_points["VIT"] == 1, "VIT added_points phai la 1!")
	assert(inv.get_effective_stats()["VIT"] == 11, "Effective VIT phai la 11!")
	print("[PASS] 5. PlayerInventory: Cong 1 diem VIT, tru shards va tinh level dung.")
	
	# Nang nhieu diem dong thoi (apply_multiple_stats)
	# Level 2 cost = 47. We have 60 shards. Adding 1 STR costs 47 -> leaves 13 shards.
	var multi_success: bool = inv.apply_multiple_stats({"STR": 1})
	assert(multi_success, "Nang tiep 1 diem STR phai thanh cong!")
	assert(inv.level == 3, "Sau do level phai la 3!")
	assert(inv.shell_shards == 13, "60 - 47 = 13 shards, nhan duoc: %d" % inv.shell_shards)
	
	# Thu nang tiep khi khong du shards (Level 3 cost = 56, only have 13)
	var fail_attempt: bool = inv.apply_multiple_stats({"DEX": 1})
	assert(not fail_attempt, "Khong du shards thi apply_multiple_stats phai fail!")
	assert(inv.level == 3, "Level phai giu nguyen 3!")
	print("[PASS] 6. PlayerInventory: apply_multiple_stats kiem tra du shards va ap dung chinh xac.")
	
	# 5. Test Export / Import (Save/Load)
	var exported: Dictionary = inv.export_data()
	assert(exported["level"] == 3, "Exported level phai la 3!")
	assert(exported["shell_shards"] == 13, "Exported shards phai la 13!")
	
	var inv2 = inv_script.new()
	add_child(inv2)
	inv2.import_data(exported)
	assert(inv2.level == 3, "Imported level phai la 3!")
	assert(inv2.shell_shards == 13, "Imported shards phai la 13!")
	assert(inv2.added_points["VIT"] == 1, "Imported VIT bonus phai la 1!")
	assert(inv2.added_points["STR"] == 1, "Imported STR bonus phai la 1!")
	print("[PASS] 7. PlayerInventory export_data & import_data bao toan day du du lieu.")
	
	# 6. Test LostShard single-pile mechanic
	var lost_node1 = LostShard.new()
	lost_node1.shard_amount = 50
	LostShard.current_pile = lost_node1
	add_child(lost_node1)
	
	# Mo phong Player chet lan 2 -> spawn_at phai xoa pile cu
	var pile2 = LostShard.spawn_at(self, Vector2(100, 100), 30)
	assert(pile2 != null, "Pile moi phai duoc tao!")
	assert(not is_instance_valid(lost_node1) or lost_node1.is_queued_for_deletion(), "Pile cu phai bi xoa khi chet lan 2!")
	assert(LostShard.current_pile == pile2, "current_pile phai tro vao pile moi!")
	pile2.queue_free()
	print("[PASS] 8. LostShard: Co che duy nhat 1 dong shards va huy dong cu khi chet lan 2 hoat dung.")
	
	# 7. Test StrawBed & LevelUpScreen scene loading
	var straw_bed_scene = load("res://scenes/world/straw_bed.tscn")
	assert(straw_bed_scene != null, "scenes/world/straw_bed.tscn phai ton tai va hop le!")
	var straw_bed = straw_bed_scene.instantiate()
	assert(straw_bed is StrawBed, "straw_bed phai la instance cua class StrawBed!")
	straw_bed.queue_free()
	
	var level_up_scene = load("res://scenes/ui/level_up_screen.tscn")
	assert(level_up_scene != null, "scenes/ui/level_up_screen.tscn phai ton tai va hop le!")
	var level_up_ui = level_up_scene.instantiate()
	assert(level_up_ui is LevelUpScreen, "level_up_ui phai la instance cua class LevelUpScreen!")
	level_up_ui.queue_free()
	print("[PASS] 9. Khoi tao thanh cong scenes StrawBed va LevelUpScreen.")
	
	# Don dep
	inv.queue_free()
	inv2.queue_free()
	
	print("--- TAT CA CAC TEST CUA LEVELING SYSTEM DA VUOT QUA THANH CONG! ---")
	get_tree().quit(0)
