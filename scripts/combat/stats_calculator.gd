extends RefCounted
class_name StatsCalc

# StatsCalc: Dịch vụ tính toán các chỉ số phái sinh và công thức cân bằng
# Tuân thủ chặt chẽ COMBAT_SPEC mục 9 và đọc thông số từ data/stats.json qua GameData.

const DEFAULT_SCALING_COEFF: Dictionary = {
	"S": 0.08,
	"A": 0.06,
	"B": 0.045,
	"C": 0.03,
	"D": 0.02,
	"E": 0.01,
	"-": 0.0
}

static func _get_stat_val(category: String, key: String, default_val: Variant) -> Variant:
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var gd = root.root.get_node_or_null("GameData")
		if gd != null and gd.has_method("get_stat"):
			return gd.get_stat(category, key, default_val)
	return default_val

static func calc_max_hp(base_stats: Dictionary) -> int:
	var vit: int = int(base_stats.get("VIT", 10))
	var hp_base: int = int(_get_stat_val("formulas", "hp_base", 60))
	var hp_per_vit: int = int(_get_stat_val("formulas", "hp_per_vit", 4))
	return hp_base + vit * hp_per_vit

static func calc_max_stamina(base_stats: Dictionary) -> float:
	var vit: int = int(base_stats.get("VIT", 10))
	var sta_base: float = float(_get_stat_val("formulas", "stamina_base", 60.0))
	var sta_per_vit: float = float(_get_stat_val("formulas", "stamina_per_vit", 2.0))
	return sta_base + float(vit) * sta_per_vit

static func calc_equip_capacity(base_stats: Dictionary) -> float:
	var vit: int = int(base_stats.get("VIT", 10))
	var ec_base: float = float(_get_stat_val("formulas", "equip_capacity_base", 40.0))
	var ec_per_vit: float = float(_get_stat_val("formulas", "equip_capacity_per_vit", 1.5))
	return ec_base + float(vit) * ec_per_vit

static func calc_max_mp(base_stats: Dictionary) -> int:
	var int_stat: int = int(base_stats.get("INT", 10))
	var mp_base: int = int(_get_stat_val("formulas", "mp_base", 20))
	var mp_per_int: int = int(_get_stat_val("formulas", "mp_per_int", 3))
	return mp_base + int_stat * mp_per_int

static func calc_weapon_damage(weapon_data: Dictionary, attack_spec: Dictionary, base_stats: Dictionary) -> int:
	var base_dmg: float = float(weapon_data.get("base_damage", 10))
	var mv: float = float(attack_spec.get("damage_mv", 1.0))
	
	# Tính scaling
	var scaling: Dictionary = weapon_data.get("scaling", {})
	var scaling_sum: float = 0.0
	for stat_name in scaling:
		var grade: String = str(scaling[stat_name])
		var coeff: float = float(_get_stat_val("scaling_coeff", grade, DEFAULT_SCALING_COEFF.get(grade, 0.0)))
		var stat_val: int = int(base_stats.get(stat_name, 10))
		var stat_diff: int = maxi(0, stat_val - 10)
		scaling_sum += coeff * float(stat_diff)
	
	var dmg: float = base_dmg * mv * (1.0 + scaling_sum)
	
	# Kiểm tra thiếu chỉ số yêu cầu (Requirements penalty)
	var reqs: Dictionary = weapon_data.get("requirements", {})
	var missing_pts: int = 0
	for stat_name in reqs:
		var req_val: int = int(reqs[stat_name])
		var stat_val: int = int(base_stats.get(stat_name, 10))
		if stat_val < req_val:
			missing_pts += (req_val - stat_val)
	
	if missing_pts > 0:
		var dmg_mult_per_pt: float = float(_get_stat_val("requirement_penalty", "damage_mult_per_pt", 0.05))
		var dmg_min_mult: float = float(_get_stat_val("requirement_penalty", "damage_min_mult", 0.5))
		var penalty_mult: float = maxf(dmg_min_mult, 1.0 - dmg_mult_per_pt * float(missing_pts))
		dmg *= penalty_mult
	
	return maxi(1, int(round(dmg)))

static func calc_level_cost(current_level: int) -> int:
	var cost_base: float = float(_get_stat_val("leveling", "cost_base", 40.0))
	var cost_growth: float = float(_get_stat_val("leveling", "cost_growth", 1.18))
	return maxi(1, int(round(cost_base * pow(cost_growth, max(0, current_level - 1)))))

static func calc_level(total_added_points: int) -> int:
	return 1 + total_added_points
