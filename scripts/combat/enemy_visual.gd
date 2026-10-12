extends Node2D

# Vẽ hình khối tạm của Kẻ thù thử nghiệm
# Màu sắc: Đỏ Rượu (DO_RUOU), viền Nâu Hầm (NAU_HAM), cảnh báo Đỏ Gạch (DO_GACH)

const DummyEnemyScript = preload("res://scripts/combat/dummy_enemy.gd")

@onready var enemy: Node2D = get_parent()

func _draw() -> void:
	if enemy == null:
		return
	
	var radius: float = enemy.get("attack_radius")
	var state_val = enemy.get("current_state")
	var is_flashing: bool = enemy.get("is_flashing_red")
	
	# 1. Vẽ vòng bán kính cảnh báo / đòn đánh
	match state_val:
		DummyEnemyScript.State.TELEGRAPH:
			if is_flashing:
				draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_GACH, 1.5)
			else:
				draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_RUOU, 1.0)
		DummyEnemyScript.State.ATTACK:
			# Vùng sát thương khi đang vung đòn
			draw_circle(Vector2.ZERO, radius, Color(Palette.DO_GACH.r, Palette.DO_GACH.g, Palette.DO_GACH.b, 0.35))
			draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_GACH, 2.0)
		_:
			# Hiển thị đường nét mờ bán kính khi nhàn rỗi
			draw_arc(Vector2.ZERO, radius, 0, TAU, 24, Palette.XAM_SAT, 0.75)
	
	# 2. Thân khối quái vật (hình hộp 20x20 px)
	var body_rect := Rect2(-10, -10, 20, 20)
	var outline_rect := Rect2(-11, -11, 22, 22)
	
	draw_rect(outline_rect, Palette.NAU_HAM)
	
	if state_val == DummyEnemyScript.State.TELEGRAPH and is_flashing:
		draw_rect(body_rect, Palette.DO_GACH)
	elif state_val == DummyEnemyScript.State.ATTACK:
		draw_rect(body_rect, Palette.DO_GACH)
	else:
		draw_rect(body_rect, Palette.DO_RUOU)
	
	# Mắt đỏ gạch quái vật
	draw_rect(Rect2(-6, -4, 3, 3), Palette.DO_GACH)
	draw_rect(Rect2(3, -4, 3, 3), Palette.DO_GACH)
