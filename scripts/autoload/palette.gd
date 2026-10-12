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
