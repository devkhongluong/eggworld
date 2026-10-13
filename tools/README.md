# Thư mục công cụ (Tools) – Dự án "Vỡ Vỏ" (Shellbound)

Thư mục này chứa các kịch bản hỗ trợ tạo, cắt lát, xuất mẫu xem trước (preview) và kiểm định chất lượng (validation) tài nguyên sprite pixel art.

---

## Danh sách công cụ

### 1. `validate_sprites.py`
- **Công dụng:** Kiểm định toàn bộ file ảnh PNG trong thư mục `assets/sprites/` theo tiêu chuẩn kỹ thuật GDD mục 2 & 3:
  - Khung hình chuẩn: 32×32 (hoặc 64×64 với boss), chiều rộng dải PNG chia hết cho kích thước khung (32 hoặc 64).
  - Nền trong suốt (kênh Alpha).
  - Tuân thủ nghiêm ngặt 16 màu cố định trong bảng màu GDD (báo cáo pixel không thuộc bảng màu).
- **Cách chạy:**
  ```bash
  python tools/validate_sprites.py
  ```

### 2. `slice_spritesheet.py`
- **Công dụng:** Cắt dải ảnh Sprite Sheet nguồn (lưới 6×6) thành các animation strip 6 khung hình hướng `down`, `up`, `side` cho các hoạt ảnh `run` và `roll`.
- **Cách chạy:**
  ```bash
  python tools/slice_spritesheet.py
  ```

### 3. `slice_attack_sheet.py`
- **Công dụng:** Cắt bảng Sprite Sheet nguồn tấn công (5 cột × 3 hàng) thành 3 dải hoạt ảnh 5 khung hình cho `attack_down`, `attack_up`, `attack_side`. Xóa nền tối và thu nhỏ nearest về khung 32×32 px.
- **Cách chạy:**
  ```bash
  python tools/slice_attack_sheet.py
  ```

### 4. `slice_hurt_death.py`
- **Công dụng:** Cắt bảng hoạt ảnh Hurt (5 khung) và Death (7 khung) từ ảnh nguồn tham khảo, tự động căn chỉnh tọa độ và loại bỏ phần chữ chú thích.
- **Cách chạy:**
  ```bash
  python tools/slice_hurt_death.py
  ```

### 5. `make_previews.py`
- **Công dụng:** Tạo ảnh preview phóng to tỉ lệ nguyên (x5) đặt trên nền tương phản tối để người kiểm duyệt xem trước dải hoạt ảnh.
- **Cách chạy:**
  ```bash
  python tools/make_previews.py
  ```

### 6. `make_hurt_death.py`
- **Công dụng:** Kịch bản vẽ thủ công các khung hình Hurt và Death ban đầu bằng Pillow trước khi chuyển sang mẫu tham khảo.
- **Cách chạy:**
  ```bash
  python tools/make_hurt_death.py
  ```

### 7. `generate_run_roll_sprites.gd` & `generate_run_roll_v2.gd`
- **Công dụng:** Script GDScript chạy độc lập trên Godot Engine để dựng hoạt ảnh chạy/lăn dạng procedural khi chưa có sprite vẽ tay.
- **Cách chạy:**
  Chạy qua dòng lệnh Godot:
  ```bash
  godot --headless -s tools/generate_run_roll_sprites.gd
  ```

### 8. `test_combat_stage_a.gd`
- **Công dụng:** Kịch bản kiểm thử tự động hệ thống chiến đấu Giai đoạn A:
  - Nạp dữ liệu `data/weapons.json` (Gậy Gỗ, Dao Găm, Ná, Tay Không).
  - Tính toán sát thương theo scaling thuộc tính (STR, DEX, INT).
  - Kiểm tra hệ số phạt khi người chơi không đạt chỉ số yêu cầu (`requirements`).
  - Kiểm tra tính toán tiêu hao thể lực Stamina.
- **Cách chạy:**
  ```bash
  godot --headless -s tools/test_combat_stage_a.gd
  ```

