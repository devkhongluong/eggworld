# COMBAT_SPEC – Hệ chiến đấu và lên cấp (Vỡ Vỏ)

Đọc cùng `docs/GDD.md` và `docs/CHARACTER_SPEC.md`.

**Quy tắc ưu tiên:** ở các điểm liệt kê trong mục 14, file này **thay thế** GDD. Nếu thấy mâu thuẫn khác hoặc thiếu thông tin, hãy **hỏi người dùng**, không tự đổi. Mọi con số trong file này là **giá trị tạm**, phải nằm trong file dữ liệu (JSON) để chỉnh cân bằng, không hard-code trong script.

---

## 1. Nguyên tắc thiết kế

1. **Mọi vũ khí dùng được ở mọi dạng.** Thiếu chỉ số yêu cầu thì bị phạt (đánh yếu hơn, tốn Stamina hơn), không bị khóa.
2. **Tiến hóa khuếch đại, không khóa.** Dạng nở ra tăng thành thạo, thêm một kỹ năng riêng và một bản năng bị động. Không dạng nào bị cấm cầm loại vũ khí nào.
3. **Sáng tạo đến từ việc ghép các lớp độc lập:** vũ khí × kỹ năng vũ khí × phụ ma × thế cầm × môi trường. Mỗi lớp là dữ liệu riêng, không phụ thuộc cứng vào nhau.
4. **Hành vi quyết định dạng tiến hóa, chỉ số thì không.** Cộng điểm chỉ số vào đâu không ảnh hưởng dạng nở; chỉ 5 bộ đếm hành vi (GUARD, DODGE, MAGIC, EXPLORE, SUPPORT) quyết định. Hai hệ thống này độc lập.
5. **Dữ liệu trước, code sau.** Mọi đòn đánh, vũ khí, kỹ năng, công thức là bản ghi dữ liệu.

---

## 2. Hành động và Input Map

Đã có: `move_*`, `attack`, `dodge`, `guard`, `interact`, `pause`. Cần thêm:

| Action | Mặc định bàn phím | Mặc định tay cầm | Ghi chú |
|---|---|---|---|
| `skill` | I | RB | Dùng kỹ năng vũ khí (giai đoạn C) |
| `swap_weapon` | Q | D-pad lên | Đổi giữa 2 ô vũ khí |
| `two_hand` | Tab (nhấn đổi) | Nhấn cần phải | Bật/tắt cầm hai tay (giai đoạn C) |
| `use_item` | R | D-pad phải | Dùng vật phẩm đang chọn |
| `cycle_item` | Z | D-pad xuống | Chọn vật phẩm kế |

`attack`: **nhấn** = đòn nhẹ; **giữ quá ngưỡng** = đòn nặng (tích lực). Ngưỡng giữ lấy từ dữ liệu.

---

## 3. Máy trạng thái của nhân vật

Các trạng thái: `idle`, `move`, `attack_startup`, `attack_active`, `attack_recovery`, `heavy_charge`, `dodge`, `guard`, `parry_window`, `stagger`, `dead`.

Quy tắc chung:
- Mỗi đòn đánh có 3 pha tính **theo khung hình** (frame): `startup` (chuẩn bị) → `active` (hitbox bật) → `recovery` (hồi). Chỉ pha `active` mới gây sát thương.
- `cancel_from`: từ khung này của pha recovery, người chơi được hủy sang `dodge` hoặc nối đòn kế tiếp trong chuỗi.
- Né (`dodge`) hủy được recovery nhưng không hủy được startup và active (trừ vũ khí/kỹ năng có ghi rõ).
- Khi `stagger` (bị choáng), không điều khiển được trong thời gian choáng.
- Mọi trạng thái đọc thông số từ dữ liệu; đổi vũ khí chỉ đổi bản ghi dữ liệu đang dùng.

---

## 4. Dữ liệu đòn đánh

Mỗi vũ khí là một bản ghi trong `data/weapons.json`. Mẫu:

