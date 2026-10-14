# PROJECT SNAPSHOT

## CÂY THƯ MỤC CÁC TỆP MÃ NGUỒN VÀ DỮ LIỆU

- assets\sprites\player\animations.json
- data\stats.json
- data\weapons.json
- project.godot
- scenes\enemies\common_enemy.tscn
- scenes\enemies\dummy_enemy.tscn
- scenes\items\lost_shard.tscn
- scenes\levels\test_arena.gd
- scenes\levels\test_arena.tscn
- scenes\player\player.tscn
- scenes\ui\hud.tscn
- scenes\ui\level_up_screen.tscn
- scenes\world\straw_bed.tscn
- scripts\autoload\behavior_tracker.gd
- scripts\autoload\game_data.gd
- scripts\autoload\palette.gd
- scripts\autoload\player_inventory.gd
- scripts\autoload\save_manager.gd
- scripts\combat\base_enemy.gd
- scripts\combat\combat_state.gd
- scripts\combat\common_enemy_visual.gd
- scripts\combat\dummy_enemy.gd
- scripts\combat\enemy_visual.gd
- scripts\combat\hitbox_service.gd
- scripts\combat\lost_shard.gd
- scripts\combat\projectile.gd
- scripts\combat\shell_shard_pickup.gd
- scripts\combat\stats_calculator.gd
- scripts\combat\weapon_db.gd
- scripts\player\egg_visual.gd
- scripts\player\player.gd
- scripts\ui\hud.gd
- scripts\ui\level_up_screen.gd
- scripts\world\straw_bed.gd
- tools\generate_run_roll_sprites.gd
- tools\generate_run_roll_v2.gd
- tools\test_combat_stage_a.gd
- tools\test_leveling_system.gd
- tools\test_leveling_system.tscn

---

## assets\sprites\player\animations.json
```json
{
  "player_egg": {
    "frame_size": [32, 32],
    "anchor": [16, 31],
    "animations": {
      "idle_down": { "file": "player_egg_idle_down.png", "frames": 4, "fps": 8, "loop": true, "hit_frames": [] },
      "idle_up": { "file": "player_egg_idle_up.png", "frames": 4, "fps": 8, "loop": true, "hit_frames": [] },
      "idle_side": { "file": "player_egg_idle_side.png", "frames": 4, "fps": 8, "loop": true, "hit_frames": [] },
      "run_down": { "file": "player_egg_run_down.png", "frames": 6, "fps": 12, "loop": true, "hit_frames": [] },
      "run_up": { "file": "player_egg_run_up.png", "frames": 6, "fps": 12, "loop": true, "hit_frames": [] },
      "run_side": { "file": "player_egg_run_side.png", "frames": 6, "fps": 12, "loop": true, "hit_frames": [] },
      "roll_down": { "file": "player_egg_roll_down.png", "frames": 6, "fps": 12, "loop": false, "hit_frames": [] },
      "roll_up": { "file": "player_egg_roll_up.png", "frames": 6, "fps": 12, "loop": false, "hit_frames": [] },
      "roll_side": { "file": "player_egg_roll_side.png", "frames": 6, "fps": 12, "loop": false, "hit_frames": [] },
      "attack_down": { "file": "player_egg_attack_down.png", "frames": 5, "fps": 12, "loop": false, "hit_frames": [2] },
      "attack_up": { "file": "player_egg_attack_up.png", "frames": 5, "fps": 12, "loop": false, "hit_frames": [2] },
      "attack_side": { "file": "player_egg_attack_side.png", "frames": 5, "fps": 12, "loop": false, "hit_frames": [2] },
      "death_down": { "file": "player_egg_death.png", "frames": 7, "fps": 8, "loop": false, "hit_frames": [] },
      "death_up":   { "file": "player_egg_death.png", "frames": 7, "fps": 8, "loop": false, "hit_frames": [] },
      "death_side": { "file": "player_egg_death.png", "frames": 7, "fps": 8, "loop": false, "hit_frames": [] }
    }
  }
}
```

---

## data\stats.json
```json
{
  "_huong_dan": "Dữ liệu cân bằng cho Trứng và hệ thống chiến đấu ban đầu. Bạn có thể tự do điều chỉnh các chỉ số dưới đây mà không cần sửa code.",
  "base_stats": {
	"VIT": 10,
	"STR": 10,
	"DEX": 10,
	"INT": 10,
	"FAI": 10,
	"LUK": 10
  },
  "formulas": {
	"hp_base": 60,
	"hp_per_vit": 4,
	"stamina_base": 60.0,
	"stamina_per_vit": 2.0,
	"equip_capacity_base": 40.0,
	"equip_capacity_per_vit": 1.5,
	"mp_base": 20,
	"mp_per_int": 3
  },
  "player": {
	"move_speed": 95.0,
	"dodge_speed_multiplier": 1.85,
	"dodge_duration": 0.25,
	"dodge_cooldown": 0.2,
	"dodge_stamina_cost": 16.0,
	"stamina_recovery_rate": 26.0,
	"stamina_recovery_delay": 0.35,
	"collision_size": [10.0, 6.0],
	"collision_offset": [0.0, -3.0],
	"hurtbox_size": [10.0, 14.0],
	"hurtbox_offset": [0.0, -10.0],
	"attack_combo_damage": [15, 18, 28],
	"attack_cooldowns": [0.15, 0.15, 0.45],
	"combo_window": 0.55,
	"attack_stamina_costs": [8.0, 10.0, 14.0],
	"guard_damage_reduction": 0.75,
	"guard_stamina_cost_per_hit": 20.0,
	"guard_speed_multiplier": 0.45,
	"guard_break_stun_duration": 0.8,
	"guard_arc_degrees": 180.0
  },
  "dummy_enemy": {
	"max_hp": 50,
	"damage": 20,
	"telegraph_duration": 0.3,
	"attack_interval": 2.2,
	"attack_radius": 28.0
  },
  "common_enemy": {
	"max_hp": 45,
	"damage": 18,
	"move_speed": 55.0,
	"detection_radius": 140.0,
	"attack_radius": 24.0,
	"telegraph_duration": 0.35,
	"attack_active_duration": 0.15,
	"recovery_duration": 0.4,
	"stun_duration": 0.25,
	"exp_drop": 15
  },
  "debug": {
	"show_dodge_debug": false,
	"show_combat_log": true
  },
  "leveling": {
	"cost_base": 40,
	"cost_growth": 1.18
  },
  "scaling_coeff": {
	"S": 0.08,
	"A": 0.06,
	"B": 0.045,
	"C": 0.03,
	"D": 0.02,
	"E": 0.01,
	"-": 0.0
  },
  "requirement_penalty": {
	"damage_mult_per_pt": 0.05,
	"damage_min_mult": 0.5,
	"stamina_mult_per_pt": 0.04
  }
}
```

---

## data\weapons.json
```json
{
  "fist": {
    "name": "Tay Không",
    "type": "unarmed",
    "pose_set": "swing",
    "weight": 0.0,
    "base_damage": 6,
    "scaling": { "STR": "D", "DEX": "D", "INT": "-", "FAI": "-" },
    "requirements": {},
    "light_chain": [
      {
        "pose": "punch_l",
        "startup": 3,
        "active": 2,
        "recovery": 5,
        "cancel_from": 2,
        "hitbox": { "shape": "arc", "radius": 14, "angle": 90 },
        "damage_mv": 0.7,
        "stamina": 5.0,
        "poise_dmg": 4,
        "combo_window": 10
      },
      {
        "pose": "punch_r",
        "startup": 3,
        "active": 2,
        "recovery": 6,
        "cancel_from": 3,
        "hitbox": { "shape": "arc", "radius": 14, "angle": 90 },
        "damage_mv": 0.9,
        "stamina": 6.0,
        "poise_dmg": 6,
        "combo_window": 0
      }
    ],
    "heavy": {
      "pose": "punch_charge",
      "charge_min": 0.2,
      "charge_max": 0.7,
      "startup": 6,
      "active": 3,
      "recovery": 10,
      "hitbox": { "shape": "arc", "radius": 16, "angle": 90 },
      "damage_mv_min": 1.3,
      "damage_mv_max": 1.8,
      "stamina": 12.0,
      "poise_dmg": 15
    },
    "skill_slot": false,
    "two_hand_bonus": 1.0
  },
  "staff_wood": {
    "name": "Gậy Gỗ",
    "type": "staff",
    "pose_set": "swing",
    "weight": 3.0,
    "base_damage": 12,
    "scaling": { "STR": "C", "DEX": "D", "INT": "-", "FAI": "-" },
    "requirements": { "STR": 8, "DEX": 8 },
    "light_chain": [
      {
        "pose": "swing_h",
        "startup": 4,
        "active": 3,
        "recovery": 6,
        "cancel_from": 3,
        "hitbox": { "shape": "arc", "radius": 18, "angle": 120 },
        "damage_mv": 1.0,
        "stamina": 8.0,
        "poise_dmg": 10,
        "combo_window": 10
      },
      {
        "pose": "swing_h_rev",
        "startup": 4,
        "active": 3,
        "recovery": 6,
        "cancel_from": 3,
        "hitbox": { "shape": "arc", "radius": 18, "angle": 120 },
        "damage_mv": 1.0,
        "stamina": 8.0,
        "poise_dmg": 10,
        "combo_window": 10
      },
      {
        "pose": "swing_v",
        "startup": 6,
        "active": 3,
        "recovery": 12,
        "cancel_from": 8,
        "hitbox": { "shape": "arc", "radius": 20, "angle": 90 },
        "damage_mv": 1.5,
        "stamina": 12.0,
        "poise_dmg": 22,
        "combo_window": 0
      }
    ],
    "heavy": {
      "pose": "swing_v",
      "charge_min": 0.25,
      "charge_max": 0.9,
      "startup": 8,
      "active": 4,
      "recovery": 14,
      "hitbox": { "shape": "arc", "radius": 22, "angle": 100 },
      "damage_mv_min": 1.8,
      "damage_mv_max": 2.6,
      "stamina": 22.0,
      "poise_dmg": 40
    },
    "skill_slot": true,
    "two_hand_bonus": 1.35
  },
  "dagger": {
    "name": "Dao Găm",
    "type": "dagger",
    "pose_set": "thrust",
    "weight": 1.5,
    "base_damage": 9,
    "scaling": { "STR": "E", "DEX": "B", "INT": "-", "FAI": "-" },
    "requirements": { "DEX": 9 },
    "light_chain": [
      {
        "pose": "thrust_1",
        "startup": 2,
        "active": 2,
        "recovery": 4,
        "cancel_from": 2,
        "hitbox": { "shape": "arc", "radius": 14, "angle": 70 },
        "damage_mv": 0.7,
        "stamina": 4.0,
        "poise_dmg": 5,
        "combo_window": 10
      },
      {
        "pose": "thrust_2",
        "startup": 2,
        "active": 2,
        "recovery": 4,
        "cancel_from": 2,
        "hitbox": { "shape": "arc", "radius": 14, "angle": 70 },
        "damage_mv": 0.8,
        "stamina": 4.0,
        "poise_dmg": 6,
        "combo_window": 10
      },
      {
        "pose": "thrust_3",
        "startup": 3,
        "active": 3,
        "recovery": 6,
        "cancel_from": 3,
        "hitbox": { "shape": "arc", "radius": 16, "angle": 80 },
        "damage_mv": 1.2,
        "stamina": 6.0,
        "poise_dmg": 12,
        "combo_window": 0
      }
    ],
    "heavy": {
      "pose": "pierce",
      "charge_min": 0.2,
      "charge_max": 0.7,
      "startup": 5,
      "active": 3,
      "recovery": 10,
      "hitbox": { "shape": "line", "radius": 24, "angle": 45 },
      "damage_mv_min": 1.6,
      "damage_mv_max": 2.2,
      "stamina": 14.0,
      "poise_dmg": 24
    },
    "skill_slot": true,
    "two_hand_bonus": 1.2
  },
  "sling": {
    "name": "Ná",
    "type": "sling",
    "pose_set": "shoot",
    "weight": 1.2,
    "base_damage": 10,
    "scaling": { "STR": "-", "DEX": "C", "INT": "D", "FAI": "-" },
    "requirements": { "DEX": 8 },
    "light_chain": [
      {
        "pose": "shoot_quick",
        "startup": 5,
        "active": 2,
        "recovery": 7,
        "cancel_from": 4,
        "hitbox": { "shape": "projectile", "speed": 220.0, "life": 0.75, "radius": 4 },
        "damage_mv": 0.9,
        "stamina": 7.0,
        "poise_dmg": 6,
        "combo_window": 12
      },
      {
        "pose": "shoot_quick_2",
        "startup": 5,
        "active": 2,
        "recovery": 8,
        "cancel_from": 4,
        "hitbox": { "shape": "projectile", "speed": 230.0, "life": 0.75, "radius": 4 },
        "damage_mv": 1.1,
        "stamina": 8.0,
        "poise_dmg": 8,
        "combo_window": 0
      }
    ],
    "heavy": {
      "pose": "shoot_charged",
      "charge_min": 0.3,
      "charge_max": 1.0,
      "startup": 8,
      "active": 2,
      "recovery": 12,
      "hitbox": { "shape": "projectile", "speed": 300.0, "life": 1.0, "radius": 5 },
      "damage_mv_min": 1.8,
      "damage_mv_max": 2.5,
      "stamina": 16.0,
      "poise_dmg": 20
    },
    "skill_slot": true,
    "two_hand_bonus": 1.2
  }
}
```

---

## project.godot
```ini
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=5

[application]

config/name="Vỡ Vỏ"
run/main_scene="res://scenes/levels/test_arena.tscn"
config/features=PackedStringArray("4.7", "Forward Plus")
config/icon="res://icon.svg"

[autoload]

Palette="*res://scripts/autoload/palette.gd"
GameData="*res://scripts/autoload/game_data.gd"
BehaviorTracker="*res://scripts/autoload/behavior_tracker.gd"
PlayerInventory="*res://scripts/autoload/player_inventory.gd"
SaveManager="*res://scripts/autoload/save_manager.gd"

[display]

window/size/viewport_width=320
window/size/viewport_height=180
window/size/window_width_override=1280
window/size/window_height_override=720
window/stretch/mode="viewport"
window/stretch/scale_mode="integer"

[input]

move_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":65,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194319,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":13,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":0,"axis_value":-1.0,"script":null)
]
}
move_right={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":68,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194321,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":14,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":0,"axis_value":1.0,"script":null)
]
}
move_up={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":87,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194320,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":11,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":1,"axis_value":-1.0,"script":null)
]
}
move_down={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":83,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194322,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":12,"pressure":0.0,"pressed":false,"script":null)
, Object(InputEventJoypadMotion,"resource_local_to_scene":false,"resource_name":"","device":0,"axis":1,"axis_value":1.0,"script":null)
]
}
attack={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":74,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"","device":32,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"button_mask":0,"position":Vector2(0, 0),"global_position":Vector2(0, 0),"factor":1.0,"button_index":1,"canceled":false,"pressed":false,"double_click":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":2,"pressure":0.0,"pressed":false,"script":null)
]
}
dodge={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":32,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":75,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":0,"pressure":0.0,"pressed":false,"script":null)
]
}
guard={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":76,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"","device":32,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"button_mask":0,"position":Vector2(0, 0),"global_position":Vector2(0, 0),"factor":1.0,"button_index":2,"canceled":false,"pressed":false,"double_click":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":9,"pressure":0.0,"pressed":false,"script":null)
]
}
interact={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":69,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":3,"pressure":0.0,"pressed":false,"script":null)
]
}
pause={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194305,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":6,"pressure":0.0,"pressed":false,"script":null)
]
}
swap_weapon={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":81,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":11,"pressure":0.0,"pressed":false,"script":null)
]
}
skill={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":73,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":10,"pressure":0.0,"pressed":false,"script":null)
]
}
two_hand={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":4194306,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":8,"pressure":0.0,"pressed":false,"script":null)
]
}
use_item={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":82,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":14,"pressure":0.0,"pressed":false,"script":null)
]
}
cycle_item={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":16,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":90,"key_label":0,"unicode":0,"location":0,"echo":false,"script":null)
, Object(InputEventJoypadButton,"resource_local_to_scene":false,"resource_name":"","device":0,"button_index":12,"pressure":0.0,"pressed":false,"script":null)
]
}

[physics]

3d/physics_engine="Jolt Physics"

[rendering]

textures/canvas_textures/default_texture_filter=0
rendering_device/driver.windows="d3d12"
2d/snap/snap_2d_transforms_to_pixel=true
2d/snap/snap_2d_vertices_to_pixel=true
```

---

## scenes\enemies\common_enemy.tscn
```ini
[gd_scene format=3 uid="uid://da6ht4f4h0yqb"]

[ext_resource type="Script" path="res://scripts/combat/base_enemy.gd" id="1_enemy"]
[ext_resource type="Script" path="res://scripts/combat/common_enemy_visual.gd" id="2_visual"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_body"]
size = Vector2(20, 20)

[sub_resource type="CircleShape2D" id="CircleShape2D_attack"]
radius = 24.0

[node name="CommonEnemy" type="CharacterBody2D" groups=["enemies"]]
collision_layer = 1
collision_mask = 1
script = ExtResource("1_enemy")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("RectangleShape2D_body")

[node name="EnemyVisual" type="Node2D" parent="."]
script = ExtResource("2_visual")

[node name="AttackArea" type="Area2D" parent="."]
collision_layer = 0
collision_mask = 2

[node name="CollisionShape2D" type="CollisionShape2D" parent="AttackArea"]
shape = SubResource("CircleShape2D_attack")

[node name="Hurtbox" type="Area2D" parent="." groups=["enemy_hurtbox"]]
collision_layer = 16
collision_mask = 0

[node name="CollisionShape2D" type="CollisionShape2D" parent="Hurtbox"]
shape = SubResource("RectangleShape2D_body")
```

---

## scenes\enemies\dummy_enemy.tscn
```ini
[gd_scene load_steps=5 format=3 uid="uid://dmmyenemy001"]

[ext_resource type="Script" path="res://scripts/combat/dummy_enemy.gd" id="1_enemy"]
[ext_resource type="Script" path="res://scripts/combat/enemy_visual.gd" id="2_visual"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_body"]
size = Vector2(20, 20)

[sub_resource type="CircleShape2D" id="CircleShape2D_attack"]
radius = 28.0

[node name="DummyEnemy" type="CharacterBody2D" groups=["enemies"]]
collision_layer = 1
collision_mask = 1
script = ExtResource("1_enemy")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("RectangleShape2D_body")

[node name="EnemyVisual" type="Node2D" parent="."]
script = ExtResource("2_visual")

[node name="AttackArea" type="Area2D" parent="."]
collision_layer = 0
collision_mask = 2

[node name="CollisionShape2D" type="CollisionShape2D" parent="AttackArea"]
shape = SubResource("CircleShape2D_attack")

[node name="Hurtbox" type="Area2D" parent="." groups=["enemy_hurtbox"]]
collision_layer = 16
collision_mask = 0

[node name="CollisionShape2D" type="CollisionShape2D" parent="Hurtbox"]
shape = SubResource("RectangleShape2D_body")
```

---

## scenes\items\lost_shard.tscn
```ini
[gd_scene format=3 uid="uid://lostshard001"]

[ext_resource type="Script" path="res://scripts/combat/lost_shard.gd" id="1_lost"]

[sub_resource type="CircleShape2D" id="CircleShape2D_pickup"]
radius = 12.0

[node name="LostShard" type="Area2D"]
collision_layer = 0
collision_mask = 3
script = ExtResource("1_lost")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("CircleShape2D_pickup")
```

---

## scenes\levels\test_arena.gd
```gdscript
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
	
	print("[ARENA] Test arena đã sẵn sàng! Di chuyển (WASD), Lăn né (Space), Tấn công (J/Chuột trái), Đỡ (L/Chuột phải), Đổi vũ khí 3 ô (Q), Ổ Rơm lưu & lên cấp (E), F4 (+100 Mảnh Vỏ).")

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F4:
			PlayerInventory.add_shards(100)
			print("[TEST] Phím F4: Đã thêm +100 Mảnh Vỏ Vụn! Tổng: %d" % PlayerInventory.shell_shards)

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

```

---

## scenes\levels\test_arena.tscn
```ini
[gd_scene format=3 uid="uid://btestarena001"]

[ext_resource type="Script" path="res://scenes/levels/test_arena.gd" id="1_arena"]
[ext_resource type="PackedScene" path="res://scenes/player/player.tscn" id="2_player"]
[ext_resource type="PackedScene" path="res://scenes/enemies/dummy_enemy.tscn" id="3_enemy"]
[ext_resource type="PackedScene" path="res://scenes/enemies/common_enemy.tscn" id="3_common_enemy"]
[ext_resource type="PackedScene" path="res://scenes/ui/hud.tscn" id="4_hud"]
[ext_resource type="PackedScene" path="res://scenes/world/straw_bed.tscn" id="5_straw_bed"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_horiz"]
size = Vector2(480, 16)

[sub_resource type="RectangleShape2D" id="RectangleShape2D_vert"]
size = Vector2(16, 270)

[node name="TestArena" type="Node2D"]
script = ExtResource("1_arena")

[node name="Floor" type="ColorRect" parent="."]
offset_right = 480.0
offset_bottom = 270.0
color = Color(0.0784314, 0.0666667, 0.0588235, 1)

[node name="Walls" type="StaticBody2D" parent="."]
collision_layer = 1
collision_mask = 0

[node name="TopWallVisual" type="ColorRect" parent="Walls"]
offset_right = 480.0
offset_bottom = 16.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="TopCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(240, 8)
shape = SubResource("RectangleShape2D_horiz")

[node name="BottomWallVisual" type="ColorRect" parent="Walls"]
offset_top = 254.0
offset_right = 480.0
offset_bottom = 270.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="BottomCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(240, 262)
shape = SubResource("RectangleShape2D_horiz")

[node name="LeftWallVisual" type="ColorRect" parent="Walls"]
offset_right = 16.0
offset_bottom = 270.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="LeftCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(8, 135)
shape = SubResource("RectangleShape2D_vert")

[node name="RightWallVisual" type="ColorRect" parent="Walls"]
offset_left = 464.0
offset_right = 480.0
offset_bottom = 270.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="RightCollision" type="CollisionShape2D" parent="Walls"]
position = Vector2(472, 135)
shape = SubResource("RectangleShape2D_vert")

[node name="StrawBed" parent="." instance=ExtResource("5_straw_bed")]
position = Vector2(80, 135)

[node name="DummyEnemy" parent="." instance=ExtResource("3_enemy")]
position = Vector2(260, 135)

[node name="CommonEnemy" parent="." instance=ExtResource("3_common_enemy")]
position = Vector2(340, 135)

[node name="Player" parent="." instance=ExtResource("2_player")]
position = Vector2(160, 135)

[node name="Camera2D" type="Camera2D" parent="Player"]
position_smoothing_enabled = true
position_smoothing_speed = 6.0
limit_left = 0
limit_top = 0
limit_right = 480
limit_bottom = 270

[node name="HUD" parent="." instance=ExtResource("4_hud")]
```

---

## scenes\player\player.tscn
```ini
[gd_scene load_steps=6 format=3 uid="uid://df7xeggplayer01"]

[ext_resource type="Script" path="res://scripts/player/player.gd" id="1_player"]
[ext_resource type="Script" path="res://scripts/player/egg_visual.gd" id="2_visual"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_col"]
size = Vector2(10, 6)

[sub_resource type="RectangleShape2D" id="RectangleShape2D_hurt"]
size = Vector2(10, 14)

[sub_resource type="RectangleShape2D" id="RectangleShape2D_attack"]
size = Vector2(16, 16)

[node name="Player" type="CharacterBody2D" groups=["player"]]
collision_layer = 1
collision_mask = 1
script = ExtResource("1_player")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
position = Vector2(0, -3)
shape = SubResource("RectangleShape2D_col")

[node name="AnimatedSprite2D" type="AnimatedSprite2D" parent="."]

[node name="EggVisual" type="Node2D" parent="."]
script = ExtResource("2_visual")

[node name="Hurtbox" type="Area2D" parent="."]
collision_layer = 2
collision_mask = 0

[node name="CollisionShape2D" type="CollisionShape2D" parent="Hurtbox"]
position = Vector2(0, -10)
shape = SubResource("RectangleShape2D_hurt")

[node name="AttackHitbox" type="Area2D" parent="."]
collision_layer = 0
collision_mask = 16

[node name="CollisionShape2D" type="CollisionShape2D" parent="AttackHitbox"]
shape = SubResource("RectangleShape2D_attack")
```

---

