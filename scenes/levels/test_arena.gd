extends Node2D

# Màn chơi thử nghiệm test_arena:
# - Nền tối (DEN_THAN)
# - Tường bao hầm ngục (NAU_HAM)
# - Player với Camera2D smoothed pixel-snap
# - Kẻ thù thử nghiệm (DummyEnemy)
# - HUD hiển thị máu, thể lực và thông báo chết/hồi sinh

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var straw_bed: Node2D = $StrawBed

var enemy_spawn_configs: Array[Dictionary] = [
	{
		"scene": preload("res://scenes/enemies/dummy_enemy.tscn"),
		"position": Vector2(260, 135),
		"name": "DummyEnemy"
	},
	{
		"scene": preload("res://scenes/enemies/common_enemy.tscn"),
		"position": Vector2(340, 135),
		"name": "CommonEnemy"
	}
]

func _ready() -> void:
	if player != null and hud != null:
		player.hp_changed.connect(hud.update_hp)
		player.stamina_changed.connect(hud.update_stamina)
		player.player_died.connect(func(): hud.show_death_screen(true))
		player.player_respawned.connect(func(): hud.show_death_screen(false))
		player.weapon_swapped.connect(hud.update_weapon)
		# Khởi tạo giá trị ban đầu cho HUD
		hud.update_hp(player.current_hp, player.max_hp)
		hud.update_stamina(player.current_stamina, player.max_stamina)
		var w_name: String = str(player.current_weapon_data.get("name", player.current_weapon_id))
		hud.update_weapon(player.active_slot_idx, player.current_weapon_id, w_name)
	
	if straw_bed != null and straw_bed.has_signal("activated"):
		straw_bed.activated.connect(_on_straw_bed_activated)
	
	# Cung cấp 200 Mảnh Vỏ Vụn ban đầu để người chơi thử nghiệm tính năng tăng cấp ngay lập tức
	if PlayerInventory.shell_shards < 200:
		PlayerInventory.add_shards(200)
	
	print("[ARENA] Test arena đã sẵn sàng! Di chuyển (WASD), Lăn né (Space), Tấn công (J/Chuột trái), Đỡ (L/Chuột phải), Đổi vũ khí 3 ô (Q), Ổ Rơm lưu & lên cấp (E), F4 (Căn chỉnh Anchor VFX), F5 (+100 Mảnh Vỏ).")

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F5:
			PlayerInventory.add_shards(100)
			print("[TEST] Phím F5: Đã thêm +100 Mảnh Vỏ Vụn! Tổng: %d" % PlayerInventory.shell_shards)

func _on_straw_bed_activated(_bed: Node2D) -> void:
	respawn_enemies()

func respawn_enemies() -> void:
	# Xóa toàn bộ kẻ thù hiện có và hạt EXP chưa nhặt
	for child in get_children():
		if child is BaseEnemy or child.name.begins_with("DummyEnemy") or child.name.begins_with("CommonEnemy") or child.is_in_group("enemies"):
			child.queue_free()
		elif child is ShellShardPickup:
			child.queue_free()
	
	# Hồi sinh lại kẻ thù theo danh sách cấu hình
	for cfg in enemy_spawn_configs:
		var scene: PackedScene = cfg["scene"]
		var enemy = scene.instantiate()
		enemy.name = cfg["name"]
		enemy.position = cfg["position"]
		add_child(enemy)
	
	print("[ARENA] Đã hồi sinh toàn bộ kẻ thù trong đấu trường!")

