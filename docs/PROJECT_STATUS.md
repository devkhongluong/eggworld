# BÁO CÁO TÌNH TRẠNG DỰ ÁN "VỠ VỎ" (SHELLBOUND)
*Cập nhật lần cuối: 15/10/2026*  
*Nền tảng: Godot Engine v4.7.2.stable.official (GDScript typed, 2D Pixel Art)*

---

## 1. ĐÃ HOÀN THÀNH

### Các bước nền tảng ban đầu (Bước 1 - 5):
1. **Thiết lập cấu hình dự án chuẩn 2D Pixel:**
   - Cấu hình viewport: `320 × 180`, window override `1280 × 720` (tỉ lệ nguyên x4), viewport stretch `integer`.
   - Lọc texture toàn cục: `nearest` (`default_texture_filter=0`), bật snap pixel 2D cho transform và vertex.
   - *File liên quan:* `project.godot`.
2. **Hệ thống Autoload cốt lõi:**
   - `Palette.gd`: Định nghĩa chuẩn xác 16 hằng số màu HEX trung cổ theo GDD mục 3.
   - `GameData.gd`: Tải và cung cấp dữ liệu cân bằng từ `data/stats.json`, tuyệt đối không hard-code chỉ số trong script.
   - `BehaviorTracker.gd`: Quản lý 5 bộ đếm hành vi ẩn (`GUARD`, `DODGE`, `MAGIC`, `EXPLORE`, `SUPPORT`), tính tỉ lệ mốc tiến hóa.
   - `SaveManager.gd`: Lưu/tải dữ liệu `user://savegame.json`.
   - *File liên quan:* `scripts/autoload/palette.gd`, `scripts/autoload/game_data.gd`, `scripts/autoload/behavior_tracker.gd`, `scripts/autoload/save_manager.gd`, `data/stats.json`.
3. **Điều khiển nhân vật & Né đòn (Player Movement & Dodge):**
   - Di chuyển 8 hướng với chuẩn tốc độ từ `stats.json`.
   - Lăn né (Dodge) tiêu hao Stamina, i-frame 0.25s, cooldown 0.2s, chặn né khi thiếu thể lực.
   - Cơ chế hồi phục Stamina có delay sau khi tiêu hao.
   - *File liên quan:* `scripts/player/player.gd`.
4. **Hệ thống chiến đấu sơ bộ & Hitbox/Hurtbox:**
   - Va chạm di chuyển nhân vật: `10 × 6 px` sát chân.
   - Hurtbox nhân vật: `10 × 14 px` giữa thân.
   - Combo cận chiến 3 đòn với cửa sổ combo (`combo_window` 0.55s), cooldown tăng dần theo từng đòn, xoay hướng theo `facing_direction`.
   - Bật/tắt hitbox chính xác theo khung đánh (`hit_frames: [2]`).
   - Tích lũy sát thương cận chiến: Mỗi 10 sát thương cận chiến cộng +1 điểm ẩn `GUARD`.
   - *File liên quan:* `scripts/player/player.gd`, `scenes/player/player.tscn`, `data/stats.json`.
5. **Màn chơi thử nghiệm (Test Arena), Kẻ thù thử nghiệm (DummyEnemy) & HUD:**
   - `test_arena.tscn`: Sân đấu giới hạn tường bao, sàn tối màu, camera bám theo nhân vật có làm mượt (`position_smoothing`).
   - `dummy_enemy.tscn`: Kẻ thù phát tín hiệu báo trước nhấp nháy Đỏ Gạch (`DO_GACH`) 0.3s trước khi tung đòn gây sát thương. Khi né trong i-frame nhận +2 điểm `DODGE` (tối đa 1 lần/lượt vung đòn).
   - `hud.tscn`: Hiển thị thanh máu HP (Đỏ Gạch), thanh thể lực Stamina (Xanh Lá Úa), thông báo hồi sinh và nhãn debug phím F3.
   - *File liên quan:* `scenes/levels/test_arena.tscn`, `scenes/levels/test_arena.gd`, `scenes/enemies/dummy_enemy.tscn`, `scripts/combat/dummy_enemy.gd`, `scripts/combat/enemy_visual.gd`, `scenes/ui/hud.tscn`, `scripts/ui/hud.gd`.

### Các tính năng hoàn thành trong đợt phát triển tiếp theo:
6. **Hệ thống Sprite động (AnimatedSprite2D & JSON config):**
   - Đã cắt và tích hợp dải sprite sheet 32×32 pixel art từ nguồn mẫu tham khảo cho Trứng:
     - `idle` (down, up, side): 4 khung, 8 fps.
     - `run` (down, up, side): 6 khung, 12 fps.
     - `roll` (down, up, side): 6 khung, 12 fps.
     - `attack` (down, up, side): 5 khung, 12 fps, vung kiếm có vệt chém vàng ở khung 3.
     - `death` (down, up, side): 7 khung, 8 fps, diễn hoạt vỡ vỏ, tràn lòng, tan biến.
   - Tự động nạp qua `assets/sprites/player/animations.json`.
   - *File liên quan:* `assets/sprites/player/*.png`, `assets/sprites/player/animations.json`, `scripts/player/player.gd`.
