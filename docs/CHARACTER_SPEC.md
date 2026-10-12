# CHARACTER_SPEC – Vỡ Vỏ (Shellbound)

Đặc tả nhân vật và sprite cho vertical slice. Đọc cùng `docs/GDD.md`.

**Quy tắc ưu tiên:** GDD.md và file này là nguồn sự thật. Nếu thấy mâu thuẫn hoặc thiếu thông tin, hãy **hỏi người dùng**, không tự đổi. Mục 6 và mục 7 của file này bổ sung/chi tiết hóa mục 2 và mục 10 của GDD.

---

## 1. Quy tắc vẽ chung (nhắc lại từ GDD)

- Chỉ dùng đúng 16 màu trong bảng màu GDD mục 3. Không gradient, không anti-aliasing, không dithering, không bán trong suốt.
- Viền ngoài 1 px màu Nâu Hầm `#2B1F1A` (không dùng đen thuần).
- Nguồn sáng cố định ở **trên-trái**; bóng đổ ở dưới-phải; tối đa 3 mức sáng (sáng – trung – tối).
- Nền sprite trong suốt (PNG). Mọi pixel nằm trên lưới nguyên, không xoay góc lẻ.
- Mọi dạng của Trứng giữ cùng chiều cao thân (±2 px) và cùng điểm chân chạm đất.

### Bảng màu (16 màu)

| Tên | HEX | Tên | HEX |
|---|---|---|---|
| Đen Than | `#14110F` | Kem | `#F4EBD0` |
| Nâu Hầm | `#2B1F1A` | Đỏ Rượu | `#6E1423` |
| Xám Sắt | `#4A4A52` | Đỏ Gạch | `#A8342B` |
| Xám Đá | `#7C7C80` | Xanh Rêu | `#3B4A2A` |
| Nâu Gỗ | `#6B4423` | Xanh Lá Úa | `#6B7F3A` |
| Nâu Da | `#A0693B` | Vàng Cổ | `#C79A2E` |
| Cát | `#D4A86A` | Xanh Thép | `#2F4A63` |
| Giấy Da | `#E8D9B0` | Tím Mục | `#5A3A5E` |

---

## 2. Trứng (dạng khởi đầu)

**Khung vẽ:** 32×32 px. **Điểm neo:** giữa-đáy, tọa độ (16, 31).

| Bộ phận | Quy cách |
|---|---|
| Thân | Bầu dục đứng, khoảng 16 px rộng × 20 px cao, đỉnh hơi thon |
| Viền | 1 px Nâu Hầm bao toàn thân |
| Tô màu | Gốc Giấy Da; vùng sáng Kem (trên-trái); vùng tối Cát (dưới-phải) |
| Mắt | 2 chấm Nâu Hầm, mỗi chấm 1×2 px, cách nhau khoảng 5 px, ở khoảng 40% chiều cao thân tính từ đỉnh |
| Miệng | Không vẽ khi bình thường. Chỉ hiện 1 nét ngang 2 px khi bị đánh hoặc lúc chết |
| Tay | 2 px rộng, dài 5–6 px, gắn hai bên thân ở khoảng giữa; bàn tay 2×2 px |
| Chân | 2 px rộng, dài 4 px; bàn chân 3×2 px |

**Nhận diện bất biến:** dáng trứng bầu dục và hai mắt chấm luôn giữ nguyên ở mọi dạng tiến hóa.

### Hitbox (đơn vị px, tính trong khung 32×32)

| Loại | Kích thước | Vị trí |
|---|---|---|
| Hurtbox (nhận sát thương) | 10 × 14 | Căn giữa thân |
| Va chạm di chuyển (top-down) | 10 × 6 | Sát chân, căn theo điểm neo |

### Bộ hoạt ảnh (vertical slice)

Dùng 3 hướng: `down`, `up`, `side`. Hướng ngang chỉ vẽ một lần (`side`, quay sang phải); hướng trái dùng `flip_h` trong code.

