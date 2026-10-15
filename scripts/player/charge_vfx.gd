extends Node2D
class_name ChargeVfx

# ChargeVfx: Quản lý toàn bộ hiệu ứng hình ảnh tụ lực đòn nặng (Heavy Attack Charge VFX)
# - Đọc charge_ratio (0..1) từ Player, không tự đếm thời gian
# - 3 mức (Stage 1, 2, 3) theo ngưỡng trong data/vfx_charge.json
# - Kích thước gốc 1:1, không scale lẻ, không xoay góc lẻ, không làm mờ, tọa độ pixel nguyên
# - Phím F4: Hiển thị chấm debug tại anchor và nhích bằng phím mũi tên

signal stage_reached(weapon_id: String, stage: int)

const OneShotVfxScript = preload("res://scripts/combat/one_shot_vfx.gd")

var config: Dictionary = {}
var manifest: Dictionary = {}
var textures: Dictionary = {}

var is_charging: bool = false
var charge_ratio: float = 0.0
var weapon_id: String = "staff_wood"
var facing_dir: Vector2 = Vector2.DOWN
var current_stage: int = 0
var current_frame_idx: int = 1

var anim_timer: float = 0.0
var flash_timer: float = 0.0
var flash_active: bool = false
var glint_timer: float = 0.0
var glint_active: bool = false
var glint_anim_time: float = 0.0

# Debug Anchor (F4)
var debug_anchor_mode: bool = false

func _ready() -> void:
	load_config_and_manifest()
	_load_textures()

