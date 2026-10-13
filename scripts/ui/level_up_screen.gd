extends CanvasLayer
class_name LevelUpScreen

# LevelUpScreen: Giao diện cộng điểm chỉ số tại Ổ Rơm
# Tuân thủ chặt chẽ COMBAT_SPEC mục 9:
# - Xem trước thay đổi chỉ số (HP, Stamina, Sức tải, Sát thương vũ khí)
# - Tính chi phí tăng dần: cost(level) = round(cost_base * cost_growth ^ (level-1))
# - Hỗ trợ cả chuột, bàn phím và tay cầm điều hướng

const STAT_NAMES: Array[String] = ["VIT", "STR", "DEX", "INT", "FAI", "LUK"]
const STAT_DESCRIPTIONS: Dictionary = {
	"VIT": "Tăng Máu tối đa, Thể lực & Sức tải",
	"STR": "Tăng sát thương vũ khí cận chiến nặng",
	"DEX": "Tăng sát thương vũ khí khéo léo",
	"INT": "Tăng MP & sát thương phép thuật",
	"FAI": "Tăng sát thương & hiệu ứng Thánh",
	"LUK": "Tăng tỉ lệ rơi đồ & tỉ lệ chí mạng"
}

@onready var panel_bg: ColorRect = $RootControl/PanelBg
@onready var header_label: Label = $RootControl/Margin/VBox/HeaderLabel
@onready var shards_label: Label = $RootControl/Margin/VBox/ShardsLabel
@onready var stats_container: VBoxContainer = $RootControl/Margin/VBox/MainHBox/StatsVBox
@onready var preview_vbox: VBoxContainer = $RootControl/Margin/VBox/MainHBox/PreviewVBox
@onready var btn_confirm: Button = $RootControl/Margin/VBox/MainHBox/PreviewVBox/ButtonsHBox/BtnConfirm
@onready var btn_cancel: Button = $RootControl/Margin/VBox/MainHBox/PreviewVBox/ButtonsHBox/BtnCancel
@onready var guide_label: Label = $RootControl/Margin/VBox/GuideLabel

var player_ref: Player = null
var pending_adds: Dictionary = {
	"VIT": 0, "STR": 0, "DEX": 0, "INT": 0, "FAI": 0, "LUK": 0
}
var selected_index: int = 0 # 0..5: các chỉ số, 6: Confirm, 7: Cancel
var stat_row_nodes: Array[Dictionary] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	apply_palette()
	_build_stat_rows()
	_update_display()
	_highlight_selection()

func apply_palette() -> void:
	if panel_bg != null:
		panel_bg.color = Color(Palette.DEN_THAN.r, Palette.DEN_THAN.g, Palette.DEN_THAN.b, 0.94)
	if header_label != null:
		header_label.add_theme_color_override("font_color", Palette.VANG_CO)
	if shards_label != null:
		shards_label.add_theme_color_override("font_color", Palette.KEM)
	if guide_label != null:
		guide_label.add_theme_color_override("font_color", Palette.XAM_SAT)
	if btn_confirm != null:
		btn_confirm.add_theme_color_override("font_color", Palette.KEM)
	if btn_cancel != null:
		btn_cancel.add_theme_color_override("font_color", Palette.KEM)

func open(p_player: Player) -> void:
	player_ref = p_player
	for s in STAT_NAMES:
		pending_adds[s] = 0
	selected_index = 0
	get_tree().paused = true
	_update_display()
	_highlight_selection()

func close_screen() -> void:
	get_tree().paused = false
	queue_free()