| Hoạt ảnh | Số khung | Hướng | FPS | Ghi chú |
|---|---|---|---|---|
| idle | 4 | down, up, side | 8 | Thân nhún nhẹ 1 px |
| run | 6 | down, up, side | 12 | Tay chân đung đưa, thân hơi chúi |
| roll | 6 | down, up, side | 12 | Thân nghiêng rồi cuộn; khung giữa có vệt gió Cát |
| attack | 5 | down, up, side | 12 | Khung 3 (chỉ số 2 nếu đếm từ 0) là khung gây sát thương |
| hurt | 2 | side | 12 | Có miệng, mắt nheo |
| death | 6 | side | 10 | Vỏ nứt rồi vỡ làm 3–4 mảnh |

Tổng khoảng 71 khung.

---

## 3. Dạng Nứt (cấp 1, mốc Nứt sau boss Chương 1)

Giữ nguyên thân Trứng, chỉ thêm:

- **Vết nứt** Nâu Hầm chạy từ đỉnh xuống lệch trái, dài khoảng 8 px.
- **Mẻ vỏ** ở đỉnh bên phải, lộ 1–2 px Vàng Cổ bên trong.
- **Gậy gỗ** ở tay phải, dài khoảng 10 px: thân Nâu Gỗ, đầu gậy Nâu Da.
- Hoạt ảnh `attack` đổi thành vung gậy theo vòng cung. Các hoạt ảnh khác dùng lại khung của Trứng, chỉ thêm vết nứt và gậy.
- Cùng khung 32×32, cùng điểm neo, cùng hitbox với Trứng.

---

## 4. Quạ Gác Tổ (boss Chương 0)

**Khung vẽ:** 64×64 px. **Điểm neo:** giữa-đáy.

| Bộ phận | Quy cách |
|---|---|
| Thân | Đen Than; điểm sáng Xám Sắt và Xám Đá ở lưng và cánh (sáng từ trên-trái) |
| Mắt | Đỏ Gạch, 2×2 px |
| Mỏ | Cát, đầu mỏ Nâu Da, dài khoảng 8 px |
| Chân | Nâu Gỗ, ba ngón xòe |
| Cổ | Vòng xích sắt Xám Sắt quanh cổ |
| Sải cánh | Xòe tối đa chiếm khoảng 60 px bề ngang |

**Hurtbox:** thân 28×28 px, đặt thấp ở giữa khung. Cánh không nhận sát thương nhưng gây sát thương khi quét.

### Hoạt ảnh

| Hoạt ảnh | Số khung | FPS | Ghi chú |
|---|---|---|---|
| idle | 4 | 8 | Đầu nghiêng, mắt Đỏ Gạch |
| peck_telegraph | 4 | 10 | Ngửa đầu; mắt nhấp nháy Đỏ Gạch, tổng 0,5 giây |
| peck_strike | 3 | 12 | Mổ thẳng |
| sweep_telegraph | 4 | 10 | Dang cánh, tổng 0,6 giây |
| sweep_strike | 4 | 12 | Quét cánh ngang |
| fly_up | 4 | 10 | Có bóng đổ hiện dưới đất |
| dive | 3 | 12 | Bóng đổ phóng to báo vị trí rơi |
| recover | 4 | 8 | Cửa sổ phản công cho người chơi |
| hurt | 2 | 12 | Nháy sáng 1 khung |
| death | 6 | 10 | Rơi lông, xích rơi xuống |

**Báo hiệu đòn:** mọi đòn gây sát thương phải có báo hiệu Đỏ Gạch rõ ràng trước khi gây sát thương (xem GDD mục 3 và 7). Thời lượng báo hiệu lấy từ dữ liệu, không hard-code trong script.

---

## 5. Cấu trúc file và quy ước đặt tên

Mỗi hoạt ảnh + hướng là **một dải (strip) PNG nằm ngang**, các khung xếp liền nhau từ trái sang phải, mỗi khung đúng 32×32 (nhân vật) hoặc 64×64 (boss).

```
assets/sprites/player/
  player_egg_idle_down.png      (4 khung -> 128x32)
  player_egg_idle_up.png
  player_egg_idle_side.png
  player_egg_run_down.png       (6 khung -> 192x32)
  ...
  player_egg_hurt_side.png
  player_egg_death_side.png
  player_crack_idle_down.png    (Dạng Nứt, cùng quy ước)

assets/sprites/bosses/
  boss_quagac_idle.png          (4 khung -> 256x64)
  boss_quagac_peck_telegraph.png
  boss_quagac_peck_strike.png
  ...
```

