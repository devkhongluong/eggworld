extends CanvasLayer

# HUD hiển thị máu, thể lực và thông báo tạm thời.
# Toàn bộ màu sắc lấy trực tiếp từ Palette (GDD Mục 3).

@onready var hp_bar_fill: ColorRect = $MarginContainer/VBoxContainer/HPBar/Fill
@onready var hp_bar_bg: ColorRect = $MarginContainer/VBoxContainer/HPBar/Background
@onready var stamina_bar_fill: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Fill
@onready var stamina_bar_bg: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Background
@onready var debug_label: Label = $MarginContainer/VBoxContainer/DebugDodgeLabel
@onready var weapon_label: Label = $MarginContainer/VBoxContainer/WeaponLabel
@onready var death_overlay: Control = $DeathOverlay

var max_hp: int = 100
var current_hp: int = 100
var max_stamina: float = 100.0
var current_stamina: float = 100.0

var hp_bar_max_width: float = 64.0
var stamina_bar_max_width: float = 52.0

var show_debug_dodge: bool = false

func _ready() -> void:
	apply_palette()
	# Nạp cờ debug từ stats.json
	show_debug_dodge = bool(GameData.get_stat("debug", "show_dodge_debug", false))
	update_debug_display()
	death_overlay.visible = false
	
	BehaviorTracker.points_changed.connect(_on_behavior_points_changed)

func apply_palette() -> void:
	# Màu sắc chuẩn GDD Mục 3
	hp_bar_bg.color = Palette.NAU_HAM
	hp_bar_fill.color = Palette.DO_GACH
	
	stamina_bar_bg.color = Palette.NAU_HAM
	stamina_bar_fill.color = Palette.XANH_LA_UA
	
	debug_label.add_theme_color_override("font_color", Palette.KEM)
	if weapon_label != null:
		weapon_label.add_theme_color_override("font_color", Palette.KEM)
	
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
	var ratio: float = clampf(float(current_hp) / float(maxi(1, max_hp)), 0.0, 1.0)
	hp_bar_fill.size.x = hp_bar_max_width * ratio

func update_stamina(new_stamina: float, new_max_stamina: float) -> void:
	current_stamina = new_stamina
	max_stamina = new_max_stamina
	var ratio: float = clampf(current_stamina / maxf(1.0, max_stamina), 0.0, 1.0)
	stamina_bar_fill.size.x = stamina_bar_max_width * ratio

func update_weapon(_weapon_id: String, weapon_name: String) -> void:
	if weapon_label != null:
		weapon_label.text = "[Q] " + weapon_name

func _on_behavior_points_changed(action_name: String, _new_points: int, _total: int) -> void:
	if action_name == BehaviorTracker.ACTION_DODGE:
		update_debug_display()

func update_debug_display() -> void:
	debug_label.visible = show_debug_dodge
	if show_debug_dodge:
		debug_label.text = "[DEBUG F3] DODGE: %d" % BehaviorTracker.get_points(BehaviorTracker.ACTION_DODGE)

func show_death_screen(show_it: bool) -> void:
	death_overlay.visible = show_it