## scenes\ui\hud.tscn
```ini
[gd_scene format=3 uid="uid://bvyhud001"]

[ext_resource type="Script" path="res://scripts/ui/hud.gd" id="1_hud"]

[node name="HUD" type="CanvasLayer"]
script = ExtResource("1_hud")

[node name="MarginContainer" type="MarginContainer" parent="."]
offset_left = 6.0
offset_top = 6.0
offset_right = 140.0
offset_bottom = 60.0

[node name="VBoxContainer" type="VBoxContainer" parent="MarginContainer"]
layout_mode = 2
theme_override_constants/separation = 2

[node name="HPBar" type="Control" parent="MarginContainer/VBoxContainer"]
custom_minimum_size = Vector2(64, 6)
layout_mode = 2

[node name="Background" type="ColorRect" parent="MarginContainer/VBoxContainer/HPBar"]
layout_mode = 0
offset_right = 64.0
offset_bottom = 6.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="Fill" type="ColorRect" parent="MarginContainer/VBoxContainer/HPBar"]
layout_mode = 0
offset_right = 64.0
offset_bottom = 6.0
color = Color(0.658824, 0.203922, 0.168627, 1)

[node name="StaminaBar" type="Control" parent="MarginContainer/VBoxContainer"]
custom_minimum_size = Vector2(52, 4)
layout_mode = 2

[node name="Background" type="ColorRect" parent="MarginContainer/VBoxContainer/StaminaBar"]
layout_mode = 0
offset_right = 52.0
offset_bottom = 4.0
color = Color(0.168627, 0.121569, 0.101961, 1)

[node name="Fill" type="ColorRect" parent="MarginContainer/VBoxContainer/StaminaBar"]
layout_mode = 0
offset_right = 52.0
offset_bottom = 4.0
color = Color(0.419608, 0.498039, 0.227451, 1)

[node name="WeaponHBox" type="HBoxContainer" parent="MarginContainer/VBoxContainer"]
layout_mode = 2
theme_override_constants/separation = 3

[node name="WeaponIcon" type="TextureRect" parent="MarginContainer/VBoxContainer/WeaponHBox"]
custom_minimum_size = Vector2(12, 12)
layout_mode = 2
expand_mode = 1
stretch_mode = 5

[node name="WeaponLabel" type="Label" parent="MarginContainer/VBoxContainer/WeaponHBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "[Q] Gậy Gỗ"

[node name="ShardLabel" type="Label" parent="MarginContainer/VBoxContainer"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "Cấp 1 | Mảnh Vỏ: 0"

[node name="DebugDodgeLabel" type="Label" parent="MarginContainer/VBoxContainer"]
visible = false
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "[DEBUG F3] DODGE: 0"

[node name="DeathOverlay" type="Control" parent="."]
visible = false
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="CenterContainer" type="CenterContainer" parent="DeathOverlay"]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="VBoxContainer" type="VBoxContainer" parent="DeathOverlay/CenterContainer"]
layout_mode = 2
alignment = 1

[node name="PanelBg" type="ColorRect" parent="DeathOverlay/CenterContainer/VBoxContainer"]
visible = false
custom_minimum_size = Vector2(160, 40)
layout_mode = 2
color = Color(0.168627, 0.121569, 0.101961, 0.9)

[node name="DeathLabel" type="Label" parent="DeathOverlay/CenterContainer/VBoxContainer"]
layout_mode = 2
theme_override_font_sizes/font_size = 14
text = "VỎ ĐÃ VỠ..."
horizontal_alignment = 1

[node name="SubLabel" type="Label" parent="DeathOverlay/CenterContainer/VBoxContainer"]
layout_mode = 2
theme_override_font_sizes/font_size = 8
text = "Nhấn [R] hoặc chờ hồi sinh"
horizontal_alignment = 1
```

---

## scenes\ui\level_up_screen.tscn
```ini
[gd_scene format=3 uid="uid://levelupui001"]

[ext_resource type="Script" path="res://scripts/ui/level_up_screen.gd" id="1_lvlup"]

[node name="LevelUpScreen" type="CanvasLayer"]
process_mode = 3
layer = 10
script = ExtResource("1_lvlup")

[node name="RootControl" type="Control" parent="."]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 2

[node name="PanelBg" type="ColorRect" parent="RootControl"]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -152.0
offset_top = -86.0
offset_right = 152.0
offset_bottom = 86.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 2
color = Color(0.0784314, 0.0666667, 0.0588235, 0.95)

[node name="Margin" type="MarginContainer" parent="RootControl"]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -146.0
offset_top = -82.0
offset_right = 146.0
offset_bottom = 82.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 2

[node name="VBox" type="VBoxContainer" parent="RootControl/Margin"]
layout_mode = 2
mouse_filter = 2
theme_override_constants/separation = 2

[node name="HeaderLabel" type="Label" parent="RootControl/Margin/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 8
text = "CẤP: 1 | CHI PHÍ TIẾP: 40"
horizontal_alignment = 1

[node name="ShardsLabel" type="Label" parent="RootControl/Margin/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "MẢNH VỎ VỤN: 0"
horizontal_alignment = 1

[node name="HSeparator" type="HSeparator" parent="RootControl/Margin/VBox"]
layout_mode = 2

[node name="MainHBox" type="HBoxContainer" parent="RootControl/Margin/VBox"]
layout_mode = 2
mouse_filter = 2
theme_override_constants/separation = 12

[node name="StatsVBox" type="VBoxContainer" parent="RootControl/Margin/VBox/MainHBox"]
custom_minimum_size = Vector2(136, 0)
layout_mode = 2
mouse_filter = 2
theme_override_constants/separation = 2

[node name="VSeparator" type="VSeparator" parent="RootControl/Margin/VBox/MainHBox"]
layout_mode = 2

[node name="PreviewVBox" type="VBoxContainer" parent="RootControl/Margin/VBox/MainHBox"]
custom_minimum_size = Vector2(130, 0)
layout_mode = 2
mouse_filter = 2
theme_override_constants/separation = 2

[node name="PreviewHeader" type="Label" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 8
text = "CHỈ SỐ PHÁT SINH:"

[node name="HPLabel" type="Label" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "HP: 100"

[node name="StaminaLabel" type="Label" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "Thể lực: 80.0"

[node name="CapacityLabel" type="Label" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "Sức tải: 55.0"

[node name="DamageLabel" type="Label" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "Sát thương: 12"

[node name="Spacer" type="Control" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox"]
custom_minimum_size = Vector2(0, 4)
layout_mode = 2

[node name="ButtonsHBox" type="HBoxContainer" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox"]
layout_mode = 2
mouse_filter = 2
theme_override_constants/separation = 6

[node name="BtnConfirm" type="Button" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox/ButtonsHBox"]
custom_minimum_size = Vector2(56, 14)
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "Xác nhận"

[node name="BtnCancel" type="Button" parent="RootControl/Margin/VBox/MainHBox/PreviewVBox/ButtonsHBox"]
custom_minimum_size = Vector2(50, 14)
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "Hủy bỏ"

[node name="HSeparator2" type="HSeparator" parent="RootControl/Margin/VBox"]
layout_mode = 2

[node name="FeedbackLabel" type="Label" parent="RootControl/Margin/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 7
text = "Nhấn '+' hoặc phím [D] để cộng điểm, [Enter] để xác nhận."
horizontal_alignment = 1

[node name="GuideLabel" type="Label" parent="RootControl/Margin/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 6
text = "[Lên/Xuống] Chọn   [Trái/Phải] +/-   [Enter] Xác nhận   [Esc] Hủy"
horizontal_alignment = 1
```

---

## scenes\world\straw_bed.tscn
```ini
[gd_scene format=3 uid="uid://strawbed001"]

[ext_resource type="Script" path="res://scripts/world/straw_bed.gd" id="1_bed"]

[sub_resource type="CircleShape2D" id="CircleShape2D_interact"]
radius = 24.0

[node name="StrawBed" type="Node2D"]
script = ExtResource("1_bed")

[node name="InteractionArea" type="Area2D" parent="."]
collision_layer = 0
collision_mask = 1

[node name="CollisionShape2D" type="CollisionShape2D" parent="InteractionArea"]
shape = SubResource("CircleShape2D_interact")

[node name="PromptLabel" type="Label" parent="."]
visible = false
offset_left = -60.0
offset_top = -26.0
offset_right = 60.0
offset_bottom = -14.0
theme_override_font_sizes/font_size = 8
text = "[E] Nghỉ ngơi & Lên cấp"
horizontal_alignment = 1
```

---

## scripts\autoload\behavior_tracker.gd
```gdscript
extends Node

# Autoload BehaviorTracker: 5 bộ đếm hành vi ẩn của Trứng (GDD Mục 6.1)
# GUARD, DODGE, MAGIC, EXPLORE, SUPPORT
# Dùng để quyết định nhánh tiến hóa tại các mốc mà người chơi không thấy số điểm trực tiếp.

signal points_changed(action_name: String, new_points: int, total_points: int)

const ACTION_GUARD: String = "GUARD"
const ACTION_DODGE: String = "DODGE"
const ACTION_MAGIC: String = "MAGIC"
const ACTION_EXPLORE: String = "EXPLORE"
const ACTION_SUPPORT: String = "SUPPORT"

const VALID_ACTIONS: Array[String] = [
	ACTION_GUARD,
	ACTION_DODGE,
	ACTION_MAGIC,
	ACTION_EXPLORE,
	ACTION_SUPPORT
]

var _counters: Dictionary = {
	ACTION_GUARD: 0,
	ACTION_DODGE: 0,
	ACTION_MAGIC: 0,
	ACTION_EXPLORE: 0,
	ACTION_SUPPORT: 0
}

func add_points(action_name: String, points: int) -> void:
	if not _counters.has(action_name):
		push_warning("BehaviorTracker: Hành động không hợp lệ: " + action_name)
		return
	if points <= 0:
		return
	_counters[action_name] += points
	var total: int = get_total_points()
	points_changed.emit(action_name, _counters[action_name], total)
	print("[BehaviorTracker] +%d %s (Hiện tại: %d, Tổng: %d)" % [points, action_name, _counters[action_name], total])

func get_points(action_name: String) -> int:
	return _counters.get(action_name, 0)

func get_total_points() -> int:
	var total: int = 0
	for key in _counters:
		total += int(_counters[key])
	return total

func get_ratios() -> Dictionary:
	var total: int = get_total_points()
	var ratios: Dictionary = {}
	for key in _counters:
		if total > 0:
			ratios[key] = float(_counters[key]) / float(total)
		else:
			ratios[key] = 0.0
	return ratios

func reset() -> void:
	for key in _counters:
		_counters[key] = 0

func export_data() -> Dictionary:
	return _counters.duplicate()

func import_data(data: Dictionary) -> void:
	for action_name in VALID_ACTIONS:
		if data.has(action_name):
			_counters[action_name] = int(data[action_name])
```

---

## scripts\autoload\game_data.gd
```gdscript
extends Node

# Autoload GameData: Quản lý nạp toàn bộ file cấu hình JSON trong thư mục data/
# Đảm bảo không hard-code bất kỳ chỉ số cân bằng nào vào mã nguồn.

var stats: Dictionary = {}
var weapons: Dictionary = {}

func _ready() -> void:
	load_all_data()

func load_all_data() -> void:
	stats = load_json_file("res://data/stats.json")
	if stats.is_empty():
		push_error("GameData: Không thể nạp dữ liệu từ stats.json!")
	else:
		print("GameData: Nạp thành công stats.json.")
	
	weapons = load_json_file("res://data/weapons.json")
	if weapons.is_empty():
		push_error("GameData: Không thể nạp dữ liệu từ weapons.json!")
	else:
		print("GameData: Nạp thành công weapons.json (%d loại vũ khí)." % weapons.size())

func load_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("GameData: Không tìm thấy file JSON tại " + path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("GameData: Không thể mở file " + path)
		return {}
	var content := file.get_as_text()
	var json := JSON.new()
	var parse_result := json.parse(content)
	if parse_result != OK:
		push_error("GameData: Lỗi parse JSON tại %s (dòng %d): %s" % [path, json.get_error_line(), json.get_error_message()])
		return {}
	if json.data is Dictionary:
		return json.data
	push_warning("GameData: Dữ liệu JSON trong %s không phải là Dictionary!" % path)
	return {}

func get_stat(category: String, key: String, default_value: Variant = null) -> Variant:
	if stats.has(category) and stats[category] is Dictionary and stats[category].has(key):
		return stats[category][key]
	return default_value

func get_category(category: String, default_value: Dictionary = {}) -> Dictionary:
	if stats.has(category) and stats[category] is Dictionary:
		return stats[category]
	return default_value

func get_weapon(weapon_id: String) -> Dictionary:
	if weapons.has(weapon_id) and weapons[weapon_id] is Dictionary:
		return weapons[weapon_id]
	return {}

func get_all_weapons() -> Dictionary:
	return weapons
```

---

## scripts\autoload\palette.gd
```gdscript
extends Node

# Bảng màu trung cổ (16 màu cố định theo GDD Mục 3)
# Toàn bộ màu sắc trong game bắt buộc phải tham chiếu từ Palette này.
const DEN_THAN: Color = Color("#14110F")      # 1. Bóng sâu nhất, nền hầm ngục tối, hố đen
const NAU_HAM: Color = Color("#2B1F1A")       # 2. Viền ngoài mọi sprite, tường hầm
const XAM_SAT: Color = Color("#4A4A52")       # 3. Giáp, kim loại, đá tối
const XAM_DA: Color = Color("#7C7C80")        # 4. Đá sáng, vũ khí, lưỡi kiếm
const NAU_GO: Color = Color("#6B4423")        # 5. Gỗ, cửa, cán vũ khí, đất tối
const NAU_DA: Color = Color("#A0693B")        # 6. Da thuộc, đất, rơm đậm
const CAT: Color = Color("#D4A86A")           # 7. Rơm, cát, bóng đổ trên vỏ trứng
const GIAY_DA: Color = Color("#E8D9B0")       # 8. Vỏ trứng (màu chính), giấy, xương
const KEM: Color = Color("#F4EBD0")           # 9. Điểm sáng nhất, vùng ánh sáng trên vỏ trứng
const DO_RUOU: Color = Color("#6E1423")       # 10. Vải quý tộc, máu khô, boss tối
const DO_GACH: Color = Color("#A8342B")       # 11. Lửa nhẹ, cờ hiệu, cảnh báo sát thương, thanh HP
const XANH_REU: Color = Color("#3B4A2A")      # 12. Cỏ, lá, đầm lầy, rừng
const XANH_LA_UA: Color = Color("#6B7F3A")    # 13. Cỏ sáng, độc nhẹ, đồ vật tự nhiên, thanh Stamina
const VANG_CO: Color = Color("#C79A2E")       # 14. Vàng đồng, chữ khắc, vật phẩm hiếm, Mảnh Vỏ
const XANH_THEP: Color = Color("#2F4A63")     # 15. Nước, sương, đêm, phép băng/lòng trắng
const TIM_MUC: Color = Color("#5A3A5E")       # 16. Mục Rữa, phép hắc ám
```

---

## scripts\autoload\player_inventory.gd
```gdscript
extends Node

# PlayerInventory: Autoload quản lý tiền tệ Mảnh Vỏ Vụn (EXP) và chỉ số nhân vật
# Đáp ứng COMBAT_SPEC mục 9: Lên cấp tự cộng điểm, tính chi phí và lưu trữ dữ liệu.

signal shards_changed(new_amount: int)
signal stats_changed()

var shell_shards: int = 0
var base_stats: Dictionary = {
	"VIT": 10,
	"STR": 10,
	"DEX": 10,
	"INT": 10,
	"FAI": 10,
	"LUK": 10
}
var added_points: Dictionary = {
	"VIT": 0,
	"STR": 0,
	"DEX": 0,
	"INT": 0,
	"FAI": 0,
	"LUK": 0
}
var total_added_points: int = 0
var level: int = 1

func _ready() -> void:
	_init_stats()

func _init_stats() -> void:
	var stats_data = GameData.get_category("base_stats", {})
	if not stats_data.is_empty():
		for s in stats_data:
			base_stats[s] = int(stats_data[s])
	
	for s in ["VIT", "STR", "DEX", "INT", "FAI", "LUK"]:
		if not base_stats.has(s):
			base_stats[s] = int(GameData.get_stat("base_stats", s, 10))
		if not added_points.has(s):
			added_points[s] = 0
	
	_recalculate_level()

func _recalculate_level() -> void:
	total_added_points = 0
	for s in added_points:
		total_added_points += int(added_points[s])
	level = StatsCalc.calc_level(total_added_points)

func add_shards(amount: int) -> void:
	if amount <= 0:
		return
	shell_shards += amount
	print("[INVENTORY] Nhận được %d Mảnh Vỏ Vụn (Hiện có: %d)" % [amount, shell_shards])
	shards_changed.emit(shell_shards)

func spend_shards(amount: int) -> bool:
	if amount < 0 or shell_shards < amount:
		return false
	shell_shards -= amount
	shards_changed.emit(shell_shards)
	return true

func spend_all_shards() -> int:
	var dropped: int = shell_shards
	shell_shards = 0
	shards_changed.emit(shell_shards)
	return dropped

func get_effective_stats() -> Dictionary:
	var effective: Dictionary = {}
	for s in base_stats:
		effective[s] = int(base_stats[s]) + int(added_points.get(s, 0))
	return effective

func can_level_up() -> bool:
	return shell_shards >= get_level_cost()

func get_level_cost() -> int:
	return StatsCalc.calc_level_cost(level)

func get_cost_for_next_level(level_offset: int) -> int:
	return StatsCalc.calc_level_cost(level + level_offset)

func apply_stat_point(stat_name: String) -> bool:
	if not base_stats.has(stat_name):
		return false
	var cost: int = get_level_cost()
	if not spend_shards(cost):
		return false
	
	added_points[stat_name] = int(added_points.get(stat_name, 0)) + 1
	_recalculate_level()
	print("[INVENTORY] Lên cấp %d! Điểm cộng vào %s (Tổng %s: %d)" % [
		level, stat_name, stat_name, int(base_stats[stat_name]) + int(added_points[stat_name])
	])
	stats_changed.emit()
	return true

func apply_multiple_stats(pending_adds: Dictionary) -> bool:
	var total_new_pts: int = 0
	for s in pending_adds:
		total_new_pts += maxi(0, int(pending_adds[s]))
	
	if total_new_pts <= 0:
		return true
	
	var total_cost: int = 0
	for i in range(total_new_pts):
		total_cost += StatsCalc.calc_level_cost(level + i)
	
	if shell_shards < total_cost:
		print("[INVENTORY] Không đủ Mảnh Vỏ Vụn để nâng cấp! Cần %d, có %d" % [total_cost, shell_shards])
		return false
	
	shell_shards -= total_cost
	for s in pending_adds:
		var pts: int = maxi(0, int(pending_adds[s]))
		if pts > 0:
			added_points[s] = int(added_points.get(s, 0)) + pts
	
	_recalculate_level()
	print("[INVENTORY] Đã nâng thành công %d điểm! Cấp hiện tại: %d, Mảnh Vỏ còn lại: %d" % [
		total_new_pts, level, shell_shards
	])
	shards_changed.emit(shell_shards)
	stats_changed.emit()
	return true

func export_data() -> Dictionary:
	return {
		"shell_shards": shell_shards,
		"added_points": added_points.duplicate(),
		"total_added_points": total_added_points,
		"level": level
	}

func import_data(data: Dictionary) -> void:
	if data.has("shell_shards"):
		shell_shards = int(data["shell_shards"])
	if data.has("added_points") and data["added_points"] is Dictionary:
		for s in data["added_points"]:
			added_points[s] = int(data["added_points"][s])
	_recalculate_level()
	shards_changed.emit(shell_shards)
	stats_changed.emit()
	print("[INVENTORY] Đã tải dữ liệu Inventory: Cấp %d, %d Mảnh Vỏ." % [level, shell_shards])
```

---

## scripts\autoload\save_manager.gd
```gdscript
extends Node

# Autoload SaveManager: Nơi DUY NHẤT được ghi file save vào user://
# Đảm bảo lưu/tải an toàn toàn bộ tiến trình người chơi và 5 bộ đếm hành vi dưới dạng JSON.

const SAVE_PATH: String = "user://savegame.json"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(extra_data: Dictionary = {}) -> bool:
	var inv_data: Dictionary = {}
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_method("export_data"):
			inv_data = inv.export_data()
	
	var save_dict: Dictionary = {
		"version": 1,
		"timestamp": Time.get_unix_time_from_system(),
		"behavior_counters": BehaviorTracker.export_data(),
		"player_inventory": inv_data,
		"extra": extra_data
	}
	
	var json_str := JSON.stringify(save_dict, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		var err := FileAccess.get_open_error()
		push_error("SaveManager: Lỗi khi mở file save để ghi: %d" % err)
		return false
	
	file.store_string(json_str)
	file.close()
	print("SaveManager: Đã lưu game thành công vào " + SAVE_PATH)
	return true

func load_game() -> Dictionary:
	if not has_save():
		print("SaveManager: Chưa có file save tại " + SAVE_PATH)
		return {}
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: Không thể mở file save để đọc")
		return {}
	
	var content := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var err := json.parse(content)
	if err != OK:
		push_error("SaveManager: Lỗi parse file save: %s" % json.get_error_message())
		return {}
	
	var data = json.data
	if not data is Dictionary:
		push_error("SaveManager: Nội dung file save không hợp lệ")
		return {}
	
	if data.has("behavior_counters") and data["behavior_counters"] is Dictionary:
		BehaviorTracker.import_data(data["behavior_counters"])
	
	if data.has("player_inventory") and data["player_inventory"] is Dictionary:
		var root = Engine.get_main_loop()
		if root != null and root.root != null:
			var inv = root.root.get_node_or_null("PlayerInventory")
			if inv != null and inv.has_method("import_data"):
				inv.import_data(data["player_inventory"])
	
	print("SaveManager: Đã nạp dữ liệu save thành công.")
	return data

func delete_save() -> bool:
	if has_save():
		var err := DirAccess.remove_absolute(SAVE_PATH)
		return err == OK
	return true
```

---