7. **Cơ chế Bị thương (Hurt) mới thiết kế:**
   - Thay vì dùng hoạt ảnh thay thế hình dáng, hệ thống giữ nguyên sprite nhân vật và phủ hiệu ứng động:
     - **Vết nứt trên vỏ (Cracks):** Xuất hiện và to dần theo tỉ lệ mất máu ($<80\%$, $<60\%$, $<35\%$).
     - **Mảnh vỡ văng (Shell Debris Burst):** Tung tóe 7 mảnh vỏ rơi có trọng lực khi trúng đòn.
     - **Khung bất tử (i-frame nhận đòn):** 0.25 giây tự động hết, chớp màu Đỏ Gạch 0.18s, khắc phục triệt để lỗi bất tử vĩnh viễn và kẹt game.
   - *File liên quan:* `scripts/player/egg_visual.gd`, `scripts/player/player.gd`.
8. **Tổ chức thư mục Tools & Validator Sprite:**
   - Đã gom toàn bộ các file script hỗ trợ vào `tools/` kèm `tools/README.md`.
   - Đã tạo `tools/validate_sprites.py` quét kiểm định 14 asset sprite PNG theo chuẩn GDD mục 2 & 3 (khung 32x32, alpha trong suốt, chia hết cho kích thước khung, kiểm tra 16 màu cố định).
   - *File liên quan:* `tools/*`.
9. **Cơ chế Đỡ đòn (Guard):**
   - Giữ nút `guard` (`L`, chuột phải, Joypad L1): Giảm tốc độ di chuyển còn 45% (`guard_speed_multiplier`), khóa hồi Stamina trong khi giữ.
   - Kiểm tra cung đỡ góc 180 độ phía trước theo `facing_direction`.
   - Đỡ thành công: giảm 75% sát thương (`guard_damage_reduction`), tiêu hao 25 thể lực (`guard_stamina_cost_per_hit`), cộng +2 điểm `GUARD` trong `BehaviorTracker`.
   - Vỡ thế đỡ (Guard Break): Nếu Stamina không đủ khi bị đánh trúng trong thế đỡ, người chơi bị choáng 0.8 giây (`guard_break_stun_duration`), nhận trọn 100% sát thương.
   - Đòn đánh ngoài cung 180 độ hoặc từ sau lưng: không đỡ được, nhận trọn sát thương.
   - Hiển thị thế đỡ bằng hình khối tạm (vòng cung khiên Nâu Hầm/Xám Sắt và điểm tâm Vàng Cổ).
   - *File liên quan:* `data/stats.json`, `scripts/player/player.gd`, `scripts/player/egg_visual.gd`.
10. **Khung Kẻ Thù Cơ Sở (BaseEnemy) & Quái Thường (CommonEnemy) có AI FSM:**
    - `BaseEnemy.gd`: Thiết kế kế thừa cho kẻ thù thường và boss tương lai, quản lý đầy đủ FSM: `IDLE` $\rightarrow$ `CHASE` $\rightarrow$ `TELEGRAPH` $\rightarrow$ `ATTACK` $\rightarrow$ `RECOVERY` $\rightarrow$ `STUNNED` $\rightarrow$ `DEAD`.
    - Tự động tìm Player, truy đuổi khi trong bán kính phát hiện (`detection_radius` 140px).
    - Dừng lại báo hiệu Đỏ Gạch (`DO_GACH`) 0.35s trước khi tung đòn trong tầm (`attack_radius` 24px).
    - Bị đẩy lùi nhẹ và choáng ngắn (`stun_duration` 0.25s) khi trúng đòn của Player.
    - Chết rơi vật phẩm Mảnh Vỏ Vụn (EXP Pickup).
    - `common_enemy_visual.gd`: Dựng hình khối tạm chuẩn 16 màu Palette (Nâu Da, Cát, mảng ăn mòn Tím Mục, mắt Đỏ Rượu).
    - `shell_shard_pickup.gd`: Hạt tinh thể Mảnh Vỏ Vụn hình thoi bay nhấp nháy, tự hút nhặt khi chạm Player.
    - *File liên quan:* `data/stats.json`, `scripts/combat/base_enemy.gd`, `scripts/combat/common_enemy_visual.gd`, `scripts/combat/shell_shard_pickup.gd`, `scenes/enemies/common_enemy.tscn`, `scenes/levels/test_arena.tscn`.
