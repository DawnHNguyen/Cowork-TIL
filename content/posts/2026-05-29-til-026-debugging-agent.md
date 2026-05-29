---
title: "TIL #026 — Debugging agent: khi agent làm sai thì debug như thế nào"
date: 2026-05-29
tags: ["cowork", "debugging", "agent", "troubleshooting", "prompt-engineering"]
summary: "Agent không có stack trace — nhưng vẫn debug được, nếu bạn biết nhìn vào đâu."
---

## Bài học hôm nay

Hôm qua tôi viết về Agent Prompt Engineering — cách viết instruction tốt để agent làm đúng từ đầu. Nhưng thực tế? Agent vẫn sai. Thường xuyên. Và câu hỏi không phải "làm sao để agent không bao giờ sai" mà là **"khi agent sai, tôi tìm lỗi ở đâu?"**

Debugging agent khác hoàn toàn với debugging code truyền thống. Không có breakpoint, không có stack trace, không có error log đỏ lòm chỉ thẳng dòng bị lỗi. Agent sai thường là sai *ngầm* — output trông hợp lý nhưng không phải thứ bạn cần. Vì vậy, mindset debug cũng phải khác: bạn không debug *model*, bạn debug *workflow* — tức prompt, context, và cách bạn giao việc.

## Ba loại lỗi agent hay mắc

Trước khi debug, cần phân loại lỗi. Từ trải nghiệm của tôi với Cowork, lỗi agent rơi vào ba nhóm chính:

| Loại lỗi | Biểu hiện | Nguyên nhân thường gặp |
|---|---|---|
| **Hiểu sai yêu cầu** | Output đúng format nhưng sai nội dung, sai hướng | Prompt mơ hồ, thiếu context, hoặc có nhiều cách hiểu |
| **Quên giữa chừng** | Bước 1-3 đúng, bước 4 trở đi bắt đầu lệch | Context window đầy, agent "quên" instruction ban đầu |
| **Hallucinate dữ liệu** | Agent tự bịa thông tin, file path sai, API không tồn tại | Thiếu dữ liệu thực, agent không được search trước khi trả lời |

Nhận diện đúng loại lỗi giúp bạn biết nên sửa ở đâu — prompt, context hay workflow.

## Chiến thuật debug thực tế

### 1. Đừng bảo "sửa đi" — hãy hỏi "tại sao"

Sai lầm lớn nhất tôi hay mắc: thấy output sai là bảo ngay "Sai rồi, sửa lại." Agent sẽ sửa — nhưng thường chỉ patch bề mặt, không giải quyết gốc rễ.

Cách tốt hơn: mô tả kỳ vọng và hỏi agent phân tích. Ví dụ: *"Tôi expect file output ở thư mục X nhưng agent ghi vào Y. Bạn walk through lại logic để xem chỗ nào bị lệch?"* Khi agent tự trace lại bước đi, nó thường tìm được bug chính xác hơn bạn chỉ tay.

### 2. Cho agent một "bài kiểm tra" để tự verify

Đây là tip tôi học được và thay đổi cách dùng Cowork: đừng chỉ giao việc, hãy giao luôn **tiêu chí kiểm tra**. Ví dụ:
- "Tạo file report.docx, sau đó đọc lại file đó và confirm nó có đúng 5 section không"
- "Viết script Python, chạy thử, nếu có error thì tự sửa đến khi pass"

Khi agent có check để chạy — test, build, screenshot để so sánh — nó sẽ tự iterate cho đến khi pass. Không có check? Agent giao output và nghĩ mình xong rồi.

### 3. Cẩn thận "vùng ngu" của context window

Đây là khái niệm mà tôi ước mình biết sớm hơn. Context window của agent giống như bộ nhớ ngắn hạn — nó chứa toàn bộ conversation, mọi file đã đọc, mọi tool đã gọi. Khi context đầy khoảng 60-70%, performance bắt đầu xuống dốc rõ rệt. Agent bỏ qua instruction, mắc lỗi cơ bản, hoặc lặp lại thao tác đã làm.

Dấu hiệu nhận biết: agent bắt đầu "quên" rule bạn đã nói ở đầu conversation, hoặc làm ngược lại instruction rõ ràng.

**Giải pháp:** Đừng nhồi mọi thứ vào một session dài. Nếu task phức tạp, chia thành nhiều session nhỏ. Mỗi session có một mục tiêu rõ ràng, context gọn.

### 4. Quy tắc "hai lần thử"

Nếu agent sửa lỗi lần 1 mà vẫn sai, sửa lần 2 vẫn sai — **dừng lại**. Đừng insist. Lúc này bạn đang cho agent ngày càng nhiều context mâu thuẫn, và nó sẽ chỉ tệ hơn.

Thay vào đó: bắt đầu session mới, viết lại prompt từ đầu nhưng rõ hơn. Nhiều khi vấn đề không phải agent "dốt" mà là conversation đã bị nhiễu quá nhiều thông tin sai.

### 5. Dùng dry run trước khi chạy thật

Với những task có side effect (gửi email, xóa file, post lên Notion), tôi luôn dùng dry run: bảo agent mô tả bước sẽ làm **trước khi thực sự làm**. Kiểu "Liệt kê ra 5 bước bạn sẽ thực hiện, chưa cần chạy." Review xong mới cho chạy thật. Mất thêm 30 giây nhưng tránh được tai nạn.

## Điều tôi hiểu nhầm

Tôi từng nghĩ debug agent là vấn đề của model — "Claude chưa đủ giỏi." Thực tế, 90% lỗi tôi gặp là do **tôi giao việc sai**: prompt mơ hồ, context thừa, hoặc nhồi quá nhiều task vào một session.

Một hiểu nhầm khác: tôi hay copy nguyên đoạn output sai rồi paste lại kèm "cái này sai, sửa lại." Cách này chỉ thêm noise vào context. Tốt hơn là mô tả ngắn gọn: expected gì, actual gì, khác nhau chỗ nào.

## Takeaway

Debug agent = debug cách bạn giao việc. Phân loại lỗi trước, hỏi "tại sao" thay vì "sửa đi", cho agent cách tự kiểm tra, và biết lúc nào nên dừng để bắt đầu lại từ đầu. Agent không có stack trace — nhưng nếu bạn cung cấp đủ context và tiêu chí rõ ràng, nó tự debug được.

Bài tiếp theo: **TIL #027 — Fail Wall tổng hợp** — tổng hợp lại tất cả những lần tôi thử và agent làm sai (hoặc tôi hỏi sai) suốt 26 bài vừa qua. Spoiler: danh sách dài hơn tôi tưởng.
