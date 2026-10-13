# BÁO CÁO TÌNH TRẠNG DỰ ÁN "VỠ VỎ" (SHELLBOUND)
*Ngày khảo sát: 13/10/2026*  
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

### Các việc bổ sung ở các phiên gần nhất (Sprite & Visuals):
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

---

## 2. ĐANG LÀM DỞ / CHƯA CHẮC CHẠY ĐÚNG

1. **Hành động Đỡ đòn (Guard):**
   - Đã có action `guard` trong Input Map (`L`, chuột phải, Joypad L1) và hằng số `ACTION_GUARD`, nhưng trong `player.gd` chưa hiện thực hóa logic bấm giữ đỡ đòn (chưa có trạng thái `is_guarding`, giảm trừ sát thương khi đỡ, tiêu hao stamina khi đỡ).
2. **Kẻ thù chỉ mới là bao cát (DummyEnemy):**
   - Đứng yên một chỗ, chưa có AI đuổi theo người chơi hay tìm đường (Navigation/Pathfinding).
3. **File kịch bản ngoài luồng còn sót lại trong thư mục gốc:**
   - Các file python và gdscript tạo sprite hỗ trợ (`generate_run_roll_sprites.gd`, `make_hurt_death.py`, `slice_spritesheet.py`, v.v.) chưa được dọn vào thư mục `tools/` riêng.
4. **Hệ thống EXP / Mảnh Vỏ Vụn (Lost Runes mechanic):**
   - Cơ chế nhặt lại Mảnh Vỏ Vụn tại vị trí chết (mục 7 GDD) chưa được code, hiện tại chết chỉ đếm ngược 1.5s rồi respawn về vị trí spawn ban đầu.

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
4. **Sprite hướng Side cho Death:**
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
3. **Quy tắc Bảng màu & Pixel Art:**
   - Tuyệt đối 16 màu cố định trong `Palette.gd`.
   - Viền ngoài `NAU_HAM (#2B1F1A)`. Lọc hình `Nearest`.
4. **Tách biệt Dữ liệu và Mã nguồn:**
   - Tất cả thông số sát thương, máu, tốc độ, hồi thể lực... bắt buộc đặt trong `data/stats.json`.

---

## 5. BỘ ĐẾM HÀNH VI, AUTOLOAD & INPUT MAP HIỆN CÓ

### Bộ đếm hành vi ẩn (BehaviorTracker):
- `GUARD`: +2 khi đỡ đòn thành công; +1 mỗi 10 sát thương cận chiến gây ra (đã tích hợp trong đòn đánh).
- `DODGE`: +2 khi lăn né tránh đòn trong i-frame (đã tích hợp với đòn đánh của DummyEnemy).
- `MAGIC`: +2 khi đánh trúng bằng phép/tầm xa (chưa có vũ khí phép).
- `EXPLORE`: +5 khi tìm lối tắt/mở rương (chưa có hầm ngục).
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

1. **Hiện thực hóa cơ chế Đỡ đòn (Guard):**
   - Thêm trạng thái Guard khi giữ nút `guard`.
   - Tiêu hao stamina khi chặn đòn, giảm sát thương nhận vào, cộng điểm `GUARD` vào `BehaviorTracker`.
2. **Cơ chế Nhặt lại Mảnh Vỏ Vụn (EXP drop upon death):**
   - Khi chết để lại node `DeathRune`/`LostShell` tại vị trí chết.
   - Nhặt lại hồi phục EXP; chết lần 2 trước khi nhặt thì xóa mất.
3. **Nâng cấp Kẻ thù thường & AI tuần tra / truy đuổi:**
   - Xây dựng lớp quái cơ bản có AI di chuyển về phía Player khi vào tầm phát hiện.
4. **Xây dựng Tilemap môi trường Tổ Hoang (Chương 0):**
   - Tạo tile nền 16×16 px chuẩn 16 màu theo GDD.
5. **Hiện thực hóa Boss Chương 0: Quạ Gác Tổ (64×64 px):**
   - Thiết kế logic đòn mổ (`peck`), quét cánh (`sweep`), bay dập (`dive`) kèm bóng đổ cảnh báo.