11. **Tái cấu trúc kiến trúc Combat & Công thức Stamina động (Commit 1):**
    - Tách `player.gd` thành các dịch vụ độc lập theo quy tắc kiến trúc COMBAT_SPEC mục 15:
      - `scripts/combat/combat_state.gd` (`CombatState`): Quản lý FSM và các chu kỳ trạng thái nhân vật.
      - `scripts/combat/hitbox_service.gd` (`HitboxService`): Quản lý vị trí, kích thước và kích hoạt vùng va chạm tấn công.
      - `scripts/combat/weapon_db.gd` (`WeaponDB`): Nạp và truy vấn dữ liệu vũ khí từ `data/weapons.json`.
    - Tích hợp công thức động cho Stamina & HP từ `data/stats.json` theo COMBAT_SPEC mục 9:
      - `max_hp = 60 + VIT * 4` (100 HP tại VIT 10).
      - `max_stamina = 60 + VIT * 2` (80.0 Stamina tại VIT 10).
      - Cân bằng lại chi phí tương ứng bể thể lực 80: lăn né `16.0` (trước là 20), hồi thể lực `26.0/s` (trước là 30), đòn đánh `[8.0, 10.0, 14.0]`, đỡ đòn `20.0/hit`.
    - *File liên quan:* `data/stats.json`, `scripts/player/player.gd`, `scripts/combat/*.gd`.
12. **Triển khai Giai đoạn A – Hệ thống Vũ khí & Chuỗi đòn 60 FPS Logic:**
    - `data/weapons.json`: Định nghĩa đầy đủ 4 cấu hình vũ khí (`staff_wood`, `dagger`, `sling`, `fist`) với cấu trúc chuẩn COMBAT_SPEC mục 4 (tên, kiểu, trọng lượng, base damage, scaling, requirements, light_chain với startup/active/recovery/cancel_from, poise_dmg, combo_window).
    - `GameData.gd` nạp `weapons.json` và `WeaponDB.gd` đọc qua `GameData`, áp dụng công thức scaling và phạt khi thiếu chỉ số.
    - Chu kỳ 3 pha theo khung hình logic 60 FPS: `startup` $\rightarrow$ `active` $\rightarrow$ `recovery` với khả năng hủy đòn sang lăn né (`dodge cancel`) hoặc nối chuỗi combo từ khung `cancel_from`.
    - Input Map khai báo theo mục 2: `swap_weapon` (Q, Joypad D-pad Lên - đã kích hoạt), `use_item` (R), `cycle_item` (Z), `skill` (I), `two_hand` (Tab).
    - Đổi vũ khí bằng `swap_weapon` (Q / Joypad D-pad Lên) xoay vòng mượt mà giữa 3 ô trang bị: Ô 1: Gậy Gỗ $\rightarrow$ Ô 2: Dao Găm $\rightarrow$ Ô 3: Ná. Hỗ trợ phím số 1, 2, 3 để chọn nhanh từng ô, phím 4 để chuyển sang đòn Tay Không (`fist`).
    - **Hoạt ảnh diễn hoạt vũ khí động (Dynamic Weapon Animations):** Khắc phục triệt để lỗi vũ khí đứng yên:
      - Khi nghỉ: Vũ khí giắt gọn gàng bên hông/tay nhân vật (Gậy Gỗ gác chéo lưng, Dao Găm cài hông, Ná cầm tay). Khi chết hoặc đỡ đòn vũ khí tự động ẩn phù hợp.
      - Khi ra đòn: Vũ khí chuyển động sống động theo chu kỳ đòn đánh 60 FPS:
        - **Gậy Gỗ (`staff_wood`):** Vung quét xoay tròn qua góc 180° kèm vệt chém cánh cung vàng rực rỡ (`Palette.KEM` và `Palette.VANG_CO`), đổi hướng vung xen kẽ theo từng bước combo.
        - **Dao Găm (`dagger`):** Đâm thẳng vút tới trước (+22px) cực nhanh kèm vệt sáng ánh thép và thu dao về mượt mà.
        - **Ná (`sling`):** Kéo căng chạc và dây thun kèm hòn sỏi ở pha tụ lực, sau đó nhả bung dây và bắn viên đạn bay vút đi ở pha phát lực.
        - **Tay không (`fist`):** Thụi nắm đấm bật về phía trước.
    - Vũ khí tầm xa Ná (`sling`): Bắn đạn `Projectile` qua `HitboxService`, bay theo hướng nhìn, va chạm Hurtbox kẻ thù, gây sát thương và cộng +2 điểm `MAGIC` vào `BehaviorTracker`.
    - `HitboxService.gd`: Tạo, định vị và cấu hình hitbox chuẩn xác theo 4 hình dạng (`arc`, `rect`, `line`, `projectile`), xoay theo `facing_direction` và lật theo `flip_h`. Hỗ trợ quét tự động mọi dạng node con `CollisionShape2D`.
    - Mỗi đòn trúng cộng điểm theo mục 12 và in console log khi bật cờ `debug.show_combat_log` trong `data/stats.json`.
    - Cập nhật HUD: hiển thị trực quan `[Q] Vũ khí (X/3): [Tên vũ khí]`, tự động cập nhật khi đổi ô.
    - Kịch bản kiểm thử tự động toàn diện: `tools/test_combat_stage_a.gd` (kiểm tra đầy đủ 7 tiêu chí đơn vị).
    - *File liên quan:* `data/weapons.json`, `data/stats.json`, `project.godot`, `scripts/autoload/game_data.gd`, `scripts/combat/*.gd`, `scripts/player/*.gd`, `scripts/ui/hud.gd`, `scenes/ui/hud.tscn`, `scenes/levels/test_arena.gd`, `tools/test_combat_stage_a.gd`.