## scripts\combat\base_enemy.gd
```gdscript
extends CharacterBody2D
class_name BaseEnemy

# BaseEnemy: Lớp cơ sở cho toàn bộ kẻ thù trong "Vỡ Vỏ" (bao gồm Quạ Gác Tổ sau này)
# Các trạng thái:
# - IDLE: Chờ / quan sát
# - CHASE: Đuổi theo người chơi khi trong bán kính phát hiện
# - TELEGRAPH: Dừng lại, nhấp nháy Đỏ Gạch (DO_GACH) báo trước đòn đánh
# - ATTACK: Kích hoạt vùng sát thương
# - RECOVERY: Hồi chiêu sau đòn đánh
# - STUNNED: Choáng khi bị Player tấn công trúng
# - DEAD: Chết, rơi Mảnh Vỏ Vụn (EXP) và biến mất

enum State { IDLE, CHASE, TELEGRAPH, ATTACK, RECOVERY, STUNNED, DEAD }

@export var enemy_id: String = "common_enemy"

@onready var visual_node: Node2D = $EnemyVisual
@onready var attack_area: Area2D = $AttackArea
@onready var hurtbox_area: Area2D = $Hurtbox

var max_hp: int = 45
var current_hp: int = 45
var damage: int = 18
var move_speed: float = 55.0
var detection_radius: float = 140.0
var attack_radius: float = 24.0

var telegraph_duration: float = 0.35
var attack_active_duration: float = 0.15
var recovery_duration: float = 0.4
var stun_duration: float = 0.25
var exp_drop: int = 15

var current_state: State = State.IDLE
var state_timer: float = 0.0
var flash_timer: float = 0.0
var hurt_flash_timer: float = 0.0
var is_flashing_red: bool = false
var has_resolved_player_this_attack: bool = false

var target_player: CharacterBody2D = null

func _ready() -> void:
	load_stats()
	current_hp = max_hp
	current_state = State.IDLE
	state_timer = 0.5
	find_player()

func load_stats() -> void:
	max_hp = int(GameData.get_stat(enemy_id, "max_hp", 45))
	damage = int(GameData.get_stat(enemy_id, "damage", 18))
	move_speed = float(GameData.get_stat(enemy_id, "move_speed", 55.0))
	detection_radius = float(GameData.get_stat(enemy_id, "detection_radius", 140.0))
	attack_radius = float(GameData.get_stat(enemy_id, "attack_radius", 24.0))
	telegraph_duration = float(GameData.get_stat(enemy_id, "telegraph_duration", 0.35))
	attack_active_duration = float(GameData.get_stat(enemy_id, "attack_active_duration", 0.15))
	recovery_duration = float(GameData.get_stat(enemy_id, "recovery_duration", 0.4))
	stun_duration = float(GameData.get_stat(enemy_id, "stun_duration", 0.25))
	exp_drop = int(GameData.get_stat(enemy_id, "exp_drop", 15))

func find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		target_player = players[0]

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	if target_player == null or not is_instance_valid(target_player):
		find_player()
	
	state_timer -= delta
	
	if hurt_flash_timer > 0.0:
		hurt_flash_timer -= delta
		if hurt_flash_timer <= 0.0:
			modulate = Color.WHITE
	
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			move_and_slide()
			if target_player != null:
				var dist: float = global_position.distance_to(target_player.global_position)
				if dist <= detection_radius:
					start_chase()
		
		State.CHASE:
			if target_player == null:
				start_idle()
				return
			
			var dist: float = global_position.distance_to(target_player.global_position)
			if dist <= attack_radius:
				start_telegraph()
			elif dist > detection_radius * 1.3:
				start_idle()
			else:
				var dir: Vector2 = (target_player.global_position - global_position).normalized()
				velocity = dir * move_speed
				move_and_slide()
		
		State.TELEGRAPH:
			velocity = Vector2.ZERO
			move_and_slide()
			process_telegraph_flash(delta)
			if state_timer <= 0.0:
				execute_attack()
		
		State.ATTACK:
			velocity = Vector2.ZERO
			move_and_slide()
			check_attack_hitbox()
			if state_timer <= 0.0:
				end_attack()
		
		State.RECOVERY:
			velocity = Vector2.ZERO
			move_and_slide()
			if state_timer <= 0.0:
				start_chase()
		
		State.STUNNED:
			velocity = Vector2.ZERO
			move_and_slide()
			if state_timer <= 0.0:
				start_chase()

func start_idle() -> void:
	current_state = State.IDLE
	state_timer = 0.5
	is_flashing_red = false
	if visual_node != null:
		visual_node.queue_redraw()

func start_chase() -> void:
	current_state = State.CHASE
	is_flashing_red = false
	if visual_node != null:
		visual_node.queue_redraw()

func start_telegraph() -> void:
	current_state = State.TELEGRAPH
	state_timer = telegraph_duration
	flash_timer = 0.0
	is_flashing_red = true
	if visual_node != null:
		visual_node.queue_redraw()

func process_telegraph_flash(delta: float) -> void:
	flash_timer += delta
	if flash_timer >= 0.07:
		flash_timer = 0.0
		is_flashing_red = not is_flashing_red
		if visual_node != null:
			visual_node.queue_redraw()

func execute_attack() -> void:
	current_state = State.ATTACK
	state_timer = attack_active_duration
	has_resolved_player_this_attack = false
	is_flashing_red = true
	if visual_node != null:
		visual_node.queue_redraw()
	print("[%s] Tung đòn tấn công! Sát thương: %d" % [name, damage])
	check_attack_hitbox()

func check_attack_hitbox() -> void:
	if has_resolved_player_this_attack:
		return
	
	if attack_area == null:
		return
	
	var overlapping_areas := attack_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.name == "Hurtbox":
			var parent: Node = area.get_parent()
			if parent != null and parent.has_method("receive_hit") and parent != self:
				has_resolved_player_this_attack = true
				parent.receive_hit(damage, self)
				break

func end_attack() -> void:
	current_state = State.RECOVERY
	state_timer = recovery_duration
	is_flashing_red = false
	if visual_node != null:
		visual_node.queue_redraw()

func receive_hit(amount: int, attack_source: Node) -> Dictionary:
	if current_state == State.DEAD:
		return {"hit": false, "damage": 0}
	
	current_hp = maxi(0, current_hp - amount)
	print("[%s] Bị đánh trúng! Nhận %d sát thương (HP còn: %d/%d)" % [name, amount, current_hp, max_hp])
	
	modulate = Palette.KEM
	hurt_flash_timer = 0.15
	
	# Bị đẩy lùi nhẹ nếu có hướng nguồn đánh
	if attack_source != null and "global_position" in attack_source:
		var knockback_dir: Vector2 = (global_position - attack_source.global_position).normalized()
		velocity = knockback_dir * 80.0
		move_and_slide()
	
	if current_hp <= 0:
		die()
		return {"hit": true, "damage": amount, "killed": true}
	else:
		# Choáng ngắn (Stun) khi bị trúng đòn
		current_state = State.STUNNED
		state_timer = stun_duration
		is_flashing_red = false
		if visual_node != null:
			visual_node.queue_redraw()
	
	return {"hit": true, "damage": amount, "killed": false}

func die() -> void:
	current_state = State.DEAD
	velocity = Vector2.ZERO
	is_flashing_red = false
	print("[%s] Đã bị tiêu diệt! Rơi %d Mảnh Vỏ Vụn." % [name, exp_drop])
	
	# Tạo vật phẩm nhặt EXP tại chỗ chết
	spawn_exp_drop()
	queue_free()

func spawn_exp_drop() -> void:
	var pickup := Area2D.new()
	pickup.set_script(load("res://scripts/combat/shell_shard_pickup.gd"))
	pickup.set("shard_amount", exp_drop)
	pickup.global_position = global_position
	
	var col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0
	col.shape = circle
	pickup.add_child(col)
	
	get_parent().call_deferred("add_child", pickup)
```

---

## scripts\combat\combat_state.gd
```gdscript
extends RefCounted
class_name CombatState

# CombatState: Quản lý trạng thái và chu kỳ đòn đánh của nhân vật
# Hỗ trợ FSM trạng thái: IDLE, MOVE, ATTACK_STARTUP, ATTACK_ACTIVE, ATTACK_RECOVERY, DODGING, GUARDING, STUNNED, DEAD
# Quản lý 3 pha logic 60 FPS: startup -> active -> recovery (với cancel_from)

enum State {
	IDLE,
	MOVE,
	ATTACKING,
	ATTACK_STARTUP,
	ATTACK_ACTIVE,
	ATTACK_RECOVERY,
	DODGING,
	GUARDING,
	STUNNED,
	DEAD
}

enum AttackPhase {
	NONE,
	STARTUP,
	ACTIVE,
	RECOVERY
}

var current_state: State = State.IDLE
var attack_phase: AttackPhase = AttackPhase.NONE

var combo_step: int = 0
var attack_frame: int = 0
var combo_window_frames: int = 0
var combo_buffered: bool = false

var is_in_hit_frame: bool = false
var already_hit_enemies: Array[Node] = []

var attack_cooldown_timer: float = 0.0
var combo_window_timer: float = 0.0
var stun_timer: float = 0.0

func is_attacking() -> bool:
	return attack_phase != AttackPhase.NONE or current_state == State.ATTACKING or \
		current_state == State.ATTACK_STARTUP or current_state == State.ATTACK_ACTIVE or \
		current_state == State.ATTACK_RECOVERY

func can_cancel_to_dodge(cancel_from: int) -> bool:
	# Chỉ được hủy sang né khi đang ở pha recovery và đã qua khung cancel_from
	return attack_phase == AttackPhase.RECOVERY and attack_frame >= cancel_from

func can_chain_combo(cancel_from: int) -> bool:
	# Cho phép nối chuỗi combo từ khung cancel_from của pha recovery
	return attack_phase == AttackPhase.RECOVERY and attack_frame >= cancel_from

func reset_combo() -> void:
	combo_step = 0
	attack_phase = AttackPhase.NONE
	attack_frame = 0
	combo_window_frames = 0
	combo_buffered = false
	is_in_hit_frame = false
	combo_window_timer = 0.0
	already_hit_enemies.clear()

func process_timers(delta: float, attacking_flag: bool) -> void:
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
	
	if combo_window_timer > 0.0:
		combo_window_timer -= delta
		if combo_window_timer <= 0.0 and not attacking_flag:
			combo_step = 0
	
	if stun_timer > 0.0:
		stun_timer -= delta
		if stun_timer <= 0.0 and current_state == State.STUNNED:
			current_state = State.IDLE
```

---

## scripts\combat\common_enemy_visual.gd
```gdscript
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
```

---

## scripts\combat\dummy_enemy.gd
```gdscript
extends CharacterBody2D

# Kẻ thù giả để kiểm tra né đòn và nhận sát thương.
# Tuân thủ:
# - Báo hiệu nhấp nháy Đỏ Gạch (DO_GACH) đúng 0.3 giây trước khi gây sát thương (GDD Mục 3 & 7)
# - Chỉ cộng DODGE tối đa 1 lần cho mỗi lượt tung đòn (Quy tắc điều chỉnh #3)
# - Số liệu cân bằng lấy từ data/stats.json
# - Màu sắc 100% từ Palette

enum State { IDLE, TELEGRAPH, ATTACK, RECOVERY }

@onready var visual_node: Node2D = $EnemyVisual
@onready var attack_area: Area2D = $AttackArea

var max_hp: int = 50
var current_hp: int = 50
var damage: int = 20
var telegraph_duration: float = 0.3
var attack_interval: float = 2.2
var attack_radius: float = 28.0

var current_state: State = State.IDLE
var state_timer: float = 0.0
var flash_timer: float = 0.0
var hurt_flash_timer: float = 0.0
var is_flashing_red: bool = false

# Đảm bảo mỗi lượt vung đòn chỉ tương tác với người chơi đúng 1 lần (Quy tắc điều chỉnh #3)
var has_resolved_player_this_attack: bool = false
var attack_active_duration: float = 0.15

func _ready() -> void:
	load_stats()
	current_hp = max_hp
	state_timer = attack_interval - telegraph_duration
	current_state = State.IDLE

func load_stats() -> void:
	max_hp = int(GameData.get_stat("dummy_enemy", "max_hp", 50))
	damage = int(GameData.get_stat("dummy_enemy", "damage", 20))
	telegraph_duration = float(GameData.get_stat("dummy_enemy", "telegraph_duration", 0.3))
	attack_interval = float(GameData.get_stat("dummy_enemy", "attack_interval", 2.2))
	attack_radius = float(GameData.get_stat("dummy_enemy", "attack_radius", 28.0))

func _physics_process(delta: float) -> void:
	state_timer -= delta
	
	if hurt_flash_timer > 0.0:
		hurt_flash_timer -= delta
		if hurt_flash_timer <= 0.0:
			modulate = Color.WHITE
	
	match current_state:
		State.IDLE:
			if state_timer <= 0.0:
				start_telegraph()
		
		State.TELEGRAPH:
			process_telegraph_flash(delta)
			if state_timer <= 0.0:
				execute_attack()
		
		State.ATTACK:
			check_attack_hitbox()
			if state_timer <= 0.0:
				end_attack()
		
		State.RECOVERY:
			if state_timer <= 0.0:
				start_idle()

func start_telegraph() -> void:
	current_state = State.TELEGRAPH
	state_timer = telegraph_duration
	flash_timer = 0.0
	is_flashing_red = true
	visual_node.queue_redraw()

func process_telegraph_flash(delta: float) -> void:
	flash_timer += delta
	# Nhấp nháy tần số nhanh (0.07s) bằng màu Đỏ Gạch
	if flash_timer >= 0.07:
		flash_timer = 0.0
		is_flashing_red = not is_flashing_red
		visual_node.queue_redraw()

func execute_attack() -> void:
	current_state = State.ATTACK
	state_timer = attack_active_duration
	has_resolved_player_this_attack = false
	is_flashing_red = true
	visual_node.queue_redraw()
	print("[ENEMY] Tung đòn tấn công! (Sát thương: %d, Bán kính: %.1f)" % [damage, attack_radius])
	check_attack_hitbox()

func check_attack_hitbox() -> void:
	# Nếu đợt vung đòn này đã giải quyết với Player rồi thì bỏ qua (Quy tắc #3)
	if has_resolved_player_this_attack:
		return
	
	var overlapping_areas := attack_area.get_overlapping_areas()
	for area in overlapping_areas:
		# Chỉ kiểm tra va chạm với Hurtbox, không tương tác với thân vật lý
		if area.name == "Hurtbox":
			var parent: Node = area.get_parent()
			if parent != null and parent.has_method("receive_hit"):
				has_resolved_player_this_attack = true
				parent.receive_hit(damage, self)
				break

func end_attack() -> void:
	current_state = State.RECOVERY
	state_timer = 0.3
	is_flashing_red = false
	visual_node.queue_redraw()

func start_idle() -> void:
	current_state = State.IDLE
	state_timer = maxf(0.5, attack_interval - telegraph_duration - 0.3)
	is_flashing_red = false
	visual_node.queue_redraw()

func receive_hit(amount: int, _attack_source: Node) -> Dictionary:
	current_hp = maxi(0, current_hp - amount)
	print("[ENEMY] Nhận %d sát thương từ Player! HP còn: %d/%d" % [amount, current_hp, max_hp])
	modulate = Palette.KEM
	hurt_flash_timer = 0.15
	if current_hp <= 0:
		print("[ENEMY] Kẻ thù bị tiêu diệt! Rơi 30 Mảnh Vỏ Vụn & tự động hồi phục.")
		spawn_exp_drop()
		current_hp = max_hp
	return {"hit": true, "damage": amount}

func spawn_exp_drop() -> void:
	var pickup := Area2D.new()
	pickup.set_script(load("res://scripts/combat/shell_shard_pickup.gd"))
	pickup.set("shard_amount", 30)
	pickup.global_position = global_position + Vector2(randf_range(-6.0, 6.0), randf_range(-6.0, 6.0))
	
	var col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0
	col.shape = circle
	pickup.add_child(col)
	
	get_parent().call_deferred("add_child", pickup)

```

---

## scripts\combat\enemy_visual.gd
```gdscript
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
```

---

## scripts\combat\hitbox_service.gd
```gdscript
extends Node
class_name HitboxService

# HitboxService: Quản lý vị trí, kích thước, hình dạng và kích hoạt vùng va chạm tấn công
# Hỗ trợ các hình dạng theo COMBAT_SPEC: arc (cung), rect (chữ nhật), line (đường đâm), projectile (đạn bay)
# Định vị và lật theo facing_direction và flip_h

const ProjectileScript = preload("res://scripts/combat/projectile.gd")

static func update_attack_hitbox_position(hitbox: Area2D, dir_suffix: String, flip_left: bool) -> void:
	if hitbox == null:
		return
	
	match dir_suffix:
		"down":
			hitbox.position = Vector2(0, 6)
		"up":
			hitbox.position = Vector2(0, -24)
		"side":
			if flip_left:
				hitbox.position = Vector2(-16, -10)
			else:
				hitbox.position = Vector2(16, -10)

static func configure_hitbox(hitbox: Area2D, hitbox_spec: Dictionary, dir_suffix: String, flip_left: bool, facing_dir: Vector2 = Vector2.ZERO) -> void:
	if hitbox == null:
		return
	
	var shape_type: String = str(hitbox_spec.get("shape", "arc"))
	var radius: float = float(hitbox_spec.get("radius", 18.0))
	var shape_owner: CollisionShape2D = null
	for child in hitbox.get_children():
		if child is CollisionShape2D:
			shape_owner = child
			break
	if shape_owner == null:
		shape_owner = hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D
	
	match shape_type:
		"line":
			# Đường đâm thẳng dài và hẹp theo hướng nhìn
			var reach: float = float(hitbox_spec.get("reach", radius * 1.3))
			var thickness: float = float(hitbox_spec.get("thickness", 8.0))
			match dir_suffix:
				"down":
					hitbox.position = Vector2(0, reach * 0.5)
					if shape_owner != null:
						var rect := RectangleShape2D.new()
						rect.size = Vector2(thickness, reach)
						shape_owner.shape = rect
				"up":
					hitbox.position = Vector2(0, -reach * 0.9)
					if shape_owner != null:
						var rect := RectangleShape2D.new()
						rect.size = Vector2(thickness, reach)
						shape_owner.shape = rect
				"side":
					var offset_x: float = -reach * 0.6 if flip_left else reach * 0.6
					hitbox.position = Vector2(offset_x, -10)
					if shape_owner != null:
						var rect := RectangleShape2D.new()
						rect.size = Vector2(reach, thickness)
						shape_owner.shape = rect
		
		"rect":
			# Vùng va chạm hình chữ nhật cố định
			var sz: Array = hitbox_spec.get("size", [radius * 1.2, radius * 1.2])
			var w: float = float(sz[0])
			var h: float = float(sz[1]) if sz.size() > 1 else w
			match dir_suffix:
				"down":
					hitbox.position = Vector2(0, h * 0.4)
				"up":
					hitbox.position = Vector2(0, -h * 0.9)
				"side":
					hitbox.position = Vector2(-w * 0.7 if flip_left else w * 0.7, -10)
			if shape_owner != null:
				var rect := RectangleShape2D.new()
				rect.size = Vector2(w, h)
				shape_owner.shape = rect
				
		"arc", _:
			# Cung quét vung vũ khí cận chiến
			match dir_suffix:
				"down":
					hitbox.position = Vector2(0, maxf(6.0, radius * 0.4))
				"up":
					hitbox.position = Vector2(0, -maxf(20.0, radius * 1.1))
				"side":
					if flip_left:
						hitbox.position = Vector2(-maxf(14.0, radius * 0.9), -10)
					else:
						hitbox.position = Vector2(maxf(14.0, radius * 0.9), -10)
			
			if shape_owner != null:
				var circle := CircleShape2D.new()
				circle.radius = radius
				shape_owner.shape = circle

static func spawn_projectile(parent: Node, hitbox_spec: Dictionary, facing_dir: Vector2, spawn_pos: Vector2, attacker: Node, damage: int) -> Area2D:
	if parent == null:
		return null
	var proj: Area2D = ProjectileScript.new()
	var spd: float = float(hitbox_spec.get("speed", 220.0))
	var life: float = float(hitbox_spec.get("life", 0.75))
	var rad: float = float(hitbox_spec.get("radius", 3.0))
	proj.setup(facing_dir, spd, damage, life, attacker, rad)
	proj.global_position = spawn_pos
	parent.add_child(proj)
	return proj

static func deactivate_hitbox(hitbox: Area2D) -> void:
	if hitbox != null:
		hitbox.monitoring = false

static func check_and_process_overlaps(hitbox: Area2D, attacker: Node, damage: int, already_hit: Array[Node], on_hit_callback: Callable = Callable()) -> void:
	if hitbox == null or not hitbox.monitoring:
		return
	
	var areas := hitbox.get_overlapping_areas()
	for area in areas:
		process_single_target(area, attacker, damage, already_hit, on_hit_callback)

static func process_single_target(area: Area2D, attacker: Node, damage: int, already_hit: Array[Node], on_hit_callback: Callable = Callable()) -> void:
	var target: Node = area.get_parent()
	if target != null and target != attacker and not target in already_hit:
		if target.has_method("receive_hit"):
			already_hit.append(target)
			var res: Dictionary = target.receive_hit(damage, attacker)
			if on_hit_callback.is_valid():
				on_hit_callback.call(target, damage, res)
```

---

## scripts\combat\lost_shard.gd
```gdscript
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
	
	# Cộng nhẹ điểm EXPLORE
	var bt = root.root.get_node_or_null("BehaviorTracker")
	if bt != null:
		bt.add_points(bt.ACTION_EXPLORE, 3)
	
	queue_free()
```

---

## scripts\combat\projectile.gd
```gdscript
extends Area2D
class_name Projectile

# Projectile: Đạn bắn tầm xa (dùng cho Ná - Sling, phép thuật...)
# Bay theo hướng xác định, va chạm Hurtbox kẻ thù (Layer 16)
# Khi trúng đích: gây sát thương, cộng +2 điểm MAGIC cho BehaviorTracker

var direction: Vector2 = Vector2.DOWN
var speed: float = 220.0
var damage: int = 10
var lifetime: float = 0.8
var attacker: Node = null
var radius: float = 3.0

var _traveled_time: float = 0.0

func setup(p_direction: Vector2, p_speed: float, p_damage: int, p_lifetime: float, p_attacker: Node, p_radius: float = 3.0) -> void:
	direction = p_direction.normalized()
	speed = p_speed
	damage = p_damage
	lifetime = p_lifetime
	attacker = p_attacker
	radius = p_radius

func _ready() -> void:
	collision_layer = 0
	collision_mask = 16 # Lớp Hurtbox của kẻ thù
	monitoring = true
	monitorable = false
	
	area_entered.connect(_on_area_entered)
	
	# Tạo shape va chạm
	var col := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	col.shape = circle
	add_child(col)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	_traveled_time += delta
	if _traveled_time >= lifetime:
		queue_free()

func _draw() -> void:
	# Vẽ viên sỏi pixel (Palette chuẩn GDD)
	draw_circle(Vector2.ZERO, radius, Palette.XAM_SAT)
	draw_circle(Vector2(-1, -1), radius * 0.5, Palette.KEM)

func _on_area_entered(area: Area2D) -> void:
	var target: Node = area.get_parent()
	if target != null and target != attacker and target.has_method("receive_hit"):
		var _res: Dictionary = target.receive_hit(damage, attacker)
		var show_log: bool = bool(GameData.get_stat("debug", "show_combat_log", true))
		if show_log:
			print("[PROJECTILE] Đạn Ná bắn trúng %s! Gây %d sát thương. (+2 MAGIC)" % [target.name, damage])
		BehaviorTracker.add_points(BehaviorTracker.ACTION_MAGIC, 2)
		queue_free()
```

---

## scripts\combat\shell_shard_pickup.gd
```gdscript
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
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_method("add_shards"):
			inv.add_shards(shard_amount)
	# Tích lũy hành vi EXPLORE nhẹ nếu nhặt đồ
	BehaviorTracker.add_points(BehaviorTracker.ACTION_EXPLORE, 1)
	queue_free()
```

---

## scripts\combat\stats_calculator.gd
```gdscript
extends RefCounted
class_name StatsCalc

# StatsCalc: Dịch vụ tính toán các chỉ số phái sinh và công thức cân bằng
# Tuân thủ chặt chẽ COMBAT_SPEC mục 9 và đọc thông số từ data/stats.json qua GameData.

const DEFAULT_SCALING_COEFF: Dictionary = {
	"S": 0.08,
	"A": 0.06,
	"B": 0.045,
	"C": 0.03,
	"D": 0.02,
	"E": 0.01,
	"-": 0.0
}

static func _get_stat_val(category: String, key: String, default_val: Variant) -> Variant:
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var gd = root.root.get_node_or_null("GameData")
		if gd != null and gd.has_method("get_stat"):
			return gd.get_stat(category, key, default_val)
	return default_val

static func calc_max_hp(base_stats: Dictionary) -> int:
	var vit: int = int(base_stats.get("VIT", 10))
	var hp_base: int = int(_get_stat_val("formulas", "hp_base", 60))
	var hp_per_vit: int = int(_get_stat_val("formulas", "hp_per_vit", 4))
	return hp_base + vit * hp_per_vit

static func calc_max_stamina(base_stats: Dictionary) -> float:
	var vit: int = int(base_stats.get("VIT", 10))
	var sta_base: float = float(_get_stat_val("formulas", "stamina_base", 60.0))
	var sta_per_vit: float = float(_get_stat_val("formulas", "stamina_per_vit", 2.0))
	return sta_base + float(vit) * sta_per_vit

static func calc_equip_capacity(base_stats: Dictionary) -> float:
	var vit: int = int(base_stats.get("VIT", 10))
	var ec_base: float = float(_get_stat_val("formulas", "equip_capacity_base", 40.0))
	var ec_per_vit: float = float(_get_stat_val("formulas", "equip_capacity_per_vit", 1.5))
	return ec_base + float(vit) * ec_per_vit

static func calc_max_mp(base_stats: Dictionary) -> int:
	var int_stat: int = int(base_stats.get("INT", 10))
	var mp_base: int = int(_get_stat_val("formulas", "mp_base", 20))
	var mp_per_int: int = int(_get_stat_val("formulas", "mp_per_int", 3))
	return mp_base + int_stat * mp_per_int

static func calc_weapon_damage(weapon_data: Dictionary, attack_spec: Dictionary, base_stats: Dictionary) -> int:
	var base_dmg: float = float(weapon_data.get("base_damage", 10))
	var mv: float = float(attack_spec.get("damage_mv", 1.0))
	
	# Tính scaling
	var scaling: Dictionary = weapon_data.get("scaling", {})
	var scaling_sum: float = 0.0
	for stat_name in scaling:
		var grade: String = str(scaling[stat_name])
		var coeff: float = float(_get_stat_val("scaling_coeff", grade, DEFAULT_SCALING_COEFF.get(grade, 0.0)))
		var stat_val: int = int(base_stats.get(stat_name, 10))
		var stat_diff: int = maxi(0, stat_val - 10)
		scaling_sum += coeff * float(stat_diff)
	
	var dmg: float = base_dmg * mv * (1.0 + scaling_sum)
	
	# Kiểm tra thiếu chỉ số yêu cầu (Requirements penalty)
	var reqs: Dictionary = weapon_data.get("requirements", {})
	var missing_pts: int = 0
	for stat_name in reqs:
		var req_val: int = int(reqs[stat_name])
		var stat_val: int = int(base_stats.get(stat_name, 10))
		if stat_val < req_val:
			missing_pts += (req_val - stat_val)
	
	if missing_pts > 0:
		var dmg_mult_per_pt: float = float(_get_stat_val("requirement_penalty", "damage_mult_per_pt", 0.05))
		var dmg_min_mult: float = float(_get_stat_val("requirement_penalty", "damage_min_mult", 0.5))
		var penalty_mult: float = maxf(dmg_min_mult, 1.0 - dmg_mult_per_pt * float(missing_pts))
		dmg *= penalty_mult
	
	return maxi(1, int(round(dmg)))

static func calc_level_cost(current_level: int) -> int:
	var cost_base: float = float(_get_stat_val("leveling", "cost_base", 40.0))
	var cost_growth: float = float(_get_stat_val("leveling", "cost_growth", 1.18))
	return maxi(1, int(round(cost_base * pow(cost_growth, max(0, current_level - 1)))))

static func calc_level(total_added_points: int) -> int:
	return 1 + total_added_points
```