```json
{
  "staff_wood": {
    "name": "Gậy Gỗ",
    "type": "staff",
    "pose_set": "swing",
    "weight": 3.0,
    "base_damage": 12,
    "scaling": { "STR": "C", "DEX": "D", "INT": "-", "FAI": "-" },
    "requirements": { "STR": 8, "DEX": 8 },
    "light_chain": [
      { "pose": "swing_h", "startup": 4, "active": 3, "recovery": 6, "cancel_from": 3,
        "hitbox": { "shape": "arc", "radius": 18, "angle": 120 },
        "damage_mv": 1.0, "stamina": 8, "poise_dmg": 10, "combo_window": 10 },
      { "pose": "swing_h_rev", "startup": 4, "active": 3, "recovery": 6, "cancel_from": 3,
        "hitbox": { "shape": "arc", "radius": 18, "angle": 120 },
        "damage_mv": 1.0, "stamina": 8, "poise_dmg": 10, "combo_window": 10 },
      { "pose": "swing_v", "startup": 6, "active": 3, "recovery": 12, "cancel_from": 8,
        "hitbox": { "shape": "arc", "radius": 20, "angle": 90 },
        "damage_mv": 1.5, "stamina": 12, "poise_dmg": 22, "combo_window": 0 }
    ],
    "heavy": { "pose": "swing_v", "charge_min": 0.25, "charge_max": 0.9, "startup": 8,
               "active": 4, "recovery": 14, "hitbox": { "shape": "arc", "radius": 22, "angle": 100 },
               "damage_mv_min": 1.8, "damage_mv_max": 2.6, "stamina": 22, "poise_dmg": 40 },
    "skill_slot": true,
    "two_hand_bonus": 1.35
  }
}
```

Quy ước:
- Đơn vị thời gian đòn là **khung hình tại 60 FPS logic** (không phụ thuộc FPS hoạt ảnh).
- `hitbox.shape`: `arc` (cung), `rect`, `circle`, `line`, `projectile`. Hitbox đặt theo `facing_direction` và lật theo `flip_h`.
- `pose`/`pose_set`: tên tư thế thân dùng để chọn hoạt ảnh thân chung (xem mục 11).
- Chuỗi nhẹ: nếu bấm `attack` trong `combo_window` khung sau pha active thì nối đòn kế; không thì reset.

### Ba vũ khí cho vertical slice

| Vũ khí | Kiểu | Đặc điểm |
|---|---|---|
| **Gậy Gỗ** (mặc định của Dạng Nứt) | Cận chiến, cung quét | Chuỗi 3 đòn, cân bằng, đòn 3 chậm và nặng |
| **Dao Găm** | Cận chiến, tầm ngắn | Rất nhanh, tốn ít Stamina, tầm ngắn, nhân hệ số cao khi đâm lén; đòn nặng là đâm xuyên thẳng |
| **Ná** | Tầm xa | Đạn bay (projectile); nhẹ = bắn thẳng, nặng = tích lực bắn mạnh; tốn Stamina, không tốn đạn ở giai đoạn đầu; cộng điểm MAGIC khi trúng (xem mục 12) |

Trứng khởi đầu (chưa Nứt) dùng **đòn tay không** (một bản ghi `fist` ngắn, yếu), nhặt được vũ khí ở Chương 0–1.

---

## 5. Poise, choáng, đâm lén, đỡ khéo

**Poise (độ vững):** mỗi thực thể có thanh poise. Mỗi đòn trúng trừ `poise_dmg`. Khi poise về 0 thì **choáng** (`stagger`) trong thời gian cố định, rồi poise hồi đầy. Poise tự hồi chậm nếu không bị đánh trong một khoảng thời gian.

**Đòn kết liễu (critical):** đánh trúng kẻ đang choáng từ phía trước, hoặc đánh vào lưng khi kẻ thù chưa phát hiện/đang quay lưng, gây `critical_mult` lần sát thương (từ dữ liệu). Đòn kết liễu có hoạt ảnh/khóa ngắn và là một khung bất tử cho người chơi.

**Đâm lén (backstab):** kẻ thù có `facing_direction`; đánh từ cung 90° phía sau là đâm lén. Mỗi lần đâm lén thành công cộng bộ đếm DODGE (xem mục 12).

