---
title: "TIL #019 — Gmail connector: agent làm inbox thay bạn"
date: 2026-05-19
tags: ["gmail", "connector", "mcp", "email", "workflow"]
summary: "Gmail connector biến Cowork thành trợ lý email thực thụ — tìm kiếm, đọc, tạo draft — nhưng không bao giờ tự gửi mail thay bạn."
---

## Bài học hôm nay

Hôm qua tôi viết về Notion connector, hôm nay chuyển sang một connector mà hầu như ai cũng cần: **Gmail**. Nếu bạn từng mở Gmail, gõ từ khóa tìm email cũ, scroll qua 47 kết quả không liên quan, rồi cuối cùng bỏ cuộc — thì Gmail connector trong Cowork sinh ra để giải quyết đúng cái đau đó.

Ý tưởng cốt lõi: thay vì bạn phải mở Gmail, nhớ cú pháp search phức tạp (`from:boss@company.com after:2026/04/01 has:attachment`), bạn chỉ cần nói với agent bằng tiếng người: *"Tìm email nào từ sếp gửi tháng trước có đính kèm file"*. Agent sẽ dịch yêu cầu đó thành Gmail query syntax và trả kết quả cho bạn.

## Gmail connector làm được gì?

Sau khi kết nối, agent có một bộ tools khá rõ ràng. Tôi chia thành 3 nhóm chính:

**Nhóm 1 — Tìm kiếm và đọc email.** Đây là thứ tôi dùng nhiều nhất. Tool `search_threads` cho phép tìm email theo bất kỳ tiêu chí nào: người gửi, ngày tháng, có attachment hay không, label nào, đã đọc hay chưa. Kết quả trả về là danh sách thread kèm snippet. Muốn đọc chi tiết thì dùng `get_thread` với thread ID để lấy toàn bộ nội dung.

**Nhóm 2 — Tạo draft email.** Tool `create_draft` cho phép agent soạn email nháp với đầy đủ To, CC, BCC, subject, body (cả plain text lẫn HTML). Thậm chí có thể tạo draft reply cho một email cụ thể bằng cách truyền `replyToMessageId`. Draft sẽ xuất hiện trong Gmail Drafts của bạn — bạn review rồi tự tay nhấn Send.

**Nhóm 3 — Quản lý labels.** Agent có thể tạo label mới, gắn label vào message hoặc thread, gỡ label, và liệt kê tất cả labels hiện có. Nghe đơn giản nhưng khi kết hợp với search, bạn có thể làm những thứ kiểu: *"Tìm tất cả email từ client X trong 30 ngày qua và gắn label 'Review Q2' cho chúng."*

## Điều quan trọng nhất: agent KHÔNG gửi email

Đây là thiết kế có chủ đích, không phải limitation. Khi bạn authorize Gmail qua OAuth, Google sẽ hiện scope có quyền gửi mail — nhưng Cowork chỉ dùng quyền đọc và tạo draft. Mọi email đều phải do bạn nhấn nút Send trong Gmail.

Tại sao? Vì email là hành động không thể undo. Gửi nhầm mail cho sếp lúc 2 giờ sáng với nội dung agent hiểu sai thì không có nút Ctrl+Z. Đây là một ví dụ rõ ràng của nguyên tắc **"explicit permission"** mà tôi đã nhắc ở các bài trước — agent tạo draft, bạn review và quyết định.

## Workflow thực tế tôi hay dùng

Workflow tôi thấy hữu ích nhất là kiểu "research + draft". Ví dụ:

1. Tôi bảo agent: *"Tìm email thread gần nhất với team marketing về campaign Q2"*
2. Agent dùng `search_threads` tìm ra thread, rồi `get_thread` để đọc nội dung
3. Tôi bảo tiếp: *"Dựa vào thread đó, soạn draft reply tóm tắt 3 action items chính"*
4. Agent tạo draft reply — tôi mở Gmail, đọc lại, chỉnh vài chỗ, rồi gửi

Toàn bộ flow này mất khoảng 2 phút thay vì 15 phút đọc thread dài và tự tóm tắt. Cái hay là agent hiểu context của cả thread, không chỉ email cuối cùng.

Một workflow khác: **dọn inbox**. Tôi bảo agent tìm tất cả email chưa đọc trong 7 ngày qua, tóm tắt từng cái trong 1 câu, rồi gợi ý label phù hợp. Agent không tự gắn label (trừ khi tôi cho phép cụ thể), nhưng cái bản tóm tắt đó giúp tôi quyết định nhanh hơn nhiều.

## Cách setup

Setup khá giống Notion connector mà tôi viết hôm qua. Vào **Settings > Connectors**, tìm Gmail, click **Connect**. Browser sẽ mở ra trang OAuth của Google — bạn chọn tài khoản Gmail và authorize. Xong. Quay lại Cowork là agent đã có quyền truy cập.

Lưu ý: nếu bạn dùng plan Team hoặc Enterprise, admin phải bật connector ở cấp tổ chức trước. Nếu bạn click Connect mà không thấy gì, hỏi admin trước khi debug lung tung.

## Điều tôi hiểu nhầm

Ban đầu tôi tưởng Gmail connector có thể gửi email. Tôi bảo agent "gửi email cho X" và agent tạo draft. Tôi nghĩ nó bị lỗi, mở Gmail thấy draft nằm đó. Hóa ra đó là **đúng behavior** — tôi đã mất 10 phút debug một thứ hoạt động hoàn toàn đúng thiết kế.

Một nhầm lẫn khác: tôi nghĩ `search_threads` trả về toàn bộ nội dung email. Thực tế nó chỉ trả snippet — muốn đọc full body phải gọi thêm `get_thread`. Thiết kế hai bước này hợp lý vì nếu search trả 20 thread mà mỗi cái kèm toàn bộ nội dung thì tốn token khủng khiếp.

## Về bảo mật

Agent chỉ truy cập email khi bạn yêu cầu cụ thể — không tự đọc inbox trong background. Token OAuth được mã hóa, và Anthropic cam kết không dùng dữ liệu Gmail để train model. Nhưng dù vậy, tôi khuyên bạn nên dùng tài khoản work thay vì personal email nếu lo lắng về privacy. Và nhớ rằng agent mirror quyền của bạn — nó không đọc được email của người khác.

## Takeaway

Gmail connector biến Cowork thành trợ lý email thực sự: tìm nhanh, đọc thông minh, soạn draft giúp bạn — nhưng luôn để bạn là người nhấn nút Send. Nếu bạn xử lý nhiều email mỗi ngày, đây là connector nên setup đầu tiên sau Notion.

Bài tiếp theo: tôi sẽ nói về **GitHub connector** — hay đúng hơn là tại sao nó không tồn tại chính thức, và các workaround bằng PAT mà bạn có thể dùng.