13. **Hệ thống Lên cấp & Ổ Rơm (Leveling System & Straw Bed - COMBAT_SPEC mục 9):**
    - `data/stats.json`: Bổ sung cấu hình `leveling` (`cost_base: 40`, `cost_growth: 1.18`), `scaling_coeff` (S/A/B/C/D/E/-), và `requirement_penalty`.
    - `scripts/combat/stats_calculator.gd` (`StatsCalc`): Dịch vụ tính toán chỉ số phái sinh và công thức cân bằng (`calc_max_hp`, `calc_max_stamina`, `calc_equip_capacity`, `calc_max_mp`, `calc_weapon_damage`, `calc_level_cost`, `calc_level`).
    - `scripts/autoload/player_inventory.gd` (`PlayerInventory` Autoload): Quản lý tích lũy Mảnh Vỏ Vụn (EXP), 6 chỉ số (VIT, STR, DEX, INT, FAI, LUK), cấp độ nhân vật, thăng cấp và chi tiêu; phát tín hiệu `shards_changed` và `stats_changed`.
    - `scripts/combat/shell_shard_pickup.gd`: Tích hợp nạp trực tiếp Mảnh Vỏ Vụn vào `PlayerInventory` khi Player nhặt.
    - `scripts/combat/lost_shard.gd` & `scenes/items/lost_shard.tscn` (`LostShard`): Cơ chế đánh rơi Mảnh Vỏ Vụn tại chỗ chết và nhặt lại (Lost Runes mechanic). Chỉ tồn tại DUY NHẤT 1 đống trên bản đồ; chết lần 2 trước khi nhặt lại sẽ làm đống cũ tan biến vĩnh viễn.
    - `scripts/world/straw_bed.gd` & `scenes/world/straw_bed.tscn` (`StrawBed`): Điểm lưu và nghỉ ngơi Ổ Rơm với hình khối vàng óng pixel-art; bấm phím `E` hồi đầy HP/Stamina, cập nhật `spawn_position`, hồi sinh kẻ thù trong đấu trường, lưu game và mở giao diện lên cấp.
    - `scripts/ui/level_up_screen.gd` & `scenes/ui/level_up_screen.tscn` (`LevelUpScreen`): Giao diện lên cấp trực quan 320×180 px; hỗ trợ bàn phím, tay cầm và chuột; xem trước biến động chỉ số (HP, Thể lực, Sức tải, Sát thương vũ khí); hệ thống cộng điểm tạm thời (`pending_adds`) trước khi bấm Xác nhận.
    - `scripts/ui/hud.gd` & `scenes/ui/hud.tscn`: Bổ sung `ShardLabel` hiển thị số Mảnh Vỏ Vụn hiện có bằng màu Vàng Cổ (`Palette.VANG_CO`).
    - `scripts/autoload/save_manager.gd`: Lưu/tải tự động dữ liệu `PlayerInventory` (cấp độ, mảnh vỏ, điểm đã cộng) trong `savegame.json`.
    - `scenes/levels/test_arena.tscn` & `test_arena.gd`: Bố trí Ổ Rơm tại đấu trường, hồi sinh lại toàn bộ kẻ thù (`DummyEnemy`, `CommonEnemy`) khi người chơi nghỉ ngơi.
    - Kịch bản kiểm thử tự động: `tools/test_leveling_system.gd` kiểm tra thành công 9 tiêu chí kiểm thử.
    - *File liên quan:* `data/stats.json`, `project.godot`, `scripts/combat/stats_calculator.gd`, `scripts/autoload/player_inventory.gd`, `scripts/combat/lost_shard.gd`, `scenes/items/lost_shard.tscn`, `scripts/world/straw_bed.gd`, `scenes/world/straw_bed.tscn`, `scripts/ui/level_up_screen.gd`, `scenes/ui/level_up_screen.tscn`, `scripts/player/player.gd`, `scripts/autoload/save_manager.gd`, `scripts/ui/hud.gd`, `scenes/ui/hud.tscn`, `scenes/levels/test_arena.tscn`, `scenes/levels/test_arena.gd`, `tools/test_leveling_system.gd`.
