---
title: "TIL #025 — Agent Prompt Engineering: viết SKILL.md tốt hơn để agent làm đúng việc"
date: 2026-05-28
tags: ["prompt-engineering", "skill", "SKILL.md", "automation", "cowork"]
summary: "Prompt cho agent không giống prompt chat thường — nó cần cấu trúc rõ, context đủ, và biết khi nào nên dừng. Hôm nay tôi học cách viết SKILL.md để agent chạy autonomous mà không cần hỏi lại."
---

## Bài học hôm nay

Hôm qua tôi viết về workflow thực tế cho Android/KMP dev. Hôm nay quay lại một chủ đề nền tảng hơn: **viết prompt cho agent**.

Nếu bạn đã dùng Cowork được vài tuần, chắc bạn nhận ra một điều: prompt kiểu chat ("hey giúp tôi cái này") khác hoàn toàn với prompt cho agent chạy tự động. Chat prompt có bạn ngồi đó sửa sai real-time. Agent prompt thì agent chạy một mình — không ai hỏi, không ai confirm — nên nếu prompt mơ hồ, kết quả cũng mơ hồ theo.

Cowork gọi file chứa prompt này là **SKILL.md**. Đây là file Markdown nằm trong mỗi skill folder, gồm hai phần: YAML frontmatter (metadata) và phần thân chứa instructions thật sự. Agent đọc file này mỗi khi skill được trigger, và toàn bộ hành vi của agent phụ thuộc vào những gì bạn viết ở đây.

## Cấu trúc một SKILL.md tốt

Qua thử nghiệm (và đọc docs), tôi rút ra cấu trúc hoạt động ổn nhất:

### 1. Frontmatter — Nói cho agent biết "khi nào dùng skill này"

```yaml
---
name: daily-report
description: >
  Tạo báo cáo tổng hợp từ Notion tasks mỗi sáng.
  Trigger khi user hỏi "báo cáo hôm nay", "daily report",
  hoặc khi scheduled task chạy lúc 8:00 AM.
---
```

Phần `description` cực kỳ quan trọng. Claude đọc description để quyết định có nên tự trigger skill hay không. Nếu bạn viết mơ hồ kiểu "helps with reports" thì skill sẽ gần như không bao giờ được gọi tự động. Ngược lại, viết cụ thể trigger words thì hit rate cao hơn hẳn.

### 2. Thân file — Instructions theo thứ tự

Tôi dùng pattern này:

```markdown
## Step 1 — Gather data
Đọc Notion database "Sprint Board", lọc tasks có status "Done"
trong 24h qua.

## Step 2 — Format output
Viết báo cáo dạng Markdown với các section:
- **Completed**: danh sách tasks đã xong
- **In Progress**: tasks đang làm
- **Blocked**: tasks bị chặn, kèm lý do

## Step 3 — Save file
Lưu vào `/reports/YYYY-MM-DD-daily.md`

## Constraints
- KHÔNG gửi email hay post Slack — chỉ tạo file
- Nếu Notion không response, ghi log lỗi và dừng
```

Mỗi step là một hành động rõ ràng. Agent đọc từ trên xuống và thực hiện tuần tự. Không có chỗ nào nó cần "đoán" bạn muốn gì.

### 3. Constraints — Ranh giới agent không được vượt

Đây là phần tôi hay quên, và cũng là phần gây fail nhiều nhất. Agent rất "nhiệt tình" — nếu bạn không nói rõ giới hạn, nó sẽ tự sáng tạo. Ví dụ: bạn bảo "gửi báo cáo" mà không nói gửi cho ai, nó có thể tự tìm email trong context và gửi luôn. Viết constraints rõ ràng giúp tránh những tình huống như vậy.

## Nguyên tắc vàng: Context Engineering > Prompt Engineering

Một insight lớn mà tôi học được: năm 2026, người ta nói nhiều về **context engineering** hơn là prompt engineering. Ý tưởng là thế này — model đã đủ thông minh để hiểu instruction. Vấn đề không phải *bạn nói gì*, mà là *bạn load gì vào context*.

Trong thực tế với Cowork, điều này có nghĩa:

**Tách process khỏi knowledge.** SKILL.md chứa quy trình (làm gì, theo thứ tự nào). Dữ liệu tham khảo (template, ví dụ, glossary) nên để trong file riêng — ví dụ REFERENCE.md — và chỉ bảo agent đọc khi cần. Nhồi hết vào SKILL.md sẽ làm phình context window và giảm chất lượng output.

**Giữ instruction count thấp.** Có người ước tính Claude follow được khoảng 150–200 instructions với độ chính xác hợp lý. System prompt của Cowork đã chiếm ~50 instructions rồi. SKILL.md của bạn nên gọn nhất có thể — chỉ giữ những gì thật sự cần cho mọi lần chạy.

**Progressive disclosure.** Đừng dump hết thông tin vào prompt. Thay vào đó, nói cho agent biết *cách tìm* thông tin khi cần. Ví dụ: "Nếu cần template, đọc file `/templates/report-template.md`" thay vì paste nguyên cái template vào SKILL.md.

## Điều tôi hiểu nhầm

**"Viết prompt dài và chi tiết = kết quả tốt hơn."**

Sai. Prompt dài nhưng lộn xộn thì agent bị overwhelm. Tôi từng viết một SKILL.md dài 3 trang, liệt kê mọi edge case có thể xảy ra. Kết quả? Agent thực hiện 80% instruction đúng nhưng miss mất 2 steps quan trọng ở giữa — vì context window đầy và nó bắt đầu "quên" instruction sớm.

Bài học: **ngắn + cấu trúc rõ > dài + đầy đủ**.

**"Agent sẽ tự biết output format."**

Cũng sai. Nếu bạn không specify format, mỗi lần chạy agent sẽ cho output khác nhau. Lần thì Markdown, lần thì plain text, lần thì nó tự thêm emoji. Luôn viết rõ output format trong SKILL.md.

**"Không cần test skill."**

Skill Creator trong Cowork có tính năng generate test prompts và chạy eval. Tôi bỏ qua bước này ở 3 skill đầu và phải sửa đi sửa lại. Từ skill thứ 4, tôi dùng eval trước khi deploy — tiết kiệm thời gian hơn nhiều.

## Checklist nhanh khi viết SKILL.md

Trước khi save một SKILL.md, tôi tự hỏi:

1. Description có đủ cụ thể để auto-trigger đúng không?
2. Mỗi step có rõ ràng "làm gì" và "dùng tool gì" không?
3. Output format đã specify chưa?
4. Constraints đã cover các hành động agent KHÔNG được làm chưa?
5. Có step nào cần data mà agent chưa chắc có access không?
6. File có dưới 1 trang không? Nếu dài hơn, tách knowledge ra REFERENCE.md.

## Takeaway

Viết SKILL.md giống viết spec cho một junior dev cực kỳ chăm chỉ nhưng không biết đọc ý bạn: rõ ràng, có thứ tự, có giới hạn, và đừng nhồi quá nhiều thông tin cùng lúc. Tập trung vào context engineering — load đúng thông tin vào đúng lúc — thay vì cố viết prompt "hoàn hảo".

Bài tiếp theo: **TIL #026 — Debugging agent: khi agent làm sai thì debug như thế nào**. Spoiler: console.log không giúp được gì ở đây.
