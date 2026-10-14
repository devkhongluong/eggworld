extends Area2D
class_name LostShard

# LostShard: Đống Mảnh Vỏ Vụn bị rơi khi Player chết (Lost Runes mechanic)
# - Chỉ tồn tại DUY NHẤT 1 đống trên bản đồ tại một thời điểm
# - Nếu chết lần thứ hai trước khi nhặt lại, đống cũ sẽ biến mất vĩnh viễn
# - Kích thước lớn hơn, sáng hơn và nổi bật hơn Mảnh Vỏ Vụn thông thường

static var current_pile: LostShard = null

@export var shard_amount: int = 0
var is_lost_pile: bool = true
var time_passed: float = 0.0

static func spawn_at(parent: Node, pos: Vector2, amount: int) -> LostShard:
	if amount <= 0:
		return null
	
	if current_pile != null and is_instance_valid(current_pile):
		print("[LOST_SHARD] Player chết lần nữa! Đống Mảnh Vỏ Vụn trước đó (%d hạt) đã tan biến vĩnh viễn!" % current_pile.shard_amount)
		current_pile.queue_free()
		current_pile = null
	
	var scene: PackedScene = load("res://scenes/items/lost_shard.tscn")
	var instance: LostShard = scene.instantiate()
	instance.shard_amount = amount
	instance.global_position = pos
	current_pile = instance
	parent.call_deferred("add_child", instance)
	print("[LOST_SHARD] Đã rơi đống Mảnh Vỏ Vụn (%d hạt) tại vị trí %s" % [amount, pos])
	return instance

func _ready() -> void:
	collision_layer = 0
	collision_mask = 3 # Player body (Layer 1) và Hurtbox (Layer 2)
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time_passed += delta * 4.0
	queue_redraw()

func _draw() -> void:
	var bobbing: float = sin(time_passed) * 3.0
	var pulse: float = 1.0 + sin(time_passed * 1.5) * 0.15
	var center := Vector2(0, bobbing)
	
	# Vòng hào quang sáng phía sau
	draw_circle(center, 9.0 * pulse, Color(Palette.VANG_CO.r, Palette.VANG_CO.g, Palette.VANG_CO.b, 0.25))
	
	# Đa giác tinh thể lớn (hình thoi 12x12 px)
	var pts := PackedVector2Array([
		center + Vector2(0, -6 * pulse),
		center + Vector2(6 * pulse, 0),
		center + Vector2(0, 6 * pulse),
		center + Vector2(-6 * pulse, 0)
	])
	draw_colored_polygon(pts, Palette.VANG_CO)
	
	# Tâm sáng Kem
	var inner_pts := PackedVector2Array([
		center + Vector2(0, -3),
		center + Vector2(3, 0),
		center + Vector2(0, 3),
		center + Vector2(-3, 0)
	])
	draw_colored_polygon(inner_pts, Palette.KEM)
	
	# Viền Nâu Hầm
	draw_polyline(pts, Palette.NAU_HAM, 1.2)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hurtbox" or (area.get_parent() != null and area.get_parent() is Player):
		_collect()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_collect()

func _collect() -> void:
	print("[LOST_SHARD] Player đã nhặt lại toàn bộ %d Mảnh Vỏ Vụn đánh rơi!" % shard_amount)
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_method("add_shards"):
			inv.add_shards(shard_amount)
	
	if current_pile == self:
		current_pile = null
	
	queue_free()
