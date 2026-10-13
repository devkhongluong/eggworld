# BÁO CÁO TÌNH TRẠNG DỰ ÁN "VỠ VỎ" (SHELLBOUND)
*Cập nhật lần cuối: 13/10/2026*  
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

---

## 2. ĐANG LÀM DỞ / CHƯA HOÀN THIỆN

1. **Cơ chế Nhặt lại Mảnh Vỏ Vụn đã mất khi Chết (Lost Runes mechanic - GDD mục 7):**
   - Hiện tại Player chết chỉ rơi thông báo đếm ngược hồi sinh về điểm spawn, chưa rơi node `LostShell` chứa toàn bộ EXP đã tích lũy tại vị trí chết để người chơi nhặt lại.
2. **Khu vực Môi trường & Tilemap Chương 0 (Tổ Hoang):**
   - Chưa dựng TileSet 16×16 px nền và tường gạch theo bảng màu GDD. Hiện test_arena vẫn đang dùng `ColorRect` đơn giản.
3. **Boss Chương 0: Quạ Gác Tổ (64×64 px):**
   - Đã có khung kế thừa `BaseEnemy`, sẵn sàng để mở rộng phase và các kỹ năng mổ thẳng (`peck`), quét cánh (`sweep`), dập lao (`dive`).
4. **Hệ thống Giao diện Menu & Lưu/Tải game:**
   - `SaveManager.gd` đã có hàm lưu và đọc `user://savegame.json`, nhưng chưa có màn hình UI Pause Menu hoặc Nút Save/Load trong game.

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
- `GUARD`: +2 khi đỡ đòn thành công (mỗi đòn tối đa 1 lần); +1 mỗi 10 sát thương cận chiến gây ra.
- `DODGE`: +2 khi lăn né tránh đòn trong i-frame (mỗi đòn tối đa 1 lần).
- `MAGIC`: +2 khi đánh trúng bằng phép/tầm xa (chưa có vũ khí phép).
- `EXPLORE`: +5 khi tìm lối tắt/mở rương, +1 khi nhặt Mảnh Vỏ Vụn.
- `SUPPORT`: +3 khi dùng hỗ trợ/hồi máu (chưa có item hồi máu).

### Autoload (Project Settings):
1. `Palette` $\rightarrow$ `*res://scripts/autoload/palette.gd`
2. `GameData` $\rightarrow$ `*res://scripts/autoload/game_data.gd`
3. `BehaviorTracker` $\rightarrow$ `*res://scripts/autoload/behavior_tracker.gd`
4. `SaveManager` $\rightarrow$ `*res://scripts/autoload/save_manager.gd`

### Input Map (`project.godot`):
- `move_left`: `A`, Mũi tên trái, D-pad Trái, Joypad Trục X âm.
- `move_right`: `D`, Mũi tên phải, D-pad Phải, Joypad Trục X dương.
- `move_up`: `W`, Mũi tên lên, D-pad Lên, Joypad Trục Y âm.
- `move_down`: `S`, Mũi tên xuống, D-pad Xuống, Joypad Trục Y dương.
- `attack`: `J`, Chuột trái, Nút Joypad X (Square/X).
- `dodge`: `Space`, `K`, Nút Joypad A (Cross/A).
- `guard`: `L`, Chuột phải, Nút Joypad L1.
- `interact`: `E`, Nút Joypad Y (Triangle/Y).
- `pause`: `Escape`, Nút Joypad Start.

---

## 6. CÁC BƯỚC TIẾP THEO ĐỀ XUẤT (THEO THỨ TỰ)

1. **Cơ chế Nhặt lại Mảnh Vỏ Vụn khi Chết (Lost Runes mechanic - GDD mục 7):**
   - Khi chết để lại node `DeathRune` tại chỗ chết chứa số EXP đã tích lũy. Nhặt lại hồi phục; nếu chết lần 2 trước khi nhặt thì mất hẳn.
2. **Xây dựng Tilemap môi trường Tổ Hoang (Chương 0):**
   - Tạo tile nền và tường hầm 16×16 px chuẩn 16 màu theo GDD.
3. **Hiện thực hóa Boss Chương 0: Quạ Gác Tổ (64×64 px):**
   - Kế thừa `BaseEnemy`, triển khai 3 chiêu: Mổ thẳng (`peck`), quét cánh (`sweep`), dập lao (`dive` kèm bóng đổ báo vị trí).
4. **Hệ thống Giao diện Menu Tạm dừng (Pause Menu) & Màn Lưu/Tải:**
   - Kết nối trực tiếp vào `SaveManager.gd`.