---

## scripts\combat\weapon_db.gd
```gdscript
extends RefCounted
class_name WeaponDB

# WeaponDB: Dịch vụ truy vấn và quản lý dữ liệu vũ khí
# Tải cấu hình từ data/weapons.json (nếu có) hoặc fallback dữ liệu mặc định

static var _weapons_cache: Dictionary = {}

static func get_weapon(weapon_id: String) -> Dictionary:
	_ensure_loaded()
	if _weapons_cache.has(weapon_id):
		return _weapons_cache[weapon_id]
	return {}

static func get_all_weapons() -> Dictionary:
	_ensure_loaded()
	return _weapons_cache

static func _ensure_loaded() -> void:
	if not _weapons_cache.is_empty():
		return
	
	# Đọc dữ liệu qua GameData (Autoload) theo yêu cầu COMBAT_SPEC
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var gd = root.root.get_node_or_null("GameData")
		if gd != null and not gd.weapons.is_empty():
			_weapons_cache = gd.weapons
			return
	
	# Fallback nếu chạy trong môi trường SceneTree độc lập chưa có Autoload
	var path := "res://data/weapons.json"
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				_weapons_cache = json.data
				return
	
	_weapons_cache = {}

const SCALING_COEFF: Dictionary = {
	"S": 0.08,
	"A": 0.06,
	"B": 0.045,
	"C": 0.03,
	"D": 0.02,
	"E": 0.01,
	"-": 0.0
}

static func calculate_damage(weapon: Dictionary, attack_spec: Dictionary, stats: Dictionary) -> int:
	var base_dmg: float = float(weapon.get("base_damage", 10))
	var mv: float = float(attack_spec.get("damage_mv", 1.0))
	
	# Tính scaling
	var scaling: Dictionary = weapon.get("scaling", {})
	var scaling_sum: float = 0.0
	for stat_name in scaling:
		var grade: String = str(scaling[stat_name])
		var coeff: float = float(SCALING_COEFF.get(grade, 0.0))
		var stat_val: int = int(stats.get(stat_name, 10))
		var stat_diff: int = maxi(0, stat_val - 10)
		scaling_sum += coeff * float(stat_diff)
	
	var dmg: float = base_dmg * mv * (1.0 + scaling_sum)
	
	# Kiểm tra thiếu chỉ số yêu cầu (Requirements penalty)
	var reqs: Dictionary = weapon.get("requirements", {})
	var missing_pts: int = 0
	for stat_name in reqs:
		var req_val: int = int(reqs[stat_name])
		var stat_val: int = int(stats.get(stat_name, 10))
		if stat_val < req_val:
			missing_pts += (req_val - stat_val)
	
	if missing_pts > 0:
		var penalty_mult: float = maxf(0.5, 1.0 - 0.05 * float(missing_pts))
		dmg *= penalty_mult
	
	return maxi(1, int(round(dmg)))

static func calculate_stamina_cost(attack_spec: Dictionary, weapon: Dictionary, stats: Dictionary) -> float:
	var base_cost: float = float(attack_spec.get("stamina", 8.0))
	
	var reqs: Dictionary = weapon.get("requirements", {})
	var missing_pts: int = 0
	for stat_name in reqs:
		var req_val: int = int(reqs[stat_name])
		var stat_val: int = int(stats.get(stat_name, 10))
		if stat_val < req_val:
			missing_pts += (req_val - stat_val)
	
	if missing_pts > 0:
		base_cost *= (1.0 + 0.04 * float(missing_pts))
	
	return base_cost

```

---

## scripts\player\egg_visual.gd
```gdscript
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

func start_attack_visual(dir: Vector2, step: int, weapon_id: String = "staff_wood", custom_duration: float = -1.0) -> void:
	attack_slash_dir = dir.normalized()
	if attack_slash_dir == Vector2.ZERO:
		attack_slash_dir = Vector2.DOWN
	facing_dir = attack_slash_dir
	attack_slash_step = step
	attack_weapon_type = weapon_id
	
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
				
				# Vệt chém hình vòng cung vàng rực bám theo sau mũi gậy (giảm xuống 2/3)
				var arc_rad: float = 15.3 if attack_slash_step == 2 else 12.7
				var a1 := minf(start_ang, cur_ang)
				var a2 := maxf(start_ang, cur_ang)
				draw_arc(pivot, arc_rad, a1, a2, 14, Palette.KEM, 2.0)
				draw_arc(pivot, arc_rad - 1.5, a1, a2, 14, Palette.VANG_CO, 1.5)
				
				# Vẽ sprite gậy gỗ xoay theo góc chém (scale 2/3)
				var staff_tex: Texture2D = weapon_textures.get("staff_wood", null)
				if staff_tex != null:
					_draw_weapon_sprite(staff_tex, pivot, cur_ang + PI * 0.5, Vector2(16.0, 24.0), Vector2(0.67, 0.67))
				else:
					var staff_dir := Vector2(cos(cur_ang), sin(cur_ang))
					draw_line(pivot + staff_dir * 2.0, pivot + staff_dir * 16.0, Palette.NAU_DA, 2.0)
					draw_circle(pivot + staff_dir * 16.0, 1.8, Palette.KEM)
			
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
				
				# Vẽ sprite dao găm (scale 2/3)
				var dagger_tex: Texture2D = weapon_textures.get("dagger", null)
				if dagger_tex != null:
					_draw_weapon_sprite(dagger_tex, dagger_pos, aim.angle() + PI * 0.5, Vector2(16.0, 23.0), Vector2(0.67, 0.67))
				else:
					draw_line(dagger_pos, tip, Palette.KEM, 1.8)
					draw_circle(dagger_pos, 1.5, Palette.NAU_HAM)
			
			"sling":
				# Ná giương chạc và bung dây thun (tỉ lệ 2/3)
				var sling_pos := pivot + aim * 5.3
				var pull_pos := pivot - aim * 2.7 if progress < 0.45 else sling_pos + aim * 3.3
				
				# Vẽ sprite ná bắn đá (scale 2/3)
				var sling_tex: Texture2D = weapon_textures.get("sling", null)
				if sling_tex != null:
					_draw_weapon_sprite(sling_tex, sling_pos, aim.angle() + PI * 0.5, Vector2(16.0, 21.0), Vector2(0.67, 0.67))
				
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
```

---