func load_config_and_manifest() -> void:
	var cfg_path := "res://data/vfx_charge.json"
	if FileAccess.file_exists(cfg_path):
		var file := FileAccess.open(cfg_path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				config = json.data
	
	var mani_path := "res://assets/vfx/charge/manifest.json"
	if FileAccess.file_exists(mani_path):
		var file := FileAccess.open(mani_path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				manifest = json.data

func _load_textures() -> void:
	var file_list: Array[String] = [
		"charge_staff_s1.png", "charge_staff_s2.png", "charge_staff_s3.png",
		"release_staff_dust.png",
		"glint_dagger.png", "release_dagger_speed.png",
		"stone_sling_s1.png", "stone_sling_s2.png", "stone_sling_s3.png",
		"release_sling_trail_s1.png", "release_sling_trail_s2.png", "release_sling_trail_s3.png",
		"flash_stage.png", "puff_cancel.png"
	]
	for fname in file_list:
		var p: String = "res://assets/vfx/charge/" + fname
		if ResourceLoader.exists(p):
			textures[fname] = load(p)

func get_manifest_info(file_name: String) -> Dictionary:
	if manifest.has(file_name):
		return manifest[file_name]
	return {"frames": 1, "frame_width": 32, "frame_height": 32, "fps": 12, "anchor": [16, 16]}

func get_thresholds_for_weapon(w_id: String) -> Dictionary:
	var stages_dict: Dictionary = config.get("stages", {})
	var th: Dictionary = stages_dict.get("thresholds", {})
	if th.has(w_id):
		return th[w_id]
	if th.has("default"):
		return th["default"]
	return {"stage_1": 0.28, "stage_2": 0.6, "stage_3": 1.0}

func get_stage_from_ratio(w_id: String, ratio: float) -> int:
	var th := get_thresholds_for_weapon(w_id)
	var s1: float = float(th.get("stage_1", 0.28))
	var s2: float = float(th.get("stage_2", 0.6))
	var s3: float = float(th.get("stage_3", 1.0))
	
	if ratio >= s3 - 0.001:
		return 3
	elif ratio >= s2:
		return 2
	elif ratio >= s1:
		return 1
	return 0

func is_min_charge_reached(w_id: String, ratio: float) -> bool:
	var th := get_thresholds_for_weapon(w_id)
	var s1: float = float(th.get("stage_1", 0.28))
	return ratio >= s1

func get_anchor_offset(w_id: String, dir_suffix: String, frame_idx: int = 1) -> Vector2:
	var weapons_cfg: Dictionary = config.get("weapons", {})
	if weapons_cfg.has(w_id):
		var w_cfg: Dictionary = weapons_cfg[w_id]
		var offsets: Dictionary = w_cfg.get("offsets", {})
		if offsets.has(dir_suffix):
			var dir_off: Dictionary = offsets[dir_suffix]
			var f_key := str(frame_idx)
			if dir_off.has(f_key):
				var arr: Array = dir_off[f_key]
				return Vector2(float(arr[0]), float(arr[1]))
			elif dir_off.has("default"):
				var arr: Array = dir_off["default"]
				return Vector2(float(arr[0]), float(arr[1]))
	
	# Mặc định theo hướng nếu chưa có trong json
	match dir_suffix:
		"up": return Vector2(0, -26)
		"down": return Vector2(0, 4)
		_: return Vector2(14, -14)

func set_anchor_offset(w_id: String, dir_suffix: String, frame_idx: int, new_offset: Vector2) -> void:
	if not config.has("weapons"):
		config["weapons"] = {}
	if not config["weapons"].has(w_id):
		config["weapons"][w_id] = {"offsets": {}}
	if not config["weapons"][w_id].has("offsets"):
		config["weapons"][w_id]["offsets"] = {}
	if not config["weapons"][w_id]["offsets"].has(dir_suffix):
		config["weapons"][w_id]["offsets"][dir_suffix] = {}
	
	var dir_off: Dictionary = config["weapons"][w_id]["offsets"][dir_suffix]
	dir_off[str(frame_idx)] = [int(new_offset.x), int(new_offset.y)]
	dir_off["default"] = [int(new_offset.x), int(new_offset.y)]

func start_charge(w_id: String, dir: Vector2) -> void:
	is_charging = true
	charge_ratio = 0.0
	weapon_id = w_id
	facing_dir = dir
	current_stage = 0
	current_frame_idx = 1
	anim_timer = 0.0
	flash_timer = 0.0
	flash_active = false
	glint_timer = 0.0
	glint_active = false
	glint_anim_time = 0.0
	queue_redraw()

func update_charge(ratio: float, dir: Vector2, frame_idx: int = 1) -> void:
	charge_ratio = clampf(ratio, 0.0, 1.0)
	facing_dir = dir
	current_frame_idx = frame_idx
	
	var new_stage := get_stage_from_ratio(weapon_id, charge_ratio)
	if new_stage > current_stage and new_stage >= 1:
		current_stage = new_stage
		flash_active = true
		flash_timer = 0.0
		stage_reached.emit(weapon_id, current_stage)
		print("[VFX_CHARGE] Đạt mức tụ lực: Mức %d cho %s!" % [current_stage, weapon_id])
	
	queue_redraw()

func cancel_charge(player_global_pos: Vector2, parent_node: Node) -> void:
	if is_charging:
		spawn_puff_cancel(player_global_pos, parent_node)
	is_charging = false
	charge_ratio = 0.0
	current_stage = 0
	flash_active = false
	glint_active = false
	queue_redraw()

func spawn_puff_cancel(player_global_pos: Vector2, parent_node: Node) -> void:
	if parent_node == null:
		return
	var tex: Texture2D = textures.get("puff_cancel.png", null)
	if tex == null:
		return
	
	var dir_suffix := get_direction_suffix(facing_dir)
	var flip_left: bool = (facing_dir.x < 0 and abs(facing_dir.x) >= abs(facing_dir.y))
	var offset := get_anchor_offset(weapon_id, dir_suffix, current_frame_idx)
	if flip_left:
		offset.x = -offset.x
	
	var vfx := OneShotVfxScript.new()
	var info := get_manifest_info("puff_cancel.png")
	var anc: Array = info.get("anchor", [8, 8])
	vfx.setup(
		tex,
		int(info.get("frame_width", 16)),
		int(info.get("frame_height", 16)),
		int(info.get("frames", 4)),
		float(info.get("fps", 12)),
		Vector2(float(anc[0]), float(anc[1])),
		flip_left
	)
	vfx.global_position = player_global_pos + offset
	parent_node.add_child(vfx)

func release_charge(player_global_pos: Vector2, parent_node: Node) -> Dictionary:
	var st := current_stage
	is_charging = false
	charge_ratio = 0.0
	current_stage = 0
	flash_active = false
	glint_active = false
	queue_redraw()
	
	var dir_suffix := get_direction_suffix(facing_dir)
	var flip_left: bool = (facing_dir.x < 0 and abs(facing_dir.x) >= abs(facing_dir.y))
	
	match weapon_id:
		"staff_wood", "staff":
			# Phát release_staff_dust tại điểm đập
			var tex: Texture2D = textures.get("release_staff_dust.png", null)
			if tex != null and parent_node != null:
				var info := get_manifest_info("release_staff_dust.png")
				var anc: Array = info.get("anchor", [24, 24])
				var vfx := OneShotVfxScript.new()
				var custom_data := {}
				if st >= 2:
					var target_r: float = 24.0 if st == 2 else 28.0
					custom_data["code_dust_ring"] = {
						"target_radius": target_r,
						"particle_count": 16 if st == 2 else 22,
						"duration": 0.33
					}
				vfx.setup(
					tex,
					int(info.get("frame_width", 48)),
					int(info.get("frame_height", 48)),
					int(info.get("frames", 4)),
					float(info.get("fps", 12)),
					Vector2(float(anc[0]), float(anc[1])),
					flip_left,
					custom_data
				)
				# Điểm đập phía trước người chơi
				var impact_pos := player_global_pos + facing_dir.normalized() * 16.0
				vfx.global_position = impact_pos
				parent_node.add_child(vfx)
		
		"dagger":
			# Phát release_dagger_speed phía sau thân
			var tex: Texture2D = textures.get("release_dagger_speed.png", null)
			if tex != null and parent_node != null:
				var info := get_manifest_info("release_dagger_speed.png")
				var anc: Array = info.get("anchor", [16, 8])
				var vfx := OneShotVfxScript.new()
				vfx.setup(
					tex,
					int(info.get("frame_width", 32)),
					int(info.get("frame_height", 16)),
					int(info.get("frames", 3)),
					float(info.get("fps", 12)),
					Vector2(float(anc[0]), float(anc[1])),
					flip_left
				)
				var behind_pos := player_global_pos - facing_dir.normalized() * 12.0
				vfx.global_position = behind_pos
				parent_node.add_child(vfx)
		
		"sling":
			pass
	
	return {"stage": st, "facing_dir": facing_dir}

func get_egg_shake_offset() -> Vector2:
	if not is_charging or current_stage < 3:
		return Vector2.ZERO
	var settings: Dictionary = config.get("settings", {})
	if not bool(settings.get("egg_shake_enabled", true)):
		return Vector2.ZERO
	var shake_x: float = 1.0 if (int(Time.get_ticks_msec() / 35) % 2 == 0) else -1.0
	return Vector2(shake_x, 0.0)

func _process(delta: float) -> void:
	if not is_charging and not debug_anchor_mode:
		return
	
	anim_timer += delta
	
	# Xử lý flash_stage (4 khung @ 12 fps = 0.33s)
	if flash_active:
		flash_timer += delta
		if flash_timer >= 0.33:
			flash_active = false
	
	# Xử lý dagger glint interval
	if is_charging and weapon_id == "dagger" and current_stage >= 1:
		glint_timer += delta
		var interval: float = 0.50
		if current_stage == 2: interval = 0.30
		elif current_stage == 3: interval = 0.16
		
		if glint_timer >= interval:
			glint_timer = 0.0
			glint_active = true
			glint_anim_time = 0.0
		
		if glint_active:
			glint_anim_time += delta
			if glint_anim_time >= 0.25: # 3 khung @ 12 fps
				glint_active = false
	
	queue_redraw()

func _draw() -> void:
	var dir_suffix := get_direction_suffix(facing_dir)
	var flip_left: bool = (facing_dir.x < 0 and abs(facing_dir.x) >= abs(facing_dir.y))
	var offset := get_anchor_offset(weapon_id, dir_suffix, current_frame_idx)
	
	# Chế độ Debug Anchor (F4): vẽ tâm ngắm rõ nét tại điểm gắn hiệu ứng
	if debug_anchor_mode:
		_draw_debug_anchor(offset, flip_left, dir_suffix)
	
	if not is_charging:
		return
	
	# Kiểm tra chế độ giảm hiệu ứng (vfx_reduced) hoặc thiếu texture -> fallback hào quang code
	var settings: Dictionary = config.get("settings", {})
	var vfx_reduced: bool = bool(settings.get("vfx_reduced", false))
	if vfx_reduced or textures.is_empty():
		_draw_fallback_aura()
		return
	
	# 1. Vẽ hiệu ứng tụ lực theo vũ khí
	match weapon_id:
		"staff_wood", "staff":
			_draw_staff_charge(offset, flip_left)
		"dagger":
			_draw_dagger_charge(offset, flip_left)
		"sling":
			_draw_sling_charge(offset, flip_left)
		"fist", _:
			_draw_fist_charge(offset, flip_left)
	
	# 2. Vẽ flash_stage đè lên tại anchor khi đạt mức mới
	if flash_active:
		var tex: Texture2D = textures.get("flash_stage.png", null)
		if tex != null:
			var info := get_manifest_info("flash_stage.png")
			var fw: int = int(info.get("frame_width", 24))
			var fh: int = int(info.get("frame_height", 24))
			var anc: Array = info.get("anchor", [12, 12])
			var f_idx: int = mini(3, int(flash_timer * 12.0))
			var src_rect := Rect2(f_idx * fw, 0, fw, fh)
			_draw_sprite_exact(tex, offset, Vector2(float(anc[0]), float(anc[1])), fw, fh, src_rect, flip_left)

func _draw_staff_charge(offset: Vector2, flip_left: bool) -> void:
	if current_stage < 1:
		return
	var fname := "charge_staff_s%d.png" % current_stage
	var tex: Texture2D = textures.get(fname, null)
	if tex != null:
		var info := get_manifest_info(fname)
		var fw: int = int(info.get("frame_width", 32))
		var fh: int = int(info.get("frame_height", 32))
		var anc: Array = info.get("anchor", [16, 16])
		var total_f: int = int(info.get("frames", 4))
		var f_idx: int = int(anim_timer * 12.0) % total_f
		var src_rect := Rect2(f_idx * fw, 0, fw, fh)
		_draw_sprite_exact(tex, offset, Vector2(float(anc[0]), float(anc[1])), fw, fh, src_rect, flip_left)

func _draw_dagger_charge(offset: Vector2, flip_left: bool) -> void:
	# 1. Vạch báo đường đâm bằng code (dãy điểm Kem trước mặt, đúng tầm đâm thực 24px)
	var aim := facing_dir.normalized()
	if aim == Vector2.ZERO:
		aim = Vector2.DOWN
	var max_reach: float = 24.0 # theo hitbox đòn nặng dagger
	var cur_reach: float = clampf(max_reach * charge_ratio, 6.0, max_reach)
	var dot_color: Color = Palette.KEM if current_stage < 3 else Palette.VANG_CO
	
	var start_p := Vector2(0, -10) + aim * 6.0
	var d: float = 0.0
	while d <= cur_reach:
		var p := start_p + aim * d
		draw_rect(Rect2(round(p.x), round(p.y), 1, 1), dot_color)
		d += 3.0
	
	# 2. glint_dagger chạy dọc lưỡi dao lặp lại theo mức
	if current_stage >= 1 and glint_active:
		var tex: Texture2D = textures.get("glint_dagger.png", null)
		if tex != null:
			var info := get_manifest_info("glint_dagger.png")
			var fw: int = int(info.get("frame_width", 8))
			var fh: int = int(info.get("frame_height", 8))
			var anc: Array = info.get("anchor", [4, 4])
			var total_f: int = int(info.get("frames", 3))
			var f_idx: int = mini(total_f - 1, int(glint_anim_time * 12.0))
			var src_rect := Rect2(f_idx * fw, 0, fw, fh)
			_draw_sprite_exact(tex, offset, Vector2(float(anc[0]), float(anc[1])), fw, fh, src_rect, flip_left)

func _draw_sling_charge(offset: Vector2, flip_left: bool) -> void:
	var pivot := Vector2(0, -10)
	var aim := facing_dir.normalized()
	if aim == Vector2.ZERO:
		aim = Vector2.DOWN
	
	# 1. Dây ná căng bằng code
	var sling_pos := pivot + aim * 5.0
	var pull_pos := offset
	if flip_left:
		pull_pos.x = -pull_pos.x
	
	var fork_l := sling_pos + Vector2(-aim.y, aim.x) * 2.5 + aim * 2.5
	var fork_r := sling_pos + Vector2(aim.y, -aim.x) * 2.5 + aim * 2.5
	draw_line(Vector2(round(fork_l.x), round(fork_l.y)), Vector2(round(pull_pos.x), round(pull_pos.y)), Palette.GIAY_DA, 1.0)
	draw_line(Vector2(round(fork_r.x), round(fork_r.y)), Vector2(round(pull_pos.x), round(pull_pos.y)), Palette.GIAY_DA, 1.0)
	
	# 2. Vạch ngắm bằng code (dài theo charge_ratio)
	var aim_reach: float = clampf(42.0 * charge_ratio, 8.0, 42.0)
	var d: float = 6.0
	while d <= aim_reach:
		var p := sling_pos + aim * d
		draw_rect(Rect2(round(p.x), round(p.y), 1, 1), Palette.CAT)
		d += 4.0
	
	# 3. Viên sỏi stone_sling_s1/s2/s3 trong túi theo mức
	if current_stage >= 1:
		var fname := "stone_sling_s%d.png" % current_stage
		var tex: Texture2D = textures.get(fname, null)
		if tex != null:
			var info := get_manifest_info(fname)
			var fw: int = int(info.get("frame_width", 8))
			var fh: int = int(info.get("frame_height", 8))
			var anc: Array = info.get("anchor", [4, 4])
			var total_f: int = int(info.get("frames", 2))
			var f_idx: int = int(anim_timer * 12.0) % total_f
			var src_rect := Rect2(f_idx * fw, 0, fw, fh)
			_draw_sprite_exact(tex, offset, Vector2(float(anc[0]), float(anc[1])), fw, fh, src_rect, flip_left)

func _draw_fist_charge(offset: Vector2, flip_left: bool) -> void:
	if current_stage >= 1:
		var r: float = 2.0 + float(current_stage) * 1.5
		var pos := offset
		if flip_left:
			pos.x = -pos.x
		draw_circle(pos, r, Palette.DO_GACH)
		draw_circle(pos, maxf(1.0, r - 1.5), Palette.KEM)

func _draw_sprite_exact(
	tex: Texture2D,
	pos: Vector2,
	anc: Vector2,
	fw: int,
	fh: int,
	src_rect: Rect2,
	flip_left: bool
) -> void:
	if tex == null:
		return
	if flip_left:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
		var dst := Rect2(round(pos.x - anc.x), round(pos.y - anc.y), fw, fh)
		draw_texture_rect_region(tex, dst, src_rect)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		var dst := Rect2(round(pos.x - anc.x), round(pos.y - anc.y), fw, fh)
		draw_texture_rect_region(tex, dst, src_rect)

func _draw_fallback_aura() -> void:
	# Giữ lại hào quang vẽ bằng code như phương án dự phòng khi vfx_reduced bật hoặc thiếu sprite
	var pulse: float = sin(Time.get_ticks_msec() * 0.02) * 1.5
	var charge_rad: float = 8.0 + charge_ratio * 9.0 + pulse
	draw_arc(Vector2(0, -10), charge_rad, 0.0, TAU, 16, Palette.DO_GACH, 1.8)
	draw_arc(Vector2(0, -10), maxf(3.0, charge_rad - 2.5), 0.0, TAU, 16, Palette.VANG_CO, 1.2)
	if charge_ratio >= 0.7:
		draw_arc(Vector2(0, -10), maxf(2.0, charge_rad - 4.5), 0.0, TAU, 16, Palette.KEM, 1.5)

func _draw_debug_anchor(offset: Vector2, flip_left: bool, dir_suffix: String) -> void:
	var anchor_pt := offset
	if flip_left:
		anchor_pt.x = -anchor_pt.x
	
	# Vẽ dấu thập đỏ gạch và điểm tâm kem
	draw_line(anchor_pt + Vector2(-4, 0), anchor_pt + Vector2(4, 0), Palette.DO_GACH, 1.0)
	draw_line(anchor_pt + Vector2(0, -4), anchor_pt + Vector2(0, 4), Palette.DO_GACH, 1.0)
	draw_rect(Rect2(anchor_pt.x, anchor_pt.y, 1, 1), Palette.KEM)
	
	# Khung bao quanh
	draw_rect(Rect2(anchor_pt.x - 2, anchor_pt.y - 2, 5, 5), Palette.VANG_CO, false, 1.0)
	
	# Nhãn tọa độ hiển thị trực quan
	draw_string(ThemeDB.fallback_font, anchor_pt + Vector2(6, -2), "%s [%d, %d]" % [dir_suffix, int(offset.x), int(offset.y)], HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Palette.KEM)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F4:
			debug_anchor_mode = not debug_anchor_mode
			print("[VFX_DEBUG] Chế độ căn chỉnh anchor VFX tụ lực (F4): %s" % ("BẬT" if debug_anchor_mode else "TẮT"))
			if debug_anchor_mode:
				var dir_s := get_direction_suffix(facing_dir)
				var cur_off := get_anchor_offset(weapon_id, dir_s, current_frame_idx)
				print("[VFX_OFFSET_F4] Hiện tại: Vũ khí '%s' | Hướng '%s' | Offset: [%d, %d] (Dùng mũi tên để nhích)" % [
					weapon_id, dir_s, cur_off.x, cur_off.y
				])
			queue_redraw()
			return
		
		if debug_anchor_mode:
			var dir_s := get_direction_suffix(facing_dir)
			var cur_off := get_anchor_offset(weapon_id, dir_s, current_frame_idx)
			var delta_off := Vector2.ZERO
			
			if event.keycode == KEY_UP:
				delta_off.y -= 1
			elif event.keycode == KEY_DOWN:
				delta_off.y += 1
			elif event.keycode == KEY_LEFT:
				delta_off.x -= 1
			elif event.keycode == KEY_RIGHT:
				delta_off.x += 1
			
			if delta_off != Vector2.ZERO:
				var new_off := cur_off + delta_off
				set_anchor_offset(weapon_id, dir_s, current_frame_idx, new_off)
				print("[VFX_OFFSET_F4] weapon: \"%s\", dir: \"%s\", frame: %d -> offset: [%d, %d]" % [
					weapon_id, dir_s, current_frame_idx, int(new_off.x), int(new_off.y)
				])
				queue_redraw()

func get_direction_suffix(dir: Vector2) -> String:
	if abs(dir.x) >= abs(dir.y):
		return "side"
	elif dir.y > 0:
		return "down"
	else:
		return "up"
