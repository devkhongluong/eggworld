extends Node2D

# Màn chơi thử nghiệm test_arena:
# - Nền tối (DEN_THAN)
# - Tường bao hầm ngục (NAU_HAM)
# - Player với Camera2D smoothed pixel-snap
# - Kẻ thù thử nghiệm (DummyEnemy)
# - HUD hiển thị máu, thể lực và thông báo chết/hồi sinh

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD

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
	
	print("[ARENA] Test arena đã sẵn sàng! Di chuyển (WASD), Lăn né (Space), Tấn công (J/Chuột trái), Đỡ (L/Chuột phải), Đổi vũ khí 3 ô (Q), Chọn nhanh (1: Gậy, 2: Dao, 3: Ná, 4: Tay không).")