14. **Triển khai Giai đoạn B – Đòn nặng, Poise/Stagger, Đâm lén, Đỡ khéo, Game Feel & F3 Debug (COMBAT_SPEC mục 5, 12, 13):**
    - **Cân bằng lại Luật Điểm Hành Vi:**
      - Bỏ hoàn toàn luật "+1 GUARD mỗi 10 sát thương cận chiến".
      - `GUARD` chỉ cộng khi đỡ thường (+2) và đỡ khéo (+4).
      - Thêm trường `behavior_tag` trong `data/weapons.json` (Dao Găm: `DODGE`, Ná: `MAGIC`, Gậy Gỗ: không có, Tay Không: không có). Mỗi đòn trúng thưởng +1 điểm hành vi tương ứng (tối đa 1 lần/lượt vung đòn).
      - `EXPLORE`: bỏ +1 khi nhặt Mảnh Vỏ Vụn, chỉ giữ +5 khi mở rương, tìm lối tắt hoặc phòng ẩn.
      - Giao diện debug F3: hiển thị bảng thông số đầy đủ 5 bộ đếm ẩn (`GUARD`, `DODGE`, `MAGIC`, `EXPLORE`, `SUPPORT`) kèm tỉ lệ phần trăm trực quan.
    - **Đòn nặng tích lực (`heavy_charge`):**
      - Kích hoạt bằng cách giữ phím tấn công (`J` / chuột trái) quá `heavy_hold_threshold` (0.18s) hoặc nhấn phím `U` (`heavy_attack`).
      - Hiển thị hiệu ứng hào quang tụ lực co giãn quanh Trứng. Khi thả nút, tung đòn nặng gây sát thương cao, poise damage lớn và đẩy lùi mạnh.
    - **Hệ thống Poise & Choáng (Stagger):**
      - Cả Player và Enemy đều sở hữu thanh Poise ẩn (`max_poise`, `current_poise`) tự hồi phục sau thời gian không nhận đòn (`poise_recovery_delay`).
      - Khi thanh Poise cạn kiệt, mục tiêu rơi vào trạng thái choáng (`stagger`) trong thời gian định sẵn, hiện chữ phản hồi "CHOÁNG!".
    - **Đâm lén (Backstab):**
      - Tấn công kẻ thù từ cung 90° sau lưng (`backstab_angle_threshold` 0.785 rad): gây sát thương nhân đôi (2.0×), hiện nhãn "ĐÂM LÉN!", cộng +2 điểm `DODGE`.
    - **Đòn kết liễu (Critical Hit / Riposte):**
      - Tấn công kẻ thù đang bị choáng (`is_staggered`): gây sát thương 2.5×, lập tức xóa trạng thái choáng, hiện nhãn "KẾT LIỄU!".
    - **Đỡ khéo (Parry):**
      - Kích hoạt trong cửa sổ 8 khung hình đầu tiên của tư thế Đỡ (`parry_window_frames: 8`).
      - Parry thành công: triệt tiêu 100% sát thương, tiêu hao 0 thể lực, lập tức làm choáng kẻ tấn công, rung camera, hiện nhãn "ĐỠ KHÉO!" và thưởng +4 điểm `GUARD`.
    - **Cảm giác đánh (Game Feel) – toàn bộ tham số trong `data/stats.json` & có công tắc bật/tắt:**
      - `hit_stop`: Dừng ngắn 2-4 khung hình logic khi đánh trúng (đòn nặng và đòn kết liễu dừng 4-5 khung).
      - `flash_white`: Kẻ thù nhấp nháy màu kem sáng (`Palette.KEM`) ngắn khi trúng đòn; đòn nặng đẩy lùi xa hơn đòn nhẹ.
      - `camera_shake`: Rung màn hình khi tung đòn nặng trúng, đòn kết liễu trúng, parry thành công và khi người chơi nhận đòn.
      - `floating_numbers`: Hiển thị số sát thương nhảy lên và nhãn chữ hiệu ứng trực quan ("ĐÂM LÉN!", "KẾT LIỄU!", "CHOÁNG!", "ĐỠ KHÉO!").
    - Kịch bản kiểm thử tự động toàn diện: `tools/test_combat_stage_b.gd` (vượt qua 100% cả 6 bộ kiểm thử: behavior tags, poise & stagger break, backstab detection & multiplier, critical hit & stagger reset, parry window & rewards, heavy attack data & formula).
    - *File liên quan:* `data/stats.json`, `data/weapons.json`, `project.godot`, `scripts/combat/combat_state.gd`, `scripts/combat/combat_feedback.gd`, `scripts/combat/hitbox_service.gd`, `scripts/combat/projectile.gd`, `scripts/combat/base_enemy.gd`, `scripts/combat/dummy_enemy.gd`, `scripts/combat/lost_shard.gd`, `scripts/combat/shell_shard_pickup.gd`, `scripts/player/player.gd`, `scripts/player/player_camera.gd`, `scripts/player/egg_visual.gd`, `scripts/ui/hud.gd`, `scenes/levels/test_arena.tscn`, `tools/test_combat_stage_b.gd`.

