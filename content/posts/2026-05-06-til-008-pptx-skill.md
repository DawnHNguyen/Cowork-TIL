---
title: "TIL #008 — pptx skill: từ bullet points đến slide deck trong 2 phút"
date: 2026-05-06
tags: ["cowork", "skills", "pptx", "powerpoint", "presentation", "automation"]
summary: "Agent đọc SKILL.md dài hàng trăm dòng, viết Python dùng python-pptx, rồi xuất file .pptx — nhưng đừng mong nó đẹp như template Canva."
---

## Bài học hôm nay

Hôm qua tôi kể chuyện docx skill — tạo Word document bằng một câu lệnh. Hôm nay đến lượt người anh em của nó: `pptx` skill — built-in skill chuyên tạo slide deck. Tôi thử với mindset: "Liệu nó có thay thế được PowerPoint cho mấy buổi demo nội bộ không?"

Câu trả lời ngắn: **có, nhưng có điều kiện**. Nếu bạn cần deck nội bộ kiểu standup update, project overview, hay training material — pptx skill làm rất nhanh, đủ xài. Nếu bạn cần pitch deck cho investor hay presentation cho hội nghị — bạn vẫn cần mở PowerPoint ra chỉnh tay, hoặc dùng template chuyên nghiệp.

---

## pptx skill hoạt động thế nào

Flow bên trong tương tự docx skill nhưng dùng stack khác:

1. **Nhận diện task** — bạn nói "presentation", "slides", "deck", "pptx" → agent biết cần skill `pptx`
2. **Đọc SKILL.md** — file instruction chứa toàn bộ best practices cho việc tạo slide: layout, font size, spacing, image handling
3. **Generate Python** — khác với docx skill dùng JavaScript, pptx skill dùng **Python** với thư viện `python-pptx`
4. **Chạy code trong sandbox** — sandbox Linux có sẵn Python, agent `pip install python-pptx` rồi chạy script
5. **Xuất file .pptx** — file được lưu vào workspace folder, bạn nhận link mở trực tiếp

Điểm khác biệt lớn nhất so với docx: slide deck là **visual-heavy**. Mỗi slide không chỉ là text — nó có layout, positioning, font size hierarchy, color scheme. Và đây chính là chỗ skill phải làm việc nhiều nhất.

### Skill biết gì mà bạn không cần dạy?

| Vấn đề thường gặp | Cách skill xử lý |
|-------------------|------------------|
| Text tràn ra ngoài slide | Skill giới hạn số bullet points và ký tự mỗi dòng |
| Font size không nhất quán | Skill có sẵn hierarchy: title 28pt, subtitle 20pt, body 16pt |
| Slide trống vì quên content | Skill bắt agent validate mỗi slide phải có nội dung |
| Image bị stretch méo | Skill hướng dẫn giữ aspect ratio khi insert ảnh |
| Color scheme loạn xạ | Skill đặt palette mặc định thống nhất cho toàn deck |

---

## Thử nghiệm thực tế: từ 5 bullet points đến 10 slides

Tôi thử prompt đơn giản: *"Tạo một slide deck về quy trình onboarding nhân viên mới, khoảng 8-10 slides, có slide mục tiêu, timeline, checklist, và Q&A."*

Kết quả: agent tạo ra file `.pptx` với 10 slides trong khoảng 90 giây. Cấu trúc khá hợp lý — title slide, agenda, 6 slides nội dung, summary, Q&A. Mỗi slide có heading rõ ràng, bullet points gọn gàng, color scheme thống nhất.

Nhưng "đẹp" thì... phải nói thật. Output trông giống **slide mặc định của PowerPoint khi bạn chọn blank template rồi gõ text vào**. Không có gradient fancy, không có icon minh họa, không có animation. Nó functional — đúng nội dung, đúng structure — nhưng không wow.

Và đó là design trade-off có chủ đích. Skill ưu tiên **nội dung đúng + structure rõ** hơn là đẹp. Vì đẹp thì subjective, còn content sai thì ai cũng biết.

---

## So sánh: khi nào dùng pptx skill, khi nào mở PowerPoint

| Tình huống | pptx skill | PowerPoint/Canva |
|-----------|-----------|-----------------|
| Demo nội bộ team meeting | Dùng luôn — nhanh, đủ xài | Overkill |
| Training material cho team | Rất phù hợp — content-heavy | Tùy yêu cầu |
| Pitch deck cho investor | Tạo draft → chỉnh tay trong PPT | Nên dùng từ đầu |
| Conference talk | Tạo outline → design lại | Cần đầu tư visual |
| Weekly standup slides | Perfect use case | Mất thời gian vô ích |

Quy tắc ngón tay cái của tôi: **nếu người xem quan tâm nội dung hơn hình thức → pptx skill. Nếu first impression quan trọng → cần design tool.**

---

## Fail Wall

**Fail #1: Prompt tiếng Việt, nhưng slide ra tiếng Anh.** Ngược lại với docx skill (fail vì ra tiếng Việt khi cần tiếng Anh), lần này agent tự động dùng tiếng Anh cho slide content vì "presentation thường bằng tiếng Anh". Bài học giống hôm qua: **luôn nói rõ ngôn ngữ output**.

**Fail #2: Yêu cầu 8 slides, nhận được 12.** Agent nhiệt tình quá, tự thêm slide "Appendix", "References", "Thank You" mà tôi không yêu cầu. Không phải lỗi nghiêm trọng, nhưng nó cho thấy agent có xu hướng "thêm cho đủ" khi làm presentation. Muốn kiểm soát chặt thì phải nói: "Chính xác 8 slides, không thêm."

**Fail #3: Tưởng có thể dùng template riêng.** Tôi thử upload file `.pptx` template của công ty rồi nói "dùng template này để tạo deck mới". Kết quả: agent tạo deck mới hoàn toàn, bỏ qua template. Skill `pptx` hiện tại chủ yếu tạo từ scratch — nếu bạn muốn dùng template có sẵn, phải dùng cách khác hoặc chỉnh tay sau. Đây là limitation thật sự mà tôi nghĩ nhiều người sẽ va phải.

---

## Takeaway

pptx skill giống như có một người junior tạo draft slide cho bạn trong 2 phút: nội dung đúng, structure hợp lý, nhưng design thì basic. Với 80% use case nội bộ — standup, demo, training — nó đủ tốt để dùng luôn. Với 20% use case cần đẹp — pitch deck, conference — hãy coi nó là bước draft đầu tiên, rồi mở PowerPoint/Canva ra polish. Và nhớ: nói rõ ngôn ngữ, nói rõ số slides, đừng kỳ vọng template magic.

Ngày mai: xlsx skill — spreadsheet, formula, chart — agent lo hết. Bài #009 sẽ xem agent xử lý Excel có ngon như Word và PowerPoint không.