## scripts\player\player.gd
```gdscript
extends CharacterBody2D
class_name Player

# Player: Nhân vật Trứng trong game "Vỡ Vỏ"
# Đầy đủ cơ chế:
# - Di chuyển 8 hướng theo tốc độ từ stats.json
# - Lăn né tiêu hao Stamina, i-frame 0.25s, chặn né khi thiếu thể lực
# - Hệ thống tấn công cận chiến Combo 3 đòn theo facing_direction (Điểm 2, 3)
# - AnimatedSprite2D nạp SpriteFrames từ animations.json, bật/tắt Hitbox qua frame_changed (Điểm 4)
# - Kích thước Collision 10x6 sát chân, Hurtbox 10x14 giữa thân từ stats.json (Điểm 5)

signal hp_changed(new_hp: int, max_hp: int)
signal stamina_changed(new_stamina: float, max_stamina: float)
signal player_died()
signal player_respawned()
signal combo_stepped(current_step: int)
signal weapon_swapped(active_slot: int, weapon_id: String, weapon_name: String)
signal shards_dropped(position: Vector2, amount: int)

@onready var visual_node: Node2D = $EggVisual
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_hitbox_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Chỉ số từ stats.json
var max_hp: int = 100
var current_hp: int = 100
var max_stamina: float = 100.0
var current_stamina: float = 100.0

var move_speed: float = 95.0
var dodge_speed_multiplier: float = 1.85
var dodge_duration: float = 0.25
var dodge_cooldown: float = 0.2
var dodge_stamina_cost: float = 20.0
var stamina_recovery_rate: float = 30.0
var stamina_recovery_delay: float = 0.35

# Thông số combo cận chiến từ stats.json
var attack_combo_damage: Array = [15, 18, 28]
var attack_cooldowns: Array = [0.15, 0.15, 0.45]
var combo_window: float = 0.55
var attack_stamina_costs: Array = [10.0, 12.0, 18.0]

# Trạng thái di chuyển & né
var facing_direction: Vector2 = Vector2.DOWN
var is_dodging: bool = false
var is_invulnerable: bool = false
var can_dodge: bool = true
var is_dead: bool = false

var dodge_timer: float = 0.0
var dodge_cooldown_timer: float = 0.0
var stamina_delay_timer: float = 0.0
var dodge_direction: Vector2 = Vector2.ZERO

# Trạng thái combo tấn công
var combat_state: CombatState = CombatState.new()
var is_attacking: bool = false
var can_attack: bool = true
var combo_step: int = 0 # 0, 1, 2 tương ứng các đòn trong chuỗi

# Hệ thống vũ khí (Giai đoạn A: 3 ô vũ khí trang bị)
var weapon_slots: Array[String] = ["staff_wood", "dagger", "sling"]
var active_slot_idx: int = 0
var current_weapon_id: String = "staff_wood"
var current_weapon_data: Dictionary = {}
var player_stats: Dictionary = {}
var debug_combat_log: bool = true

const LOGIC_FRAME_TIME: float = 1.0 / 60.0
var attack_frame_accumulator: float = 0.0
var attack_cooldown_timer: float = 0.0
var combo_window_timer: float = 0.0
var already_hit_enemies: Array[Node] = []
var accumulated_melee_damage: int = 0

# Trạng thái đỡ đòn (Guard)
var is_guarding: bool = false
var is_stunned: bool = false
var stun_timer: float = 0.0
var guard_damage_reduction: float = 0.75
var guard_stamina_cost_per_hit: float = 25.0
var guard_speed_multiplier: float = 0.45
var guard_break_stun_duration: float = 0.8
var guard_arc_degrees: float = 180.0

# Hoạt ảnh và hit_frames
var animations_config: Dictionary = {}
var current_hit_frames: Array = []
var is_in_hit_frame: bool = false
var is_hurt: bool = false   # đang phát hurt animation → block update_animations

var spawn_position: Vector2 = Vector2.ZERO
var respawn_timer: float = 0.0
var flash_timer: float = 0.0

func _ready() -> void:
	load_stats_from_data()
	setup_animations()
	spawn_position = global_position
	current_hp = max_hp
	current_stamina = max_stamina
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	
	if attack_hitbox != null:
		attack_hitbox.monitoring = true
		attack_hitbox.monitorable = false
		attack_hitbox.area_entered.connect(_on_attack_hitbox_area_entered)
	
	if animated_sprite != null:
		animated_sprite.frame_changed.connect(_on_sprite_frame_changed)
		animated_sprite.animation_finished.connect(_on_sprite_animation_finished)
	
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_signal("stats_changed"):
			inv.stats_changed.connect(apply_leveled_stats)
	
	update_animations()

func apply_leveled_stats() -> void:
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_method("get_effective_stats"):
			player_stats = inv.get_effective_stats()
	
	var old_max_hp: int = max_hp
	var old_max_stamina: float = max_stamina
	max_hp = StatsCalc.calc_max_hp(player_stats)
	max_stamina = StatsCalc.calc_max_stamina(player_stats)
	
	if max_hp > old_max_hp:
		current_hp = mini(max_hp, current_hp + (max_hp - old_max_hp))
	else:
		current_hp = mini(current_hp, max_hp)
	
	if max_stamina > old_max_stamina:
		current_stamina = minf(max_stamina, current_stamina + (max_stamina - old_max_stamina))
	else:
		current_stamina = minf(current_stamina, max_stamina)
	
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	print("[PLAYER] Đã áp dụng chỉ số mới: HP tối đa %d, Thể lực tối đa %.1f" % [max_hp, max_stamina])

func load_stats_from_data() -> void:
	debug_combat_log = bool(GameData.get_stat("debug", "show_combat_log", true))
	
	var effective_stats: Dictionary = {}
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null and inv.has_method("get_effective_stats"):
			effective_stats = inv.get_effective_stats()
	
	if effective_stats.is_empty():
		effective_stats = {
			"STR": int(GameData.get_stat("base_stats", "STR", 10)),
			"DEX": int(GameData.get_stat("base_stats", "DEX", 10)),
			"INT": int(GameData.get_stat("base_stats", "INT", 10)),
			"FAI": int(GameData.get_stat("base_stats", "FAI", 10)),
			"VIT": int(GameData.get_stat("base_stats", "VIT", 10)),
			"LUK": int(GameData.get_stat("base_stats", "LUK", 10))
		}
	
	player_stats = effective_stats
	max_hp = StatsCalc.calc_max_hp(player_stats)
	max_stamina = StatsCalc.calc_max_stamina(player_stats)
	current_weapon_data = WeaponDB.get_weapon(current_weapon_id)
	
	move_speed = float(GameData.get_stat("player", "move_speed", 95.0))
	dodge_speed_multiplier = float(GameData.get_stat("player", "dodge_speed_multiplier", 1.85))
	dodge_duration = float(GameData.get_stat("player", "dodge_duration", 0.25))
	dodge_cooldown = float(GameData.get_stat("player", "dodge_cooldown", 0.2))
	dodge_stamina_cost = float(GameData.get_stat("player", "dodge_stamina_cost", 16.0))
	stamina_recovery_rate = float(GameData.get_stat("player", "stamina_recovery_rate", 26.0))
	stamina_recovery_delay = float(GameData.get_stat("player", "stamina_recovery_delay", 0.35))
	
	attack_combo_damage = GameData.get_stat("player", "attack_combo_damage", [15, 18, 28])
	attack_cooldowns = GameData.get_stat("player", "attack_cooldowns", [0.15, 0.15, 0.45])
	combo_window = float(GameData.get_stat("player", "combo_window", 0.55))
	attack_stamina_costs = GameData.get_stat("player", "attack_stamina_costs", [8.0, 10.0, 14.0])
	
	guard_damage_reduction = float(GameData.get_stat("player", "guard_damage_reduction", 0.75))
	guard_stamina_cost_per_hit = float(GameData.get_stat("player", "guard_stamina_cost_per_hit", 20.0))
	guard_speed_multiplier = float(GameData.get_stat("player", "guard_speed_multiplier", 0.45))
	guard_break_stun_duration = float(GameData.get_stat("player", "guard_break_stun_duration", 0.8))
	guard_arc_degrees = float(GameData.get_stat("player", "guard_arc_degrees", 180.0))
	
	# Nạp kích thước Collision & Hurtbox từ stats.json (Điểm 5)
	var col_size: Array = GameData.get_stat("player", "collision_size", [10.0, 6.0])
	var col_offset: Array = GameData.get_stat("player", "collision_offset", [0.0, -3.0])
	var hurt_size: Array = GameData.get_stat("player", "hurtbox_size", [10.0, 14.0])
	var hurt_offset: Array = GameData.get_stat("player", "hurtbox_offset", [0.0, -10.0])
	
	if collision_shape != null:
		var col_rect := RectangleShape2D.new()
		col_rect.size = Vector2(col_size[0], col_size[1])
		collision_shape.shape = col_rect
		collision_shape.position = Vector2(col_offset[0], col_offset[1])
	
	if hurtbox != null:
		var hurt_col: CollisionShape2D = hurtbox.get_node_or_null("CollisionShape2D")
		if hurt_col != null:
			var hurt_rect := RectangleShape2D.new()
			hurt_rect.size = Vector2(hurt_size[0], hurt_size[1])
			hurt_col.shape = hurt_rect
			hurt_col.position = Vector2(hurt_offset[0], hurt_offset[1])

func setup_animations() -> void:
	var anim_path := "res://assets/sprites/player/animations.json"
	if FileAccess.file_exists(anim_path):
		var file := FileAccess.open(anim_path, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
				if json.data.has("player_egg") and json.data["player_egg"].has("animations"):
					animations_config = json.data["player_egg"]["animations"]
	
	var sprite_frames := SpriteFrames.new()
	for anim_name in animations_config:
		var cfg: Dictionary = animations_config[anim_name]
		var frame_count: int = int(cfg.get("frames", 4))
		var fps: float = float(cfg.get("fps", 12))
		var loop: bool = bool(cfg.get("loop", true))
		
		sprite_frames.add_animation(anim_name)
		sprite_frames.set_animation_speed(anim_name, fps)
		sprite_frames.set_animation_loop(anim_name, loop)
		
		var file_name: String = str(cfg.get("file", ""))
		var full_img_path := "res://assets/sprites/player/" + file_name
		
		if ResourceLoader.exists(full_img_path):
			var texture: Texture2D = load(full_img_path)
			for i in range(frame_count):
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2(i * 32, 0, 32, 32)
				sprite_frames.add_frame(anim_name, atlas)
		else:
			var img := Image.create(32, 32, false, Image.FORMAT_RGBA8)
			var placeholder_tex := ImageTexture.create_from_image(img)
			for i in range(frame_count):
				sprite_frames.add_frame(anim_name, placeholder_tex)
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.offset = Vector2(0, -16)

func _physics_process(delta: float) -> void:
	if is_dead:
		process_death(delta)
		return
	
	process_cooldowns(delta)
	process_input_and_movement(delta)
	process_stamina(delta)
	process_attack_logic(delta)
	process_visual_effects(delta)
	update_animations()

func update_animations() -> void:
	if is_dead:
		return
	
	# Ẩn hoàn toàn hình khối tạm – sprite đã đủ
	if visual_node != null and "show_placeholder_body" in visual_node:
		visual_node.show_placeholder_body = false
	animated_sprite.visible = true
	
	if is_attacking:
		return  # hoạt ảnh attack đã được bật trong try_attack()
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	animated_sprite.flip_h = flip_left
	
	if is_dodging:
		var roll_anim := "roll_" + dir_suffix
		if animated_sprite.animation != roll_anim or not animated_sprite.is_playing():
			animated_sprite.play(roll_anim)
		return
	
	if velocity == Vector2.ZERO:
		var anim_name := "idle_" + dir_suffix
		if animated_sprite.animation != anim_name or not animated_sprite.is_playing():
			animated_sprite.play(anim_name)
	else:
		var run_anim := "run_" + dir_suffix
		if animated_sprite.animation != run_anim or not animated_sprite.is_playing():
			animated_sprite.play(run_anim)

func process_cooldowns(delta: float) -> void:
	if dodge_cooldown_timer > 0.0:
		dodge_cooldown_timer -= delta
		if dodge_cooldown_timer <= 0.0:
			can_dodge = true
	
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0.0:
			can_attack = true
	
	if combo_window_timer > 0.0:
		combo_window_timer -= delta
		if combo_window_timer <= 0.0 and not is_attacking:
			combo_step = 0
	
	if stun_timer > 0.0:
		stun_timer -= delta
		if stun_timer <= 0.0:
			is_stunned = false
	
	if stamina_delay_timer > 0.0:
		stamina_delay_timer -= delta

func process_input_and_movement(delta: float) -> void:
	if is_stunned:
		is_guarding = false
		if visual_node != null and visual_node.has_method("set_guarding"):
			visual_node.set_guarding(false, facing_direction)
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if is_dodging:
		is_guarding = false
		if visual_node != null and visual_node.has_method("set_guarding"):
			visual_node.set_guarding(false, facing_direction)
		dodge_timer -= delta
		velocity = dodge_direction * (move_speed * dodge_speed_multiplier)
		move_and_slide()
		if dodge_timer <= 0.0:
			end_dodge()
		return
	
	if is_attacking:
		is_guarding = false
		if visual_node != null and visual_node.has_method("set_guarding"):
			visual_node.set_guarding(false, facing_direction)
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Kiểm tra trạng thái Giữ Guard
	var wants_guard: bool = Input.is_action_pressed("guard") and current_stamina > 0.0
	is_guarding = wants_guard
	if visual_node != null and visual_node.has_method("set_guarding"):
		visual_node.set_guarding(is_guarding, facing_direction)
	
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector.normalized()
		if visual_node != null and visual_node.has_method("set_equipped_weapon"):
			visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
		var speed: float = move_speed
		if is_guarding:
			speed *= guard_speed_multiplier
		velocity = input_vector * speed
		stamina_delay_timer = maxf(stamina_delay_timer, stamina_recovery_delay)
	else:
		velocity = Vector2.ZERO
	
	if not is_guarding and not is_dodging:
		if Input.is_action_just_pressed("swap_weapon"):
			swap_weapon()
		
		# Hỗ trợ phím số 1, 2, 3 để chọn nhanh 3 ô vũ khí, phím 4 là đòn tay không
		if Input.is_physical_key_pressed(KEY_1) or Input.is_key_pressed(KEY_1):
			_switch_to_slot(0)
		elif Input.is_physical_key_pressed(KEY_2) or Input.is_key_pressed(KEY_2):
			_switch_to_slot(1)
		elif Input.is_physical_key_pressed(KEY_3) or Input.is_key_pressed(KEY_3):
			_switch_to_slot(2)
		elif Input.is_physical_key_pressed(KEY_4) or Input.is_key_pressed(KEY_4):
			equip_weapon_to_active_slot("fist")
		elif Input.is_action_just_pressed("cycle_item"):
			var all_keys := ["staff_wood", "dagger", "sling", "fist"]
			var cur_i := all_keys.find(current_weapon_id)
			var nxt_i := (cur_i + 1) % all_keys.size() if cur_i != -1 else 0
			equip_weapon_to_active_slot(all_keys[nxt_i])
	
	if not is_guarding:
		if Input.is_action_just_pressed("attack"):
			try_attack()
	
	if Input.is_action_just_pressed("dodge"):
		try_dodge(input_vector)
	
	move_and_slide()

# --- Hệ thống Vũ khí & Đổi vũ khí (Giai đoạn A) ---

func swap_weapon() -> void:
	if is_attacking or is_dodging or is_dead or is_stunned:
		return
	
	# Đổi xoay vòng giữa 3 ô vũ khí trang bị (Gậy Gỗ -> Dao Găm -> Ná)
	active_slot_idx = (active_slot_idx + 1) % weapon_slots.size()
	current_weapon_id = weapon_slots[active_slot_idx]
	current_weapon_data = WeaponDB.get_weapon(current_weapon_id)
	
	combat_state.reset_combo()
	combo_step = 0
	
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	if debug_combat_log:
		print("[PLAYER] Đổi ô vũ khí: Ô %d/%d -> %s (%s)" % [active_slot_idx + 1, weapon_slots.size(), w_name, current_weapon_id])
	weapon_swapped.emit(active_slot_idx, current_weapon_id, w_name)

func _switch_to_slot(slot_idx: int) -> void:
	if slot_idx < 0 or slot_idx >= weapon_slots.size():
		return
	if active_slot_idx == slot_idx:
		return
	active_slot_idx = slot_idx
	current_weapon_id = weapon_slots[active_slot_idx]
	current_weapon_data = WeaponDB.get_weapon(current_weapon_id)
	combat_state.reset_combo()
	combo_step = 0
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	if debug_combat_log:
		print("[PLAYER] Chọn nhanh Ô %d: %s (%s)" % [active_slot_idx + 1, w_name, current_weapon_id])
	weapon_swapped.emit(active_slot_idx, current_weapon_id, w_name)

func equip_weapon_to_active_slot(weapon_id: String) -> void:
	if is_attacking or is_dodging or is_dead or is_stunned:
		return
	if current_weapon_id == weapon_id:
		return
	var w_data := WeaponDB.get_weapon(weapon_id)
	if w_data.is_empty():
		return
	weapon_slots[active_slot_idx] = weapon_id
	current_weapon_id = weapon_id
	current_weapon_data = w_data
	combat_state.reset_combo()
	combo_step = 0
	if visual_node != null and visual_node.has_method("set_equipped_weapon"):
		visual_node.set_equipped_weapon(current_weapon_id, facing_direction)
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	if debug_combat_log:
		print("[PLAYER] Trang bị vào Ô %d: %s (%s)" % [active_slot_idx + 1, w_name, current_weapon_id])
	weapon_swapped.emit(active_slot_idx, current_weapon_id, w_name)

# --- Chuỗi đòn nhẹ 60 FPS Logic (Startup -> Active -> Recovery) ---

const ProjectileScript = preload("res://scripts/combat/projectile.gd")

func try_attack() -> void:
	if is_dodging or is_dead or is_stunned or is_guarding:
		return
	
	# Nếu đang trong pha recovery và đã qua mốc cancel_from, cho phép nối combo ngay
	if is_attacking:
		var chain: Array = current_weapon_data.get("light_chain", [])
		if combo_step < chain.size():
			var spec: Dictionary = chain[combo_step]
			var cancel_from: int = int(spec.get("cancel_from", 3))
			if combat_state.can_chain_combo(cancel_from):
				_advance_combo()
				return
		combat_state.combo_buffered = true
		return
	
	_start_attack_step(combo_step)

func _start_attack_step(step: int) -> void:
	var chain: Array = current_weapon_data.get("light_chain", [])
	if chain.is_empty():
		return
	
	if step >= chain.size():
		step = 0
	combo_step = step
	
	var spec: Dictionary = chain[combo_step]
	var cost: float = WeaponDB.calculate_stamina_cost(spec, current_weapon_data, player_stats)
	
	if current_stamina < cost:
		print("[PLAYER] Không đủ Stamina để tấn công đòn %d! (Cần %.1f, có %.1f)" % [combo_step + 1, cost, current_stamina])
		combat_state.reset_combo()
		combo_step = 0
		return
	
	current_stamina -= cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_attacking = true
	can_attack = false
	combat_state.current_state = CombatState.State.ATTACK_STARTUP
	combat_state.attack_phase = CombatState.AttackPhase.STARTUP
	combat_state.attack_frame = 0
	combat_state.combo_step = combo_step
	combat_state.combo_buffered = false
	attack_frame_accumulator = 0.0
	already_hit_enemies.clear()
	combo_stepped.emit(combo_step)
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var anim_name := "attack_" + dir_suffix
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	animated_sprite.flip_h = flip_left
	
	if animated_sprite != null and animations_config.has(anim_name):
		animated_sprite.stop()
		animated_sprite.frame = 0
		animated_sprite.play(anim_name)
	
	# Khởi động diễn hoạt vũ khí động (vung gậy / đâm dao / kéo ná)
	var total_frames: int = int(spec.get("startup", 4)) + int(spec.get("active", 3)) + int(spec.get("recovery", 6))
	var attack_duration: float = float(total_frames) * LOGIC_FRAME_TIME
	if visual_node != null and visual_node.has_method("start_attack_visual"):
		visual_node.start_attack_visual(facing_direction, combo_step, current_weapon_id, attack_duration)
	
	var w_name: String = str(current_weapon_data.get("name", current_weapon_id))
	print("[PLAYER] Tung đòn combo %d/%d (%s)! Startup: %d khung, Tiêu hao: %.1f Stamina" % [
		combo_step + 1, chain.size(), w_name, int(spec.get("startup", 4)), cost
	])

func process_attack_logic(delta: float) -> void:
	if not is_attacking:
		return
	
	attack_frame_accumulator += delta
	while attack_frame_accumulator >= LOGIC_FRAME_TIME:
		attack_frame_accumulator -= LOGIC_FRAME_TIME
		_tick_attack_frame()

func _tick_attack_frame() -> void:
	if not is_attacking:
		return
	
	var chain: Array = current_weapon_data.get("light_chain", [])
	if combo_step < 0 or combo_step >= chain.size():
		end_attack(true)
		return
	
	var spec: Dictionary = chain[combo_step]
	var startup_frames: int = int(spec.get("startup", 4))
	var active_frames: int = int(spec.get("active", 3))
	var recovery_frames: int = int(spec.get("recovery", 6))
	var cancel_from: int = int(spec.get("cancel_from", 3))
	
	match combat_state.attack_phase:
		CombatState.AttackPhase.STARTUP:
			combat_state.attack_frame += 1
			if combat_state.attack_frame >= startup_frames:
				combat_state.attack_phase = CombatState.AttackPhase.ACTIVE
				combat_state.current_state = CombatState.State.ATTACK_ACTIVE
				combat_state.attack_frame = 0
				_enter_active_phase(spec)
				
		CombatState.AttackPhase.ACTIVE:
			combat_state.attack_frame += 1
			var hitbox_spec: Dictionary = spec.get("hitbox", {})
			if str(hitbox_spec.get("shape", "arc")) != "projectile":
				check_melee_overlaps()
				
			if combat_state.attack_frame >= active_frames:
				combat_state.attack_phase = CombatState.AttackPhase.RECOVERY
				combat_state.current_state = CombatState.State.ATTACK_RECOVERY
				combat_state.attack_frame = 0
				_enter_recovery_phase()
				
		CombatState.AttackPhase.RECOVERY:
			combat_state.attack_frame += 1
			
			# Hủy sang né (dodge cancel) từ khung cancel_from
			if combat_state.can_cancel_to_dodge(cancel_from) and Input.is_action_just_pressed("dodge"):
				end_attack(false)
				var input_vec := Input.get_vector("move_left", "move_right", "move_up", "move_down")
				try_dodge(input_vec)
				return
			
			# Nối chuỗi combo từ khung cancel_from
			if combat_state.can_chain_combo(cancel_from):
				if combat_state.combo_buffered or Input.is_action_just_pressed("attack"):
					combat_state.combo_buffered = false
					_advance_combo()
					return
			
			if combat_state.attack_frame >= recovery_frames:
				_finish_attack_recovery(spec, chain)

func _enter_active_phase(spec: Dictionary) -> void:
	is_in_hit_frame = true
	already_hit_enemies.clear()
	
	var dir_suffix := get_direction_suffix(facing_direction)
	var flip_left: bool = (facing_direction.x < 0 and abs(facing_direction.x) >= abs(facing_direction.y))
	var hitbox_spec: Dictionary = spec.get("hitbox", {})
	var shape_type: String = str(hitbox_spec.get("shape", "arc"))
	var w_type: String = str(current_weapon_data.get("type", "staff"))
	var dmg: int = WeaponDB.calculate_damage(current_weapon_data, spec, player_stats)
	
	if shape_type == "projectile":
		# Bắn đạn tầm xa (Ná) qua HitboxService
		var spawn_pos: Vector2 = global_position + Vector2(0, -10) + facing_direction * 8.0
		HitboxService.spawn_projectile(get_parent(), hitbox_spec, facing_direction, spawn_pos, self, dmg)
	else:
		# Cận chiến: tạo/cấu hình Hitbox theo hình dạng (arc, line, rect)
		HitboxService.configure_hitbox(attack_hitbox, hitbox_spec, dir_suffix, flip_left, facing_direction)
		attack_hitbox.monitoring = true
		check_melee_overlaps()

func _enter_recovery_phase() -> void:
	is_in_hit_frame = false
	HitboxService.deactivate_hitbox(attack_hitbox)

func _advance_combo() -> void:
	var chain: Array = current_weapon_data.get("light_chain", [])
	if combo_step + 1 < chain.size():
		_start_attack_step(combo_step + 1)
	else:
		_start_attack_step(0)

func _finish_attack_recovery(spec: Dictionary, chain: Array) -> void:
	var combo_win: int = int(spec.get("combo_window", 0))
	if combo_step + 1 < chain.size() and combo_win > 0:
		is_attacking = false
		combat_state.attack_phase = CombatState.AttackPhase.NONE
		combat_state.current_state = CombatState.State.IDLE
		can_attack = true
		combo_step += 1
		combat_state.combo_step = combo_step
		combo_window_timer = float(combo_win) / 60.0
	else:
		end_attack(true)

func end_attack(reset_step: bool = true) -> void:
	is_attacking = false
	is_in_hit_frame = false
	HitboxService.deactivate_hitbox(attack_hitbox)
	combat_state.attack_phase = CombatState.AttackPhase.NONE
	combat_state.current_state = CombatState.State.IDLE
	can_attack = true
	attack_frame_accumulator = 0.0
	if visual_node != null and visual_node.has_method("stop_attack_visual"):
		visual_node.stop_attack_visual()
	if reset_step:
		combo_step = 0
		combat_state.combo_step = 0
		combo_window_timer = 0.0
		combat_state.combo_buffered = false

func _on_sprite_frame_changed() -> void:
	pass

func _on_sprite_animation_finished() -> void:
	pass

func update_attack_hitbox_transform(dir_suffix: String, flip_left: bool) -> void:
	HitboxService.update_attack_hitbox_position(attack_hitbox, dir_suffix, flip_left)

func check_melee_overlaps() -> void:
	var chain: Array = current_weapon_data.get("light_chain", [])
	if combo_step >= chain.size():
		return
	var spec: Dictionary = chain[combo_step]
	var dmg: int = WeaponDB.calculate_damage(current_weapon_data, spec, player_stats)
	HitboxService.check_and_process_overlaps(attack_hitbox, self, dmg, already_hit_enemies, _on_enemy_hit)

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if is_in_hit_frame:
		var chain: Array = current_weapon_data.get("light_chain", [])
		if combo_step >= chain.size():
			return
		var spec: Dictionary = chain[combo_step]
		var dmg: int = WeaponDB.calculate_damage(current_weapon_data, spec, player_stats)
		HitboxService.process_single_target(area, self, dmg, already_hit_enemies, _on_enemy_hit)

func _on_enemy_hit(target: Node, dmg: int, _res: Dictionary) -> void:
	if debug_combat_log:
		print("[COMBAT] Đòn %d của %s đánh trúng %s! Gây %d sát thương." % [
			combo_step + 1, current_weapon_data.get("name", current_weapon_id), target.name, dmg
		])
	accumulated_melee_damage += dmg
	if accumulated_melee_damage >= 10:
		var guard_pts := accumulated_melee_damage / 10
		accumulated_melee_damage = accumulated_melee_damage % 10
		BehaviorTracker.add_points(BehaviorTracker.ACTION_GUARD, guard_pts)
		if debug_combat_log:
			print("[COMBAT] +%d điểm GUARD từ tích lũy sát thương cận chiến!" % guard_pts)

func get_direction_suffix(dir: Vector2) -> String:
	if abs(dir.x) >= abs(dir.y):
		return "side"
	elif dir.y > 0:
		return "down"
	else:
		return "up"

func try_dodge(input_vector: Vector2) -> void:
	if not can_dodge or is_dodging or is_attacking:
		return
	
	if current_stamina < dodge_stamina_cost:
		print("[PLAYER] Không đủ Stamina để lăn né! (Cần %.1f, có %.1f)" % [dodge_stamina_cost, current_stamina])
		return
	
	current_stamina -= dodge_stamina_cost
	stamina_changed.emit(current_stamina, max_stamina)
	stamina_delay_timer = stamina_recovery_delay
	
	is_dodging = true
	combat_state.current_state = CombatState.State.DODGING
	is_invulnerable = true
	can_dodge = false
	dodge_timer = dodge_duration
	
	if input_vector != Vector2.ZERO:
		dodge_direction = input_vector.normalized()
	else:
		dodge_direction = facing_direction
	
	print("[PLAYER] Lăn né! Khung bất tử: %.2fs, tốn %.1f Stamina" % [dodge_duration, dodge_stamina_cost])

func end_dodge() -> void:
	is_dodging = false
	combat_state.current_state = CombatState.State.IDLE
	is_invulnerable = false
	dodge_cooldown_timer = dodge_cooldown

func process_stamina(delta: float) -> void:
	if not is_dodging and not is_attacking and not is_guarding and not is_stunned and velocity == Vector2.ZERO and stamina_delay_timer <= 0.0:
		if current_stamina < max_stamina:
			current_stamina = minf(max_stamina, current_stamina + stamina_recovery_rate * delta)
			stamina_changed.emit(current_stamina, max_stamina)

var hurt_invulnerable_timer: float = 0.0

func process_visual_effects(delta: float) -> void:
	if hurt_invulnerable_timer > 0.0:
		hurt_invulnerable_timer -= delta
		if hurt_invulnerable_timer <= 0.0:
			is_invulnerable = false
	
	if flash_timer > 0.0:
		flash_timer -= delta
		if flash_timer <= 0.0:
			modulate = Color.WHITE

func receive_hit(damage: int, attack_source: Node) -> Dictionary:
	if is_dead:
		return {"hit": false, "dodged": false, "guarded": false}
	
	if is_invulnerable:
		if is_dodging:
			print("[COMBAT] Né thành công đòn đánh! +2 điểm DODGE")
			BehaviorTracker.add_points(BehaviorTracker.ACTION_DODGE, 2)
			return {"hit": false, "dodged": true, "guarded": false}
		else:
			# Đang trong thời gian chớp miễn nhiễm sau khi bị thương (i-frame)
			return {"hit": false, "dodged": false, "guarded": false}
	
	# Kiểm tra cơ chế Đỡ Đòn (Guard)
	var guarded_successfully: bool = false
	var final_damage: int = damage
	
	if is_guarding and not is_stunned:
		# Xác định hướng từ Player tới nguồn tấn công
		var incoming_dir := facing_direction
		if attack_source != null and "global_position" in attack_source:
			var diff: Vector2 = (attack_source.global_position - global_position)
			if diff != Vector2.ZERO:
				incoming_dir = diff.normalized()
		
		# Tính góc giữa hướng nhìn của Player và hướng của đòn tấn công
		var angle_diff_rad: float = abs(facing_direction.angle_to(incoming_dir))
		var max_allowed_rad: float = deg_to_rad(guard_arc_degrees * 0.5)
		
		if angle_diff_rad <= max_allowed_rad:
			# Đòn đánh nằm trong cung đỡ phía trước!
			if current_stamina >= guard_stamina_cost_per_hit:
				# Đỡ thành công
				current_stamina -= guard_stamina_cost_per_hit
				stamina_changed.emit(current_stamina, max_stamina)
				stamina_delay_timer = stamina_recovery_delay
				
				final_damage = int(round(float(damage) * (1.0 - guard_damage_reduction)))
				guarded_successfully = true
				
				BehaviorTracker.add_points(BehaviorTracker.ACTION_GUARD, 2)
				print("[COMBAT] Đỡ đòn thành công! Giảm sát thương từ %d xuống %d (-%.1f Stamina, +2 GUARD)" % [
					damage, final_damage, guard_stamina_cost_per_hit
				])
				
				# Hiệu ứng nảy lùi nhẹ & nháy sáng Xám Sắt
				modulate = Palette.XAM_SAT
				flash_timer = 0.12
			else:
				# Vỡ thế đỡ (Guard Break): Hết stamina khi đỡ
				current_stamina = 0.0
				stamina_changed.emit(current_stamina, max_stamina)
				stamina_delay_timer = stamina_recovery_delay * 1.5
				
				is_guarding = false
				is_stunned = true
				combat_state.current_state = CombatState.State.STUNNED
				stun_timer = guard_break_stun_duration
				final_damage = damage # Nhận trọn sát thương
				
				if visual_node != null and visual_node.has_method("set_guarding"):
					visual_node.set_guarding(false, facing_direction)
				
				print("[COMBAT] VỠ THẾ ĐỠ (Guard Break)! Choáng trong %.2fs và nhận trọn %d sát thương!" % [
					guard_break_stun_duration, final_damage
				])
		else:
			print("[COMBAT] Bị đánh từ phía sau / ngoài cung đỡ (góc: %.1f độ)! Không thể đỡ đòn." % rad_to_deg(angle_diff_rad))
	
	current_hp = maxi(0, current_hp - final_damage)
	hp_changed.emit(current_hp, max_hp)
	print("[COMBAT] Player nhận %d sát thương! HP còn: %d/%d" % [final_damage, current_hp, max_hp])
	
	# Cập nhật tỉ lệ máu cho EggVisual để vẽ vết nứt to dần
	if visual_node != null and visual_node.has_method("set_hp_ratio"):
		visual_node.set_hp_ratio(float(current_hp) / float(maxi(1, max_hp)))
	
	# Bắn hiệu ứng mảnh vỏ văng tung tóe (nếu đỡ thành công văng ít hơn)
	if visual_node != null and visual_node.has_method("spawn_shell_burst"):
		visual_node.spawn_shell_burst(3 if guarded_successfully else 7)
	
	if current_hp <= 0:
		die()
		return {"hit": true, "dodged": false, "guarded": guarded_successfully}
	
	if not guarded_successfully:
		# Khung bất tử ngắn (i-frame 0.25s) và chớp đỏ phản hồi trúng đòn
		is_invulnerable = true
		hurt_invulnerable_timer = 0.25
		flash_timer = 0.18
		modulate = Palette.DO_GACH
	
	return {"hit": true, "dodged": false, "guarded": guarded_successfully}

func die() -> void:
	is_dead = true
	combat_state.current_state = CombatState.State.DEAD
	is_hurt = false
	is_guarding = false
	is_stunned = false
	stun_timer = 0.0
	velocity = Vector2.ZERO
	is_dodging = false
	is_invulnerable = false
	is_attacking = false
	combo_step = 0
	respawn_timer = 1.5
	modulate = Color.WHITE
	if visual_node != null and visual_node.has_method("set_guarding"):
		visual_node.set_guarding(false, facing_direction)
	if visual_node != null and visual_node.has_method("stop_attack_visual"):
		visual_node.stop_attack_visual()
	if visual_node != null and visual_node.has_method("set_dead"):
		visual_node.set_dead(true)
	print("[PLAYER] VỎ ĐÃ VỠ... Bắt đầu chuẩn bị hồi sinh.")
	
	# Rơi đống Mảnh Vỏ Vụn tại chỗ chết nếu Player có Mảnh Vỏ
	var root = Engine.get_main_loop()
	var current_shards: int = 0
	var inv_node = null
	if root != null and root.root != null:
		inv_node = root.root.get_node_or_null("PlayerInventory")
		if inv_node != null and "shell_shards" in inv_node:
			current_shards = int(inv_node.shell_shards)
	
	if current_shards > 0:
		LostShard.spawn_at(get_parent(), global_position, current_shards)
		if inv_node != null and inv_node.has_method("spend_all_shards"):
			inv_node.spend_all_shards()
		shards_dropped.emit(global_position, current_shards)
		print("[PLAYER] Đã đánh rơi %d Mảnh Vỏ Vụn tại %s!" % [current_shards, global_position])
	
	# Phát death animation
	var dir_suffix := get_direction_suffix(facing_direction)
	var death_anim := "death_" + dir_suffix
	if animated_sprite != null and animations_config.has(death_anim):
		animated_sprite.play(death_anim)
	
	player_died.emit()

func process_death(delta: float) -> void:
	respawn_timer -= delta
	if respawn_timer <= 0.0:
		respawn()

func respawn() -> void:
	global_position = spawn_position
	current_hp = max_hp
	current_stamina = max_stamina
	is_dead = false
	combat_state.current_state = CombatState.State.IDLE
	is_hurt = false
	is_guarding = false
	is_stunned = false
	stun_timer = 0.0
	is_dodging = false
	is_invulnerable = false
	hurt_invulnerable_timer = 0.0
	is_attacking = false
	can_dodge = true
	can_attack = true
	combo_step = 0
	dodge_cooldown_timer = 0.0
	attack_cooldown_timer = 0.0
	modulate = Color.WHITE
	if visual_node != null and visual_node.has_method("set_guarding"):
		visual_node.set_guarding(false, facing_direction)
	if visual_node != null and visual_node.has_method("set_hp_ratio"):
		visual_node.set_hp_ratio(1.0)
	if visual_node != null and visual_node.has_method("set_dead"):
		visual_node.set_dead(false)
	hp_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)
	print("[PLAYER] Trứng đã hồi sinh tại điểm bắt đầu!")
	player_respawned.emit()
```

---

## scripts\ui\hud.gd
```gdscript
extends CanvasLayer

# HUD hiển thị máu, thể lực, vũ khí, mảnh vỏ và thông báo tạm thời.
# Toàn bộ màu sắc lấy trực tiếp từ Palette (GDD Mục 3).

@onready var hp_bar_fill: ColorRect = $MarginContainer/VBoxContainer/HPBar/Fill
@onready var hp_bar_bg: ColorRect = $MarginContainer/VBoxContainer/HPBar/Background
@onready var stamina_bar_fill: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Fill
@onready var stamina_bar_bg: ColorRect = $MarginContainer/VBoxContainer/StaminaBar/Background
@onready var debug_label: Label = $MarginContainer/VBoxContainer/DebugDodgeLabel
@onready var weapon_label: Label = $MarginContainer/VBoxContainer/WeaponHBox/WeaponLabel
@onready var weapon_icon: TextureRect = $MarginContainer/VBoxContainer/WeaponHBox/WeaponIcon
@onready var shard_label: Label = $MarginContainer/VBoxContainer/ShardLabel
@onready var death_overlay: Control = $DeathOverlay

var max_hp: int = 100
var current_hp: int = 100
var max_stamina: float = 100.0
var current_stamina: float = 100.0

var hp_bar_base_width: float = 64.0
var stamina_bar_base_width: float = 52.0

var show_debug_dodge: bool = false
var weapon_icons: Dictionary = {}

func _ready() -> void:
	_load_weapon_icons()
	apply_palette()
	# Nạp cờ debug từ stats.json
	show_debug_dodge = bool(GameData.get_stat("debug", "show_dodge_debug", false))
	update_debug_display()
	death_overlay.visible = false
	
	BehaviorTracker.points_changed.connect(_on_behavior_points_changed)
	
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null:
			if inv.has_signal("shards_changed"):
				inv.shards_changed.connect(func(_amount): update_level_and_shards())
			if inv.has_signal("stats_changed"):
				inv.stats_changed.connect(update_level_and_shards)
	
	update_level_and_shards()

func _load_weapon_icons() -> void:
	var staff_tex = load("res://assets/sprites/weapons/weapon_staff_wood.png")
	if staff_tex != null:
		weapon_icons["staff_wood"] = staff_tex
		weapon_icons["staff"] = staff_tex
	var dagger_tex = load("res://assets/sprites/weapons/weapon_dagger.png")
	if dagger_tex != null:
		weapon_icons["dagger"] = dagger_tex
	var sling_tex = load("res://assets/sprites/weapons/weapon_sling.png")
	if sling_tex != null:
		weapon_icons["sling"] = sling_tex

func apply_palette() -> void:
	# Màu sắc chuẩn GDD Mục 3
	hp_bar_bg.color = Palette.NAU_HAM
	hp_bar_fill.color = Palette.DO_GACH
	
	stamina_bar_bg.color = Palette.NAU_HAM
	stamina_bar_fill.color = Palette.XANH_LA_UA
	
	debug_label.add_theme_color_override("font_color", Palette.KEM)
	if weapon_label != null:
		weapon_label.add_theme_color_override("font_color", Palette.KEM)
	if shard_label != null:
		shard_label.add_theme_color_override("font_color", Palette.VANG_CO)
	
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
	# Thanh máu kéo dài theo lượng max_hp (Tăng sinh động khi nâng VIT)
	var max_w: float = hp_bar_base_width + maxf(0.0, float(max_hp - 100) * 0.8)
	hp_bar_bg.size.x = max_w
	var ratio: float = clampf(float(current_hp) / float(maxi(1, max_hp)), 0.0, 1.0)
	hp_bar_fill.size.x = max_w * ratio

func update_stamina(new_stamina: float, new_max_stamina: float) -> void:
	current_stamina = new_stamina
	max_stamina = new_max_stamina
	# Thanh thể lực kéo dài theo max_stamina
	var max_w: float = stamina_bar_base_width + maxf(0.0, float(max_stamina - 100.0) * 0.6)
	stamina_bar_bg.size.x = max_w
	var ratio: float = clampf(current_stamina / maxf(1.0, max_stamina), 0.0, 1.0)
	stamina_bar_fill.size.x = max_w * ratio

func update_weapon(slot_idx: int, weapon_id: String, weapon_name: String) -> void:
	if weapon_label != null:
		weapon_label.text = "[Q] Vũ khí (%d/3): %s" % [slot_idx + 1, weapon_name]
	if weapon_icon != null:
		var tex: Texture2D = weapon_icons.get(weapon_id, null)
		weapon_icon.texture = tex
		weapon_icon.visible = (tex != null)

func update_level_and_shards() -> void:
	var lvl: int = 1
	var shards: int = 0
	var root = Engine.get_main_loop()
	if root != null and root.root != null:
		var inv = root.root.get_node_or_null("PlayerInventory")
		if inv != null:
			if "level" in inv:
				lvl = int(inv.level)
			if "shell_shards" in inv:
				shards = int(inv.shell_shards)
	if shard_label != null:
		shard_label.text = "Cấp %d | Mảnh Vỏ: %d" % [lvl, shards]

func update_shards(_amount: int) -> void:
	update_level_and_shards()

func _on_behavior_points_changed(action_name: String, _new_points: int, _total: int) -> void:
	if action_name == BehaviorTracker.ACTION_DODGE:
		update_debug_display()

func update_debug_display() -> void:
	debug_label.visible = show_debug_dodge
	if show_debug_dodge:
		debug_label.text = "[DEBUG F3] DODGE: %d" % BehaviorTracker.get_points(BehaviorTracker.ACTION_DODGE)

func show_death_screen(show_it: bool) -> void:
	death_overlay.visible = show_it
```

---

