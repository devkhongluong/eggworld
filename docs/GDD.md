# GDD – Vỡ Vỏ (Shellbound)

Tài liệu thiết kế gốc dùng làm đầu vào cho công cụ code/vẽ. Mọi quyết định về kích thước, màu sắc, chỉ số và luật tiến hóa dưới đây là **cố định**; nếu cần đổi, sửa tài liệu này trước rồi mới sửa asset/code.

## 1. Tổng quan nhanh

- **Thể loại:** Action RPG 2D pixel art, đánh boss, hầm ngục, farm EXP/đồ.
- **Nhân vật chính:** Trứng – quả trứng có tay chân, tiến hóa thành lớp nhân vật theo phong cách chơi.
- **Tông thị giác:** trung cổ phương Tây, u buồn, cũ kỹ, hơi bẩn; nhân vật chính ngây ngô dễ thương tạo tương phản.
- **Cảm hứng:** Elden Ring (thế giới vỡ, Á Thần, lore qua vật phẩm), nhịp chơi kiểu Souls (né, stamina, mất EXP khi chết).
- **Phạm vi hiện tại:** vertical slice = Chương 0 + Chương 1 (xem mục 11).

## 2. Thông số kỹ thuật pixel art

| Hạng mục | Giá trị |
| --- | --- |
| Độ phân giải nội bộ | 320 × 180 px, phóng to theo số nguyên (×4 = 1280×720, ×6 = 1920×1080) |
| Tile nền | 16 × 16 px |
| Trứng và quái thường | 32 × 32 px (khung vẽ), thân chiếm khoảng 20–24 px |
| NPC | 32 × 32 px |
| Boss nhỏ / tinh anh | 64 × 64 px |
| Boss lớn | 96 × 96 px hoặc 128 × 128 px (ghi rõ trong từng boss) |
| Icon vật phẩm / kỹ năng | 16 × 16 px |
| Khung hình | 12 fps cho hoạt ảnh nhân vật, 8 fps cho nền/hiệu ứng |
| Lọc hình | Nearest-neighbor, tuyệt đối không làm mờ hay làm mịn khi phóng to |
| Nền sprite | Trong suốt (PNG, không viền trắng) |

**Quy tắc vẽ bắt buộc**

1. Mọi pixel nằm trên lưới nguyên; không xoay sprite ở góc lẻ, không nửa pixel.
2. Chỉ dùng đúng 16 màu trong bảng màu mục 3. Không thêm màu, không dùng gradient, không anti-aliasing.
3. Viền ngoài (outline) dày 1 px, dùng màu **Nâu Hầm #2B1F1A**, không dùng đen thuần.
4. Nguồn sáng cố định ở **góc trên-trái**; bóng đổ nằm dưới-phải. Mỗi vật thể có tối đa 3 mức sáng: sáng – trung – tối.
5. Mọi dạng tiến hóa của Trứng giữ **cùng chiều cao thân (±2 px)** và cùng điểm chân chạm đất để hoạt ảnh không bị nhảy.
6. Các khung hình trong một hoạt ảnh phải giữ cùng khung vẽ, cùng điểm neo (anchor) ở giữa-đáy.

## 3. Bảng màu trung cổ (16 màu, cố định)

| # | Tên | Mã HEX | Dùng cho |
| --- | --- | --- | --- |
| 1 | Đen Than | #14110F | Bóng sâu nhất, nền hầm ngục tối, hố đen |
| 2 | Nâu Hầm | #2B1F1A | Viền ngoài mọi sprite, tường hầm |
| 3 | Xám Sắt | #4A4A52 | Giáp, kim loại, đá tối |
| 4 | Xám Đá | #7C7C80 | Đá sáng, vũ khí, lưỡi kiếm |
| 5 | Nâu Gỗ | #6B4423 | Gỗ, cửa, cán vũ khí, đất tối |
| 6 | Nâu Da | #A0693B | Da thuộc, đất, rơm đậm |
| 7 | Cát | #D4A86A | Rơm, cát, bóng đổ trên vỏ trứng |
| 8 | Giấy Da | #E8D9B0 | Vỏ trứng (màu chính), giấy, xương |
| 9 | Kem | #F4EBD0 | Điểm sáng nhất, vùng ánh sáng trên vỏ trứng |
| 10 | Đỏ Rượu | #6E1423 | Vải quý tộc, máu khô, boss tối |
| 11 | Đỏ Gạch | #A8342B | Lửa nhẹ, cờ hiệu, cảnh báo sát thương |
| 12 | Xanh Rêu | #3B4A2A | Cỏ, lá, đầm lầy, rừng |
| 13 | Xanh Lá Úa | #6B7F3A | Cỏ sáng, độc nhẹ, đồ vật tự nhiên |
| 14 | Vàng Cổ | #C79A2E | Vàng đồng, chữ khắc, vật phẩm hiếm, Mảnh Vỏ |
| 15 | Xanh Thép | #2F4A63 | Nước, sương, đêm, phép băng/lòng trắng |
| 16 | Tím Mục | #5A3A5E | Mục Rữa (Scarlet Rot của thế giới này), phép hắc ám |

