extends Node2D

# Vẽ hình khối tạm của Kẻ thù thường (Common Enemy)
# Màu sắc theo GDD:
# - Vỏ/thân: Nâu Da (NAU_DA), Cát (CAT), điểm mảng Tím Mục (TIM_MUC - dấu hiệu ăn mòn)
# - Viền: Nâu Hầm (NAU_HAM)
# - Báo hiệu tấn công: Đỏ Gạch (DO_GACH)
# - Mắt: Đỏ Rượu (DO_RUOU)

@onready var enemy: Node2D = get_parent()

func _draw() -> void:
	if enemy == null:
		return
	
	var radius: float = enemy.get("attack_radius")
	var state_val = enemy.get("current_state")
	var is_flashing: bool = enemy.get("is_flashing_red")
	
	# Kiểm tra state theo BaseEnemy.State
	# State: IDLE=0, CHASE=1, TELEGRAPH=2, ATTACK=3, RECOVERY=4, STUNNED=5, DEAD=6
	
	# 1. Vẽ vòng bán kính cảnh báo / đòn đánh
	if state_val == 2: # TELEGRAPH
		if is_flashing:
			draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_GACH, 1.5)
		else:
			draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_RUOU, 1.0)
	elif state_val == 3: # ATTACK
		draw_circle(Vector2.ZERO, radius, Color(Palette.DO_GACH.r, Palette.DO_GACH.g, Palette.DO_GACH.b, 0.35))
		draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Palette.DO_GACH, 2.0)
	elif state_val == 1: # CHASE
		# Vẽ chấm nhỏ hướng về mục tiêu
		draw_arc(Vector2.ZERO, radius, 0, TAU, 16, Palette.TIM_MUC, 0.5)
	
	# 2. Thân khối quái vật (hình hộp 20x20 px)
	var body_rect := Rect2(-10, -10, 20, 20)
	var outline_rect := Rect2(-11, -11, 22, 22)
	
	draw_rect(outline_rect, Palette.NAU_HAM)
	
	if state_val == 2 and is_flashing: # TELEGRAPH
		draw_rect(body_rect, Palette.DO_GACH)
	elif state_val == 3: # ATTACK
		draw_rect(body_rect, Palette.DO_GACH)
	elif state_val == 5: # STUNNED
		draw_rect(body_rect, Palette.XAM_SAT) # Choáng nhạt màu sắt
	else:
		draw_rect(body_rect, Palette.NAU_DA)
		# Mảng Tím Mục (ăn mòn) ở góc dưới-trái
		draw_rect(Rect2(-10, 0, 8, 10), Palette.TIM_MUC)
		# Mảng Cát sáng ở góc trên-phải
		draw_rect(Rect2(2, -10, 8, 6), Palette.CAT)
	
	# Mắt đỏ quái vật
	if state_val == 5: # STUNNED: mắt nhắm (dấu gạch)
		draw_line(Vector2(-6, -4), Vector2(-3, -4), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(3, -4), Vector2(6, -4), Palette.NAU_HAM, 1.0)
	else:
		draw_rect(Rect2(-6, -5, 3, 3), Palette.DO_RUOU)
		draw_rect(Rect2(3, -5, 3, 3), Palette.DO_RUOU)