## scripts\ui\level_up_screen.gd
```gdscript
extends CanvasLayer
class_name LevelUpScreen

# LevelUpScreen: Giao diện cộng điểm chỉ số tại Ổ Rơm
# Tuân thủ chặt chẽ COMBAT_SPEC mục 9:
# - Xem trước thay đổi chỉ số (HP, Stamina, Sức tải, Sát thương vũ khí)
# - Tính chi phí tăng dần: cost(level) = round(cost_base * cost_growth ^ (level-1))
# - Hỗ trợ cả chuột, bàn phím và tay cầm điều hướng

const STAT_NAMES: Array[String] = ["VIT", "STR", "DEX", "INT", "FAI", "LUK"]
const STAT_DESCRIPTIONS: Dictionary = {
	"VIT": "Tăng Máu tối đa, Thể lực & Sức tải",
	"STR": "Tăng sát thương vũ khí cận chiến nặng",
	"DEX": "Tăng sát thương vũ khí khéo léo",
	"INT": "Tăng MP & sát thương phép thuật",
	"FAI": "Tăng sát thương & hiệu ứng Thánh",
	"LUK": "Tăng tỉ lệ rơi đồ & tỉ lệ chí mạng"
}

@onready var panel_bg: ColorRect = $RootControl/PanelBg
@onready var header_label: Label = $RootControl/Margin/VBox/HeaderLabel
@onready var shards_label: Label = $RootControl/Margin/VBox/ShardsLabel
@onready var stats_container: VBoxContainer = $RootControl/Margin/VBox/MainHBox/StatsVBox
@onready var preview_vbox: VBoxContainer = $RootControl/Margin/VBox/MainHBox/PreviewVBox
@onready var btn_confirm: Button = $RootControl/Margin/VBox/MainHBox/PreviewVBox/ButtonsHBox/BtnConfirm
@onready var btn_cancel: Button = $RootControl/Margin/VBox/MainHBox/PreviewVBox/ButtonsHBox/BtnCancel
@onready var feedback_label: Label = $RootControl/Margin/VBox/FeedbackLabel
@onready var guide_label: Label = $RootControl/Margin/VBox/GuideLabel

var player_ref: Player = null
var pending_adds: Dictionary = {
	"VIT": 0, "STR": 0, "DEX": 0, "INT": 0, "FAI": 0, "LUK": 0
}
var selected_index: int = 0 # 0..5: các chỉ số, 6: Confirm, 7: Cancel
var stat_row_nodes: Array[Dictionary] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	apply_palette()
	
	if btn_confirm != null:
		btn_confirm.pressed.connect(_on_confirm_pressed)
		btn_confirm.mouse_entered.connect(func(): selected_index = 6; _highlight_selection())
	if btn_cancel != null:
		btn_cancel.pressed.connect(_on_cancel_pressed)
		btn_cancel.mouse_entered.connect(func(): selected_index = 7; _highlight_selection())
	
	_build_stat_rows()
	_update_display()
	_highlight_selection()

func apply_palette() -> void:
	if panel_bg != null:
		panel_bg.color = Color(Palette.DEN_THAN.r, Palette.DEN_THAN.g, Palette.DEN_THAN.b, 0.94)
	if header_label != null:
		header_label.add_theme_color_override("font_color", Palette.VANG_CO)
	if shards_label != null:
		shards_label.add_theme_color_override("font_color", Palette.KEM)
	if feedback_label != null:
		feedback_label.add_theme_color_override("font_color", Palette.KEM)
	if guide_label != null:
		guide_label.add_theme_color_override("font_color", Palette.XAM_SAT)
	if btn_confirm != null:
		btn_confirm.add_theme_color_override("font_color", Palette.KEM)
	if btn_cancel != null:
		btn_cancel.add_theme_color_override("font_color", Palette.KEM)

func open(p_player: Player) -> void:
	player_ref = p_player
	for s in STAT_NAMES:
		pending_adds[s] = 0
	selected_index = 0
	get_tree().paused = true
	_set_feedback("Nhấn '+' hoặc phím [D] để cộng điểm, [Enter] để xác nhận.", Palette.KEM)
	_update_display()
	_highlight_selection()

func close_screen() -> void:
	get_tree().paused = false
	queue_free()

func _set_feedback(msg: String, color: Color) -> void:
	if feedback_label != null:
		feedback_label.text = msg
		feedback_label.add_theme_color_override("font_color", color)

func _build_stat_rows() -> void:
	if stats_container == null:
		return
	
	for child in stats_container.get_children():
		child.queue_free()
	stat_row_nodes.clear()
	
	for i in range(STAT_NAMES.size()):
		var s := STAT_NAMES[i]
		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 4)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# Nhãn tên chỉ số (VIT, STR, ...)
		var name_lbl := Label.new()
		name_lbl.custom_minimum_size = Vector2(28, 12)
		name_lbl.text = s
		name_lbl.add_theme_font_size_override("font_size", 8)
		name_lbl.add_theme_color_override("font_color", Palette.KEM)
		row.add_child(name_lbl)
		
		# Nhãn giá trị
		var val_lbl := Label.new()
		val_lbl.custom_minimum_size = Vector2(40, 12)
		val_lbl.text = "10"
		val_lbl.add_theme_font_size_override("font_size", 8)
		val_lbl.add_theme_color_override("font_color", Palette.KEM)
		row.add_child(val_lbl)
		
		# Nút trừ (-)
		var btn_sub := Button.new()
		btn_sub.custom_minimum_size = Vector2(16, 12)
		btn_sub.text = "-"
		btn_sub.add_theme_font_size_override("font_size", 8)
		btn_sub.focus_mode = Control.FOCUS_NONE
		btn_sub.pressed.connect(func(): _modify_stat(s, -1))
		var s_idx := i
		btn_sub.mouse_entered.connect(func(): selected_index = s_idx; _highlight_selection())
		row.add_child(btn_sub)
		
		# Nút cộng (+)
		var btn_add := Button.new()
		btn_add.custom_minimum_size = Vector2(16, 12)
		btn_add.text = "+"
		btn_add.add_theme_font_size_override("font_size", 8)
		btn_add.focus_mode = Control.FOCUS_NONE
		btn_add.pressed.connect(func(): _modify_stat(s, +1))
		btn_add.mouse_entered.connect(func(): selected_index = s_idx; _highlight_selection())
		row.add_child(btn_add)
		
		stats_container.add_child(row)
		stat_row_nodes.append({
			"stat": s,
			"row": row,
			"name_lbl": name_lbl,
			"val_lbl": val_lbl,
			"btn_sub": btn_sub,
			"btn_add": btn_add
		})

func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("pause") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE):
		_on_cancel_pressed()
		get_viewport().set_input_as_handled()
		return
	
	# Điều hướng Lên / Xuống
	if event.is_action_pressed("move_up") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_UP or event.keycode == KEY_W)):
		_nav_vertical(-1)
		get_viewport().set_input_as_handled()
		return
	elif event.is_action_pressed("move_down") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_DOWN or event.keycode == KEY_S)):
		_nav_vertical(1)
		get_viewport().set_input_as_handled()
		return
	
	# Điều hướng Trái / Phải hoặc +/-
	if selected_index < STAT_NAMES.size():
		var cur_stat := STAT_NAMES[selected_index]
		if event.is_action_pressed("move_left") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_LEFT or event.keycode == KEY_A or event.keycode == KEY_MINUS)):
			_modify_stat(cur_stat, -1)
			get_viewport().set_input_as_handled()
			return
		elif event.is_action_pressed("move_right") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_RIGHT or event.keycode == KEY_D or event.keycode == KEY_EQUAL or event.keycode == KEY_PLUS)):
			_modify_stat(cur_stat, +1)
			get_viewport().set_input_as_handled()
			return
	else:
		# Ở hàng nút Confirm / Cancel
		if event.is_action_pressed("move_left") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_LEFT or event.keycode == KEY_A)):
			selected_index = 6
			_highlight_selection()
			get_viewport().set_input_as_handled()
			return
		elif event.is_action_pressed("move_right") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_RIGHT or event.keycode == KEY_D)):
			selected_index = 7
			_highlight_selection()
			get_viewport().set_input_as_handled()
			return
	
	# Phím Enter / Space / E (Interact)
	if event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER or event.keycode == KEY_SPACE)):
		if selected_index == 6:
			_on_confirm_pressed()
		elif selected_index == 7:
			_on_cancel_pressed()
		elif selected_index < STAT_NAMES.size():
			_modify_stat(STAT_NAMES[selected_index], +1)
		get_viewport().set_input_as_handled()
		return

func _nav_vertical(dir: int) -> void:
	selected_index = clampi(selected_index + dir, 0, 7)
	_highlight_selection()

func _highlight_selection() -> void:
	for i in range(stat_row_nodes.size()):
		var info: Dictionary = stat_row_nodes[i]
		var is_sel: bool = (i == selected_index)
		var name_lbl: Label = info["name_lbl"]
		if is_sel:
			name_lbl.add_theme_color_override("font_color", Palette.VANG_CO)
			name_lbl.text = "> " + info["stat"]
		else:
			name_lbl.add_theme_color_override("font_color", Palette.KEM)
			name_lbl.text = "  " + info["stat"]
	
	if btn_confirm != null:
		if selected_index == 6:
			btn_confirm.add_theme_color_override("font_color", Palette.VANG_CO)
		else:
			btn_confirm.add_theme_color_override("font_color", Palette.KEM)
	
	if btn_cancel != null:
		if selected_index == 7:
			btn_cancel.add_theme_color_override("font_color", Palette.VANG_CO)
		else:
			btn_cancel.add_theme_color_override("font_color", Palette.KEM)

func _get_total_pending_points() -> int:
	var total: int = 0
	for s in pending_adds:
		total += pending_adds[s]
	return total

func _get_total_pending_cost() -> int:
	var total_pts: int = _get_total_pending_points()
	var cur_lvl: int = PlayerInventory.level
	var cost: int = 0
	for i in range(total_pts):
		cost += StatsCalc.calc_level_cost(cur_lvl + i)
	return cost

func _get_next_point_cost() -> int:
	var total_pts: int = _get_total_pending_points()
	return StatsCalc.calc_level_cost(PlayerInventory.level + total_pts)

func _modify_stat(stat_name: String, delta: int) -> void:
	if delta > 0:
		var next_cost: int = _get_next_point_cost()
		var rem_shards: int = PlayerInventory.shell_shards - _get_total_pending_cost()
		if rem_shards >= next_cost:
			pending_adds[stat_name] = pending_adds.get(stat_name, 0) + 1
			var total_pending := _get_total_pending_points()
			_set_feedback("✓ Đã cộng 1 điểm vào %s! (Chờ: %d điểm). Nhấn [Xác nhận] để lưu." % [stat_name, total_pending], Palette.VANG_CO)
		else:
			_set_feedback("⚠️ Thiếu Mảnh Vỏ! Cần %d, còn %d. Nhấn F4 nhận thêm!" % [next_cost, rem_shards], Palette.DO_GACH)
			print("[UI] Không đủ Mảnh Vỏ Vụn để cộng thêm điểm! (Cần %d, còn %d)" % [next_cost, rem_shards])
	elif delta < 0:
		if pending_adds.get(stat_name, 0) > 0:
			pending_adds[stat_name] -= 1
			_set_feedback("Đã bớt 1 điểm chờ của %s." % stat_name, Palette.KEM)
		else:
			_set_feedback("Chỉ số %s chưa có điểm cộng tạm thời nào." % stat_name, Palette.XAM_SAT)
	
	_update_display()

func _update_display() -> void:
	var cur_lvl: int = PlayerInventory.level
	var total_pending_pts: int = _get_total_pending_points()
	var new_lvl: int = cur_lvl + total_pending_pts
	var total_cost: int = _get_total_pending_cost()
	var next_cost: int = _get_next_point_cost()
	var rem_shards: int = PlayerInventory.shell_shards - total_cost
	
	if header_label != null:
		if total_pending_pts > 0:
			header_label.text = "CẤP: %d -> %d | CHI PHÍ TIẾP: %d" % [cur_lvl, new_lvl, next_cost]
		else:
			header_label.text = "CẤP: %d | CHI PHÍ TIẾP: %d" % [cur_lvl, next_cost]
	
	if shards_label != null:
		if total_cost > 0:
			shards_label.text = "MẢNH VỎ VỤN: %d (-%d) | CÒN LẠI: %d" % [PlayerInventory.shell_shards, total_cost, rem_shards]
		else:
			shards_label.text = "MẢNH VỎ VỤN: %d" % [PlayerInventory.shell_shards]
	
	var effective_stats: Dictionary = PlayerInventory.get_effective_stats()
	var preview_stats: Dictionary = {}
	for s in STAT_NAMES:
		preview_stats[s] = int(effective_stats.get(s, 10)) + int(pending_adds.get(s, 0))
	
	# Cập nhật danh sách hàng chỉ số
	for info in stat_row_nodes:
		var s: String = info["stat"]
		var cur_val: int = int(effective_stats.get(s, 10))
		var add: int = int(pending_adds.get(s, 0))
		var val_lbl: Label = info["val_lbl"]
		if add > 0:
			val_lbl.text = "%d (+%d)" % [cur_val, add]
			val_lbl.add_theme_color_override("font_color", Palette.VANG_CO)
		else:
			val_lbl.text = "%d" % cur_val
			val_lbl.add_theme_color_override("font_color", Palette.KEM)
		
		var btn_sub: Button = info["btn_sub"]
		btn_sub.disabled = (add <= 0)
		var btn_add: Button = info["btn_add"]
		# Giữ nút bấm được để khi bấm thiếu shards sẽ báo lỗi trên feedback_label rõ ràng
		if rem_shards < next_cost:
			btn_add.modulate = Color(0.7, 0.7, 0.7, 0.85)
		else:
			btn_add.modulate = Color.WHITE
	
	# Cập nhật phần xem trước bên phải
	_update_preview_section(effective_stats, preview_stats)

func _update_preview_section(cur_stats: Dictionary, new_stats: Dictionary) -> void:
	if preview_vbox == null:
		return
	
	var cur_hp := StatsCalc.calc_max_hp(cur_stats)
	var new_hp := StatsCalc.calc_max_hp(new_stats)
	
	var cur_sta := StatsCalc.calc_max_stamina(cur_stats)
	var new_sta := StatsCalc.calc_max_stamina(new_stats)
	
	var cur_ec := StatsCalc.calc_equip_capacity(cur_stats)
	var new_ec := StatsCalc.calc_equip_capacity(new_stats)
	
	# Tính sát thương vũ khí hiện tại
	var w_data: Dictionary = {}
	if player_ref != null and not player_ref.current_weapon_data.is_empty():
		w_data = player_ref.current_weapon_data
	else:
		w_data = WeaponDB.get_weapon("staff_wood")
	
	var light_chain: Array = w_data.get("light_chain", [])
	var first_spec: Dictionary = light_chain[0] if not light_chain.is_empty() else {"damage_mv": 1.0}
	
	var cur_dmg := StatsCalc.calc_weapon_damage(w_data, first_spec, cur_stats)
	var new_dmg := StatsCalc.calc_weapon_damage(w_data, first_spec, new_stats)
	
	var hp_lbl: Label = preview_vbox.get_node_or_null("HPLabel")
	if hp_lbl != null:
		hp_lbl.text = "HP: %d %s" % [cur_hp, ("-> %d" % new_hp) if new_hp != cur_hp else ""]
		hp_lbl.add_theme_color_override("font_color", Palette.DO_GACH if new_hp > cur_hp else Palette.KEM)
	
	var sta_lbl: Label = preview_vbox.get_node_or_null("StaminaLabel")
	if sta_lbl != null:
		sta_lbl.text = "Thể lực: %.0f %s" % [cur_sta, ("-> %.0f" % new_sta) if new_sta != cur_sta else ""]
		sta_lbl.add_theme_color_override("font_color", Palette.XANH_LA_UA if new_sta > cur_sta else Palette.KEM)
	
	var ec_lbl: Label = preview_vbox.get_node_or_null("CapacityLabel")
	if ec_lbl != null:
		ec_lbl.text = "Sức tải: %.1f %s" % [cur_ec, ("-> %.1f" % new_ec) if new_ec != cur_ec else ""]
		ec_lbl.add_theme_color_override("font_color", Palette.VANG_CO if new_ec > cur_ec else Palette.KEM)
	
	var dmg_lbl: Label = preview_vbox.get_node_or_null("DamageLabel")
	if dmg_lbl != null:
		dmg_lbl.text = "Sát thương: %d %s" % [cur_dmg, ("-> %d" % new_dmg) if new_dmg != cur_dmg else ""]
		dmg_lbl.add_theme_color_override("font_color", Palette.CAT if new_dmg > cur_dmg else Palette.KEM)

func _on_confirm_pressed() -> void:
	var total_pts: int = _get_total_pending_points()
	if total_pts > 0:
		if PlayerInventory.apply_multiple_stats(pending_adds):
			if player_ref != null and is_instance_valid(player_ref) and player_ref.has_method("apply_leveled_stats"):
				player_ref.apply_leveled_stats()
			SaveManager.save_game()
			print("[UI] Đã xác nhận tăng cấp thành công! Cấp mới: %d" % PlayerInventory.level)
	close_screen()

func _on_cancel_pressed() -> void:
	close_screen()
```

---

## scripts\world\straw_bed.gd
```gdscript
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
```

---