**Đỡ khéo (parry):** khi bấm `guard`, 8 khung đầu tiên là `parry_window`. Nếu đòn của kẻ thù trúng trong cửa sổ này (và thuộc loại đỡ khéo được), kẻ thù **bị choáng ngay** và người chơi được phản đòn. Đỡ khéo thành công cộng GUARD nhiều hơn đỡ thường (xem mục 12). Đòn nào đỡ khéo được ghi trong dữ liệu của kẻ thù (`parryable`).

---

## 6. Thế cầm và Tải Vỏ

**Thế cầm** (giai đoạn C): bật `two_hand` thì dùng `two_hand_bonus` cho sát thương vũ khí đó, nhưng không dùng khiên/ô phụ. Cầm một tay thì có thể dùng ô phụ (khiên hoặc vật phẩm).

**Tải Vỏ (equip load)** (giai đoạn E): tổng `weight` của vũ khí + giáp so với `equip_capacity` (tính từ VIT).
- Dưới 30% sức tải: lăn **nhẹ** (nhiều khung bất tử nhất, lăn xa).
- 30–70%: lăn **vừa**.
- Trên 70%: lăn **nặng** (ít khung bất tử, chậm).
- Vượt 100%: không lăn được, chỉ bước lùi.
Bảng khung bất tử và khoảng lăn theo từng bậc để trong JSON.

---

## 7. Kỹ năng vũ khí (giai đoạn C)

Mỗi vũ khí có một ô kỹ năng (`skill_slot`). Kỹ năng là bản ghi riêng trong `data/skills.json`, **tháo ráp được** giữa các vũ khí tương thích (theo `compatible_types`). Kỹ năng tốn Stamina và/hoặc MP, có hồi chiêu. Ví dụ ba kỹ năng đầu: **Lao Thẳng** (lao tới và đâm), **Xoáy Vòng** (quét 360°), **Ném Vỏ** (ném mảnh vỏ gây choáng nhẹ). Kỹ năng rơi từ boss/hầm ngục hoặc bán ở cửa hàng.

---

## 8. Phụ ma và trạng thái (giai đoạn D)

**Phụ ma (imbue):** vật phẩm tiêu hao hoặc ô gắn, thêm sát thương nguyên tố và tích lũy trạng thái lên vũ khí trong một thời gian.

| Nguyên tố | Trạng thái | Mô tả |
|---|---|---|
| Lửa | Cháy | Sát thương theo thời gian, đốt vật liệu dễ cháy |
| Băng (Lòng Trắng) | Đóng băng/chậm | Giảm tốc, làm choáng khi đầy |
| Thánh (Vàng Cổ) | Hồi/khắc Mục | Mạnh với quái Mục Rữa |
| Mục | Mục Rữa | Sát thương theo thời gian, giảm HP tối đa tạm thời |

**Tích lũy trạng thái (buildup):** mỗi đòn cộng vào thanh trạng thái của mục tiêu; khi đầy thì kích hoạt hiệu ứng rồi thanh về 0, có thời gian miễn nhiễm ngắn. Khả năng kháng riêng theo từng kẻ thù (dữ liệu).

**Môi trường:** mỗi tile có thuộc tính (ví dụ `flammable`, `wet`, `rot`). Quy tắc đơn giản: lửa lan trên tile `flammable` và gây Cháy cho ai đứng trên; nước làm `wet`, `wet` + Băng thì tăng buildup; Mục lan chậm trên tile cỏ. Làm tối thiểu (1–2 tương tác) ở giai đoạn D.

---

## 9. Chỉ số và lên cấp (người chơi tự cộng)

Sáu chỉ số hiện ra cho người chơi: **VIT, STR, DEX, INT, FAI, LUK** (giá trị khởi đầu 10, theo `stats.json`).

**Lên cấp:**
- Dùng **Mảnh Vỏ Vụn** (đơn vị EXP) để lên cấp, **chỉ thực hiện ở Ổ Rơm** (như điểm lưu).
- Mỗi cấp được cộng **1 điểm** vào **một** chỉ số do người chơi chọn.
- Cấp độ = `1 + tổng điểm đã cộng`. Có thể lên nhiều cấp liên tiếp nếu đủ Mảnh Vỏ Vụn.
- Chi phí lên cấp tăng theo cấp: `cost(level) = round(cost_base * cost_growth ^ (level - 1))` (tham số `cost_base`, `cost_growth` trong JSON; mặc định tạm 40 và 1.18).
- Chưa có reset chỉ số ở vertical slice (để sau, bằng vật phẩm hiếm).