15. **Tích hợp Sprite Hoạt Ảnh & Icon Vũ Khí Chuyên Biệt (Gậy Gỗ, Dao Găm, Ná):**
    - Trích xuất từ hình vẽ pixel art tham khảo của người dùng:
      - 3 Icon vũ khí pixel art chuẩn 32×32: `assets/sprites/weapons/weapon_staff_wood.png`, `weapon_dagger.png`, `weapon_sling.png`.
      - 3 Dải spritesheet tấn công 6 khung hình tỉ lệ 64×48 px (tổng 384×48 px) diễn hoạt Trứng vung gậy, đâm dao, kéo bắn ná: `player_egg_attack_staff_side.png`, `player_egg_attack_dagger_side.png`, `player_egg_attack_sling_side.png`.
    - Hỗ trợ kích thước khung linh hoạt trong `animations.json` và `setup_animations()` (`frame_width`, `frame_height`), không bị bó buộc 32×32.
    - Cơ chế chuyển hoạt ảnh tự động theo vũ khí (`get_attack_animation_name`): `staff_wood` → `attack_staff`, `dagger` → `attack_dagger`, `sling` → `attack_sling`, mặc định → `attack_side`.
    - Cân chỉnh trọng tâm động (`update_sprite_offset_for_animation`):
      - Khi thi triển đòn đánh 64×48: offset tự động chuyển thành `Vector2(±10, -20)` theo hướng lật mặt `flip_h`, giữ chân chạm đất tại $y=0$ và tâm trứng trùng khớp với va chạm di chuyển & hurtbox.
      - Khi kết thúc đòn đánh hoặc chuyển sang idle/run/roll/death: offset trả về chuẩn `Vector2(0, -16)`.
    - Diễn hoạt gồng lực (Heavy Charge): giữ nguyên khung tụ lực (frame 1) xoay mượt mà theo 8 hướng WASD, nhả đòn kích hoạt trọn vẹn chuỗi diễn hoạt đòn nặng uy lực.
    - Tối ưu `egg_visual.gd`: ẩn sprite vẽ bù khi vũ khí đã có diễn hoạt sprite riêng, tránh vẽ đè (double draw), đồng thời bảo toàn vệt chém hào quang, tia sáng và đạn đá.
    - Công cụ trích xuất tự động: `tools/extract_weapon_animations.py`.
    - *File liên quan:* `assets/sprites/weapons/*`, `assets/sprites/player/player_egg_attack_*.png`, `assets/sprites/player/animations.json`, `scripts/player/player.gd`, `scripts/player/egg_visual.gd`, `tools/extract_weapon_animations.py`.

---

## 2. ĐANG LÀM DỞ / CHƯA HOÀN THIỆN

1. **Khu vực Môi trường & Tilemap Chương 0 (Tổ Hoang):**
   - Chưa dựng TileSet 16×16 px nền và tường gạch theo bảng màu GDD. Hiện test_arena vẫn đang dùng `ColorRect` đơn giản.
2. **Boss Chương 0: Quạ Gác Tổ (64×64 px):**
   - Đã có khung kế thừa `BaseEnemy`, sẵn sàng để mở rộng phase và các kỹ năng mổ thẳng (`peck`), quét cánh (`sweep`), dập lao (`dive`).
3. **Hệ thống Giao diện Menu Pause:**
   - Đã có màn hình lên cấp tại Ổ Rơm và lưu/tải tự động, nhưng chưa có màn hình UI Pause Menu khi nhấn phím Escape trong lúc khám phá ngoài Ổ Rơm.

---

## 3. ĐIỂM KHÁC SO VỚI GDD HOẶC CHARACTER_SPEC (VÀ LÝ DO)

1. **Hoạt ảnh Hurt (Bị thương):**
   - *Theo CHARACTER_SPEC:* Hoạt ảnh 2 khung `hurt_side` nheo mắt há miệng.
   - *Thực tế triển khai:* Người dùng yêu cầu bỏ thiết kế hoạt ảnh này vì làm mất dáng nhân vật; chuyển sang giữ nguyên char, hiển thị vết nứt nứt dần theo thanh máu giảm và văng mảnh vỏ trực tiếp bằng `egg_visual.gd`.
2. **Hoạt ảnh Death:**
   - *Theo CHARACTER_SPEC:* 6 khung hình hướng `side`.
   - *Thực tế triển khai:* Sử dụng bản mẫu tham khảo 7 khung (vỡ vỏ $\rightarrow$ ngã $\rightarrow$ tràn lòng $\rightarrow$ tan dần $\rightarrow$ biến mất) áp dụng chung cho mọi hướng.
3. **Cơ chế Combo 3 đòn:**
   - *Theo CHARACTER_SPEC:* Hoạt ảnh `attack` 5 khung cơ bản.
   - *Thực tế triển khai:* Combo 3 đòn liên hoàn sử dụng chung dải hoạt ảnh 5 khung nhưng khác biệt về thông số sát thương (`[15, 18, 28]`), tiêu hao thể lực (`[10.0, 12.0, 18.0]`), thời gian hồi (`[0.15, 0.15, 0.45]`) và độ rộng vệt chém phụ trợ.
4. **Sprite các hướng cho Death:**
   - *Theo CHARACTER_SPEC:* Chỉ cần `death_side`.
   - *Thực tế triển khai:* Đăng ký cả `death_down`, `death_up`, `death_side` trong `animations.json` (dùng chung file `player_egg_death.png`) để code logic xoay hướng nào cũng gọi được mà không văng lỗi thiếu key.