## tools\generate_run_roll_sprites.gd
```gdscript
extends SceneTree

# ============================================================
# Màu sắc Palette GDD (16 màu cố định)
# ============================================================
const C_OUTLINE : Color = Color("#2B1F1A")  # Nâu Hầm
const C_SHELL   : Color = Color("#E8D9B0")  # Giấy Da
const C_LIGHT   : Color = Color("#F4EBD0")  # Kem
const C_SHADOW  : Color = Color("#D4A86A")  # Cát
const C_SPOT    : Color = Color("#A0693B")  # Nâu Da (đốm vỏ)
const C_TRANSP  : Color = Color(0, 0, 0, 0) # Trong suốt

const OUT_DIR   : String = "d:/game/vo-vo/assets/sprites/player/"
const PREV_DIR  : String = "C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c/"
const W         : int = 32
const H         : int = 32

# ============================================================
# HELPERS
# ============================================================
func px(img: Image, x: int, y: int, c: Color) -> void:
	if x >= 0 and x < W and y >= 0 and y < H:
		img.set_pixel(x, y, c)

func new_frame() -> Image:
	var img := Image.create(W, H, true, Image.FORMAT_RGBA8)
	img.fill(C_TRANSP)
	return img

func draw_body_base(img: Image, cx: int, cy: int) -> void:
	# Vẽ thân trứng tại tâm (cx, cy) – elipse ~14x16
	for dy in range(-8, 9):
		for dx in range(-7, 8):
			var nx : float = float(dx) / 7.0
			var ny : float = float(dy) / 8.0
			if nx * nx + ny * ny <= 1.0:
				var c : Color = C_SHELL
				# Highlight bên trái trên
				if nx < -0.3 and ny < -0.2:
					c = C_LIGHT
				# Shadow bên phải dưới
				if nx > 0.35 and ny > 0.25:
					c = C_SHADOW
				px(img, cx + dx, cy + dy, c)

func draw_body_outline(img: Image, cx: int, cy: int) -> void:
	for dy in range(-9, 10):
		for dx in range(-8, 9):
			var nx : float = float(dx) / 7.5
			var ny : float = float(dy) / 8.5
			if nx * nx + ny * ny <= 1.0:
				var inside_nx : float = float(dx) / 6.5
				var inside_ny : float = float(dy) / 7.5
				if inside_nx * inside_nx + inside_ny * inside_ny > 1.0:
					px(img, cx + dx, cy + dy, C_OUTLINE)

func draw_eyes_down(img: Image, cx: int, cy: int) -> void:
	# Mắt nhìn xuống: hai chấm tròn
	px(img, cx - 2, cy - 2, C_OUTLINE)
	px(img, cx - 2, cy - 1, C_OUTLINE)
	px(img, cx + 1, cy - 2, C_OUTLINE)
	px(img, cx + 1, cy - 1, C_OUTLINE)
	# Gleam trắng nhỏ
	px(img, cx - 2, cy - 2, C_LIGHT)
	px(img, cx + 1, cy - 2, C_LIGHT)
	# Đồng tử dưới
	px(img, cx - 2, cy - 1, C_OUTLINE)
	px(img, cx + 1, cy - 1, C_OUTLINE)

func draw_spot(img: Image, cx: int, cy: int) -> void:
	px(img, cx - 3, cy - 5, C_SPOT)
	px(img, cx + 2, cy - 6, C_SPOT)
	px(img, cx - 1, cy + 2, C_SPOT)

# ============================================================
# VẼ TAY – stick limb dạng que rõ ràng
# ============================================================
func draw_arm_left(img: Image, cx: int, body_mid_y: int, swing: int) -> void:
	# Vai trái
	var sx : int = cx - 8
	var sy : int = body_mid_y - 1
	px(img, sx, sy, C_OUTLINE)
	# Cánh tay xuống + swing
	px(img, sx - 1, sy + 1 + swing, C_OUTLINE)
	px(img, sx - 1, sy + 2 + swing, C_OUTLINE)
	# Bàn tay (2x2)
	px(img, sx - 2, sy + 3 + swing, C_OUTLINE)
	px(img, sx - 1, sy + 3 + swing, C_OUTLINE)

func draw_arm_right(img: Image, cx: int, body_mid_y: int, swing: int) -> void:
	# Vai phải
	var sx : int = cx + 7
	var sy : int = body_mid_y - 1
	px(img, sx, sy, C_OUTLINE)
	# Cánh tay xuống + swing
	px(img, sx + 1, sy + 1 - swing, C_OUTLINE)
	px(img, sx + 1, sy + 2 - swing, C_OUTLINE)
	# Bàn tay (2x2)
	px(img, sx + 1, sy + 3 - swing, C_OUTLINE)
	px(img, sx + 2, sy + 3 - swing, C_OUTLINE)

# ============================================================
# VẼ CHÂN – stick limb
# ============================================================
func draw_legs_run(img: Image, cx: int, ground_y: int, phase: int) -> void:
	# phase 0-5: chân trái/phải đổi bước
	var left_lift  : int = [0, 2, 3, 0, -2, -1][phase]
	var right_lift : int = [0, -2, -1, 0, 2, 3][phase]

	# Chân trái
	var lx : int = cx - 3
	px(img, lx, ground_y - 5, C_OUTLINE)
	px(img, lx, ground_y - 4, C_OUTLINE)
	px(img, lx - 1, ground_y - 3 + left_lift, C_OUTLINE)
	px(img, lx - 1, ground_y - 2 + left_lift, C_OUTLINE)
	# Bàn chân trái
	px(img, lx - 2, ground_y - 1 + left_lift, C_OUTLINE)
	px(img, lx - 1, ground_y - 1 + left_lift, C_OUTLINE)

	# Chân phải
	var rx : int = cx + 2
	px(img, rx, ground_y - 5, C_OUTLINE)
	px(img, rx, ground_y - 4, C_OUTLINE)
	px(img, rx + 1, ground_y - 3 + right_lift, C_OUTLINE)
	px(img, rx + 1, ground_y - 2 + right_lift, C_OUTLINE)
	# Bàn chân phải
	px(img, rx + 1, ground_y - 1 + right_lift, C_OUTLINE)
	px(img, rx + 2, ground_y - 1 + right_lift, C_OUTLINE)

# ============================================================
# RUN DOWN – thân nhìn thẳng, chân đổi bước, tay vung ngược
# ============================================================
func make_run_down() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	var arm_swings : Array[int] = [0, 2, 1, 0, -2, -1]
	var body_bobs  : Array[int] = [0, -1, -1, 0, -1, -1]  # thân nảy lên nhẹ

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 14 + body_bobs[f]
		var gy : int = 30  # ground_y cố định

		draw_body_outline(frame, cx, cy)
		draw_body_base(frame, cx, cy)
		draw_spot(frame, cx, cy)
		draw_eyes_down(frame, cx, cy)
		draw_arm_left(frame, cx, cy, arm_swings[f])
		draw_arm_right(frame, cx, cy, arm_swings[f])
		draw_legs_run(frame, cx, gy, f)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# RUN UP – thân mặt sau, chân đổi bước
# ============================================================
func draw_body_back(img: Image, cx: int, cy: int) -> void:
	# Vỏ mặt sau – giống nhưng không có mắt, có đốm khác
	draw_body_base(img, cx, cy)
	# Đốm mặt sau
	px(img, cx - 2, cy - 5, C_SPOT)
	px(img, cx + 3, cy - 4, C_SPOT)
	px(img, cx,     cy + 1, C_SPOT)
	# Tóc/đỉnh nổi lên thêm một chút
	px(img, cx - 1, cy - 9, C_OUTLINE)
	px(img, cx,     cy - 9, C_OUTLINE)

func make_run_up() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	var arm_swings : Array[int] = [0, 2, 1, 0, -2, -1]
	var body_bobs  : Array[int] = [0, -1, -1, 0, -1, -1]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 14 + body_bobs[f]
		var gy : int = 30

		draw_body_outline(frame, cx, cy)
		draw_body_back(frame, cx, cy)
		draw_arm_left(frame, cx, cy, arm_swings[f])
		draw_arm_right(frame, cx, cy, arm_swings[f])
		draw_legs_run(frame, cx, gy, f)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# RUN SIDE – nhìn nghiêng phải (flip_h cho trái)
# ============================================================
func draw_body_side(img: Image, cx: int, cy: int) -> void:
	for dy in range(-8, 9):
		for dx in range(-6, 7):
			var nx : float = float(dx) / 6.0
			var ny : float = float(dy) / 8.0
			if nx * nx + ny * ny <= 1.0:
				var c : Color = C_SHELL
				if nx < -0.4 and ny < -0.2:
					c = C_LIGHT
				if nx > 0.3 and ny > 0.3:
					c = C_SHADOW
				px(img, cx + dx, cy + dy, c)
	# Outline
	for dy in range(-9, 10):
		for dx in range(-7, 8):
			var nx : float = float(dx) / 6.5
			var ny : float = float(dy) / 8.5
			if nx * nx + ny * ny <= 1.0:
				var ins_nx : float = float(dx) / 5.5
				var ins_ny : float = float(dy) / 7.5
				if ins_nx * ins_nx + ins_ny * ins_ny > 1.0:
					px(img, cx + dx, cy + dy, C_OUTLINE)

func draw_eyes_side(img: Image, cx: int, cy: int, blink: bool) -> void:
	if blink:
		# Mắt nhắm (1 đường ngang)
		px(img, cx + 2, cy - 2, C_OUTLINE)
		px(img, cx + 3, cy - 2, C_OUTLINE)
	else:
		px(img, cx + 2, cy - 3, C_OUTLINE)
		px(img, cx + 2, cy - 2, C_OUTLINE)
		px(img, cx + 3, cy - 3, C_OUTLINE)
		px(img, cx + 3, cy - 2, C_OUTLINE)
		# Gleam
		px(img, cx + 2, cy - 3, C_LIGHT)

func draw_legs_side_run(img: Image, cx: int, gy: int, phase: int) -> void:
	# Nhìn nghiêng: chỉ thấy 2 chân rõ (trước/sau)
	var front_lift : int = [0, 3, 2, 0, -2, -1][phase]
	var back_lift  : int = [0, -2, -1, 0, 3, 2][phase]

	# Chân sau (mờ hơn – nhạt hơn)
	px(img, cx - 1, gy - 4, C_SHADOW)
	px(img, cx - 1, gy - 3, C_SHADOW)
	px(img, cx - 2, gy - 2 + back_lift, C_SHADOW)
	px(img, cx - 2, gy - 1 + back_lift, C_SHADOW)
	px(img, cx - 3, gy + back_lift, C_SHADOW)

	# Chân trước (đậm)
	px(img, cx + 1, gy - 4, C_OUTLINE)
	px(img, cx + 1, gy - 3, C_OUTLINE)
	px(img, cx + 2, gy - 2 + front_lift, C_OUTLINE)
	px(img, cx + 2, gy - 1 + front_lift, C_OUTLINE)
	px(img, cx + 2, gy + front_lift,     C_OUTLINE)
	px(img, cx + 3, gy + front_lift,     C_OUTLINE)

func draw_arms_side_run(img: Image, cx: int, cy: int, phase: int) -> void:
	# Tay phía sau (nhạt)
	var back_sw : int = [0, -2, -1, 0, 2, 1][phase]
	px(img, cx - 4, cy,     C_SHADOW)
	px(img, cx - 5, cy + 1 + back_sw, C_SHADOW)
	px(img, cx - 5, cy + 2 + back_sw, C_SHADOW)
	px(img, cx - 6, cy + 3 + back_sw, C_SHADOW)

	# Tay phía trước (đậm)
	var front_sw : int = [0, 2, 1, 0, -2, -1][phase]
	px(img, cx + 5, cy,     C_OUTLINE)
	px(img, cx + 5, cy + 1 + front_sw, C_OUTLINE)
	px(img, cx + 5, cy + 2 + front_sw, C_OUTLINE)
	px(img, cx + 6, cy + 3 + front_sw, C_OUTLINE)

func make_run_side() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	var body_bobs  : Array[int] = [0, -1, -1, 0, -1, -1]
	var blink_frames : Array[bool] = [false, false, false, false, false, false]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 15
		var cy : int = 14 + body_bobs[f]
		var gy : int = 30

		draw_body_side(frame, cx, cy)
		# Đốm vỏ bên cạnh
		px(frame, cx - 3, cy - 4, C_SPOT)
		px(frame, cx + 1, cy - 6, C_SPOT)
		px(frame, cx - 1, cy + 2, C_SPOT)
		draw_eyes_side(frame, cx, cy, blink_frames[f])
		draw_arms_side_run(frame, cx, cy, f)
		draw_legs_side_run(frame, cx, gy, f)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# ROLL – trứng cuộn tròn (xoay hình oval, tay chân thu lại)
# ============================================================
func make_roll_down() -> Image:
	# 6 khung: trứng nghiêng, xoay tròn, thu tứ chi
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	# Góc nghiêng mỗi khung (độ) – xoay: 0→30→60→90→120→150
	var tilts : Array[int] = [0, 30, 60, 90, 120, 150]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 16
		var tilt_deg : float = float(tilts[f])
		var tilt_rad : float = deg_to_rad(tilt_deg)

		# Vẽ thân hình oval xoay
		for dy in range(-9, 10):
			for dx in range(-9, 10):
				# Biến đổi tọa độ theo góc xoay
				var rx : float = float(dx) * cos(tilt_rad) + float(dy) * sin(tilt_rad)
				var ry : float = -float(dx) * sin(tilt_rad) + float(dy) * cos(tilt_rad)
				var nx : float = rx / 7.0
				var ny : float = ry / 9.0
				# Outline
				var onx : float = rx / 7.5
				var ony : float = ry / 9.5
				if onx * onx + ony * ony <= 1.0 and nx * nx + ny * ny > 1.0:
					px(frame, cx + dx, cy + dy, C_OUTLINE)
				elif nx * nx + ny * ny <= 1.0:
					# Gradient màu theo góc
					var c : Color = C_SHELL
					# Vùng sáng phần nhỏ của oval
					if rx < -2.0 and ry < -2.0:
						c = C_LIGHT
					# Vùng bóng
					if rx > 2.0 and ry > 2.0:
						c = C_SHADOW
					px(frame, cx + dx, cy + dy, c)

		# Đốm vỏ quay theo oval (cố định tương đối)
		var sp1x : int = int(cx + (-3) * cos(tilt_rad) + (-5) * sin(tilt_rad))
		var sp1y : int = int(cy - (-3) * sin(tilt_rad) + (-5) * cos(tilt_rad))
		var sp2x : int = int(cx + 3 * cos(tilt_rad) + (-4) * sin(tilt_rad))
		var sp2y : int = int(cy - 3 * sin(tilt_rad) + (-4) * cos(tilt_rad))
		px(frame, sp1x, sp1y, C_SPOT)
		px(frame, sp2x, sp2y, C_SPOT)

		# Tay chân thu vào – chỉ 2-3 px ló ra quanh rìa
		# Khung 0-1: vẫn còn tay chân; 2-5: thu hoàn toàn
		if f <= 1:
			# Chân nhỏ ở đáy
			px(frame, cx - 2, cy + 8, C_OUTLINE)
			px(frame, cx + 1, cy + 8, C_OUTLINE)
			# Tay nhỏ hai bên
			px(frame, cx - 9, cy - 1, C_OUTLINE)
			px(frame, cx + 8, cy - 1, C_OUTLINE)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

func make_roll_up() -> Image:
	# Giống roll_down nhưng theo hướng ngược (dùng bản sao roll_down ở giai đoạn này)
	return make_roll_down()

func make_roll_side() -> Image:
	var strip := Image.create(W * 6, H, true, Image.FORMAT_RGBA8)
	strip.fill(C_TRANSP)

	# Roll ngang: oval nghiêng sang phải → thẳng → nghiêng sang trái → ...
	var tilts : Array[int] = [0, 30, 60, 90, 120, 150]

	for f in range(6):
		var frame := new_frame()
		var cx : int = 16
		var cy : int = 15
		var tilt_rad : float = deg_to_rad(float(tilts[f]))

		for dy in range(-9, 10):
			for dx in range(-9, 10):
				var rx : float = float(dx) * cos(tilt_rad) + float(dy) * sin(tilt_rad)
				var ry : float = -float(dx) * sin(tilt_rad) + float(dy) * cos(tilt_rad)
				var nx : float = rx / 6.5
				var ny : float = ry / 9.0
				var onx : float = rx / 7.0
				var ony : float = ry / 9.5
				if onx * onx + ony * ony <= 1.0 and nx * nx + ny * ny > 1.0:
					px(frame, cx + dx, cy + dy, C_OUTLINE)
				elif nx * nx + ny * ny <= 1.0:
					var c : Color = C_SHELL
					if rx < -2.0 and ry < -2.0:
						c = C_LIGHT
					if rx > 2.0 and ry > 2.0:
						c = C_SHADOW
					px(frame, cx + dx, cy + dy, c)

		px(frame, int(cx + (-2) * cos(tilt_rad) + (-5) * sin(tilt_rad)),
		          int(cy - (-2) * sin(tilt_rad) + (-5) * cos(tilt_rad)), C_SPOT)
		px(frame, int(cx + 3 * cos(tilt_rad) + (-3) * sin(tilt_rad)),
		          int(cy - 3 * sin(tilt_rad) + (-3) * cos(tilt_rad)), C_SPOT)

		if f <= 1:
			px(frame, cx - 8, cy, C_OUTLINE)
			px(frame, cx + 7, cy, C_OUTLINE)
			px(frame, cx,     cy + 8, C_OUTLINE)
			px(frame, cx + 1, cy + 8, C_OUTLINE)

		strip.blit_rect(frame, Rect2i(0, 0, W, H), Vector2i(f * W, 0))

	return strip

# ============================================================
# PREVIEW helper: phóng to x5 và ghép hàng ngang
# ============================================================
func make_preview(strip: Image, label_y: int) -> Image:
	var frames_w : int = strip.get_width() / W
	var prev := Image.create(frames_w * W * 5, H * 5, false, Image.FORMAT_RGBA8)
	prev.fill(Color("#1A1A2E"))  # Nền tối
	for f in range(frames_w):
		for py in range(H):
			for ppx in range(W):
				var c := strip.get_pixel(f * W + ppx, py)
				for sy in range(5):
					for sx in range(5):
						prev.set_pixel(f * W * 5 + ppx * 5 + sx, py * 5 + sy, c)
	return prev

func save_png(img: Image, path: String) -> void:
	var err := img.save_png(path)
	if err == OK:
		print("[OK] Đã lưu: " + path)
	else:
		print("[ERR] Lỗi lưu: " + path + " code=" + str(err))

# ============================================================
# MAIN
# ============================================================
func _init() -> void:
	print("=== Bắt đầu tạo sprite Run & Roll ===")

	# --- RUN ---
	var run_down := make_run_down()
	var run_up   := make_run_up()
	var run_side := make_run_side()
	save_png(run_down, OUT_DIR + "player_egg_run_down.png")
	save_png(run_up,   OUT_DIR + "player_egg_run_up.png")
	save_png(run_side, OUT_DIR + "player_egg_run_side.png")

	# --- ROLL ---
	var roll_down := make_roll_down()
	var roll_up   := make_roll_up()
	var roll_side := make_roll_side()
	save_png(roll_down, OUT_DIR + "player_egg_roll_down.png")
	save_png(roll_up,   OUT_DIR + "player_egg_roll_up.png")
	save_png(roll_side, OUT_DIR + "player_egg_roll_side.png")

	# --- PREVIEW ---
	var prev_run_down := make_preview(run_down, 0)
	var prev_run_up   := make_preview(run_up,   0)
	var prev_run_side := make_preview(run_side, 0)
	var prev_roll_down := make_preview(roll_down, 0)
	var prev_roll_side := make_preview(roll_side, 0)

	save_png(prev_run_down,  PREV_DIR + "preview_run_down.png")
	save_png(prev_run_up,    PREV_DIR + "preview_run_up.png")
	save_png(prev_run_side,  PREV_DIR + "preview_run_side.png")
	save_png(prev_roll_down, PREV_DIR + "preview_roll_down.png")
	save_png(prev_roll_side, PREV_DIR + "preview_roll_side.png")

	print("=== Hoàn tất ===")
	quit(0)
```

---

## tools\generate_run_roll_v2.gd
```gdscript
extends SceneTree

# ============================================================
# Palette GDD – 16 màu cố định
# ============================================================
const C_OUT  : Color = Color("#2B1F1A")  # Nâu Hầm (viền)
const C_BODY : Color = Color("#E8D9B0")  # Giấy Da
const C_LIT  : Color = Color("#F4EBD0")  # Kem (highlight)
const C_SHD  : Color = Color("#D4A86A")  # Cát (shadow)
const C_SPOT : Color = Color("#A0693B")  # Nâu Da (đốm)
const C_MOUT : Color = Color("#6E1423")  # Đỏ Rượu (khoang miệng)
const C_TONG : Color = Color("#A8342B")  # Đỏ Gạch (lưỡi)
const C_EYE  : Color = Color("#F4EBD0")  # Kem (lòng trắng mắt)
const C_TR   : Color = Color(0,0,0,0)   # Trong suốt

const SPRITES_DIR : String = "d:/game/vo-vo/assets/sprites/player/"
const PREV_DIR    : String = "C:/Users/behoa/.gemini/antigravity/brain/62492e13-e916-43f0-bd2c-66b632ffed5c/"
const W : int = 32
const H : int = 32

# ============================================================
# HELPER: đặt pixel an toàn
# ============================================================
func px(img: Image, x: int, y: int, c: Color) -> void:
	if x >= 0 and x < img.get_width() and y >= 0 and y < H:
		img.set_pixel(x, y, c)

func new_img(frames: int) -> Image:
	var img := Image.create(W * frames, H, true, Image.FORMAT_RGBA8)
	img.fill(C_TR)
	return img

# ============================================================
# BODY: thân trứng to, tròn, chiếm gần hết 32x32
# Tâm tại (cx, cy), bán kính ngang rw, dọc rh
# ============================================================
func draw_body(img: Image, cx: int, cy: int, rw: float, rh: float) -> void:
	var ox : int = 0
	var x_start : int = cx
	# Outline trước
	for dy in range(-int(rh)-2, int(rh)+3):
		for dx in range(-int(rw)-2, int(rw)+3):
			var nx : float = float(dx)/( rw + 1.0)
			var ny : float = float(dy)/(rh + 1.0)
			var ins_nx : float = float(dx)/rw
			var ins_ny : float = float(dy)/rh
			if nx*nx + ny*ny <= 1.0 and ins_nx*ins_nx + ins_ny*ins_ny > 1.0:
				px(img, cx+dx, cy+dy, C_OUT)
	# Fill bên trong
	for dy in range(-int(rh)-1, int(rh)+2):
		for dx in range(-int(rw)-1, int(rw)+2):
			var nx : float = float(dx)/rw
			var ny : float = float(dy)/rh
			if nx*nx + ny*ny <= 1.0:
				var c : Color = C_BODY
				# Highlight trái-trên
				if nx < -0.25 and ny < -0.1:
					c = C_LIT
				# Shadow phải-dưới
				if nx > 0.30 and ny > 0.20:
					c = C_SHD
				px(img, cx+dx, cy+dy, c)

func draw_spots(img: Image, cx: int, cy: int) -> void:
	# Đốm vỏ: 3-4 đốm nhỏ phân bố tự nhiên
	px(img, cx-4, cy-5, C_SPOT)
	px(img, cx+3, cy-6, C_SPOT)
	px(img, cx-2, cy+3, C_SPOT)
	px(img, cx+5, cy+1, C_SPOT)

func draw_spots_back(img: Image, cx: int, cy: int) -> void:
	# Đốm mặt sau – vị trí khác
	px(img, cx-5, cy-3, C_SPOT)
	px(img, cx+2, cy-5, C_SPOT)
	px(img, cx-1, cy+4, C_SPOT)
	px(img, cx+4, cy-1, C_SPOT)

# ============================================================
# MẮT – hướng xuống (nhìn thẳng)
# Hai ô vuông 2x2 với lòng trắng và đồng tử
# ============================================================
func draw_eyes_front(img: Image, cx: int, cy: int, squish: int) -> void:
	# Lòng trắng trái
	px(img, cx-4, cy-2+squish, C_EYE)
	px(img, cx-3, cy-2+squish, C_EYE)
	px(img, cx-4, cy-1+squish, C_EYE)
	px(img, cx-3, cy-1+squish, C_EYE)
	# Đồng tử trái
	px(img, cx-3, cy-1+squish, C_OUT)
	# Lòng trắng phải
	px(img, cx+2, cy-2+squish, C_EYE)
	px(img, cx+3, cy-2+squish, C_EYE)
	px(img, cx+2, cy-1+squish, C_EYE)
	px(img, cx+3, cy-1+squish, C_EYE)
	# Đồng tử phải
	px(img, cx+3, cy-1+squish, C_OUT)

func draw_mouth_front(img: Image, cx: int, cy: int, open_w: int) -> void:
	# Khoang miệng to, hình chữ U rộng
	for dx in range(-open_w, open_w+1):
		px(img, cx+dx, cy+2, C_MOUT)
		px(img, cx+dx, cy+3, C_MOUT)
	px(img, cx-open_w-1, cy+3, C_MOUT)
	px(img, cx+open_w+1, cy+3, C_MOUT)
	# Lưỡi
	px(img, cx-1, cy+4, C_TONG)
	px(img, cx,   cy+4, C_TONG)
	px(img, cx+1, cy+4, C_TONG)

# ============================================================
# MẮT – hướng ngang (nhìn nghiêng phải)
# ============================================================
func draw_eye_side(img: Image, cx: int, cy: int, squish: int) -> void:
	# Chỉ thấy 1 mắt
	px(img, cx+3, cy-2+squish, C_EYE)
	px(img, cx+4, cy-2+squish, C_EYE)
	px(img, cx+3, cy-1+squish, C_EYE)
	px(img, cx+4, cy-1+squish, C_EYE)
	# Đồng tử
	px(img, cx+4, cy-1+squish, C_OUT)

func draw_mouth_side(img: Image, cx: int, cy: int) -> void:
	# Miệng mở hướng phải – nhìn thấy cạnh
	px(img, cx+5, cy+1, C_MOUT)
	px(img, cx+6, cy+1, C_MOUT)
	px(img, cx+5, cy+2, C_MOUT)
	px(img, cx+6, cy+2, C_MOUT)
	px(img, cx+6, cy+3, C_MOUT)
	# Lưỡi nhỏ
	px(img, cx+6, cy+2, C_TONG)
	px(img, cx+7, cy+2, C_TONG)

# ============================================================
# CHÂN – ngắn, to, rõ bước như trong tham khảo
# ============================================================
func draw_feet_run(img: Image, cx: int, base_y: int, phase: int) -> void:
	# 6 pha: chân trái/phải đổi bước
	# lift > 0 = chân nhấc lên (giảm y)
	var lift_table : Array = [
		[0, 0],   # pha 0: cả hai chân đất
		[2, -1],  # pha 1: trái nhấc, phải sau
		[3, -2],  # pha 2: trái cao nhất
		[0, 0],   # pha 3: đổi chân
		[-1, 2],  # pha 4: phải nhấc
		[-2, 3],  # pha 5: phải cao nhất
	]
	var lifts : Array = lift_table[phase]

	# Chân trái (2px rộng)
	var lx : int = cx - 4
	var ly : int = base_y - int(lifts[0])
	px(img, lx,   ly-3, C_OUT)
	px(img, lx+1, ly-3, C_OUT)
	px(img, lx,   ly-2, C_OUT)
	px(img, lx+1, ly-2, C_OUT)
	# Bàn chân trái (3px ngang)
	px(img, lx-1, ly-1, C_OUT)
	px(img, lx,   ly-1, C_OUT)
	px(img, lx+1, ly-1, C_OUT)

	# Chân phải (2px rộng)
	var rx : int = cx + 3
	var ry : int = base_y - int(lifts[1])
	px(img, rx,   ry-3, C_OUT)
	px(img, rx+1, ry-3, C_OUT)
	px(img, rx,   ry-2, C_OUT)
	px(img, rx+1, ry-2, C_OUT)
	# Bàn chân phải
	px(img, rx,   ry-1, C_OUT)
	px(img, rx+1, ry-1, C_OUT)
	px(img, rx+2, ry-1, C_OUT)

# Chân cho hướng nghiêng – nhìn từ bên
func draw_feet_side_run(img: Image, cx: int, base_y: int, phase: int) -> void:
	var phases_front : Array[int] = [0, 2, 3, 0, -2, -1]
	var phases_back  : Array[int] = [0, -2, -1, 0, 2, 3]
	var fl := phases_front[phase]
	var bl := phases_back[phase]

	# Chân sau (hơi nhạt)
	var bx := cx - 2
	var by := base_y - bl
	px(img, bx,   by-3, C_SHD)
	px(img, bx+1, by-3, C_SHD)
	px(img, bx,   by-2, C_SHD)
	px(img, bx-1, by-1, C_SHD)
	px(img, bx,   by-1, C_SHD)

	# Chân trước (đậm)
	var fx := cx + 2
	var fy := base_y - fl
	px(img, fx,   fy-3, C_OUT)
	px(img, fx+1, fy-3, C_OUT)
	px(img, fx,   fy-2, C_OUT)
	px(img, fx+1, fy-2, C_OUT)
	px(img, fx+1, fy-1, C_OUT)
	px(img, fx+2, fy-1, C_OUT)

# ============================================================
# TAY – nhỏ, sát thân, vung nhẹ khi chạy
# ============================================================
func draw_arms_front(img: Image, cx: int, cy: int, swing: int) -> void:
	# Tay trái
	px(img, cx-7, cy+swing,   C_OUT)
	px(img, cx-8, cy+swing,   C_OUT)
	px(img, cx-8, cy+1+swing, C_OUT)
	# Tay phải
	px(img, cx+6, cy-swing,   C_OUT)
	px(img, cx+7, cy-swing,   C_OUT)
	px(img, cx+7, cy+1-swing, C_OUT)

func draw_arms_side(img: Image, cx: int, cy: int, swing: int) -> void:
	# Chỉ thấy 1 tay rõ (trước) và gợi tay sau
	# Tay sau (nhạt)
	px(img, cx-5, cy+swing,   C_SHD)
	px(img, cx-6, cy+swing,   C_SHD)
	# Tay trước (đậm)
	px(img, cx+5, cy-swing,   C_OUT)
	px(img, cx+6, cy-swing,   C_OUT)
	px(img, cx+6, cy+1-swing, C_OUT)

# ============================================================
# RUN DOWN – mặt trước nhìn thẳng
# ============================================================
func make_run_down() -> Image:
	var img := new_img(6)
	# Thân nảy nhẹ lên khi chạy
	var bobs    : Array[int] = [0, -1, 0, 0, -1, 0]
	var squish  : Array[int] = [0,  0, 0, 0,  0, 0]
	var swings  : Array[int] = [0,  1, 0, 0, -1, 0]

	for f in range(6):
		var cx := 16
		var cy := 14 + bobs[f]
		var base_y := 30

		draw_body(img, cx + f*W, cy, 9.0, 10.0)
		draw_spots(img, cx + f*W, cy)
		draw_eyes_front(img, cx + f*W, cy, squish[f])
		draw_mouth_front(img, cx + f*W, cy, 2)
		draw_arms_front(img, cx + f*W, cy, swings[f])
		draw_feet_run(img, cx + f*W, base_y, f)

	return img

# ============================================================
# RUN UP – mặt sau
# ============================================================
func make_run_up() -> Image:
	var img := new_img(6)
	var bobs : Array[int] = [0, -1, 0, 0, -1, 0]
	var swings : Array[int] = [0, 1, 0, 0, -1, 0]

	for f in range(6):
		var cx := 16
		var cy := 14 + bobs[f]
		var base_y := 30

		draw_body(img, cx + f*W, cy, 9.0, 10.0)
		draw_spots_back(img, cx + f*W, cy)
		# Không vẽ mắt/miệng (mặt sau)
		# Nhưng vẫn vẽ tay/chân
		draw_arms_front(img, cx + f*W, cy, swings[f])
		draw_feet_run(img, cx + f*W, base_y, f)

	return img

# ============================================================
# RUN SIDE – nhìn nghiêng phải
# ============================================================
func make_run_side() -> Image:
	var img := new_img(6)
	var bobs   : Array[int] = [0, -1, 0, 0, -1, 0]
	var squish : Array[int] = [0,  0, 0, 0,  0, 0]
	var swings : Array[int] = [0,  1, 0, 0, -1, 0]

	for f in range(6):
		# Thân hơi dẹt ngang khi nhìn nghiêng
		var cx := 15
		var cy := 14 + bobs[f]
		var base_y := 30

		draw_body(img, cx + f*W, cy, 8.0, 10.0)
		# Đốm bên hông
		px(img, cx + f*W - 4, cy - 3, C_SPOT)
		px(img, cx + f*W + 2, cy - 5, C_SPOT)
		px(img, cx + f*W - 1, cy + 3, C_SPOT)

		draw_eye_side(img, cx + f*W, cy, squish[f])
		draw_mouth_side(img, cx + f*W, cy)
		draw_arms_side(img, cx + f*W, cy, swings[f])
		draw_feet_side_run(img, cx + f*W, base_y, f)

	return img

# ============================================================
# ROLL – thu dần vào, xoay tròn
# Hàng 4 tham khảo: còn thấy mắt, thu tay chân vào
# Hàng 5: oval tròn hoàn toàn
# Hàng 6: bắt đầu mở ra (nhỏ hơn)
# → Tôi mô phỏng: 6 khung liên tục
#   0-1: còn mặt, thu tay chân
#   2-3: oval hoàn toàn, xoay
#   4-5: bắt đầu mở ra lại
# ============================================================
func draw_roll_body(img: Image, ox: int, cx: int, cy: int, 
					rw: float, rh: float, angle: float) -> void:
	# Vẽ oval xoay góc angle (radian)
	var ca := cos(angle)
	var sa := sin(angle)
	# Outline
	for dy in range(-13, 14):
		for dx in range(-13, 14):
			var rx : float = float(dx)*ca + float(dy)*sa
			var ry : float = -float(dx)*sa + float(dy)*ca
			var nx : float = rx/(rw+1.0)
			var ny : float = ry/(rh+1.0)
			var inx : float = rx/rw
			var iny : float = ry/rh
			if nx*nx+ny*ny <= 1.0 and inx*inx+iny*iny > 1.0:
				px(img, ox+cx+dx, cy+dy, C_OUT)
	# Fill
	for dy in range(-12, 13):
		for dx in range(-12, 13):
			var rx : float = float(dx)*ca + float(dy)*sa
			var ry : float = -float(dx)*sa + float(dy)*ca
			var nx : float = rx/rw
			var ny : float = ry/rh
			if nx*nx+ny*ny <= 1.0:
				var c : Color = C_BODY
				if rx < -1.5 and ry < -1.5:
					c = C_LIT
				if rx > 1.5 and ry > 1.5:
					c = C_SHD
				px(img, ox+cx+dx, cy+dy, c)

func make_roll_all() -> Array:
	# Trả về [roll_down, roll_up, roll_side] – dùng chung logic
	var results : Array = []
	for variant in range(3):  # 0=down, 1=up, 2=side
		var img := new_img(6)

		# Kích thước ban đầu (hơi dẹt đứng, như thân chạy)
		# → thu dần thành tròn → rồi oval ngang nhỏ hơn
		var rws : Array[float] = [9.0, 8.5, 9.5, 10.0, 9.5, 8.5]
		var rhs : Array[float] = [10.0, 9.5, 9.0, 9.5, 10.0, 10.5]
		# Góc xoay từng khung (rad)
		var angles : Array[float] = [0.0, 0.52, 1.05, 1.57, 2.09, 2.62]
		# Vị trí cy thay đổi (thu thân lên cao)
		var cys : Array[int] = [15, 15, 16, 16, 15, 15]

		for f in range(6):
			var cx := 16
			var cy : int = cys[f]
			var rw : float = rws[f]
			var rh : float = rhs[f]
			var angle : float = angles[f]

			draw_roll_body(img, f*W, cx, cy, rw, rh, angle)

			# Đốm quay theo oval
			var sp1x := int(cx + (-3.0)*cos(angle) + (-5.0)*sin(angle))
			var sp1y := int(cy + 3.0*sin(angle) + (-5.0)*cos(angle))
			var sp2x := int(cx + 3.0*cos(angle) + (-3.0)*sin(angle))
			var sp2y := int(cy + (-3.0)*sin(angle) + (-3.0)*cos(angle))
			px(img, f*W + sp1x, sp1y, C_SPOT)
			px(img, f*W + sp2x, sp2y, C_SPOT)

			# Khung 0-1: vẫn còn thấy mặt và chân nhỏ
			if f <= 1:
				# Mắt nhỏ chớp (thu dần)
				if variant != 1:  # không vẽ mắt cho hướng lưng
					px(img, f*W + cx - 3 + int(f), cy - 2, C_EYE)
					px(img, f*W + cx + 2 + int(f), cy - 2, C_EYE)
					px(img, f*W + cx - 3 + int(f), cy - 1, C_OUT)
					px(img, f*W + cx + 2 + int(f), cy - 1, C_OUT)
				# Chân nhỏ ló ra đáy
				px(img, f*W + cx - 3, cy + int(rh) - 2, C_OUT)
				px(img, f*W + cx - 2, cy + int(rh) - 2, C_OUT)
				px(img, f*W + cx + 1, cy + int(rh) - 2, C_OUT)
				px(img, f*W + cx + 2, cy + int(rh) - 2, C_OUT)

		results.append(img)
	return results

# ============================================================
# PREVIEW: phóng to 5x, nền tối
# ============================================================
func make_preview(strip: Image) -> Image:
	var fw : int = strip.get_width() / W
	var prev := Image.create(fw * W * 5, H * 5, false, Image.FORMAT_RGBA8)
	prev.fill(Color("#1A1A2E"))
	for f in range(fw):
		for py2 in range(H):
			for px2 in range(W):
				var c := strip.get_pixel(f * W + px2, py2)
				for sy in range(5):
					for sx in range(5):
						prev.set_pixel(f*W*5 + px2*5+sx, py2*5+sy, c)
	return prev

func save_png(img: Image, path: String) -> void:
	var err := img.save_png(path)
	print(("[OK] " if err == OK else "[ERR] ") + path)

# ============================================================
# MAIN
# ============================================================
func _init() -> void:
	print("=== Vẽ lại Run & Roll theo style tham khảo ===")

	var run_down := make_run_down()
	var run_up   := make_run_up()
	var run_side := make_run_side()
	save_png(run_down, SPRITES_DIR + "player_egg_run_down.png")
	save_png(run_up,   SPRITES_DIR + "player_egg_run_up.png")
	save_png(run_side, SPRITES_DIR + "player_egg_run_side.png")

	var rolls := make_roll_all()
	save_png(rolls[0], SPRITES_DIR + "player_egg_roll_down.png")
	save_png(rolls[1], SPRITES_DIR + "player_egg_roll_up.png")
	save_png(rolls[2], SPRITES_DIR + "player_egg_roll_side.png")

	# Previews
	save_png(make_preview(run_down),  PREV_DIR + "preview_run_down.png")
	save_png(make_preview(run_up),    PREV_DIR + "preview_run_up.png")
	save_png(make_preview(run_side),  PREV_DIR + "preview_run_side.png")
	save_png(make_preview(rolls[0]),  PREV_DIR + "preview_roll_down.png")
	save_png(make_preview(rolls[2]),  PREV_DIR + "preview_roll_side.png")

	print("=== Xong ===")
	quit(0)
```

