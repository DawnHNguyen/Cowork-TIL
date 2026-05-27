---
title: "TIL #024 — Cowork cho Android/KMP dev: 5 workflow thực tế có thể áp dụng ngay"
date: 2026-05-27
tags: ["cowork", "android", "kotlin-multiplatform", "workflow", "developer"]
summary: "Cowork không phải chỉ dành cho PM hay BA — nếu bạn là Android/KMP dev, có ít nhất 5 workflow giúp tiết kiệm thời gian mỗi ngày mà không cần mở terminal."
---

## Bài học hôm nay

Hôm qua tôi vừa viết bài so sánh Cowork và Claude Code, kết luận rằng "Cowork cho knowledge work, Claude Code cho code work." Nhưng rồi tôi tự hỏi: nếu mình là Android/KMP dev — người vừa viết code vừa phải làm đủ thứ xung quanh code — thì Cowork có chỗ đứng ở đâu trong ngày làm việc?

Câu trả lời: nhiều hơn tôi tưởng. Không phải thay thế IDE hay Claude Code, mà là xử lý hết mấy việc "ngoài code" mà dev nào cũng phải làm nhưng chẳng ai thích.

## 5 workflow thực tế

### 1. Nghiên cứu library/API trước khi dùng

Trước khi thêm một dependency mới vào project KMP — ví dụ chọn giữa Ktor và Retrofit, hay giữa SQLDelight và Room — tôi hay mất cả tiếng đọc docs, so sánh GitHub stars, tìm blog reviews.

Với Cowork: mở session, bảo "so sánh SQLDelight và Room cho KMP project, focus vào multiplatform support, migration path, và community activity." Cowork sẽ web search, đọc nhiều nguồn, và tổng hợp thành bảng so sánh rõ ràng. Muốn lưu kết quả thì bảo nó xuất ra `.md` hoặc `.docx` luôn.

Điểm hay: Cowork trả lời dựa trên thông tin mới nhất (web search), không phải knowledge cũ. Điều này quan trọng vì ecosystem Android/KMP thay đổi cực nhanh.

### 2. Generate boilerplate documentation

Mỗi PR cần mô tả rõ ràng. Mỗi module cần README. Mỗi API endpoint cần doc. Nhưng thực tế thì dev hay viết PR description kiểu "fix bug" rồi thôi.

Workflow: mount thư mục project vào Cowork, bảo nó "đọc file `UserRepository.kt` và `UserViewModel.kt`, viết technical documentation giải thích architecture, data flow, và public API." Cowork đọc code trực tiếp trong folder đã mount, hiểu structure, rồi sinh ra doc đầy đủ. Output là Word doc hay Markdown tùy bạn chọn.

Tôi đã thử với một module nhỏ — Cowork sinh ra doc có cả class diagram mô tả bằng text, giải thích dependency injection flow, và liệt kê edge cases. Không hoàn hảo 100%, nhưng tốt hơn "không có doc" rất nhiều.

### 3. Tạo slide deck cho tech sharing

Dev hay phải present: sprint demo, tech talk nội bộ, architecture proposal. Mà dev thì ghét làm slide.

Workflow: bảo Cowork "tạo slide deck 10 slides về cách migrate từ single-platform Android sang KMP, audience là team mobile, tone technical nhưng dễ hiểu." Cowork dùng pptx skill, search web lấy thông tin mới nhất về KMP migration path, rồi xuất ra file `.pptx` mở được bằng PowerPoint hay Google Slides.

Cái này tôi dùng thật rồi. Nó không đẹp bằng designer làm, nhưng từ zero đến "có slide đủ tốt để present" chỉ mất khoảng 3–5 phút. So với 2 tiếng tự làm thì quá hời.

### 4. Phân tích crash log và error pattern

Bạn export crash log từ Firebase Crashlytics, copy vào một file `.txt`, mount folder chứa nó cho Cowork. Bảo: "đọc file crash_log.txt, nhóm các crash theo pattern, sắp xếp theo frequency, và đề xuất priority fix."

Cowork sẽ đọc file, dùng bash để parse và nhóm stack traces, rồi output một báo cáo có structure. Nó không fix code cho bạn — nhưng nó giúp bạn nhìn ra pattern nhanh hơn rất nhiều so với scroll qua hàng trăm dòng log.

Đặc biệt hữu ích khi bạn phải report bug cho stakeholder: Cowork có thể xuất kết quả phân tích ra `.xlsx` với sheet tổng hợp, giúp PM/PO hiểu được mà không cần đọc stack trace.

### 5. Tạo test plan và checklist trước release

Trước mỗi release, team cần checklist: regression test nào cần chạy, edge case nào cần verify, platform nào cần test (Android phone, tablet, nếu KMP thì cả iOS). Viết checklist này bằng tay thì nhàm, mà bỏ qua thì miss bug.

Workflow: mount project folder, bảo Cowork "đọc danh sách file đã thay đổi trong thư mục `src/`, liệt kê các module bị ảnh hưởng, và tạo test checklist cho QA." Cowork đọc file structure, hiểu module nào thay đổi, rồi sinh ra checklist dạng Markdown hoặc spreadsheet.

Kết hợp với Notion connector thì còn hay hơn: Cowork tạo checklist rồi push thẳng vào Notion database, assign cho QA luôn.

## Điều tôi hiểu nhầm

Tôi từng nghĩ Cowork chỉ dành cho người không biết code — PM, BA, marketer. Sai. Cowork dành cho bất kỳ ai muốn **tự động hóa công việc xung quanh code**: viết doc, nghiên cứu, báo cáo, tạo slide, phân tích dữ liệu. Những việc này chiếm 30–40% thời gian dev nhưng ít ai tối ưu.

Sai lầm thứ hai: cố dùng Cowork để **viết code production**. Đó là việc của Claude Code hoặc IDE plugin. Cowork đọc code để hiểu context, nhưng không nên dùng nó để refactor hay commit thay bạn. Ranh giới này hôm qua tôi đã bàn rồi.

## Takeaway

Nếu bạn là Android/KMP dev, đừng bỏ qua Cowork chỉ vì "nó không phải IDE." Thử mount project folder, bảo nó viết doc cho một module, hay tổng hợp crash log — bạn sẽ thấy nó tiết kiệm thời gian ở những chỗ bạn không ngờ. Dev giỏi không chỉ code giỏi, mà còn biết delegate đúng việc cho đúng tool.

Bài tiếp theo: **Agent Prompt Engineering** — cách viết `AGENT_PROMPT.md` để agent hiểu đúng ý bạn từ lần đầu.
