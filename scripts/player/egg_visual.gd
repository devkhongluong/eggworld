extends Node2D

# EggVisual: Quản lý hiệu ứng hình ảnh mở rộng trên người chơi
# 1. Vết nứt trên vỏ trứng (to dần theo lượng máu giảm)
# 2. Hiệu ứng văng mảnh vỏ (egg shell debris particles) khi trúng đòn
# 3. Hoạt ảnh vung kiếm/dao/ná sống động (Dynamic weapon attack swing/thrust/shoot)
# 4. Vệt chém combo đòn đánh tương ứng từng vũ khí
# 5. Hình khối vũ khí giắt bên hông khi nghỉ

var attack_slash_total_time: float = 0.22
var attack_slash_timer: float = 0.0
var attack_slash_dir: Vector2 = Vector2.DOWN
var attack_slash_step: int = 0
var attack_weapon_type: String = "staff_wood"
var is_attacking_visual: bool = false
var show_placeholder_body: bool = false

# Dữ liệu vết nứt vỏ trứng (tính theo tỉ lệ hp: 1.0 -> 0.0)
var current_hp_ratio: float = 1.0

# Danh sách mảnh vỏ đang văng
var shell_shards: Array[Dictionary] = []

# Trạng thái đỡ đòn
var is_guarding: bool = false
var guard_dir: Vector2 = Vector2.DOWN

var is_dead_visual: bool = false
var equipped_weapon_id: String = "staff_wood"
var facing_dir: Vector2 = Vector2.DOWN
var weapon_textures: Dictionary = {}

func _ready() -> void:
	set_process(true)
	_load_weapon_textures()

func _load_weapon_textures() -> void:
	var staff_tex = load("res://assets/sprites/weapons/weapon_staff_wood.png")
	if staff_tex != null:
		weapon_textures["staff_wood"] = staff_tex
		weapon_textures["staff"] = staff_tex
	var dagger_tex = load("res://assets/sprites/weapons/weapon_dagger.png")
	if dagger_tex != null:
		weapon_textures["dagger"] = dagger_tex
	var sling_tex = load("res://assets/sprites/weapons/weapon_sling.png")
	if sling_tex != null:
		weapon_textures["sling"] = sling_tex

func set_guarding(guarding: bool, dir: Vector2) -> void:
	if is_guarding != guarding or guard_dir != dir:
		is_guarding = guarding
		guard_dir = dir
		queue_redraw()

func set_dead(dead: bool) -> void:
	is_dead_visual = dead
	if dead:
		is_attacking_visual = false
		attack_slash_timer = 0.0
	queue_redraw()

func set_hp_ratio(ratio: float) -> void:
	current_hp_ratio = clampf(ratio, 0.0, 1.0)
	queue_redraw()

func set_equipped_weapon(w_id: String, dir: Vector2) -> void:
	equipped_weapon_id = w_id
	facing_dir = dir
	queue_redraw()

func spawn_shell_burst(amount: int = 6) -> void:
	for i in range(amount):
		var angle := randf_range(0.0, TAU)
		var speed := randf_range(40.0, 110.0)
		var vel := Vector2(cos(angle), sin(angle)) * speed
		vel.y -= randf_range(20.0, 50.0)
		
		var colors := [Palette.GIAY_DA, Palette.CAT, Palette.NAU_HAM, Palette.KEM]
		var col: Color = colors[randi() % colors.size()]
		var sz := Vector2(randf_range(1.5, 3.0), randf_range(1.5, 3.0))
		var life := randf_range(0.3, 0.55)
		
		shell_shards.append({
			"pos": Vector2(randf_range(-4.0, 4.0), randf_range(-18.0, -10.0)),
			"vel": vel,
			"color": col,
			"size": sz,
			"life": life,
			"max_life": life
		})
	queue_redraw()

var is_heavy_charging: bool = false
var heavy_charge_ratio: float = 0.0
var is_heavy_attack: bool = false

func set_heavy_charging(charging: bool, ratio: float = 0.0, weapon_id: String = "", dir: Vector2 = Vector2.ZERO) -> void:
	is_heavy_charging = charging
	heavy_charge_ratio = ratio
	if weapon_id != "":
		equipped_weapon_id = weapon_id
	if dir != Vector2.ZERO:
		facing_dir = dir
	queue_redraw()

func start_attack_visual(dir: Vector2, step: int, weapon_id: String = "staff_wood", custom_duration: float = -1.0, is_heavy: bool = false) -> void:
	attack_slash_dir = dir.normalized()
	if attack_slash_dir == Vector2.ZERO:
		attack_slash_dir = Vector2.DOWN
	facing_dir = attack_slash_dir
	attack_slash_step = step
	attack_weapon_type = weapon_id
	is_heavy_attack = is_heavy
	
	if custom_duration > 0.0:
		attack_slash_total_time = custom_duration
	elif weapon_id == "dagger":
		attack_slash_total_time = 0.14
	elif weapon_id == "sling":
		attack_slash_total_time = 0.18
	else:
		attack_slash_total_time = 0.22
	
	attack_slash_timer = attack_slash_total_time
	is_attacking_visual = true
	queue_redraw()

