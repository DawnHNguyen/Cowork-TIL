---
title: "TIL #022 — Custom Skills: tạo skill của riêng bạn bằng Skill Creator"
date: 2026-05-25
tags: ["cowork", "skills", "skill-creator", "custom-skill", "SKILL.md", "automation"]
summary: "Skill không phải thứ chỉ Anthropic mới tạo được — bạn hoàn toàn có thể viết skill riêng, và thậm chí nhờ Claude viết giúp bằng cách... nói chuyện."
---

## Bài học hôm nay

Suốt 5 bài trước (từ #006 đến #010), tôi dùng skill như một thứ "có sẵn" — docx, pptx, xlsx, pdf — bấm nút, chạy, xong. Nhưng hôm nay tôi mới nhận ra: skill trong Cowork không phải một hệ thống đóng. Bạn hoàn toàn có thể tự tạo skill của riêng mình, đóng gói cách làm việc của bạn thành một "playbook" mà Claude sẽ tự động kích hoạt khi cần.

Và cái twist hay nhất? Bạn không cần biết code. Bạn chỉ cần mô tả workflow của mình trong một cuộc hội thoại, và Claude sẽ đóng gói nó thành skill cho bạn.

## Custom Skill là gì, thật sự?

Về bản chất, một skill chỉ là một thư mục chứa ít nhất một file `SKILL.md`. File này gồm hai phần: YAML frontmatter ở đầu (metadata để Claude biết khi nào nên dùng skill), và phần thân Markdown chứa hướng dẫn chi tiết.

Cấu trúc tối thiểu trông như thế này:

```
my-skill/
├── SKILL.md          ← bắt buộc
├── resources/        ← tùy chọn: tài liệu tham khảo
└── scripts/          ← tùy chọn: code thực thi
```

Còn file `SKILL.md` tối thiểu thì chỉ cần:

```yaml
---
name: Brand Guidelines
description: Apply Acme Corp brand guidelines to all presentations and documents. Use this whenever creating external-facing materials.
---

## Overview
Hướng dẫn Claude áp dụng brand guideline của Acme Corp...

## Workflow
1. Đọc file input
2. Áp dụng color palette chính thức
3. Format theo typography standards
...
```

Hai trường bắt buộc trong frontmatter: `name` (tối đa 64 ký tự) và `description` (tối đa 200 ký tự). Phần `description` cực kỳ quan trọng — đây là thứ Claude đọc đầu tiên để quyết định có nên load skill hay không. Viết description mờ nhạt = skill không bao giờ được gọi. Viết quá rộng = skill bị trigger linh tinh.

## Hai cách tạo skill

**Cách 1: Tự viết tay.** Bạn tạo thư mục, viết `SKILL.md` theo cấu trúc trên, thêm resources nếu cần, zip lại, rồi upload lên Claude qua Settings → Capabilities → Skills. Cách này cho bạn toàn quyền kiểm soát.

**Cách 2: Nói chuyện với Claude.** Mở một chat mới, nói đại loại "Tôi muốn tạo một skill để review hợp đồng" hoặc "Hãy biến workflow vừa rồi thành skill." Claude sẽ hỏi bạn vài câu về quy trình, output mong muốn, edge cases, rồi tự tạo file `SKILL.md` cho bạn. Trong Cowork, có sẵn một skill tên là **Skill Creator** chuyên hỗ trợ việc này.

Cách 2 là cách tôi thích hơn, vì nó giống như pair programming — bạn mô tả ý tưởng, Claude lo phần cấu trúc.

## Anatomy của một SKILL.md tốt

Sau khi đọc tài liệu chính thức và thử nghiệm, tôi rút ra vài nguyên tắc:

**Description phải "pushy" một chút.** Anthropic chính thức thừa nhận rằng Claude có xu hướng "undertrigger" — tức là có skill mà không dùng. Nên thay vì viết "Tạo dashboard cho dữ liệu nội bộ," hãy viết "Tạo dashboard cho dữ liệu nội bộ. Dùng skill này mỗi khi user nhắc đến dashboard, data visualization, hoặc muốn hiển thị bất kỳ dữ liệu nào dưới dạng bảng biểu."

**Dùng imperative voice.** Viết "Đọc file input" chứ không phải "File input nên được đọc." Rõ ràng, không mơ hồ.

**Một ví dụ cụ thể đáng giá hơn 50 dòng mô tả trừu tượng.** Nếu skill của bạn tạo report, hãy cho Claude thấy một report mẫu.

**Giữ SKILL.md dưới 500 dòng.** Nếu cần bảng dữ liệu dài, API specs, hay tài liệu tham khảo lớn — tách ra file riêng trong thư mục skill và reference từ SKILL.md.

**Skill có thể chứa script thực thi.** Bạn không cần tự viết code — khi mô tả workflow cho Claude, nó sẽ nhận ra phần nào cần script và tự tạo. Ví dụ: clean data bằng Python, format document, kết nối API bên ngoài.

## Điều tôi hiểu nhầm

Tôi nghĩ tạo custom skill phải biết code, phải hiểu YAML schema, phải debug file cấu hình. Sai. Cách đơn giản nhất là mở Cowork, bật Skill Creator, và bắt đầu nói chuyện. Claude sẽ hỏi bạn: "Skill này làm gì? Khi nào nên trigger? Output trông như thế nào?" — rồi nó tự viết.

Sai lầm thứ hai: tôi cứ nghĩ skill phải phức tạp mới đáng tạo. Thật ra, một skill chỉ với 10 dòng instruction — kiểu "khi tạo email cho client, luôn dùng tone formal, mở đầu bằng lời chào cụ thể, kết thúc bằng CTA rõ ràng" — đã đủ tiết kiệm cho bạn hàng chục lần copy-paste prompt.

Sai lầm thứ ba: description. Lần đầu tôi viết description quá chung chung ("Giúp tạo tài liệu"), Claude gần như không bao giờ tự trigger skill đó. Sau khi đổi thành cụ thể hơn — nêu rõ từ khóa, ngữ cảnh, loại request — skill mới hoạt động đúng.

## Takeaway

Custom skill là cách bạn dạy Claude "cách làm việc của bạn" — không phải cách làm việc chung chung, mà đúng quy trình, đúng format, đúng tone mà bạn hoặc team bạn dùng hàng ngày. Bắt đầu bằng một workflow nhỏ mà bạn lặp đi lặp lại, nhờ Skill Creator đóng gói nó, rồi iterate từ đó.

Bài tiếp theo: **TIL #023 — Cowork vs Claude Code: khi nào dùng cái nào** — decision framework để chọn đúng tool cho đúng việc.
