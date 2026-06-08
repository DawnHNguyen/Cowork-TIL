---
title: "TIL #031 — Claude in Chrome: browsing agent và so sánh với Cowork"
date: 2026-06-08
tags: ["claude-in-chrome", "browsing-agent", "cowork", "so-sanh", "workflow"]
summary: "Claude in Chrome biến browser thành workspace có agent điều khiển — nhưng nó khác Cowork ở đâu và khi nào dùng cái nào?"
---

## Bài học hôm nay

Sau 30 bài viết về Cowork, hôm nay tôi bước ra ngoài một chút để nhìn vào "người anh em" cùng nhà: **Claude in Chrome** — một browsing agent chạy trực tiếp trong trình duyệt. Câu hỏi đặt ra: nếu đã có Cowork thì cần Chrome extension làm gì? Spoiler: chúng giải quyết hai bài toán khác nhau, và hiểu ranh giới giữa chúng sẽ giúp bạn chọn đúng tool cho đúng việc.

## Claude in Chrome là gì?

Claude in Chrome là một extension chạy trong side panel của Chrome. Khi bật, nó có thể:

- **Đọc trang web đã render** (không phải HTML thô — mà là DOM thật sau khi JavaScript chạy xong)
- **Click, scroll, fill form** — giống một con cursor ảo do AI điều khiển
- **Quản lý nhiều tab** — kéo tab vào "tab group" của Claude, agent thấy và thao tác được tất cả
- **Chạy multi-step workflow** — ví dụ "tìm email từ sếp tuần này, tóm tắt, rồi tạo calendar event"

Nó được xây trên **Computer Use API** — Claude không dùng selector hay XPath cứng mà phân tích visual layout để xác định button, link, input. Bạn mô tả bằng tiếng tự nhiên, agent tự tìm cách thực hiện.

## So sánh nhanh: Claude in Chrome vs Cowork

| Tiêu chí | Claude in Chrome | Cowork |
|----------|-----------------|--------|
| **Phạm vi** | Chỉ trong Chrome browser | File system + shell + MCP connectors |
| **Cách tương tác** | Nhìn + click vào web page | Đọc/ghi file, chạy code, gọi API |
| **Khi nào hoạt động** | Chrome phải mở | Agent chạy độc lập (scheduled tasks) |
| **Use case chính** | Web task không có API | File processing, automation, document generation |
| **Model** | Haiku 4.5 (Pro), chọn model (Max/Team) | Tuỳ plan |
| **Yêu cầu** | Chrome extension installed | Claude Desktop app |

## Khi nào dùng Claude in Chrome?

Ba tình huống điển hình:

**1. Web app không có API hoặc MCP connector.** Ví dụ bạn cần fill form trên một portal nội bộ công ty, hoặc extract data từ dashboard mà chỉ có web UI. Chrome agent "nhìn" và thao tác trực tiếp — không cần code.

**2. Bạn muốn co-pilot real-time.** Bạn đang browse, Claude đọc cùng bạn và suggest hoặc thực hiện action ngay. Workflow kiểu "đọc email → draft reply → schedule meeting" chạy mượt vì Claude đã có built-in knowledge về Gmail, Calendar, Slack.

**3. Task lặp lại trên web.** Với scheduled tasks trong Chrome, bạn có thể set agent tự chạy vào mỗi sáng — check inbox, tóm tắt, report. Nhưng lưu ý: Chrome phải mở.

## Khi nào Cowork vẫn tốt hơn?

**File-heavy workflow.** Cowork đọc/ghi file trực tiếp, chạy Python/Node trong sandbox, tạo docx/xlsx/pptx bằng skill. Chrome agent không chạm được filesystem.

**Automation không cần browser.** Scheduled task trong Cowork chạy bất kể browser có mở hay không (chỉ cần Mac awake). Bạn delegate và đi uống cà phê.

**MCP connectors.** Cowork kết nối Notion, Gmail, GitHub qua protocol chuẩn — nhanh, ổn định, không phụ thuộc UI có thay đổi hay không. Chrome agent phải "nhìn" UI nên dễ break khi site redesign.

## Điều tôi hiểu nhầm

Ban đầu tôi nghĩ Claude in Chrome chỉ là "chat sidebar đọc webpage" — kiểu như Perplexity nhưng gắn vào Claude. Sai. Nó thực sự **điều khiển** browser: click button, navigate, fill form, switch tab. Đây là full browsing agent, không phải reader.

Hiểu nhầm thứ hai: tôi tưởng nó thay thế Cowork cho mọi web-related task. Thực tế, nếu web app có MCP connector (Notion, Gmail...) thì dùng connector trong Cowork vẫn **nhanh hơn và ổn định hơn** — vì gọi API trực tiếp thay vì simulate click.

## Takeaway

Nguyên tắc chọn đơn giản: **có API/connector → Cowork. Chỉ có web UI → Chrome agent.** Nếu task cần cả file system lẫn web interaction, dùng cả hai — Cowork xử lý phần nặng, Chrome xử lý phần browser-only.

---

*Bài tiếp theo: Vibe coding với Cowork — khác gì so với Claude Code khi bạn muốn "code bằng lời"?*