---

## 4. CÁC QUYẾT ĐỊNH ĐÃ CHỐT

1. **Kích thước va chạm & Hurtbox:**
   - Va chạm di chuyển nhân vật: cố định `10 × 6 px` sát chân.
   - Hurtbox nhận đòn: cố định `10 × 14 px` giữa thân.
   - Đồng bộ từ `stats.json` nạp vào code khi khởi chạy.
2. **Cơ chế tấn công cận chiến:**
   - Đánh theo `facing_direction` (chuẩn hóa 3 hướng: `down`, `up`, `side` với `flip_h` khi quay trái).
   - Tấn công khóa di chuyển trong thoáng chốc (`velocity = Vector2.ZERO`).
   - Sử dụng `hit_frames: [2]` bắt qua tín hiệu `frame_changed` của `AnimatedSprite2D`.
3. **Cơ chế Đỡ đòn (Guard):**
   - Bấm giữ `guard`: Tốc độ di chuyển giảm 45%, không hồi Stamina.
   - Cung đỡ 180 độ phía trước, giảm 75% sát thương, tốn 25 Stamina/hit, cộng +2 điểm `GUARD`. Hết stamina bị vỡ thế đỡ (choáng 0.8s, nhận trọn sát thương).
4. **Kẻ thù AI:**
   - Xây dựng trên `BaseEnemy`, phân chia rõ ràng các trạng thái bằng FSM. Luôn có báo hiệu nhấp nháy Đỏ Gạch trước khi kích hoạt hitbox sát thương.
5. **Quy tắc Bảng màu & Pixel Art:**
   - Tuyệt đối 16 màu cố định trong `Palette.gd`.
   - Viền ngoài `NAU_HAM (#2B1F1A)`. Lọc hình `Nearest`.
6. **Tách biệt Dữ liệu và Mã nguồn:**
   - Tất cả thông số sát thương, máu, tốc độ, hồi thể lực, cự ly và thời gian của Player và Enemy bắt buộc đặt trong `data/stats.json`.

---

## 5. BỘ ĐẾM HÀNH VI, AUTOLOAD & INPUT MAP HIỆN CÓ

### Bộ đếm hành vi ẩn (BehaviorTracker):
- `GUARD`: +2 khi đỡ đòn thành công (mỗi đòn tối đa 1 lần); +4 khi đỡ khéo (parry) thành công. (Đã bỏ luật +1 mỗi 10 sát thương cận chiến).
- `DODGE`: +2 khi lăn né tránh đòn trong i-frame (mỗi đòn tối đa 1 lần); +2 khi đâm lén (backstab); +1 khi đánh trúng bằng vũ khí có thẻ `behavior_tag: DODGE` (Dao Găm).
- `MAGIC`: +1 khi đánh trúng bằng vũ khí có thẻ `behavior_tag: MAGIC` (Ná); +2 khi dùng phép/tầm xa đặc biệt.
- `EXPLORE`: +5 khi tìm lối tắt/mở rương/phòng ẩn. (Đã bỏ +1 khi nhặt Mảnh Vỏ Vụn).
- `SUPPORT`: +3 khi dùng hỗ trợ/hồi máu (chưa có item hồi máu).

### Autoload (Project Settings):
1. `Palette` $\rightarrow$ `*res://scripts/autoload/palette.gd`
2. `GameData` $\rightarrow$ `*res://scripts/autoload/game_data.gd`
3. `BehaviorTracker` $\rightarrow$ `*res://scripts/autoload/behavior_tracker.gd`
4. `PlayerInventory` $\rightarrow$ `*res://scripts/autoload/player_inventory.gd`
5. `SaveManager` $\rightarrow$ `*res://scripts/autoload/save_manager.gd`

### Input Map (`project.godot`):
- `move_left`: `A`, Mũi tên trái, D-pad Trái, Joypad Trục X âm.
- `move_right`: `D`, Mũi tên phải, D-pad Phải, Joypad Trục X dương.
- `move_up`: `W`, Mũi tên lên, D-pad Lên, Joypad Trục Y âm.
- `move_down`: `S`, Mũi tên xuống, D-pad Xuống, Joypad Trục Y dương.
- `attack`: `J`, Chuột trái, Nút Joypad X (Square/X).
- `heavy_attack`: `U` (hoặc giữ `attack` quá 0.18s).
- `dodge`: `Space`, `K`, Nút Joypad A (Cross/A).
- `guard`: `L`, Chuột phải, Nút Joypad L1 (8 khung đầu là cửa sổ Parry).
- `interact`: `E`, Nút Joypad Y (Triangle/Y).
- `pause`: `Escape`, Nút Joypad Start.
- `swap_weapon`: `Q`, Joypad D-pad Lên.
- Phím gỡ lỗi: `F3` (Bật/tắt overlay theo dõi 5 bộ đếm hành vi và tỉ lệ %).

---