func _build_stat_rows() -> void:
	if stats_container == null:
		return
	
	for child in stats_container.get_children():
		child.queue_free()
	stat_row_nodes.clear()
	
	for s in STAT_NAMES:
		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.theme_override_constants.separation = 4
		
		# Nhãn tên chỉ số (VIT, STR, ...)
		var name_lbl := Label.new()
		name_lbl.custom_minimum_size = Vector2(28, 12)
		name_lbl.text = s
		name_lbl.theme_override_font_sizes.font_size = 8
		name_lbl.add_theme_color_override("font_color", Palette.KEM)
		row.add_child(name_lbl)
		
		# Nhãn giá trị
		var val_lbl := Label.new()
		val_lbl.custom_minimum_size = Vector2(40, 12)
		val_lbl.text = "10"
		val_lbl.theme_override_font_sizes.font_size = 8
		val_lbl.add_theme_color_override("font_color", Palette.KEM)
		row.add_child(val_lbl)
		
		# Nút trừ (-)
		var btn_sub := Button.new()
		btn_sub.custom_minimum_size = Vector2(16, 12)
		btn_sub.text = "-"
		btn_sub.theme_override_font_sizes.font_size = 8
		btn_sub.focus_mode = Control.FOCUS_NONE
		btn_sub.pressed.connect(func(): _modify_stat(s, -1))
		row.add_child(btn_sub)
		
		# Nút cộng (+)
		var btn_add := Button.new()
		btn_add.custom_minimum_size = Vector2(16, 12)
		btn_add.text = "+"
		btn_add.theme_override_font_sizes.font_size = 8
		btn_add.focus_mode = Control.FOCUS_NONE
		btn_add.pressed.connect(func(): _modify_stat(s, +1))
		row.add_child(btn_add)
		
		stats_container.add_child(row)
		stat_row_nodes.append({
			"stat": s,
			"row": row,
			"name_lbl": name_lbl,
			"val_lbl": val_lbl,
			"btn_sub": btn_sub,
			"btn_add": btn_add
		})

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("pause") or (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
		_on_cancel_pressed()
		get_viewport().set_input_as_handled()
		return
	
	# Điều hướng Lên / Xuống
	if event.is_action_pressed("move_up") or (event is InputEventKey and event.pressed and (event.keycode == KEY_UP or event.keycode == KEY_W)):
		_nav_vertical(-1)
		get_viewport().set_input_as_handled()
		return
	elif event.is_action_pressed("move_down") or (event is InputEventKey and event.pressed and (event.keycode == KEY_DOWN or event.keycode == KEY_S)):
		_nav_vertical(1)
		get_viewport().set_input_as_handled()
		return
	
	# Điều hướng Trái / Phải hoặc +/-
	if selected_index < STAT_NAMES.size():
		var cur_stat := STAT_NAMES[selected_index]
		if event.is_action_pressed("move_left") or (event is InputEventKey and event.pressed and (event.keycode == KEY_LEFT or event.keycode == KEY_A or event.keycode == KEY_MINUS)):
			_modify_stat(cur_stat, -1)
			get_viewport().set_input_as_handled()
			return
		elif event.is_action_pressed("move_right") or (event is InputEventKey and event.pressed and (event.keycode == KEY_RIGHT or event.keycode == KEY_D or event.keycode == KEY_EQUAL or event.keycode == KEY_PLUS)):
			_modify_stat(cur_stat, +1)
			get_viewport().set_input_as_handled()
			return
	else:
		# Ở hàng nút Confirm / Cancel
		if event.is_action_pressed("move_left") or (event is InputEventKey and event.pressed and (event.keycode == KEY_LEFT or event.keycode == KEY_A)):
			selected_index = 6
			_highlight_selection()
			get_viewport().set_input_as_handled()
			return
		elif event.is_action_pressed("move_right") or (event is InputEventKey and event.pressed and (event.keycode == KEY_RIGHT or event.keycode == KEY_D)):
			selected_index = 7
			_highlight_selection()
			get_viewport().set_input_as_handled()
			return
	
	# Phím Enter / Space / E (Interact)
	if event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER or event.keycode == KEY_SPACE)):
		if selected_index == 6:
			_on_confirm_pressed()
		elif selected_index == 7:
			_on_cancel_pressed()
		elif selected_index < STAT_NAMES.size():
			_modify_stat(STAT_NAMES[selected_index], +1)
		get_viewport().set_input_as_handled()
		return

func _nav_vertical(dir: int) -> void:
	selected_index = clampi(selected_index + dir, 0, 7)
	_highlight_selection()