**Quy ước dùng màu theo vai trò**

- **Trứng:** vỏ chính Giấy Da, vùng sáng Kem, vùng tối Cát, viền Nâu Hầm. Tay chân dùng cùng tông vỏ, mảnh khảnh 2 px.
- **Mục Rữa / kẻ thù bị ăn mòn:** luôn có mảng Tím Mục + Xanh Lá Úa.
- **Vật phẩm hiếm và Mảnh Vỏ:** có điểm Vàng Cổ để người chơi nhận ra từ xa.
- **Cảnh báo đòn đánh của boss:** nhấp nháy Đỏ Gạch ≥ 0,3 giây trước khi gây sát thương.
- **Giao diện (UI):** nền Nâu Hầm, khung Vàng Cổ, chữ Kem; thanh HP Đỏ Gạch, thanh Stamina Xanh Lá Úa, thanh EXP/Mảnh Vỏ Vụn Vàng Cổ.

## 4. Nhân vật chính: Trứng và các dạng tiến hóa

### 4.1 Trứng khởi đầu

- Quả trứng hình bầu dục, thân cao khoảng 20 px, rộng khoảng 16 px, hai tay hai chân mảnh, mắt là hai chấm Nâu Hầm 1–2 px.
- Mặt biểu cảm bằng vị trí hai chấm mắt và 1 nét miệng; không dùng nhiều chi tiết.
- Hoạt ảnh tối thiểu: đứng yên (4 khung), chạy (6 khung), lăn né (6 khung), đánh cơ bản (5 khung), bị đánh (2 khung), chết (6 khung, vỏ vỡ).

### 4.2 Các dạng tiến hóa

Mọi dạng giữ lại **hình dáng trứng làm lõi** (nét nhận diện), chỉ thêm vết nứt, vỏ phụ, trang bị.

| Dạng | Tông màu nhấn | Đặc điểm hình ảnh | Vũ khí gốc |
| --- | --- | --- | --- |
| Dạng Nứt (cấp 1, chung) | Cát, Giấy Da | Vết nứt chạy từ đỉnh xuống, một mảnh vỏ hở lộ màu bên trong | Gậy gỗ |
| Hiệp Sĩ Vỏ Cứng | Xám Sắt, Xám Đá | Vỏ phủ giáp sắt, mũ trụ dạng nửa vỏ trứng, khiên tròn | Kiếm ngắn + khiên |
| Sát Thủ Nứt Bóng | Đen Than, Đỏ Rượu | Vỏ nứt nhiều, khăn trùm đỏ rượu, thân gầy hơn | Dao găm đôi |
| Pháp Sư Lòng Trắng | Xanh Thép, Kem | Vỏ nửa trong suốt (dùng viền sáng, không dùng độ trong), mũ chóp | Trượng phép |
| Lữ Khách Tổ Rơm | Nâu Da, Cát, Xanh Rêu | Áo choàng rơm, túi đeo, mũ rộng vành | Cung ngắn / rìu nhỏ |
| Tu Sĩ Ấp | Vàng Cổ, Kem | Áo tu sĩ, vầng sáng nhỏ trên đỉnh, đi chân đất | Chuông + gậy |
| Dạng Hỗn Mang (ẩn) | Tím Mục, Vàng Cổ | Vỏ lốm đốm nhiều màu, không đối xứng | Thay đổi theo vũ khí đang cầm |

## 5. Hệ chỉ số