## 6. KẾ HOẠCH CÁC GIAI ĐOẠN TRIỂN KHAI (THEO MỤC 13 CỦA COMBAT_SPEC.md)

Lộ trình ưu tiên cho Vertical Slice: **Giai đoạn A $\rightarrow$ Lên cấp $\rightarrow$ Giai đoạn B $\rightarrow$ Overlay**. Các giai đoạn C, D, E sẽ triển khai khi cảm giác đánh đã hoàn toàn ổn định.

| Giai đoạn | Nội dung trọng tâm | Tiêu chí hoàn thành | Trạng thái |
|---|---|---|---|
| **Giai đoạn A** | - Tạo `data/weapons.json` (3 vũ khí khởi đầu: Gậy Gỗ, Dao Găm, Ná + đòn tay không).<br>- Tách đòn đánh theo khung hình logic 60 FPS (`startup`, `active`, `recovery`, `cancel_from`).<br>- Thêm Input Map: `swap_weapon` (Q / D-pad lên).<br>- Tách dịch vụ: `CombatState`, `HitboxService`, `WeaponDB`. | Đổi mượt mà giữa Gậy / Dao / Ná; mỗi loại có cự ly, tốc độ, hitbox và cảm giác đánh riêng biệt; hitbox bật/tắt đúng khung hình logic. | **ĐÃ HOÀN THÀNH** |
| **Giai đoạn Lên cấp** | - Quản lý Mảnh Vỏ Vụn (EXP) tích lũy của Player.<br>- Điểm lưu Ổ Rơm (`StrawBed`) tương tác bằng phím E.<br>- UI cộng chỉ số tại Ổ Rơm (bàn phím & tay cầm), xem trước chỉ số phát sinh (HP, Stamina, Sát thương, Sức tải).<br>- Công thức tính chỉ số chuẩn mục 9 COMBAT_SPEC.<br>- Cơ chế làm rơi Mảnh Vỏ Vụn tại chỗ chết và nhặt lại.<br>- Lưu/tải chỉ số vào `savegame.json`. | Cộng điểm được, chi phí tính đúng công thức, xem trước chính xác, chỉ số ảnh hưởng trực tiếp gameplay, chết nhặt lại được EXP, lưu/tải không mất tiến trình. | **ĐÃ HOÀN THÀNH** |
| **Giai đoạn B** | - Đòn nặng tích lực (`heavy_charge`).<br>- Hệ thống Poise (độ vững) & Choáng (`stagger`) cho Player và Enemy.<br>- Đâm lén (`backstab` cung 90° phía sau) + Đòn kết liễu (`critical`).<br>- Đỡ khéo (`parry` trong 8 khung đầu của Guard) mở phản đòn.<br>- Game feel (hit-stop, nhấp nháy trắng, rung camera, số sát thương/nhãn nổi).<br>- Luật hành vi theo thẻ `behavior_tag` & F3 Debug Overlay. | Quái bị trừ poise và choáng khi hết poise; đâm lén trúng cung sau nhân sát thương và cộng DODGE; parry thành công gây choáng tức thì và cộng GUARD +4; game feel mượt mà và trực quan; F3 hiển thị chuẩn xác. | **ĐÃ HOÀN THÀNH** |
| **Giai đoạn Overlay** | - Hệ thống tư thế đánh dùng chung của Trứng (`swing_h`, `swing_v`, `thrust`, `shoot`...).<br>- Lớp phủ vũ khí 16×16 px vẽ đè lên bàn tay theo `data/pose_anchors.json`.<br>- Vệt chém (slash effect) riêng từng vũ khí. | Đổi vũ khí tự động đổi sprite vũ khí và vệt chém trên tay nhân vật mà không cần vẽ lại thân Trứng. | **TIẾP THEO** |
| **Giai đoạn C** | - Ô kỹ năng vũ khí (`skill_slot`, `data/skills.json`, nút `skill`).<br>- Thế cầm hai tay (`two_hand`, nút Tab). | Tháo lắp được kỹ năng giữa các vũ khí tương thích; bật hai tay nhận `two_hand_bonus` sát thương nhưng bỏ khiên. | **ĐỂ SAU VERTICAL SLICE** |
| **Giai đoạn D** | - Phụ ma (Lửa, Băng, Thánh, Mục) & Thanh tích lũy trạng thái (Buildup).<br>- Tương tác môi trường cơ bản (cháy rơm, ướt nước). | Tích lũy đủ kích hoạt hiệu ứng rút máu/chậm; lửa lan trên tile rơm. | **ĐỂ SAU VERTICAL SLICE** |
| **Giai đoạn E** | - Tải Vỏ (Equip Load) tính từ trọng lượng vũ khí/giáp so với `equip_capacity`.<br>- Ba bậc lăn né: Nhẹ ($<30\%$), Vừa ($30-70\%$), Nặng ($>70\%$), Quá tải ($>100\%$). | Mang nặng thay đổi độ dài lăn né và khung bất tử i-frame đúng bảng dữ liệu. | **ĐỂ SAU VERTICAL SLICE** |