**Giao diện cộng chỉ số tại Ổ Rơm:**
- Hiện cấp hiện tại, số Mảnh Vỏ Vụn đang có, chi phí lên cấp tiếp theo.
- Mỗi chỉ số: giá trị hiện tại, nút `+` / `-` (tạm thời trước khi xác nhận), và **xem trước chỉ số phát sinh** thay đổi ra sao (HP, Stamina, sát thương vũ khí đang cầm, sức tải...).
- Nút xác nhận mới trừ Mảnh Vỏ Vụn và áp dụng; có nút hủy.
- Điều khiển được bằng bàn phím và tay cầm.

**Công thức tạm (đặt trong `stats.json`):**
- `max_hp = 60 + VIT * 4` (VIT 10 → 100)
- `max_stamina = 60 + VIT * 2` (VIT 10 → 80)
- `equip_capacity = 40 + VIT * 1.5`
- `max_mp = 20 + INT * 3` (chỉ dùng cho kỹ năng/phép)
- Sát thương vũ khí: `base_damage * damage_mv * (1 + sum(scaling_coeff[grade] * max(0, stat - 10)))`, hệ số `scaling_coeff`: S 0.08, A 0.06, B 0.045, C 0.03, D 0.02, E 0.01 (mỗi điểm trên 10).
- Thiếu chỉ số yêu cầu: sát thương nhân `(1 - 0.05 * số điểm thiếu)`, tối thiểu 0.5; Stamina tốn nhân `(1 + 0.04 * số điểm thiếu)`.
- LUK: tăng tỉ lệ rơi đồ hiếm và tỉ lệ chí mạng nhỏ.

---

## 10. Hành động đặc trưng của Trứng

Có từ đầu và giữ suốt game, biến đổi theo dạng tiến hóa:

| Hành động | Mô tả | Biến đổi theo dạng (gợi ý) |
|---|---|---|
| Lăn húc | Lăn né mà trúng kẻ thù thì húc nhẹ, gây choáng ngắn | Hiệp Sĩ: đâm khiên; Sát Thủ: xuyên qua lưng |
| Co vỏ | Thế đỡ thu mình | Tu Sĩ: vỏ phát sáng giảm sát thương cho gần kề |
| Nhặt và ném | Nhặt vật nhỏ (rơm, đá, vỏ vụn) ném đi gây sát thương nhẹ/dụ kẻ thù | Lữ Khách: ném nhiều vật, bẫy |

Lăn húc và co vỏ dùng lại cơ chế lăn né và guard, chỉ thêm hitbox/hiệu ứng.

---

## 11. Vũ khí hiển thị như lớp phủ (overlay)

Để không phải vẽ riêng hoạt ảnh nhân vật cho từng vũ khí:

- Thân Trứng chỉ có một số **tư thế đánh chung** (`swing_h`, `swing_h_rev`, `swing_v`, `thrust`, `shoot`, `cast`) × 3 hướng.
- Vũ khí là **sprite riêng 16×16** vẽ chồng lên bàn tay. Mỗi khung của mỗi tư thế có dữ liệu `weapon_anchor`: vị trí (x, y) so với điểm neo thân, góc xoay theo bước 45°, và lớp vẽ (trước/sau thân).
- Vệt chém là một sprite nhỏ riêng cho từng vũ khí, bật ở pha `active`.
- Dữ liệu `weapon_anchor` nằm trong `data/pose_anchors.json`, tách khỏi `animations.json`.

Thêm vũ khí mới = thêm 1 sprite vũ khí + 1 vệt chém + 1 bản ghi dữ liệu, không vẽ lại thân.

---

## 12. Thành thạo vũ khí và bộ đếm hành vi

Bộ đếm hành vi (ẩn, theo GDD mục 6) giữ nguyên 5 bộ; thêm cách cộng điểm từ hệ chiến đấu:

| Sự kiện | Cộng |
|---|---|
| Đỡ thường thành công | GUARD +2 |
| Đỡ khéo (parry) thành công | GUARD +4 |
| Né thành công | DODGE +2 (mỗi đòn một lần) |
| Đâm lén thành công | DODGE +2 |
| Trúng đòn từ xa (ná, phép) | MAGIC +2 |
| Dùng kỹ năng vũ khí kiểu phép | MAGIC +3 |
| Mở rương, tìm lối tắt, hoàn thành phòng ẩn | EXPLORE +5 |
| Hồi máu/dùng vật phẩm hỗ trợ | SUPPORT +3 |

Thêm **thành thạo theo loại vũ khí** (`staff`, `dagger`, `sling`, ...): mỗi lần trúng đòn cộng điểm thành thạo cho loại vũ khí đang dùng, cấp thành thạo tăng một bonus nhỏ (ví dụ +2% sát thương, +1 khung `cancel` sớm hơn ở mốc cao). Dữ liệu thành thạo lưu cùng save. Dạng Hỗn Mang nhận bonus nhỏ khi đổi vũ khí giữa trận.

---

## 13. Giai đoạn triển khai

| Giai đoạn | Nội dung | Tiêu chí hoàn thành |
|---|---|---|
| **A** | `weapons.json`, đòn nhẹ theo khung hình, chuỗi 3 đòn, 3 vũ khí (hình khối tạm), đổi vũ khí | Đổi được giữa gậy/dao/ná, mỗi loại cảm giác đánh khác nhau, hitbox đúng khung |
| **Lên cấp** | Mảnh Vỏ Vụn, Ổ Rơm, UI cộng chỉ số, công thức mục 9, lưu/tải | Cộng điểm được, xem trước đúng, chỉ số ảnh hưởng HP/Stamina/sát thương, lưu giữ sau khi tải lại |
| **B** | Đòn nặng, poise/choáng, đâm lén, đỡ khéo, phản đòn | Kẻ thù choáng đúng, đâm lén tính đúng cung sau, parry mở phản đòn |
| **Overlay** | Hệ thống vũ khí lớp phủ + `pose_anchors.json` | Đổi vũ khí không cần đổi hoạt ảnh thân |
| **C** | Ô kỹ năng, thế cầm hai tay | Gắn/tháo kỹ năng, bật hai tay đổi sát thương |
| **D** | Phụ ma, buildup, 1–2 tương tác môi trường | Đốt rơm làm cháy kẻ thù đứng trên |
| **E** | Tải Vỏ, ba bậc lăn | Mang nặng lăn chậm hơn đúng bảng |

**Vertical slice:** A, Lên cấp, B, Overlay. C, D, E làm khi cảm giác đánh đã ổn.

---

## 14. Điểm thay đổi so với GDD (file này thắng)

1. GDD mục 5 (chỉ số): thêm quy tắc **phạt khi thiếu chỉ số yêu cầu** thay cho khóa cứng.
2. GDD mục 6 (tiến hóa): giữ 5 bộ đếm; thêm cách cộng điểm ở mục 12 và **thành thạo theo loại vũ khí**; dạng nở không giới hạn loại vũ khí.
3. GDD mục 7 (chiến đấu): đòn nhẹ/nặng, poise, đâm lén, đỡ khéo, thế cầm, Tải Vỏ như mô tả ở trên.
4. Lên cấp: người chơi **tự cộng** điểm chỉ số tại Ổ Rơm; hành vi (không phải chỉ số) quyết định dạng tiến hóa.

---

## 15. Quy tắc cho AI code

- Mọi số liệu cân bằng và mọi đòn đánh nằm trong `data/*.json`, tải qua `GameData`.
- Thời gian đòn tính bằng khung logic, không dùng bộ đếm thời gian rời rạc cho hitbox; hitbox bật/tắt theo pha của máy trạng thái.
- Tách lớp: `CombatState` (máy trạng thái), `HitboxService` (tạo/hủy hitbox), `Stats` (tính chỉ số và sát thương), `WeaponDB` (đọc dữ liệu). Không để logic đòn đánh trong script giao diện.
- Mỗi giai đoạn chạy được trên `test_arena`, có commit riêng, và cập nhật `docs/PROJECT_STATUS.md`.
- Không thêm tính năng ngoài phạm vi giai đoạn đang làm.