func _highlight_selection() -> void:
	for i in range(stat_row_nodes.size()):
		var info: Dictionary = stat_row_nodes[i]
		var is_sel: bool = (i == selected_index)
		var name_lbl: Label = info["name_lbl"]
		if is_sel:
			name_lbl.add_theme_color_override("font_color", Palette.VANG_CO)
			name_lbl.text = "> " + info["stat"]
		else:
			name_lbl.add_theme_color_override("font_color", Palette.KEM)
			name_lbl.text = "  " + info["stat"]
	
	if btn_confirm != null:
		if selected_index == 6:
			btn_confirm.add_theme_color_override("font_color", Palette.VANG_CO)
		else:
			btn_confirm.add_theme_color_override("font_color", Palette.KEM)
	
	if btn_cancel != null:
		if selected_index == 7:
			btn_cancel.add_theme_color_override("font_color", Palette.VANG_CO)
		else:
			btn_cancel.add_theme_color_override("font_color", Palette.KEM)

func _get_total_pending_points() -> int:
	var total: int = 0
	for s in pending_adds:
		total += pending_adds[s]
	return total

func _get_total_pending_cost() -> int:
	var total_pts: int = _get_total_pending_points()
	var cur_lvl: int = PlayerInventory.level
	var cost: int = 0
	for i in range(total_pts):
		cost += StatsCalc.calc_level_cost(cur_lvl + i)
	return cost

func _get_next_point_cost() -> int:
	var total_pts: int = _get_total_pending_points()
	return StatsCalc.calc_level_cost(PlayerInventory.level + total_pts)

func _modify_stat(stat_name: String, delta: int) -> void:
	if delta > 0:
		var next_cost: int = _get_next_point_cost()
		var rem_shards: int = PlayerInventory.shell_shards - _get_total_pending_cost()
		if rem_shards >= next_cost:
			pending_adds[stat_name] = pending_adds.get(stat_name, 0) + 1
		else:
			print("[UI] Không đủ Mảnh Vỏ Vụn để cộng thêm điểm! (Cần %d, còn %d)" % [next_cost, rem_shards])
	elif delta < 0:
		if pending_adds.get(stat_name, 0) > 0:
			pending_adds[stat_name] -= 1
	
	_update_display()

func _update_display() -> void:
	var cur_lvl: int = PlayerInventory.level
	var total_pending_pts: int = _get_total_pending_points()
	var new_lvl: int = cur_lvl + total_pending_pts
	var total_cost: int = _get_total_pending_cost()
	var next_cost: int = _get_next_point_cost()
	var rem_shards: int = PlayerInventory.shell_shards - total_cost
	
	if header_label != null:
		if total_pending_pts > 0:
			header_label.text = "CẤP: %d -> %d | CHI PHÍ TIẾP: %d" % [cur_lvl, new_lvl, next_cost]
		else:
			header_label.text = "CẤP: %d | CHI PHÍ TIẾP: %d" % [cur_lvl, next_cost]
	
	if shards_label != null:
		if total_cost > 0:
			shards_label.text = "MẢNH VỎ VỤN: %d (-%d) | CÒN LẠI: %d" % [PlayerInventory.shell_shards, total_cost, rem_shards]
		else:
			shards_label.text = "MẢNH VỎ VỤN: %d" % [PlayerInventory.shell_shards]
	
	var base_stats: Dictionary = PlayerInventory.base_stats
	var added_stats: Dictionary = PlayerInventory.added_points
	var effective_stats: Dictionary = PlayerInventory.get_effective_stats()
	var preview_stats: Dictionary = {}
	for s in STAT_NAMES:
		preview_stats[s] = int(effective_stats.get(s, 10)) + int(pending_adds.get(s, 0))
	
	# Cập nhật danh sách hàng chỉ số
	for info in stat_row_nodes:
		var s: String = info["stat"]
		var cur_val: int = int(effective_stats.get(s, 10))
		var add: int = int(pending_adds.get(s, 0))
		var val_lbl: Label = info["val_lbl"]
		if add > 0:
			val_lbl.text = "%d (+%d)" % [cur_val, add]
			val_lbl.add_theme_color_override("font_color", Palette.VANG_CO)
		else:
			val_lbl.text = "%d" % cur_val
			val_lbl.add_theme_color_override("font_color", Palette.KEM)
		
		var btn_sub: Button = info["btn_sub"]
		btn_sub.disabled = (add <= 0)
		var btn_add: Button = info["btn_add"]
		btn_add.disabled = (rem_shards < next_cost)
	
	# Cập nhật phần xem trước bên phải
	_update_preview_section(effective_stats, preview_stats)