| Chỉ số | Viết tắt | Tác dụng |
| --- | --- | --- |
| Sinh lực | VIT | +HP tối đa, +chống Mục Rữa |
| Sức mạnh | STR | +sát thương vũ khí nặng, +khả năng đỡ đòn |
| Nhanh nhẹn | DEX | +sát thương vũ khí nhẹ, +tốc độ đánh, +thời gian bất tử khi lăn |
| Trí tuệ | INT | +sát thương phép, +MP tối đa |
| Tín ngưỡng | FAI | +hiệu quả hồi máu/hỗ trợ, +phép thánh |
| May mắn | LUK | +tỉ lệ rơi đồ hiếm, +tỉ lệ chí mạng nhỏ |

Chỉ số phụ: HP, Stamina, MP (chỉ lớp dùng phép). Mỗi lần lên cấp +1 điểm vào một chỉ số tự chọn. Công thức cụ thể để Antigravity cấu hình dạng bảng dữ liệu (JSON/CSV) và dễ chỉnh cân bằng, không hard-code vào logic.

## 6. Luật tiến hóa theo phong cách chơi

### 6.1 Năm bộ đếm hành vi

Game ghi 5 bộ đếm **ẩn** (người chơi không thấy số), tăng khi hành động tương ứng xảy ra:

| Bộ đếm | Tăng khi | Điểm |
| --- | --- | --- |
| GUARD | Đỡ thành công một đòn bằng khiên/vỏ | +2 mỗi lần; +1 mỗi 10 sát thương cận chiến gây ra |
| DODGE | Lăn/né thành công (qua đòn trong thời gian bất tử) | +2 mỗi lần; +1 mỗi đòn đánh lén/đánh từ phía sau |
| MAGIC | Dùng phép hoặc đánh từ xa trúng mục tiêu | +2 mỗi lần trúng |
| EXPLORE | Mở rương, tìm lối tắt, hoàn thành phòng ẩn, dò hết bản đồ khu vực | +5 mỗi sự kiện |
| SUPPORT | Hồi máu, dùng vật phẩm hỗ trợ, cứu/trợ NPC | +3 mỗi lần |

### 6.2 Tính điểm tại mốc tiến hóa

1. Tại mốc, tính **tỉ lệ** mỗi bộ đếm = bộ đếm ÷ tổng 5 bộ đếm.
2. Nếu bộ đếm cao nhất có tỉ lệ **≥ 40%** và hơn bộ đếm thứ hai **≥ 10 điểm phần trăm** → nở thành lớp tương ứng:
   - GUARD → Hiệp Sĩ Vỏ Cứng
   - DODGE → Sát Thủ Nứt Bóng
   - MAGIC → Pháp Sư Lòng Trắng
   - EXPLORE → Lữ Khách Tổ Rơm
   - SUPPORT → Tu Sĩ Ấp
3. Nếu **không** thỏa điều kiện trên (chơi dàn trải) → **Dạng Hỗn Mang**.
4. Trước mỗi mốc, người chơi được **xem trước** dạng sắp nở (gợi ý bằng hình bóng) và có **một lần** chọn "giữ nguyên dạng hiện tại" để tiếp tục tích lũy thêm.

### 6.3 Ba mốc tiến hóa

| Mốc | Thời điểm | Kết quả |
| --- | --- | --- |
| Nứt | Sau boss Chương 1 | Đổi sang Dạng Nứt (chung cho mọi người chơi), mở cây kỹ năng, bộ đếm bắt đầu tính trọng số |
| Nở | Sau boss Chương 3 | Nở thành lớp rõ ràng theo luật 6.2 |
| Hóa | Sau boss Chương 5 | Dạng cuối, có thể rẽ nhánh sang lớp phụ nếu bộ đếm hai lớp gần nhau |

*Trong vertical slice chỉ làm mốc **Nứt**; các mốc sau để dạng khung (placeholder).*

## 7. Chiến đấu

- **Stamina:** mọi hành động (đánh, lăn, đỡ) tốn stamina; hồi dần khi đứng yên.
- **Lăn né:** có khung bất tử ngắn (i-frame) khoảng 0,25 giây; có thời gian hồi nhẹ để chống lạm dụng.
- **Đánh cơ bản:** chuỗi 3 đòn, đòn thứ 3 có thời gian hồi chiêu dài hơn.
- **Chết:** mất toàn bộ **Mảnh Vỏ Vụn** (đơn vị EXP) tại chỗ chết; quay lại nhặt. Chết lần nữa trước khi nhặt thì mất hẳn.
- **Điểm lưu – Ổ Rơm:** nghỉ để hồi đầy HP/hồi vật phẩm, đồng thời làm quái thường hồi sinh.
- **Boss:** 2–3 phase, có báo hiệu đòn rõ ràng (nhấp nháy Đỏ Gạch), pattern học được; không có đòn không thể né.