---

## tools\test_combat_stage_a.gd
```gdscript
extends SceneTree

# Test verification script for Combat Stage A

func _init() -> void:
	print("--- BAT DAU TEST STAGE A: WEAPONS & COMBAT ---")
	
	# 1. Test WeaponDB
	var weapons: Dictionary = WeaponDB.get_all_weapons()
	assert(weapons.has("staff_wood"), "Thieu staff_wood!")
	assert(weapons.has("dagger"), "Thieu dagger!")
	assert(weapons.has("sling"), "Thieu sling!")
	assert(weapons.has("fist"), "Thieu fist!")
	print("[PASS] 1. WeaponDB da tai day du 4 loai vu khi tu weapons.json.")
	
	# 2. Test Stats & Damage Calculation
	var stats := { "STR": 10, "DEX": 10, "INT": 10, "FAI": 10, "VIT": 10, "LUK": 10 }
	var staff_data: Dictionary = WeaponDB.get_weapon("staff_wood")
	var staff_spec_1: Dictionary = staff_data["light_chain"][0]
	var dmg_staff_1: int = WeaponDB.calculate_damage(staff_data, staff_spec_1, stats)
	var sta_staff_1: float = WeaponDB.calculate_stamina_cost(staff_spec_1, staff_data, stats)
	print("[PASS] 2. Sát thương Gậy Gỗ đòn 1 = %d, Stamina = %.1f" % [dmg_staff_1, sta_staff_1])
	assert(dmg_staff_1 == 12, "Sat thuong don 1 Gay Go phai la 12!")
	assert(is_equal_approx(sta_staff_1, 8.0), "Stamina don 1 Gay Go phai la 8.0!")
	
	var dagger_data: Dictionary = WeaponDB.get_weapon("dagger")
	var dagger_spec_1: Dictionary = dagger_data["light_chain"][0]
	var dmg_dagger_1: int = WeaponDB.calculate_damage(dagger_data, dagger_spec_1, stats)
	var sta_dagger_1: float = WeaponDB.calculate_stamina_cost(dagger_spec_1, dagger_data, stats)
	print("[PASS] 3. Sát thương Dao Găm đòn 1 = %d, Stamina = %.1f" % [dmg_dagger_1, sta_dagger_1])
	assert(dmg_dagger_1 == 6, "Sat thuong don 1 Dao Gam phai la 6 (9 * 0.7)!")
	assert(is_equal_approx(sta_dagger_1, 4.0), "Stamina don 1 Dao Gam phai la 4.0!")
	
	var sling_data: Dictionary = WeaponDB.get_weapon("sling")
	var sling_spec_1: Dictionary = sling_data["light_chain"][0]
	var dmg_sling_1: int = WeaponDB.calculate_damage(sling_data, sling_spec_1, stats)
	var sta_sling_1: float = WeaponDB.calculate_stamina_cost(sling_spec_1, sling_data, stats)
	print("[PASS] 4. Sát thương Ná đòn 1 = %d, Stamina = %.1f" % [dmg_sling_1, sta_sling_1])
	assert(dmg_sling_1 == 9, "Sat thuong don 1 Na phai la 9 (10 * 0.9)!")
	assert(is_equal_approx(sta_sling_1, 7.0), "Stamina don 1 Na phai la 7.0!")
	
	# 3. Test Requirement Penalty
	var low_stats := { "STR": 5, "DEX": 5, "INT": 10, "FAI": 10, "VIT": 10, "LUK": 10 }
	var dmg_pen: int = WeaponDB.calculate_damage(staff_data, staff_spec_1, low_stats)
	var sta_pen: float = WeaponDB.calculate_stamina_cost(staff_spec_1, staff_data, low_stats)
	print("[PASS] 5. Penalty thiếu chỉ số: Sát thương = %d (giảm), Stamina = %.1f (tăng)" % [dmg_pen, sta_pen])
	assert(dmg_pen < dmg_staff_1, "Sát thương phai bi phat khi thieu chi so!")
	assert(sta_pen > sta_staff_1, "Stamina phai tang khi thieu chi so!")
	
	# 4. Test CombatState 60 FPS Logic
	var cs := CombatState.new()
	assert(not cs.is_attacking(), "Ban dau khong duoc o trang thai attacking!")
	cs.attack_phase = CombatState.AttackPhase.STARTUP
	assert(cs.is_attacking(), "Phai la attacking o pha startup!")
	assert(not cs.can_cancel_to_dodge(3), "Khong the cancel dodge o pha startup!")
	
	cs.attack_phase = CombatState.AttackPhase.RECOVERY
	cs.attack_frame = 2
	assert(not cs.can_cancel_to_dodge(3), "Chua toi khung 3 thi chua the cancel dodge!")
	cs.attack_frame = 3
	assert(cs.can_cancel_to_dodge(3), "Khung 3 recovery phai duoc cancel dodge!")
	assert(cs.can_chain_combo(3), "Khung 3 recovery phai duoc chain combo!")
	print("[PASS] 6. CombatState: 3 pha logic va cancel_from hoat dong chinh xac.")
	
	# 5. Test HitboxService Shapes
	var test_area := Area2D.new()
	var col_shape := CollisionShape2D.new()
	test_area.add_child(col_shape)
	
	HitboxService.configure_hitbox(test_area, { "shape": "arc", "radius": 18 }, "down", false)
	assert(col_shape.shape is CircleShape2D, "Hitbox arc phai co CircleShape2D!")
	assert(is_equal_approx(col_shape.shape.radius, 18.0), "Radius arc phai la 18!")
	
	HitboxService.configure_hitbox(test_area, { "shape": "line", "reach": 24, "thickness": 6 }, "side", false)
	assert(col_shape.shape is RectangleShape2D, "Hitbox line phai co RectangleShape2D!")
	
	HitboxService.configure_hitbox(test_area, { "shape": "rect", "size": [14, 14] }, "up", false)
	assert(col_shape.shape is RectangleShape2D, "Hitbox rect phai co RectangleShape2D!")
	print("[PASS] 7. HitboxService: Cấu hình chính xác các hình dạng arc, line, rect.")
	
	print("--- TAT CA CAC TEST UNIT CUA STAGE A DA VUOT QUA THANH CONG! ---")
	quit(0)
```

---

## tools\test_leveling_system.gd
```gdscript
extends Node

# Test verification script for Leveling System (COMBAT_SPEC Section 9)

func _ready() -> void:
	print("--- BAT DAU TEST HE THONG LEN CAP (LEVELING SYSTEM) ---")
	
	# 1. Test StatsCalc Formulas
	var base_stats := { "VIT": 10, "STR": 10, "DEX": 10, "INT": 10, "FAI": 10, "LUK": 10 }
	var hp := StatsCalc.calc_max_hp(base_stats)
	var sta := StatsCalc.calc_max_stamina(base_stats)
	var ec := StatsCalc.calc_equip_capacity(base_stats)
	var mp := StatsCalc.calc_max_mp(base_stats)
	
	assert(hp == 100, "HP tai VIT 10 phai la 100 (60 + 10*4), nhan duoc: %d" % hp)
	assert(is_equal_approx(sta, 80.0), "Stamina tai VIT 10 phai la 80.0, nhan duoc: %f" % sta)
	assert(is_equal_approx(ec, 55.0), "Equip capacity tai VIT 10 phai la 55.0, nhan duoc: %f" % ec)
	assert(mp == 50, "MP tai INT 10 phai la 50, nhan duoc: %d" % mp)
	print("[PASS] 1. Cong thuc HP, Stamina, Sức tải, MP tinh chinh xac.")
	
	# Test StatsCalc with leveled stats (VIT 15)
	var leveled_stats := { "VIT": 15, "STR": 12, "DEX": 10, "INT": 12, "FAI": 10, "LUK": 10 }
	assert(StatsCalc.calc_max_hp(leveled_stats) == 120, "HP tai VIT 15 phai la 120 (60 + 15*4)!")
	assert(is_equal_approx(StatsCalc.calc_max_stamina(leveled_stats), 90.0), "Stamina tai VIT 15 phai la 90.0!")
	assert(is_equal_approx(StatsCalc.calc_equip_capacity(leveled_stats), 62.5), "Equip cap tai VIT 15 phai la 62.5!")
	assert(StatsCalc.calc_max_mp(leveled_stats) == 56, "MP tai INT 12 phai la 56!")
	print("[PASS] 2. Cong thuc StatsCalc cho chi so sau khi nang cap tinh chinh xac.")
	
	# 2. Test Level Cost Formulas
	# cost(level) = round(40 * 1.18^(level-1))
	var c1 := StatsCalc.calc_level_cost(1)
	var c2 := StatsCalc.calc_level_cost(2)
	var c3 := StatsCalc.calc_level_cost(3)
	assert(c1 == 40, "Chi phi level 1 phai la 40, nhan duoc: %d" % c1)
	assert(c2 == 47, "Chi phi level 2 phai la 47 (round(40*1.18)), nhan duoc: %d" % c2)
	assert(c3 == 56, "Chi phi level 3 phai la 56 (round(40*1.18^2)), nhan duoc: %d" % c3)
	print("[PASS] 3. Chi phi len cap theo cap do tinh chinh xac (c1=%d, c2=%d, c3=%d)." % [c1, c2, c3])
	
	# 3. Test Weapon Damage with StatsCalc
	var w_data := WeaponDB.get_weapon("staff_wood")
	var spec: Dictionary = w_data["light_chain"][0]
	var dmg_base := StatsCalc.calc_weapon_damage(w_data, spec, base_stats)
	assert(dmg_base == 12, "Sat thuong Gay Go don 1 tai STR 10 phai la 12, nhan duoc: %d" % dmg_base)
	
	var high_str_stats := { "VIT": 10, "STR": 20, "DEX": 10, "INT": 10, "FAI": 10, "LUK": 10 }
	var dmg_high := StatsCalc.calc_weapon_damage(w_data, spec, high_str_stats)
	# scaling C = 0.03. diff = 10 -> 1 + 0.03*10 = 1.30. 12 * 1.30 = 15.6 -> 16.
	assert(dmg_high > dmg_base, "Sat thuong phai tang khi nang STR!")
	print("[PASS] 4. StatsCalc.calc_weapon_damage scaling theo STR chinh xac (10 STR: %d -> 20 STR: %d)." % [dmg_base, dmg_high])
	
	# 4. Test PlayerInventory Autoload Logic
	var inv_script = load("res://scripts/autoload/player_inventory.gd")
	var inv = inv_script.new()
	add_child(inv)
	
	assert(inv.level == 1, "Level khoi dau phai la 1!")
	assert(inv.shell_shards == 0, "Mảnh vỏ khoi dau phai la 0!")
	
	inv.add_shards(100)
	assert(inv.shell_shards == 100, "Sau khi them 100 shards, tong phai la 100!")
	assert(inv.can_level_up(), "Voi 100 shards va cost 40, can_level_up phai la true!")
	
	# Nang 1 cap don le
	var success: bool = inv.apply_stat_point("VIT")
	assert(success, "apply_stat_point phai thanh cong!")
	assert(inv.level == 2, "Sau khi nang 1 diem, level phai la 2!")
	assert(inv.shell_shards == 60, "100 - 40 = 60 shards!")
	assert(inv.added_points["VIT"] == 1, "VIT added_points phai la 1!")
	assert(inv.get_effective_stats()["VIT"] == 11, "Effective VIT phai la 11!")
	print("[PASS] 5. PlayerInventory: Cong 1 diem VIT, tru shards va tinh level dung.")
	
	# Nang nhieu diem dong thoi (apply_multiple_stats)
	# Level 2 cost = 47. We have 60 shards. Adding 1 STR costs 47 -> leaves 13 shards.
	var multi_success: bool = inv.apply_multiple_stats({"STR": 1})
	assert(multi_success, "Nang tiep 1 diem STR phai thanh cong!")
	assert(inv.level == 3, "Sau do level phai la 3!")
	assert(inv.shell_shards == 13, "60 - 47 = 13 shards, nhan duoc: %d" % inv.shell_shards)
	
	# Thu nang tiep khi khong du shards (Level 3 cost = 56, only have 13)
	var fail_attempt: bool = inv.apply_multiple_stats({"DEX": 1})
	assert(not fail_attempt, "Khong du shards thi apply_multiple_stats phai fail!")
	assert(inv.level == 3, "Level phai giu nguyen 3!")
	print("[PASS] 6. PlayerInventory: apply_multiple_stats kiem tra du shards va ap dung chinh xac.")
	
	# 5. Test Export / Import (Save/Load)
	var exported: Dictionary = inv.export_data()
	assert(exported["level"] == 3, "Exported level phai la 3!")
	assert(exported["shell_shards"] == 13, "Exported shards phai la 13!")
	
	var inv2 = inv_script.new()
	add_child(inv2)
	inv2.import_data(exported)
	assert(inv2.level == 3, "Imported level phai la 3!")
	assert(inv2.shell_shards == 13, "Imported shards phai la 13!")
	assert(inv2.added_points["VIT"] == 1, "Imported VIT bonus phai la 1!")
	assert(inv2.added_points["STR"] == 1, "Imported STR bonus phai la 1!")
	print("[PASS] 7. PlayerInventory export_data & import_data bao toan day du du lieu.")
	
	# 6. Test LostShard single-pile mechanic
	var lost_node1 = LostShard.new()
	lost_node1.shard_amount = 50
	LostShard.current_pile = lost_node1
	add_child(lost_node1)
	
	# Mo phong Player chet lan 2 -> spawn_at phai xoa pile cu
	var pile2 = LostShard.spawn_at(self, Vector2(100, 100), 30)
	assert(pile2 != null, "Pile moi phai duoc tao!")
	assert(not is_instance_valid(lost_node1) or lost_node1.is_queued_for_deletion(), "Pile cu phai bi xoa khi chet lan 2!")
	assert(LostShard.current_pile == pile2, "current_pile phai tro vao pile moi!")
	pile2.queue_free()
	print("[PASS] 8. LostShard: Co che duy nhat 1 dong shards va huy dong cu khi chet lan 2 hoat dung.")
	
	# 7. Test StrawBed & LevelUpScreen scene loading & UI lifecycle
	var straw_bed_scene = load("res://scenes/world/straw_bed.tscn")
	assert(straw_bed_scene != null, "scenes/world/straw_bed.tscn phai ton tai va hop le!")
	var straw_bed = straw_bed_scene.instantiate()
	assert(straw_bed is StrawBed, "straw_bed phai la instance cua class StrawBed!")
	add_child(straw_bed)
	straw_bed.queue_free()
	
	var level_up_scene = load("res://scenes/ui/level_up_screen.tscn")
	assert(level_up_scene != null, "scenes/ui/level_up_screen.tscn phai ton tai va hop le!")
	var level_up_ui = level_up_scene.instantiate()
	assert(level_up_ui is LevelUpScreen, "level_up_ui phai la instance cua class LevelUpScreen!")
	add_child(level_up_ui) # Trigger _ready() and _build_stat_rows()
	level_up_ui.open(null)
	assert(level_up_ui.stat_row_nodes.size() == 6, "Phai tao du 6 hang chi so!")
	
	# Test 10: Test nút bấm thao tác trên giao diện LevelUpScreen (+/- va Confirm)
	PlayerInventory.shell_shards = 100
	var vit_row = level_up_ui.stat_row_nodes[0]
	var btn_add: Button = vit_row["btn_add"]
	btn_add.emit_signal("pressed")
	assert(level_up_ui.pending_adds["VIT"] == 1, "Bam '+' phai tang diem cho pending_adds[VIT]!")
	assert(level_up_ui.feedback_label.text.contains("VIT"), "Feedback label phai thong bao diem duoc cong!")
	
	# Test nut Confirm
	level_up_ui._on_confirm_pressed()
	assert(PlayerInventory.level >= 2, "Sau khi confirm, PlayerInventory.level phai tang len >= 2!")
	assert(PlayerInventory.added_points["VIT"] >= 1, "added_points[VIT] phai tang!")
	print("[PASS] 10. Thao tac nut bam (+/- va Confirm) tren giao dien LevelUpScreen hoat dong chinh xac!")
	
	# Test 11: Kiem tra nap sprite vu khi tren EggVisual va HUD
	var egg_vis_script = load("res://scripts/player/egg_visual.gd")
	var egg_vis = egg_vis_script.new()
	add_child(egg_vis)
	assert(egg_vis.weapon_textures.has("staff_wood"), "EggVisual phai nap weapon_staff_wood.png!")
	assert(egg_vis.weapon_textures.has("dagger"), "EggVisual phai nap weapon_dagger.png!")
	assert(egg_vis.weapon_textures.has("sling"), "EggVisual phai nap weapon_sling.png!")
	egg_vis.queue_free()
	print("[PASS] 11. EggVisual nap thanh cong ca 3 sprite vu khi chuan pixel art.")
	
	# Test 12: Kiem tra HUD cap nhat cap do, vu khi va do dai thanh mau
	var hud_scene = load("res://scenes/ui/hud.tscn")
	var hud_node = hud_scene.instantiate()
	add_child(hud_node)
	hud_node.update_weapon(0, "staff_wood", "Gậy Gỗ")
	assert(hud_node.weapon_icon.texture != null, "HUD WeaponIcon phai hien thi sprite vu khi!")
	hud_node.update_hp(120, 120)
	assert(hud_node.hp_bar_bg.size.x > 64.0, "Thanh mau phai tu dong keo dai khi max_hp tang!")
	hud_node.update_level_and_shards()
	assert(hud_node.shard_label.text.begins_with("Cấp"), "HUD phai hien thi Cap do ro rang!")
	hud_node.queue_free()
	print("[PASS] 12. HUD hien thi day du Cap do, icon vu khi va co che keo dai thanh mau khi tang VIT.")
	
	# Don dep
	inv.queue_free()
	inv2.queue_free()
	
	print("--- TAT CA CAC TEST CUA LEVELING SYSTEM DA VUOT QUA THANH CONG! ---")
	get_tree().quit(0)

```

---

## tools\test_leveling_system.tscn
```ini
[gd_scene format=3 uid="uid://bibebeyamofpk"]

[ext_resource type="Script" path="res://tools/test_leveling_system.gd" id="1_test"]

[node name="TestLevelingSystem" type="Node"]
script = ExtResource("1_test")
```

---

