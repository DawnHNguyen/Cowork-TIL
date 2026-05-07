---
title: "TIL #009 — xlsx skill: spreadsheet, formula, chart — agent lo hết"
date: 2026-05-07
tags: ["cowork", "skills", "xlsx", "excel", "spreadsheet", "openpyxl"]
summary: "Agent không chỉ điền số vào ô — nó viết formula thật, tạo chart thật, và thậm chí tự verify lỗi trước khi giao file cho bạn."
---

## Bài học hôm nay

Hôm qua tôi viết về pptx skill — tạo slide deck chỉ bằng 1 câu prompt. Hôm nay đến lượt xlsx, và phải nói thật: đây là skill khiến tôi bất ngờ nhất. Không phải vì nó "tạo được file Excel" — điều đó obvious. Mà vì cách nó tạo: **agent viết Excel formula thật**, không phải tính sẵn bằng Python rồi paste kết quả vào ô.

Nghe có vẻ nhỏ, nhưng khác biệt là rất lớn. Một file Excel có formula thì sống — bạn thay đổi input, output tự cập nhật. Một file chỉ có hardcoded values thì chết — bạn đổi 1 con số, cả sheet vỡ logic.

## Cách xlsx skill hoạt động bên trong

Khi bạn yêu cầu Cowork tạo spreadsheet, nó sẽ chạy qua workflow sau:

**1. Chọn công cụ phù hợp:**
- **openpyxl** — khi cần formula, formatting, chart (phần lớn trường hợp)
- **pandas** — khi cần phân tích data, pivot, aggregate trước khi xuất file

**2. Tạo workbook với formula thật:**
```python
# Agent viết thế này (đúng)
sheet['B10'] = '=SUM(B2:B9)'
sheet['C5'] = '=(C4-C2)/C2'

# Không phải thế này (sai)
sheet['B10'] = 5000  # hardcoded, file "chết"
```

**3. Recalculate bằng LibreOffice:**
Sau khi tạo file, agent chạy script `recalc.py` để LibreOffice tính lại toàn bộ formula — đảm bảo mọi ô đều có giá trị đúng.

**4. Verify lỗi:**
Script trả về JSON báo lỗi cụ thể: `#REF!`, `#DIV/0!`, `#NAME?`... Agent tự fix rồi recalc lại cho đến khi zero errors.

## Những thứ agent làm được (mà tôi không ngờ)

| Tính năng | Ví dụ prompt |
|-----------|-------------|
| Multi-sheet workbook | "Tạo budget với 3 tab: Revenue, Expenses, Summary" |
| Cross-sheet references | "Sheet Summary lấy tổng từ 2 sheet kia" |
| Conditional formatting | "Highlight đỏ những cell âm" |
| Chart (bar, line, pie) | "Thêm bar chart so sánh revenue theo quý" |
| Financial model chuẩn | "Tạo DCF model 5 năm" — agent biết color-code inputs vs formulas |
| Data cleanup | "File CSV này lộn xộn, clean rồi xuất xlsx" |

Một chi tiết thú vị: với financial models, agent có hẳn bộ color-coding standards — text xanh dương cho inputs, đen cho formulas, xanh lá cho cross-sheet links. Đây là convention chuẩn investment banking mà nhiều người không biết.

## Điều tôi hiểu nhầm

**Nhầm lần 1: "Agent chắc chỉ tạo được CSV fancy"**

Sai. Output là `.xlsx` thật, với formula sống, formatting, chart embedded. Mở bằng Excel hay Google Sheets đều render đúng.

**Nhầm lần 2: "Chắc phải prompt siêu chi tiết"**

Cũng sai. Tôi thử: "Tạo spreadsheet theo dõi chi tiêu tháng 5, có cột ngày/mục/số tiền/category, tổng ở cuối." Agent tự quyết layout, thêm header formatting, bold tổng, set number format cho cột tiền. Không cần micromanage.

**Nhầm lần 3: "Chart chắc xấu lắm"**

Thì... chart openpyxl không đẹp bằng chart bạn tự style trong Excel. Nhưng nó functional — có title, axis labels, legend đầy đủ. Đủ để report nội bộ hoặc prototype nhanh.

**Fail thật:** Lần đầu tôi thử yêu cầu "pivot table" — agent tạo được structure nhưng pivot table trong openpyxl khá limited. Workaround: để agent dùng pandas pivot rồi xuất kết quả thành static table. Không dynamic bằng native Excel pivot, nhưng data đúng.

## So sánh nhanh: xlsx skill vs Claude in Excel

| | xlsx skill (Cowork) | Claude in Excel (Add-in) |
|--|---------------------|-------------------------|
| Cần mở Excel? | Không — tạo file từ không khí | Có — chạy trong Excel |
| Formula | Viết formula vào file | Gợi ý formula cho bạn copy |
| Bulk operations | Tạo cả workbook 10 sheet 1 lần | Thao tác từng cell/range |
| Phù hợp khi | Cần file mới từ đầu, batch job | Đang làm việc trong Excel, cần trợ lý |

Hai thứ này bổ sung nhau, không thay thế nhau.

## Takeaway

xlsx skill biến Cowork thành "Excel intern" — bạn mô tả cái bạn cần, agent xây cả workbook với formula sống, chart, formatting chuẩn. Trick quan trọng nhất: **luôn yêu cầu formula thay vì số cứng** — vì file có formula mới thật sự useful khi data thay đổi.

Bài tiếp theo: **pdf skill** — tạo, đọc, merge PDF, và khi nào nên chọn PDF thay vì docx hay xlsx.
