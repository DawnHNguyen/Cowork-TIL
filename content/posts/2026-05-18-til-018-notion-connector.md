---
title: "TIL #018 — Notion connector: agent đọc/ghi Notion database"
date: 2026-05-18
tags: ["notion", "connector", "mcp", "database", "workflow"]
summary: "Notion connector biến agent thành trợ lý có quyền truy cập workspace — search, đọc, tạo page, query database — tất cả bằng tiếng Việt trong chat."
---

## Bài học hôm nay

Hôm qua tôi đã hiểu plugin và connector là gì, cách install chúng. Hôm nay tôi thực hành cụ thể với **Notion connector** — cái connector mà tôi hào hứng nhất vì Notion là nơi tôi sống: task board, meeting notes, wiki, cái gì cũng ở đó.

Câu hỏi chính: **agent có thực sự đọc/ghi Notion database được không, hay chỉ là marketing hype?** Spoiler: nó làm được nhiều hơn tôi tưởng, nhưng cũng có vài chỗ cần hiểu rõ trước khi dùng.

## Setup: nhanh hơn pha cà phê

Bước setup Notion connector chỉ mất khoảng một phút. Trong Cowork, vào **Customize → Connectors → Notion → Connect**. Trình duyệt mở ra, Notion yêu cầu bạn chọn workspace và authorize. Click **Allow access**, quay lại Cowork, connector đã ready.

Một chi tiết quan trọng: khi authorize, Notion hỏi bạn muốn cho phép access những page/database nào. Mặc định là toàn bộ workspace, nhưng bạn có thể chỉ chọn vài page cụ thể. Tôi khuyên: **bắt đầu hẹp, mở rộng sau**. Cho agent access cả workspace ngay từ đầu nghe tiện, nhưng bạn sẽ không muốn nó vô tình sửa trang quan trọng khi bạn chưa quen cách nó hoạt động.

Connector authorize một lần và persistent xuyên session — không cần đăng nhập lại mỗi lần mở Cowork.

## Agent làm được gì với Notion?

Sau khi tìm hiểu kỹ, đây là bức tranh toàn cảnh về những tool mà Notion MCP server cung cấp cho agent:

**Tìm kiếm và khám phá** — Agent dùng `notion-search` để tìm page, database trong workspace. Bạn gõ "tìm meeting notes tuần trước" và agent sẽ search across toàn bộ workspace, trả về kết quả liên quan. Nó thậm chí search được cả nội dung từ Slack, Google Drive nếu bạn đã connect trong Notion.

**Đọc nội dung** — `notion-fetch` cho phép agent đọc nội dung chi tiết của một page, bao gồm text, heading, todo list, bảng — gần như mọi block type. Bạn paste link Notion vào chat và nói "tóm tắt trang này", agent đọc và trả lời ngay.

**Tạo và sửa page** — Đây là chỗ mạnh nhất. Agent có thể `notion-create-pages` để tạo page mới với nội dung có cấu trúc: heading, paragraph, bullet list, code block, callout, quote. Và `notion-update-page` để cập nhật property của page — đổi status, assign người, thêm tag.

**Query database** — Nếu bạn dùng Notion database (kiểu task board, CRM, content calendar), agent có thể query với filter và sort. Ví dụ: "lọc tất cả task có status In Progress và assign cho tôi" — agent hiểu và thực thi.

**Tạo database và view** — Agent thậm chí có thể tạo database mới với schema bạn mô tả, và setup view dạng table, board, calendar, gallery. Tính năng này mới được bổ sung gần đây và khá powerful cho việc scaffold workspace.

## Ví dụ thực tế tôi đã thử

Tôi test bằng cách gõ vào Cowork: *"Tìm tất cả page có chứa từ 'sprint planning' trong Notion workspace của tôi, rồi tạo một page tổng hợp các action items."*

Agent thực hiện đúng 3 bước: search → đọc từng page tìm được → tạo page mới tổng hợp. Trang tổng hợp có heading rõ ràng, bullet list action items, và link reference về page gốc. Nếu tôi tự làm thủ công, việc này mất ít nhất 15 phút mở từng trang, copy paste. Agent làm trong khoảng 30 giây.

Một use case khác mà tôi thấy rất hữu ích: dùng Notion như **persistent memory** cho agent. Vì Cowork session là ephemeral (bài #002 đã nói), bạn có thể tạo một Notion page gọi là "Agent Context" và bảo agent đọc trang đó mỗi đầu session. Kết quả: agent "nhớ" context dự án, preferences, convention — tất cả được lưu trong Notion thay vì biến mất sau mỗi session.

## Điều tôi hiểu nhầm

**Nhầm lẫn lớn nhất: tưởng agent truy cập Notion trực tiếp.** Thực tế, mọi thao tác đi qua Notion API thông qua MCP server. Điều này có nghĩa: agent chỉ truy cập được những gì Notion API cho phép. Một số thứ như comment inline, embedded database view phức tạp, hay database relation đa tầng — agent có thể xử lý chưa mượt.

**Nhầm lẫn hai: quên rằng agent cần context.** Tôi gõ "cập nhật task board" mà không nói task board nào. Agent search ra 5 database, hỏi lại tôi chọn cái nào. Bài học: càng cụ thể càng tốt. Paste link trực tiếp hoặc nói rõ tên database.

**Nhầm lẫn ba: scope quá rộng khi authorize.** Lần đầu tôi cho phép access toàn bộ workspace rồi nhờ agent "dọn dẹp các page cũ". Agent lịch sự hỏi lại trước khi xóa, nhưng cảm giác vẫn hơi run. Nên giới hạn scope ban đầu — Notion cho phép bạn chọn cụ thể page/database nào agent được access.

## Takeaway

Notion connector là ví dụ điển hình cho thấy sức mạnh thật sự của Cowork: không phải ở việc chat thông minh, mà ở việc **hành động thay bạn** trên dữ liệu thật. Setup nhanh, persistent xuyên session, và agent đủ thông minh để chain nhiều thao tác — search, đọc, tổng hợp, tạo mới — thành một workflow liền mạch. Bắt đầu với 1–2 use case đơn giản (search + tóm tắt), quen tay rồi mới mở rộng sang tạo và sửa content.

Ngày mai: tôi sẽ thử **Gmail connector** — agent draft email, tìm kiếm inbox, và liệu nó có thật sự giúp tôi giảm thời gian xử lý email hay không.
