---
title: "TIL #007 — docx skill: tạo Word document chuyên nghiệp bằng 1 câu lệnh"
date: 2026-05-05
tags: ["cowork", "skills", "docx", "word", "file-creation", "automation"]
summary: "Bạn nói một câu, agent đọc sổ tay docx skill, rồi tạo ra file Word có heading, table, page number — nhưng đừng tưởng nó hoàn hảo ngay lần đầu."
---

## Bài học hôm nay

Hôm qua tôi viết về skills là gì — lý thuyết, mental model, cách hoạt động bên trong. Hôm nay tôi thực sự **dùng** một skill lần đầu tiên: `docx` — built-in skill chuyên tạo Word document. Và tôi muốn kể thật: có chỗ output đẹp bất ngờ, có chỗ tôi phải sửa tay.

Câu lệnh đơn giản nhất tôi thử: *"Tạo cho tôi một báo cáo tiến độ dự án, có mục tiêu, timeline, và bảng phân công."* Một câu. Không giải thích format, không nói dùng font gì, không chỉ định margins. Agent tự đọc skill `docx`, tự biết phải dùng thư viện `docx-js` để generate file, và ra một file `.docx` hoàn chỉnh.

---

## docx skill hoạt động thế nào bên trong

Khi bạn yêu cầu tạo Word document, đây là flow thực tế mà agent đi qua:

1. **Nhận diện task** — bạn nói "Word", "docx", "báo cáo", "memo" → agent biết cần skill `docx`
2. **Đọc SKILL.md** — file instruction dài khoảng 600 dòng, chứa toàn bộ best practices
3. **Generate JavaScript** — agent viết code dùng thư viện `docx-js` (npm package `docx`)
4. **Chạy code trong sandbox** — Linux sandbox có sẵn Node.js, agent install package rồi chạy
5. **Xuất file .docx** — file được lưu vào workspace folder, bạn nhận link download

Điều đáng chú ý: agent không dùng Python hay copy-paste HTML. Nó viết JavaScript thuần, dùng thư viện `docx-js` để tạo từng element: paragraph, heading, table, image, header, footer. Mỗi element là một object với properties rõ ràng.

### Skill này biết gì mà bạn không cần nói?

Đây là phần khiến tôi thấy skill thực sự hữu ích — những thứ tôi không nghĩ tới nhưng skill đã cover:

| Vấn đề | Cách skill xử lý |
|--------|------------------|
| Page size mặc định A4, nhưng cần US Letter | Skill nhắc agent set explicit: 12240 × 15840 DXA |
| Bullet points bị lỗi khi dùng unicode `•` | Skill cấm dùng unicode bullets, bắt dùng `LevelFormat.BULLET` |
| Table render sai trên Google Docs | Skill bắt dùng `WidthType.DXA` thay vì `PERCENTAGE` |
| Ảnh thiếu type parameter → crash | Skill yêu cầu luôn chỉ định `type: "png"` hoặc `"jpg"` |
| Cell padding quá sát → khó đọc | Skill có sẵn margins mặc định cho table cell |

Nếu không có skill, agent vẫn tạo được file `.docx` — nhưng sẽ bị những lỗi nhỏ như bảng vỡ layout trên Google Docs, hay bullet points hiển thị sai trên Word Online. Skill chính là kinh nghiệm đúc kết từ nhiều lần thử sai, đóng gói thành instruction.

---

## Hai mode: tạo mới vs. sửa file có sẵn

Một điều tôi không biết trước khi đọc kỹ: skill `docx` có **hai mode hoàn toàn khác nhau**.

**Mode 1 — Tạo mới:** Agent viết JavaScript dùng `docx-js`, build document từ đầu. Phù hợp khi bạn cần báo cáo mới, memo, letter, template. Ưu điểm: output sạch, structure rõ ràng. Nhược điểm: nếu bạn có template riêng thì agent không dùng được — nó phải tạo từ zero.

**Mode 2 — Sửa file có sẵn:** Agent unpack file `.docx` thành XML (vì docx thực chất là file ZIP chứa XML), sửa trực tiếp XML, rồi pack lại. Nghe phức tạp nhưng skill có script sẵn cho việc unpack/pack. Mode này hay ở chỗ: nó giữ nguyên format gốc, chỉ thay đổi đúng phần bạn yêu cầu. Và nó hỗ trợ **tracked changes** — kiểu như bạn bật Track Changes trong Word rồi sửa, người nhận thấy rõ chỗ nào đã thay đổi.

Ví dụ thực tế: bạn có file hợp đồng, muốn đổi tất cả "Q1 2026" thành "Q2 2026" và thêm comment giải thích. Agent unpack → find-and-replace trong XML → thêm tracked changes + comments → pack lại. Người nhận mở file thấy các chỗ sửa được highlight.

---

## Fail Wall

**Fail #1: Quên nói rõ ngôn ngữ.** Tôi viết prompt bằng tiếng Việt nhưng nội dung document cần tiếng Anh. Agent tạo file với nội dung tiếng Việt vì suy luận từ ngôn ngữ prompt. Bài học: nếu ngôn ngữ prompt khác ngôn ngữ output, phải nói rõ.

**Fail #2: Table phức tạp thì khó đẹp.** Tôi yêu cầu bảng có merged cells, nhiều cột, header row có màu nền. Kết quả: header row bị nền đen vì agent dùng `ShadingType.SOLID` thay vì `ShadingType.CLEAR`. Skill có cảnh báo về lỗi này, nhưng agent vẫn mắc. Lần thử thứ hai thì đúng — sau khi tôi nhắc "nền đen rồi kìa, sửa lại".

**Fail #3: Nghĩ file Word tạo ra sẽ giống y hệt trên mọi phần mềm.** File mở trên Microsoft Word trông khác so với mở trên Google Docs, đặc biệt phần table width và spacing. Đây không phải lỗi của skill — đây là thực tế của format `.docx`: mỗi phần mềm render khác nhau. Skill đã cố tối ưu cho cả hai bằng cách dùng DXA thay vì percentage, nhưng không thể 100%.

---

## Takeaway

docx skill biến việc tạo Word document từ "mở Word → format tay 30 phút" thành "nói 1 câu → nhận file trong 2 phút". Nhưng đừng kỳ vọng perfect output lần đầu — hãy nghĩ nó như draft 80% hoàn chỉnh, bạn review và tweak 20% còn lại. Với document quan trọng, luôn mở file ra kiểm tra trước khi gửi đi. Và nếu cần sửa file có sẵn, hãy biết rằng agent có thể unpack XML và sửa trực tiếp — tracked changes ngon lành.

Ngày mai: pptx skill — từ bullet points đến slide deck trong 2 phút. Bài #008 sẽ khám phá xem tạo presentation bằng agent có thực sự nhanh hơn PowerPoint hay không.
