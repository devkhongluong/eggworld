extends Area2D
class_name ShellShardPickup

# Mảnh Vỏ Vụn (EXP) rơi ra khi kẻ thù bị tiêu diệt
# - Màu sắc: Vàng Cổ (VANG_CO) theo GDD Mục 3
# - Tự bay nhẹ / nhấp nháy
# - Khi Player chạm vào: tăng Mảnh Vỏ Vụn và tự giải phóng

@export var shard_amount: int = 15

var time_passed: float = 0.0

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2 # Hurtbox hoặc Layer Player
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time_passed += delta * 5.0
	queue_redraw()

func _draw() -> void:
	# Vẽ hạt tinh thể Mảnh Vỏ Vụn (hình thoi 6x6 px)
	var bobbing: float = sin(time_passed) * 2.0
	var center := Vector2(0, bobbing)
	
	var pts := PackedVector2Array([
		center + Vector2(0, -3),
		center + Vector2(3, 0),
		center + Vector2(0, 3),
		center + Vector2(-3, 0)
	])
	draw_colored_polygon(pts, Palette.VANG_CO)
	
	# Điểm sáng Kem ở đỉnh
	draw_rect(Rect2(center.x - 1, center.y - 2, 2, 2), Palette.KEM)
	# Viền Nâu Hầm
	draw_polyline(pts, Palette.NAU_HAM, 1.0)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hurtbox" or area.get_parent() is Player:
		_collect(area.get_parent())

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_collect(body)

func _collect(player_node: Node) -> void:
	print("[PICKUP] Player đã nhặt được %d Mảnh Vỏ Vụn (EXP)!" % shard_amount)
	# Tích lũy hành vi EXPLORE nhẹ nếu nhặt đồ
	BehaviorTracker.add_points(BehaviorTracker.ACTION_EXPLORE, 1)
	queue_free()
