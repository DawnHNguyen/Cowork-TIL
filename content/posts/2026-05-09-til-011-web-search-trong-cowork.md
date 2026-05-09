---
title: "TIL #011 — Web Search trong Cowork: agent tìm kiếm thay bạn"
date: 2026-05-09
tags: ["web-search", "tools", "cowork", "research"]
summary: "Agent trong Cowork có thể tự search Google thay bạn — nhưng cách nó search, lúc nào nó search, và giới hạn của nó thì không giống bạn tưởng."
---

## Bài học hôm nay

Hôm nay tôi bắt đầu Phase 3 — giai đoạn mà agent không chỉ đọc/ghi file nữa, mà thực sự có "tay chân" để tương tác với thế giới bên ngoài. Và công cụ đầu tiên cần hiểu là **Web Search** — khả năng agent tự tìm kiếm thông tin trên web thay bạn.

Nghe thì đơn giản: bạn hỏi, agent search, agent trả lời. Nhưng sau khi thử nghiệm, tôi nhận ra cơ chế đằng sau phức tạp hơn nhiều so với việc bạn tự mở Google. Và quan trọng hơn: biết lúc nào agent search tốt, lúc nào nó search tệ — sẽ quyết định bạn có tin được câu trả lời hay không.

## Cơ chế hoạt động: không phải "copy-paste từ Google"

Khi bạn hỏi agent một câu cần thông tin cập nhật, Cowork sẽ gọi tool `WebSearch` ở hậu trường. Quy trình diễn ra như thế này:

1. **Agent tự quyết định có cần search không** — dựa trên prompt của bạn. Nếu câu hỏi nằm trong kiến thức sẵn có, nó sẽ trả lời luôn mà không search.
2. **Tạo search query** — agent không gửi nguyên câu hỏi của bạn lên Google. Nó tự viết lại thành query tối ưu hơn.
3. **Nhận kết quả và đọc** — kết quả trả về dưới dạng các search result blocks kèm link.
4. **Lặp lại nếu cần** — agent có thể search nhiều lần trong một request để thu thập đủ thông tin.
5. **Tổng hợp và trích nguồn** — câu trả lời cuối cùng kèm citation, để bạn verify được.

Điểm hay nhất: agent có thể **search nhiều lần liên tiếp** trong cùng một lượt trả lời. Ví dụ, bạn hỏi "so sánh pricing giữa AWS Lambda và Google Cloud Functions năm 2026", agent có thể search riêng từng cái rồi tổng hợp lại — thay vì chỉ search một lần rồi cố gắng suy luận.

## WebSearch vs WebFetch: hai tool khác nhau

Cowork thực ra có hai tool liên quan đến web, và nhiều người (kể cả tôi ban đầu) hay nhầm:

| | **WebSearch** | **WebFetch** |
|---|---|---|
| **Mục đích** | Tìm trang web liên quan | Đọc nội dung một URL cụ thể |
| **Input** | Một câu query | Một URL + câu hỏi cụ thể |
| **Output** | Danh sách kết quả + link | Nội dung trang đã tóm tắt |
| **Khi nào dùng** | Không biết tìm ở đâu | Đã có link, cần đọc chi tiết |

Nghĩ đơn giản: **WebSearch = Google**, **WebFetch = mở tab và đọc trang đó**. Agent thường dùng kết hợp cả hai: search trước để tìm URL, rồi fetch URL đó để đọc sâu hơn.

## Khi nào agent search tốt?

Qua trải nghiệm, tôi thấy Web Search hoạt động tốt nhất khi:

- **Hỏi về sự kiện, số liệu gần đây** — "GDP Việt Nam quý 1/2026 là bao nhiêu?" Agent sẽ tự biết cần search vì đây là thông tin ngoài knowledge cutoff.
- **So sánh công cụ/sản phẩm** — agent search nhiều nguồn rồi tổng hợp, tiết kiệm bạn rất nhiều tab.
- **Research chủ đề mới** — thay vì bạn mở 10 tab, agent search và đọc giúp.

## Giới hạn thực tế (phần quan trọng)

Đây mới là phần mà documentation ít nói nhưng bạn cần biết:

**1. Egress proxy chặn khá nhiều domain.** Trong Cowork, mọi request ra ngoài đều đi qua một proxy bảo mật. Proxy này chặn một số domain — không chỉ những trang "lạ" mà cả những trang phổ biến. Nếu agent nói "không thể truy cập trang này", đó không phải lỗi — đó là proxy đang làm việc.

**2. Trang JavaScript-heavy thì fetch không được.** WebFetch lấy HTML tĩnh rồi chuyển sang Markdown. Nếu nội dung trang được render bằng JavaScript (SPA, React app, dynamic content), agent sẽ nhận được trang trắng hoặc thiếu nội dung. Đây là lý do mà đôi khi agent đọc được trang docs nhưng không đọc được trang dashboard.

**3. Agent có thể search sai query.** Agent viết query dựa trên cách nó hiểu câu hỏi của bạn. Nếu bạn hỏi mơ hồ, query cũng sẽ mơ hồ. Tip: **hãy nói rõ bạn muốn tìm gì, ở đâu, thời gian nào.** "Search giá vàng" tệ hơn nhiều so với "search giá vàng SJC hôm nay trên DOJI".

## Điều tôi hiểu nhầm

Ban đầu tôi nghĩ Web Search giống như tôi tự search Google — nghĩa là tôi thấy gì thì agent cũng thấy vậy. Sai. Agent không "thấy" trang web như bạn thấy. Nó nhận text đã được xử lý, không có layout, không có hình ảnh, không có interactive elements. Nó đọc **nội dung**, không đọc **giao diện**.

Sai lầm thứ hai: tôi cứ nghĩ agent sẽ tự động search khi cần. Phần lớn thời gian đúng vậy, nhưng đôi khi agent tự tin trả lời từ training knowledge mà không search — dù thông tin đã cũ. Nếu bạn cần thông tin chắc chắn mới nhất, hãy nói rõ: "search web để tìm thông tin mới nhất về X".

## Takeaway

Web Search biến agent từ "chỉ biết những gì nó được train" thành "có thể tìm hiểu thêm khi cần". Nhưng nó không phải magic — bạn vẫn cần cho agent query tốt, biết giới hạn của proxy, và luôn check citation thay vì tin tuyệt đối.

Bài tiếp theo: **Web Fetch** — khi bạn đã có URL và muốn agent đọc sâu nội dung trang đó cho bạn.
