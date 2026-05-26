---
title: "TIL #022 — Custom Skills: tạo skill của riêng bạn bằng Skill Creator"
date: 2026-05-26
tags: ["cowork", "skills", "skill-creator", "custom-skills", "automation"]
summary: "Skill có sẵn thì tiện, nhưng skill tự tạo mới là thứ biến Cowork thành trợ lý riêng của bạn — và Skill Creator giúp bạn làm điều đó mà không cần viết code."
---

## Bài học hôm nay

Sau 21 bài viết, tôi đã dùng đủ loại skill có sẵn: docx, pptx, xlsx, pdf. Chúng hoạt động tốt, nhưng luôn có cảm giác "gần đúng nhưng chưa đúng hẳn." Ví dụ, mỗi lần tạo báo cáo tuần, tôi phải nhắc lại format, tone, và cấu trúc. Lần nào cũng copy-paste cùng một đoạn prompt dài.

Hôm nay tôi học cách tạo **Custom Skill** — và nhận ra đây mới là thứ biến Cowork từ "một con chatbot biết tạo file" thành "trợ lý hiểu cách tôi làm việc."

## Custom Skill là gì?

Mỗi skill trong Cowork thực chất là **một thư mục chứa file SKILL.md**. File này gồm hai phần:

**YAML frontmatter** (nằm giữa hai dấu `---`) — metadata giúp Claude biết khi nào nên kích hoạt skill:

```yaml
---
name: weekly-report
description: >
  Tạo báo cáo tuần theo format công ty.
  Dùng khi user nói "báo cáo tuần", "weekly report",
  "tổng hợp tuần này", hoặc yêu cầu tóm tắt công việc.
---
```

**Markdown instructions** — phần thân, hướng dẫn Claude phải làm gì, theo thứ tự nào, output ra sao.

Cấu trúc thư mục nhìn đơn giản thế này:

```
weekly-report/
├── SKILL.md          ← bắt buộc
├── template.docx     ← tùy chọn, file tham khảo
└── examples/         ← tùy chọn, ví dụ input/output
```

## Cách tạo skill bằng Skill Creator

Skill Creator là một skill có sẵn trong Cowork (meta không?). Bạn gõ `/skill-creator` hoặc đơn giản nói: "Giúp tôi tạo một skill để [mô tả công việc lặp đi lặp lại]."

Quy trình diễn ra thế này:

**Bước 1 — Phỏng vấn.** Skill Creator hỏi bạn: skill này làm gì, khi nào nên trigger, output trông như thế nào, có edge case gì không. Nếu bạn vừa chạy xong một workflow trong Cowork, bạn có thể nói "Package cái mình vừa làm thành skill" — nó sẽ tự trích xuất các bước từ conversation.

**Bước 2 — Viết bản nháp.** Dựa trên câu trả lời, nó generate ra SKILL.md hoàn chỉnh với frontmatter, workflow steps, output format, và edge cases.

**Bước 3 — Test.** Nó tạo vài test prompt, chạy thử skill, rồi đưa kết quả cho bạn đánh giá. Phần này có cả quantitative eval — nếu skill có output kiểm chứng được (tạo file, extract data), nó sẽ chấm điểm tự động.

**Bước 4 — Iterate.** Sửa, chạy lại, sửa tiếp. Loop này lặp cho đến khi bạn hài lòng.

**Bước 5 — Tối ưu description.** Cuối cùng, nó chạy một bước riêng để optimize phần description — vì description quyết định Claude có tự trigger skill hay không.

Toàn bộ quá trình mất khoảng 15–30 phút cho skill đầu tiên.

## Mẹo viết SKILL.md tốt

Sau khi nghịch thử, tôi rút ra vài điều:

**Description phải "pushy" một chút.** Claude có xu hướng "undertrigger" — tức là có skill phù hợp nhưng không tự dùng. Thay vì viết mô tả chung chung kiểu "Tạo báo cáo", hãy liệt kê cụ thể các cụm từ trigger: "Dùng khi user nói 'báo cáo tuần', 'weekly summary', 'tổng hợp sprint', hoặc bất kỳ yêu cầu tóm tắt công việc nào."

**Giữ SKILL.md dưới 500 dòng.** Nếu cần bảng tham khảo dài hay spec chi tiết, tách ra file riêng trong cùng thư mục và reference từ SKILL.md.

**Luôn có ví dụ cụ thể.** Ít nhất 2 ví dụ: một happy path và một edge case, với cả input lẫn output thực tế. Claude hiểu ví dụ tốt hơn nhiều so với mô tả trừu tượng.

**Viết step bằng imperative voice, mỗi step một hành động.** "Đọc file CSV" chứ không phải "Bạn có thể đọc file CSV nếu cần." Rõ ràng, không mơ hồ.

## Điều tôi hiểu nhầm

Tôi tưởng tạo custom skill phải biết code, hoặc ít nhất phải hiểu YAML syntax. Thực tế, Skill Creator xử lý hết phần kỹ thuật — bạn chỉ cần mô tả workflow bằng ngôn ngữ tự nhiên. Nó giống như pair programming, nhưng thay vì viết code, bạn đang "viết" cách làm việc của mình.

Sai lầm lớn nhất của tôi: viết description quá ngắn. Tôi ghi "Tạo báo cáo" — rồi thắc mắc tại sao Claude không tự trigger skill khi tôi nói "tổng hợp tuần này." Lý do đơn giản: description không chứa cụm từ đó. Claude match theo description, không phải đọc ý bạn.

Một sai lầm nữa: nhồi quá nhiều logic vào một skill. Skill tốt nên làm **một việc**, làm rõ ràng. Nếu workflow phức tạp, tách thành nhiều skill nhỏ sẽ dễ maintain và debug hơn.

## Takeaway

Custom Skill là cách bạn "dạy" Cowork hiểu quy trình làm việc riêng của mình — và Skill Creator biến việc đó thành một cuộc trò chuyện thay vì một bài tập lập trình. Bắt đầu với task bạn lặp đi lặp lại nhiều nhất, mô tả nó cho Skill Creator, rồi iterate cho đến khi output đúng ý.

Bài tiếp theo: **Cowork vs Claude Code** — khi nào dùng cái nào, và decision framework để chọn đúng tool cho đúng việc.