Quy ước tên: `loai_ten_hanhdong_huong.png` (nhân vật) và `loai_ten_hanhdong.png` (boss, không có hướng). Với dải khung, không đánh số khung trong tên file.

Kèm mỗi nhóm một file mô tả `animations.json` ghi rõ: tên hoạt ảnh, số khung, fps, có lặp hay không. Ví dụ:

```json
{
  "player_egg": {
    "frame_size": [32, 32],
    "animations": {
      "idle_down": { "file": "player_egg_idle_down.png", "frames": 4, "fps": 8, "loop": true },
      "roll_down": { "file": "player_egg_roll_down.png", "frames": 6, "fps": 12, "loop": false }
    }
  }
}
```

---

## 6. Hướng dẫn tích hợp vào Godot (cho AI code)

1. Cắt dải PNG thành khung bằng `SpriteFrames` (hoặc `AtlasTexture`) cho `AnimatedSprite2D`, đọc thông số từ `animations.json`, không gõ cứng.
2. Texture filter = Nearest (đã đặt toàn project). Không scale sprite khác số nguyên.
3. Điểm neo giữa-đáy: đặt `offset` của sprite sao cho điểm (16, 31) trùng vị trí chân của node nhân vật.
4. Hướng trái: dùng `flip_h = true` trên hoạt ảnh `side`. Hitbox đòn đánh cũng phải lật theo.
5. Khung gây sát thương của `attack` (và các đòn của boss) bật hitbox đúng khung, tắt ở khung sau. Dùng tín hiệu theo khung (frame_changed) hoặc AnimationPlayer, không dùng bộ đếm thời gian riêng.
6. Thay hình khối tạm bằng sprite thật **từng phần một** (idle trước, rồi run, roll, attack), mỗi phần chạy được mới sang phần tiếp.
7. Giữ nguyên hitbox ở mục 2 và mục 4 dù sprite thay đổi, vì hitbox gắn với cân bằng game chứ không gắn với hình vẽ.

---

## 7. Prompt mẫu để vẽ sprite (dùng với công cụ vẽ ảnh)

Bắt đầu bằng **một tư thế duy nhất** (Trứng, idle, hướng xuống):

```
Pixel art game sprite, 32x32 pixels, a small cute egg character with tiny stick arms and legs, standing idle facing the viewer (top-down 3/4 view).
Egg body: smooth oval, about 16 px wide and 20 px tall, with two small dot eyes (1x2 px each) placed about 5 px apart. Limbs 2 px wide, hands and feet as small blocks.
Strict style rules: 1 px dark outline, flat colors only, NO gradients, NO anti-aliasing, NO blur, NO dithering, hard pixel edges, light source from top-left, exactly 3 shading levels.
Use ONLY these colors: outline #2B1F1A, shell base #E8D9B0, highlight #F4EBD0, shadow #D4A86A.
Transparent background. Medieval dark fantasy mood, cute but slightly melancholic.
Output a single sprite centered on a 32x32 canvas, no text, no border, no background.
```

Khi đã có mẫu ưng ý, dùng nó làm **ảnh tham chiếu** cho các tư thế khác: *"same character, same colors, same proportions, now running, frame 3 of 6"*.

Với Quạ Gác Tổ, dùng cùng cấu trúc prompt: khung 64×64, mô tả theo mục 4, bảng màu gồm `#14110F`, `#4A4A52`, `#7C7C80`, `#A8342B`, `#D4A86A`, `#A0693B`, `#6B4423`, viền `#2B1F1A`.

---

## 8. Kiểm tra chất lượng (mỗi sprite phải qua trước khi vào game)

1. **Màu:** đúng 16 màu của bảng. Nếu thừa màu, chuyển sang Indexed với bảng 16 màu để ép mọi pixel về đúng bảng.
2. **Lưới:** phóng 800%, không có pixel mờ, nửa trong suốt hoặc răng cưa lạ.
3. **Kích thước:** đúng 32×32 (nhân vật) hoặc 64×64 (boss), đúng điểm neo.
4. **Hoạt ảnh:** xếp các khung thành chuỗi, không bị nhảy vị trí hoặc đổi hình dáng giữa các khung.
5. **Trong game:** thử trên `test_arena`, kiểm tra độ rõ so với nền và kích thước 320×180.

Nếu một sprite không đạt, báo lại người dùng thay vì tự thay đổi bảng màu hoặc kích thước.