func _update_preview_section(cur_stats: Dictionary, new_stats: Dictionary) -> void:
	if preview_vbox == null:
		return
	
	var cur_hp := StatsCalc.calc_max_hp(cur_stats)
	var new_hp := StatsCalc.calc_max_hp(new_stats)
	
	var cur_sta := StatsCalc.calc_max_stamina(cur_stats)
	var new_sta := StatsCalc.calc_max_stamina(new_stats)
	
	var cur_ec := StatsCalc.calc_equip_capacity(cur_stats)
	var new_ec := StatsCalc.calc_equip_capacity(new_stats)
	
	# Tính sát thương vũ khí hiện tại
	var w_data: Dictionary = {}
	var cur_w_name := "Gậy Gỗ"
	if player_ref != null and not player_ref.current_weapon_data.is_empty():
		w_data = player_ref.current_weapon_data
		cur_w_name = str(w_data.get("name", "Vũ khí"))
	else:
		w_data = WeaponDB.get_weapon("staff_wood")
	
	var light_chain: Array = w_data.get("light_chain", [])
	var first_spec: Dictionary = light_chain[0] if not light_chain.is_empty() else {"damage_mv": 1.0}
	
	var cur_dmg := StatsCalc.calc_weapon_damage(w_data, first_spec, cur_stats)
	var new_dmg := StatsCalc.calc_weapon_damage(w_data, first_spec, new_stats)
	
	var hp_lbl: Label = preview_vbox.get_node_or_null("HPLabel")
	if hp_lbl != null:
		hp_lbl.text = "HP: %d %s" % [cur_hp, ("-> %d" % new_hp) if new_hp != cur_hp else ""]
		hp_lbl.add_theme_color_override("font_color", Palette.DO_GACH if new_hp > cur_hp else Palette.KEM)
	
	var sta_lbl: Label = preview_vbox.get_node_or_null("StaminaLabel")
	if sta_lbl != null:
		sta_lbl.text = "Thể lực: %.0f %s" % [cur_sta, ("-> %.0f" % new_sta) if new_sta != cur_sta else ""]
		sta_lbl.add_theme_color_override("font_color", Palette.XANH_LA_UA if new_sta > cur_sta else Palette.KEM)
	
	var ec_lbl: Label = preview_vbox.get_node_or_null("CapacityLabel")
	if ec_lbl != null:
		ec_lbl.text = "Sức tải: %.1f %s" % [cur_ec, ("-> %.1f" % new_ec) if new_ec != cur_ec else ""]
		ec_lbl.add_theme_color_override("font_color", Palette.VANG_CO if new_ec > cur_ec else Palette.KEM)
	
	var dmg_lbl: Label = preview_vbox.get_node_or_null("DamageLabel")
	if dmg_lbl != null:
		dmg_lbl.text = "Sát thương: %d %s" % [cur_dmg, ("-> %d" % new_dmg) if new_dmg != cur_dmg else ""]
		dmg_lbl.add_theme_color_override("font_color", Palette.CAT if new_dmg > cur_dmg else Palette.KEM)

func _on_confirm_pressed() -> void:
	var total_pts: int = _get_total_pending_points()
	if total_pts > 0:
		if PlayerInventory.apply_multiple_stats(pending_adds):
			if player_ref != null and is_instance_valid(player_ref) and player_ref.has_method("apply_leveled_stats"):
				player_ref.apply_leveled_stats()
			SaveManager.save_game()
	close_screen()

func _on_cancel_pressed() -> void:
	close_screen()