## 8. Vòng lặp game

1. Khám phá khu vực → tìm Ổ Rơm
2. Vào hầm ngục → nhặt đồ, mở lối tắt
3. Đánh boss → nhận Mảnh Vỏ
4. Farm ở Bãi Mục/Hầm Thử Thách → lấy nguyên liệu, EXP
5. Đạt mốc tiến hóa → đổi dạng, mở nhánh kỹ năng

## 9. Boss mẫu cho vertical slice

### 9.1 Quạ Gác Tổ (boss Chương 0)

- **Kích thước:** 64 × 64 px. **Màu:** Đen Than, Xám Sắt, mắt Đỏ Gạch.
- **HP:** thấp; mục tiêu: người chơi chết 0–2 lần.
- **Chiêu:** (1) Mổ thẳng – báo hiệu 0,5 giây; (2) Vỗ cánh quét ngang – báo hiệu 0,6 giây; (3) Bay lên rồi lao xuống – có bóng đổ báo vị trí.
- **Phase:** 1 phase duy nhất, mục đích dạy né và đọc báo hiệu.

### 9.2 Ngài Bọ Kén (boss Chương 1)

- **Kích thước:** 96 × 96 px. **Màu:** Nâu Da, Cát, mảng Tím Mục.
- **Phase 1:** nằm trong kén, bắn tơ quét vùng và thả ấu trùng nhỏ.
- **Phase 2 (dưới 50% HP):** phá kén, lao tấn công, tạo vùng Mục Rữa dưới sàn gây sát thương theo thời gian.
- **Phần thưởng:** Mảnh Vỏ I, mở mốc tiến hóa **Nứt**.

## 10. Cấu trúc dữ liệu và quy ước đặt tên (cho code)

- Dữ liệu cân bằng (chỉ số, sát thương, HP boss, bảng rơi đồ) để trong file dữ liệu riêng (JSON/CSV), không viết cứng trong code.
- Quy ước tên asset: `loai_ten_hanhdong_khung.png`, ví dụ `player_egg_run_01.png`, `boss_quagac_attack1_03.png`, `tile_dongco_01.png`.
- Sprite sheet: mỗi hoạt ảnh một hàng, khung đều nhau, kèm file mô tả số khung và fps.
- Mọi màu trong code/UI tham chiếu **bảng màu mục 3** qua hằng số, không gõ mã HEX rải rác.
- Bộ đếm hành vi lưu trong dữ liệu người chơi và được lưu cùng file save.

## 11. Phạm vi vertical slice (làm trước)

**Bao gồm**

- Nhân vật Trứng + Dạng Nứt (2 dạng), đầy đủ hoạt ảnh ở mục 4.1
- Chương 0 (Tổ Hoang) + boss Quạ Gác Tổ
- Chương 1 (Đồng Cỏ Mục): 1 khu vực mở, 1 hầm ngục nhỏ, 3–4 loại quái thường, 1 Ổ Rơm
- Boss Ngài Bọ Kén
- Hệ thống 5 bộ đếm + mốc tiến hóa Nứt
- UI cơ bản: HP, Stamina, Mảnh Vỏ Vụn, menu tạm dừng, màn lưu/tải

**Chưa làm (để sau)**

- Chương 2–5, 4 boss còn lại, các lớp tiến hóa hoàn chỉnh
- Bãi farm nâng cao (Hầm Thử Thách vô tận)
- Hệ thống kết thúc nhiều nhánh, NPC phụ

## 12. Tiêu chí hoàn thành vertical slice

- Người chơi đi từ Tổ Hoang đến hết Ngài Bọ Kén mà không gặp lỗi chặn.
- Né, đánh, đỡ, chết và nhặt lại EXP hoạt động đúng luật.
- Tất cả sprite dùng đúng 16 màu và đúng kích thước đã nêu.
- Mốc tiến hóa Nứt kích hoạt đúng sau boss Chương 1 và ghi nhận bộ đếm đúng.
