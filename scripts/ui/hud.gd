extends CanvasLayer

# HUD hiển thị máu, thể lực, vũ khí, mảnh vỏ và thông báo tạm thời.
# Toàn bộ màu sắc lấy trực tiếp từ Palette (GDD Mục 3).

@onready var hp_bar_fill: ColorRect = $MarginContainer/VBoxContainer/HPBar/Fill
@onready var hp_bar_bg: ColorRect = $MarginContainer/VBoxContainer/HPBar/Background
@onready var stamina_bar_fill: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Fill
@onready var stamina_bar_bg: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Background
@onready var debug_label: Label = $MarginContainer/VBoxContainer/DebugDodgeLabel
@onready var weapon_label: Label = $MarginContainer/VBoxContainer/WeaponHBox/WeaponLabel
@onready var weapon_icon: TextureRect = $MarginContainer/VBoxContainer/WeaponHBox/WeaponIcon
@onready var shard_label: Label = $MarginContainer/VBoxContainer/ShardLabel
@onready var death_overlay: Control = $DeathOverlay

var max_hp: int = 100
var current_hp: int = 100
var max_stamina: float = 100.0
var current_stamina: float = 100.0

var hp_bar_base_width: float = 64.0
var stamina_bar_base_width: float = 52.0

var show_debug_dodge: bool = false
var weapon_icons: Dictionary = {}

func _ready() -> void:
	_load_weapon_icons()
	apply_palette()
	# Nạp cờ debug từ stats.json
	show_debug_dodge = bool(GameData.get_stat("debug", "show_dodge_debug", false))
	update_debug_display()
	death_overlay.visible = false
	
	BehaviorTracker.points_changed.connect(_on_behavior_points_changed)
	
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null:
			if inv.has_signal("shards_changed"):
				inv.shards_changed.connect(func(_amount): update_level_and_shards())
			if inv.has_signal("stats_changed"):
				inv.stats_changed.connect(update_level_and_shards)
	
	update_level_and_shards()

func _load_weapon_icons() -> void:
	var staff_tex = load("res://assets/sprites/weapons/weapon_staff_wood.png")
	if staff_tex != null:
		weapon_icons["staff_wood"] = staff_tex
		weapon_icons["staff"] = staff_tex
	var dagger_tex = load("res://assets/sprites/weapons/weapon_dagger.png")
	if dagger_tex != null:
		weapon_icons["dagger"] = dagger_tex
	var sling_tex = load("res://assets/sprites/weapons/weapon_sling.png")
	if sling_tex != null:
		weapon_icons["sling"] = sling_tex

func apply_palette() -> void:
	# Màu sắc chuẩn GDD Mục 3
	hp_bar_bg.color = Palette.NAU_HAM
	hp_bar_fill.color = Palette.DO_GACH
	
	stamina_bar_bg.color = Palette.NAU_HAM
	stamina_bar_fill.color = Palette.XANH_LA_UA
	
	debug_label.add_theme_color_override("font_color", Palette.KEM)
	if weapon_label != null:
		weapon_label.add_theme_color_override("font_color", Palette.KEM)
	if shard_label != null:
		shard_label.add_theme_color_override("font_color", Palette.VANG_CO)
	
	var death_label: Label = $DeathOverlay/CenterContainer/VBoxContainer/DeathLabel
	death_label.add_theme_color_override("font_color", Palette.DO_GACH)
	var death_sub: Label = $DeathOverlay/CenterContainer/VBoxContainer/SubLabel
	death_sub.add_theme_color_override("font_color", Palette.KEM)
	var death_panel: ColorRect = $DeathOverlay/CenterContainer/VBoxContainer/PanelBg
	death_panel.color = Palette.NAU_HAM

func _unhandled_key_input(event: InputEvent) -> void:
	# Bật/tắt nhãn debug DODGE bằng phím F3
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F3:
			show_debug_dodge = not show_debug_dodge
			update_debug_display()

func update_hp(new_hp: int, new_max_hp: int) -> void:
	current_hp = new_hp
	max_hp = new_max_hp
	# Thanh máu kéo dài theo lượng max_hp (Tăng sinh động khi nâng VIT)
	var max_w: float = hp_bar_base_width + maxf(0.0, float(max_hp - 100) * 0.8)
	hp_bar_bg.size.x = max_w
	var ratio: float = clampf(float(current_hp) / float(maxi(1, max_hp)), 0.0, 1.0)
	hp_bar_fill.size.x = max_w * ratio

func update_stamina(new_stamina: float, new_max_stamina: float) -> void:
	current_stamina = new_stamina
	max_stamina = new_max_stamina
	# Thanh thể lực kéo dài theo max_stamina
	var max_w: float = stamina_bar_base_width + maxf(0.0, float(max_stamina - 100.0) * 0.6)
	stamina_bar_bg.size.x = max_w
	var ratio: float = clampf(current_stamina / maxf(1.0, max_stamina), 0.0, 1.0)
	stamina_bar_fill.size.x = max_w * ratio

func update_weapon(slot_idx: int, weapon_id: String, weapon_name: String) -> void:
	if weapon_label != null:
		weapon_label.text = "[Q] Vũ khí (%d/3): %s" % [slot_idx + 1, weapon_name]
	if weapon_icon != null:
		var tex: Texture2D = weapon_icons.get(weapon_id, null)
		weapon_icon.texture = tex
		weapon_icon.visible = (tex != null)

func update_level_and_shards() -> void:
	var lvl: int = 1
	var shards: int = 0
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null:
			if "level" in inv:
				lvl = int(inv.level)
			if "shell_shards" in inv:
				shards = int(inv.shell_shards)
	if shard_label != null:
		shard_label.text = "Cấp %d | Mảnh Vỏ: %d" % [lvl, shards]

func update_shards(_amount: int) -> void:
	update_level_and_shards()

func _on_behavior_points_changed(_action_name: String, _new_points: int, _total: int) -> void:
	update_debug_display()

func update_debug_display() -> void:
	debug_label.visible = show_debug_dodge
	if not show_debug_dodge:
		return
	var total: int = BehaviorTracker.get_total_points()
	var g: int = BehaviorTracker.get_points(BehaviorTracker.ACTION_GUARD)
	var d: int = BehaviorTracker.get_points(BehaviorTracker.ACTION_DODGE)
	var m: int = BehaviorTracker.get_points(BehaviorTracker.ACTION_MAGIC)
	var e: int = BehaviorTracker.get_points(BehaviorTracker.ACTION_EXPLORE)
	var s: int = BehaviorTracker.get_points(BehaviorTracker.ACTION_SUPPORT)
	
	var g_pct: float = (float(g) / float(total) * 100.0) if total > 0 else 0.0
	var d_pct: float = (float(d) / float(total) * 100.0) if total > 0 else 0.0
	var m_pct: float = (float(m) / float(total) * 100.0) if total > 0 else 0.0
	var e_pct: float = (float(e) / float(total) * 100.0) if total > 0 else 0.0
	var s_pct: float = (float(s) / float(total) * 100.0) if total > 0 else 0.0
	
	debug_label.text = "[F3 DEBUG BỘ ĐẾM HÀNH VI]\nGUARD: %d (%.1f%%) | DODGE: %d (%.1f%%)\nMAGIC: %d (%.1f%%) | EXPLORE: %d (%.1f%%)\nSUPPORT: %d (%.1f%%) | Tổng: %d" % [
		g, g_pct, d, d_pct, m, m_pct, e, e_pct, s, s_pct, total
	]

func show_death_screen(show_it: bool) -> void:
	death_overlay.visible = show_it