func stop_attack_visual() -> void:
	is_attacking_visual = false
	attack_slash_timer = 0.0
	queue_redraw()

func _process(delta: float) -> void:
	var needs_redraw: bool = false
	
	if is_heavy_charging:
		needs_redraw = true
	
	if attack_slash_timer > 0.0:
		attack_slash_timer -= delta
		if attack_slash_timer <= 0.0:
			is_attacking_visual = false
		needs_redraw = true
	
	if not shell_shards.is_empty():
		var idx := shell_shards.size() - 1
		while idx >= 0:
			var shard: Dictionary = shell_shards[idx]
			shard["life"] -= delta
			if shard["life"] <= 0.0:
				shell_shards.remove_at(idx)
			else:
				shard["pos"] += shard["vel"] * delta
				shard["vel"].y += 220.0 * delta
			idx -= 1
		needs_redraw = true
	
	if needs_redraw:
		queue_redraw()

func _draw() -> void:
	# 1. Vẽ các vết nứt trên vỏ theo mức độ mất máu
	if current_hp_ratio < 0.8:
		draw_line(Vector2(-1, -22), Vector2(1, -19), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(1, -19), Vector2(0, -17), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.6:
		draw_line(Vector2(0, -17), Vector2(3, -14), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(3, -14), Vector2(2, -11), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(-5, -17), Vector2(-2, -15), Palette.NAU_HAM, 1.0)
		draw_line(Vector2(-2, -15), Vector2(-4, -12), Palette.NAU_HAM, 1.0)
	
	if current_hp_ratio < 0.35:
		draw_line(Vector2(2, -11), Vector2(5, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(-4, -12), Vector2(-2, -8), Palette.NAU_HAM, 1.2)
		draw_line(Vector2(0, -17), Vector2(-2, -14), Palette.CAT, 1.0)
		draw_rect(Rect2(0, -15, 2, 2), Palette.VANG_CO)
		draw_rect(Rect2(2, -12, 1, 2), Palette.VANG_CO)
	
	# 2. Vẽ các mảnh vỏ trứng đang văng khi dính đòn
	for shard in shell_shards:
		var alpha: float = clampf(shard["life"] / shard["max_life"], 0.0, 1.0)
		var c: Color = shard["color"]
		c.a = alpha
		var sz: Vector2 = shard["size"]
		var p: Vector2 = shard["pos"]
		draw_rect(Rect2(p.x - sz.x * 0.5, p.y - sz.y * 0.5, sz.x, sz.y), c)
	
	# 3. Vẽ thế Đỡ Đòn (Guard)
	if is_guarding:
		var shield_center := Vector2(0, -10) + guard_dir.normalized() * 11.0
		var guard_angle: float = guard_dir.angle()
		var g_start: float = guard_angle - PI * 0.40
		var g_end: float = guard_angle + PI * 0.40
		draw_arc(shield_center, 9.0, g_start, g_end, 10, Palette.NAU_HAM, 3.5)
		draw_arc(shield_center, 9.0, g_start, g_end, 10, Palette.XAM_SAT, 2.0)
		draw_circle(shield_center, 2.0, Palette.VANG_CO)
	
	# 3.5 Vẽ vòng hào quang tích lực đòn nặng (Heavy Charge Aura)
	if is_heavy_charging:
		var pulse: float = sin(Time.get_ticks_msec() * 0.02) * 1.5
		var charge_rad: float = 8.0 + heavy_charge_ratio * 9.0 + pulse
		draw_arc(Vector2(0, -10), charge_rad, 0.0, TAU, 16, Palette.DO_GACH, 1.8)
		draw_arc(Vector2(0, -10), maxf(3.0, charge_rad - 2.5), 0.0, TAU, 16, Palette.VANG_CO, 1.2)
		if heavy_charge_ratio >= 0.7:
			draw_arc(Vector2(0, -10), maxf(2.0, charge_rad - 4.5), 0.0, TAU, 16, Palette.KEM, 1.5)
			var t := Time.get_ticks_msec() * 0.008
			for i in range(4):
				var a := t + float(i) * (TAU / 4.0)
				var p1 := Vector2(0, -10) + Vector2(cos(a), sin(a)) * (charge_rad + 2.5)
				var p2 := Vector2(0, -10) + Vector2(cos(a), sin(a)) * (charge_rad - 2.0)
				draw_line(p1, p2, Palette.KEM, 1.0)
	
	# 4. Vẽ diễn hoạt vũ khí & đòn đánh (Hoạt ảnh động)
	_draw_dynamic_weapon()

func _draw_dynamic_weapon() -> void:
	if is_guarding or is_dead_visual:
		return
	
	var pivot := Vector2(0, -10)
	var aim := facing_dir.normalized()
	if aim == Vector2.ZERO:
		aim = Vector2.DOWN
	var base_angle := aim.angle()
	var flip_sign: float = -1.0 if facing_dir.x < 0 else 1.0
	
	if is_attacking_visual:
		# --- TRẠNG THÁI RA ĐÒN: VŨ KHÍ CHUYỂN ĐỘNG THEO PHA ---
		var progress: float = clampf(1.0 - (attack_slash_timer / maxf(0.01, attack_slash_total_time)), 0.0, 1.0)
		
		match attack_weapon_type:
			"staff_wood", "staff":
				# Gậy gỗ vung xoay vòng cung (tỉ lệ 2/3)
				var reverse_swing: bool = (attack_slash_step % 2 == 1)
				var start_ang: float = base_angle + PI * 0.52 if reverse_swing else base_angle - PI * 0.52
				var end_ang: float = base_angle - PI * 0.52 if reverse_swing else base_angle + PI * 0.52
				var cur_ang: float = lerp_angle(start_ang, end_ang, progress)
				
				# Vệt chém hình vòng cung vàng rực bám theo sau mũi gậy (đòn nặng to gấp 1.5x)
				var arc_rad: float = 19.0 if is_heavy_attack else (15.3 if attack_slash_step == 2 else 12.7)
				var a1 := minf(start_ang, cur_ang)
				var a2 := maxf(start_ang, cur_ang)
				if is_heavy_attack:
					draw_arc(pivot, arc_rad, a1, a2, 16, Palette.DO_GACH, 3.0)
					draw_arc(pivot, arc_rad - 2.0, a1, a2, 16, Palette.KEM, 2.0)
					draw_arc(pivot, arc_rad - 4.0, a1, a2, 16, Palette.VANG_CO, 1.5)
				else:
					draw_arc(pivot, arc_rad, a1, a2, 14, Palette.KEM, 2.0)
					draw_arc(pivot, arc_rad - 1.5, a1, a2, 14, Palette.VANG_CO, 1.5)
			
			"dagger":
				# Dao găm đâm thẳng vọt tới trước cực nhanh (tỉ lệ 2/3)
				var base_thrust: float = 2.7
				var max_thrust: float = 13.5
				var thrust_dist: float = base_thrust
				if progress < 0.20:
					thrust_dist = lerpf(base_thrust, 0.0, progress / 0.20)
				elif progress < 0.60:
					thrust_dist = lerpf(0.0, max_thrust, (progress - 0.20) / 0.40)
				else:
					thrust_dist = lerpf(max_thrust, base_thrust, (progress - 0.60) / 0.40)
				
				var dagger_pos := pivot + aim * thrust_dist
				var tip := dagger_pos + aim * 9.5
				
				# Vệt đâm nhọn ánh sáng lướt theo dao
				draw_line(pivot + aim * 1.5, tip + aim * 2.5, Palette.KEM, 1.8)
				draw_line(pivot + aim * 1.5 + Vector2(-aim.y, aim.x) * 1.5, tip, Palette.XAM_SAT, 1.0)
				draw_line(pivot + aim * 1.5 + Vector2(aim.y, -aim.x) * 1.5, tip, Palette.XAM_SAT, 1.0)
			
			"sling":
				# Ná giương chạc và bung dây thun (tỉ lệ 2/3)
				var sling_pos := pivot + aim * 5.3
				var pull_pos := pivot - aim * 2.7 if progress < 0.45 else sling_pos + aim * 3.3
				
				# Dây thun và viên đạn đá
				var fork_l := sling_pos + Vector2(-aim.y, aim.x) * 2.7 + aim * 2.7
				var fork_r := sling_pos + Vector2(aim.y, -aim.x) * 2.7 + aim * 2.7
				draw_line(fork_l, pull_pos, Palette.GIAY_DA, 1.2)
				draw_line(fork_r, pull_pos, Palette.GIAY_DA, 1.2)
				if progress < 0.45:
					draw_circle(pull_pos, 1.7, Palette.XAM_SAT)
				else:
					draw_circle(pull_pos + aim * 4.0, 1.4, Palette.CAT)
			
			"unarmed", _:
				var p_dist: float = lerpf(1.3, 9.3, sin(progress * PI))
				draw_circle(pivot + aim * p_dist, 2.7, Palette.KEM)
	elif is_heavy_charging:
		# --- TRẠNG THÁI GỒNG LỰC: VŨ KHÍ GIƯƠNG CAO TỤ NĂNG LƯỢNG RỰC RỠ ---
		var shake: float = sin(Time.get_ticks_msec() * 0.045) * (0.8 + heavy_charge_ratio * 1.5)
		match equipped_weapon_id:
			"staff_wood", "staff":
				# Tụ cầu năng lượng ở đầu gậy
				var ready_ang: float = base_angle - PI * 0.65 * flip_sign + deg_to_rad(shake * 4.0)
				var tip_pos := pivot + Vector2(cos(ready_ang), sin(ready_ang)) * 17.0
				draw_circle(tip_pos, 2.5 + heavy_charge_ratio * 2.5, Palette.DO_GACH)
				draw_circle(tip_pos, 1.5 + heavy_charge_ratio * 1.5, Palette.KEM)
			"dagger":
				# Tia sáng nhọn ở mũi dao
				var dagger_pos: Vector2 = pivot - aim * (3.0 + heavy_charge_ratio * 3.0) + Vector2(aim.y, -aim.x) * 4.0 * flip_sign
				draw_circle(dagger_pos + aim * 8.0, 1.8 + heavy_charge_ratio * 1.5, Palette.KEM)
			"sling":
				# Kéo căng ná tối đa ra sau
				var sling_pos := pivot + aim * 5.3
				var pull_dist: float = 4.0 + heavy_charge_ratio * 5.0
				var pull_pos := pivot - aim * pull_dist + Vector2(0, shake * 0.5)
				var fork_l := sling_pos + Vector2(-aim.y, aim.x) * 2.7 + aim * 2.7
				var fork_r := sling_pos + Vector2(aim.y, -aim.x) * 2.7 + aim * 2.7
				draw_line(fork_l, pull_pos, Palette.GIAY_DA, 1.2)
				draw_line(fork_r, pull_pos, Palette.GIAY_DA, 1.2)
				draw_circle(pull_pos, 2.0 + heavy_charge_ratio * 1.2, Palette.XAM_SAT)
				draw_circle(pull_pos, 1.0 + heavy_charge_ratio * 1.0, Palette.VANG_CO)
			"unarmed", "fist", _:
				var fist_pos: Vector2 = pivot - aim * (3.0 + heavy_charge_ratio * 3.0) + Vector2(aim.y, -aim.x) * 3.0 * flip_sign
				draw_circle(fist_pos, 2.5 + heavy_charge_ratio * 1.5, Palette.DO_GACH)
				draw_circle(fist_pos, 1.5, Palette.KEM)
	else:
		# --- TRẠNG THÁI NGHỈ: VŨ KHÍ NẰM GỌN BÊN HÔNG / TAY ---
		var hand_pos: Vector2 = Vector2(5.0 * flip_sign, -8.0)
		if abs(facing_dir.y) > abs(facing_dir.x):
			hand_pos = Vector2(5.0 * flip_sign, -8.0 if facing_dir.y > 0 else -10.0)
		
		match equipped_weapon_id:
			"staff_wood", "staff":
				var staff_tex: Texture2D = weapon_textures.get("staff_wood", null)
				if staff_tex != null:
					_draw_weapon_sprite(staff_tex, hand_pos + Vector2(0, 1), 0.30 * flip_sign, Vector2(16.0, 24.0), Vector2(0.57, 0.57))
				else:
					draw_line(hand_pos + Vector2(0, 3), hand_pos + Vector2(2 * flip_sign, -9), Palette.NAU_DA, 1.8)
			"dagger":
				var dagger_tex: Texture2D = weapon_textures.get("dagger", null)
				if dagger_tex != null:
					_draw_weapon_sprite(dagger_tex, hand_pos + Vector2(0, 1), 0.65 * flip_sign, Vector2(16.0, 23.0), Vector2(0.57, 0.57))
				else:
					var d_aim := aim * 5.3
					draw_line(hand_pos, hand_pos + d_aim, Palette.XAM_SAT, 1.5)
			"sling":
				var sling_tex: Texture2D = weapon_textures.get("sling", null)
				if sling_tex != null:
					_draw_weapon_sprite(sling_tex, hand_pos, 0.15 * flip_sign, Vector2(16.0, 21.0), Vector2(0.57, 0.57))
				else:
					draw_line(hand_pos, hand_pos + Vector2(0, -3.3), Palette.CAT, 1.5)
			"fist", _:
				pass

func _draw_weapon_sprite(tex: Texture2D, pos: Vector2, rot: float, pivot: Vector2, p_scale: Vector2 = Vector2(0.67, 0.67)) -> void:
	if tex == null:
		return
	draw_set_transform(pos, rot, p_scale)
	draw_texture(tex, -pivot)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
