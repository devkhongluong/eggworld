extends Node2D
class_name StrawBed

# StrawBed: Ổ Rơm - Điểm lưu và nghỉ ngơi của Trứng
# - Tương tác bằng phím E (interact)
# - Đặt điểm hồi sinh (spawn_position)
# - Hồi phục tối đa HP & Stamina
# - Phát tín hiệu activated để màn chơi hồi sinh quái
# - Lưu game qua SaveManager
# - Mở giao diện lên cấp LevelUpScreen

signal activated(bed_node: Node2D)

const LevelUpScreenScene = preload("res://scenes/ui/level_up_screen.tscn")

@onready var interaction_area: Area2D = $InteractionArea
@onready var prompt_label: Label = $PromptLabel

var player_in_range: bool = false
var player_ref: Player = null
var active_level_up_ui: CanvasLayer = null

func _ready() -> void:
	if interaction_area != null:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
	
	if prompt_label != null:
		prompt_label.visible = false
		prompt_label.add_theme_color_override("font_color", Palette.KEM)
		prompt_label.text = "[E] Nghỉ ngơi & Lên cấp"

func _draw() -> void:
	# Vẽ Ổ Rơm ấm cúng bằng Palette 16 màu
	# Đế ổ rơm bầu dục ngoài (Nâu Hầm)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.75))
	draw_circle(Vector2(0, 0), 16.0, Palette.NAU_HAM)
	# Vòng rơm đan ngoài (Cát / Rơm)
	draw_circle(Vector2(0, 0), 14.0, Palette.CAT)
	# Lớp rơm vàng óng (Vàng Cổ)
	draw_circle(Vector2(0, 0), 12.0, Palette.VANG_CO)
	# Lòng ổ mềm mại (Kem / Nâu Da)
	draw_circle(Vector2(0, 1), 8.0, Palette.NAU_DA)
	draw_circle(Vector2(0, 2), 6.0, Palette.KEM)
	
	# Các sợi rơm tỏa ra xung quanh
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 1.0))
	for i in range(8):
		var angle: float = float(i) * PI / 4.0 + 0.2
		var start_pt := Vector2(cos(angle) * 10.0, sin(angle) * 7.0)
		var end_pt := Vector2(cos(angle) * 16.0, sin(angle) * 11.0)
		draw_line(start_pt, end_pt, Palette.VANG_CO, 1.2)

func _unhandled_input(event: InputEvent) -> void:
	if not player_in_range or player_ref == null:
		return
	
	if event.is_action_pressed("interact"):
		# Không tương tác nếu UI lên cấp đang mở
		if active_level_up_ui != null and is_instance_valid(active_level_up_ui):
			return
		activate_bed()
		get_viewport().set_input_as_handled()

func activate_bed() -> void:
	if player_ref != null and is_instance_valid(player_ref):
		player_ref.spawn_position = global_position
		player_ref.current_hp = player_ref.max_hp
		player_ref.current_stamina = player_ref.max_stamina
		player_ref.hp_changed.emit(player_ref.current_hp, player_ref.max_hp)
		player_ref.stamina_changed.emit(player_ref.current_stamina, player_ref.max_stamina)
		if player_ref.visual_node != null and player_ref.visual_node.has_method("set_hp_ratio"):
			player_ref.visual_node.set_hp_ratio(1.0)
	
	print("[STRAW_BED] Đã kích hoạt Ổ Rơm tại %s! HP/Stamina hồi phục đầy đủ." % global_position)
	
	# 3. Kích hoạt signal để arena hồi sinh quái
	activated.emit(self)
	
	# 4. Lưu game
	SaveManager.save_game()
	
	# 5. Mở màn hình lên cấp
	open_level_up_screen()

func open_level_up_screen() -> void:
	if active_level_up_ui != null and is_instance_valid(active_level_up_ui):
		return
	
	var ui = LevelUpScreenScene.instantiate()
	active_level_up_ui = ui
	get_tree().root.add_child(ui)
	if ui.has_method("open"):
		ui.open(player_ref)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		player_ref = body
		if prompt_label != null:
			prompt_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body == player_ref:
		player_in_range = false
		player_ref = null
		if prompt_label != null:
			prompt_label.visible = false
