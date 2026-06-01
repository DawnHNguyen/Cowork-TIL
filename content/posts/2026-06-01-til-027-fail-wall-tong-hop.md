---
title: "TIL #027 — Fail Wall tổng hợp: những lần tôi thử và agent làm sai (hoặc tôi hỏi sai)"
date: 2026-06-01
tags: ["cowork", "fail-wall", "lessons-learned", "debugging", "prompt-engineering"]
summary: "26 bài TIL, hàng trăm lần chạy agent — và đây là bộ sưu tập những pha fail đáng nhớ nhất, cùng bài học rút ra từ mỗi cú ngã."
---

## Bài học hôm nay

Hôm qua tôi viết về debugging agent — cách tìm lỗi khi output sai. Hôm nay là phần thực hành "sống" của bài đó: **tổng hợp tất cả những lần tôi fail** suốt 26 bài TIL vừa qua.

Mỗi bài tôi đều có mục "Điều tôi hiểu nhầm" hoặc "Fail Wall" nhỏ. Nhưng hôm nay tôi muốn gom hết lại, phân loại, và rút ra pattern. Vì fail không đáng sợ — fail mà không học mới đáng sợ.

## Bảng Fail Wall — Top 7 pha fail đáng nhớ

### 1. "Dọn folder giúp tôi" — và agent dọn luôn file quan trọng

**Chuyện gì xảy ra:** Tôi bảo agent "clean up thư mục Downloads, xóa file rác." Agent hiểu "rác" theo cách riêng — nó xóa cả file `.zip` chứa backup dự án vì thấy tên file trông "tạm."

**Bài học:** Đừng bao giờ dùng từ mơ hồ như "rác", "dọn dẹp", "sắp xếp lại" mà không kèm tiêu chí cụ thể. Câu đúng nên là: *"Xóa các file có extension .tmp và .log cũ hơn 30 ngày."* Agent cần boundary rõ ràng, không phải vibes.

### 2. Scheduled task chạy lúc 3 AM — nhưng máy đang ngủ

**Chuyện gì xảy ra:** Tôi set scheduled task lúc 3:00 AM mỗi ngày, hy vọng sáng dậy có report sẵn. Kết quả: không có gì. Task skip im lặng vì Mac đang sleep.

**Bài học:** Scheduled tasks trong Cowork **yêu cầu máy awake và Claude Desktop đang mở**. Nếu máy sleep đúng lúc task chạy, Cowork sẽ bỏ qua và chạy bù khi máy thức. Giải pháp: hoặc chỉnh thời gian task vào lúc bạn đang dùng máy, hoặc set Mac không sleep (nhưng tốn pin).

### 3. "Tạo slide deck 20 trang" — agent tạo đúng 20 slide rỗng

**Chuyện gì xảy ra:** Prompt của tôi là "Tạo presentation 20 slides về AI trends." Agent tạo đúng 20 slides với title và bullet points... nhưng mỗi slide chỉ có 1-2 dòng generic kiểu "AI is transforming industries." Không data, không ví dụ, không insight.

**Bài học:** Agent thiếu context sẽ hallucinate hoặc viết generic. Tôi cần cung cấp source material, hoặc bảo agent research trước rồi mới tạo slides. Prompt đúng: *"Search 5 bài viết mới nhất về AI trends 2026, tóm tắt key points, rồi tạo slide deck từ data đó."* Research trước, output sau — luôn luôn.

### 4. Context window đầy — agent "quên" nửa sau instruction

**Chuyện gì xảy ra:** Tôi giao một task phức tạp: đọc 3 file CSV, merge data, tạo chart, rồi viết summary. Agent làm đúng bước 1-2, nhưng đến bước 3 thì tạo chart sai cột, và bước 4 thì summary không liên quan gì đến data ban đầu.

**Bài học:** Context window là tài nguyên hữu hạn. Khi nó đầy, agent bắt đầu "quên" instruction sớm nhất. Giải pháp: tách task lớn thành nhiều task nhỏ, mỗi task có output rõ ràng. Đừng nhồi 5 việc vào 1 prompt.

### 5. Agent gọi API không tồn tại

**Chuyện gì xảy ra:** Tôi bảo agent tích hợp với một service qua REST API. Agent tự tin gọi endpoint `/api/v3/users` — endpoint này không tồn tại. Nó hallucinate luôn cả response structure.

**Bài học:** Agent không biết API nào tồn tại hay không trừ khi bạn cho nó docs. Luôn cung cấp API documentation thật, hoặc bảo agent dùng web search để tìm docs chính thức trước khi viết code gọi API.

### 6. Sai file path — agent ghi file vào void

**Chuyện gì xảy ra:** Agent tạo report xong, ghi vào `/tmp/outputs/report.docx`. File tồn tại trong sandbox nhưng tôi không bao giờ thấy nó trong folder mà tôi mounted.

**Bài học:** Cowork có hai "thế giới" file: sandbox (tạm) và workspace folder (persistent). Nếu agent ghi file vào chỗ tạm mà không copy sang workspace, bạn mất file khi session kết thúc. Skill tốt phải chỉ rõ output path — đây là thứ tôi phải ghi vào SKILL.md sau vài lần mất file.

### 7. "Tôi" hỏi sai nhiều hơn agent làm sai

**Chuyện gì xảy ra:** Suốt 26 bài, pattern lớn nhất tôi thấy: **phần lớn lỗi là do cách tôi hỏi, không phải agent kém.** Prompt mơ hồ, thiếu context, expect agent đọc ý — tất cả đều dẫn đến output sai.

**Bài học:** Debug workflow, không phải debug model. Câu hỏi đúng không phải "tại sao agent ngu thế?" mà là "tôi đã cung cấp đủ context chưa?"

## Pattern tôi rút ra

Sau khi gom hết fail lại, tôi thấy chúng rơi vào 3 pattern chính:

**Pattern A — Prompt mơ hồ:** Agent không đoán được ý bạn. Nó làm theo nghĩa đen của câu bạn viết. Từ như "dọn dẹp", "cải thiện", "làm đẹp hơn" đều là bom nổ chậm.

**Pattern B — Thiếu data, thừa kỳ vọng:** Agent không có Google trong đầu. Nếu bạn không cho data hoặc bảo nó search, nó sẽ bịa. Hallucination không phải bug — nó là hệ quả tự nhiên khi bạn hỏi mà không cung cấp source.

**Pattern C — Task quá lớn:** Một prompt 500 từ giao 8 việc cùng lúc. Agent chạy tốt 60% đầu, rồi bắt đầu drift. Tách ra, tách ra, tách ra.

## Điều tôi hiểu nhầm

Tôi từng nghĩ "Fail Wall" là phần xấu hổ cần giấu. Nhưng qua 26 bài viết, tôi nhận ra nó là phần có giá trị nhất. Mỗi fail dạy tôi một điều mà 10 bài tutorial không dạy được. Và pattern chung luôn là: **fix workflow, đừng blame model.**

## Takeaway

Nếu bạn mới dùng Cowork, hãy tạo một file `my-fails.md` riêng. Mỗi lần agent làm sai, ghi lại: prompt bạn dùng, output sai, và cách bạn sửa. Sau 2 tuần, bạn sẽ thấy pattern của chính mình — và từ đó trở đi, bạn sẽ ít fail hơn đáng kể.

Bài tiếp theo: **Mental Models — 5 cách nghĩ về Cowork giúp tôi dùng hiệu quả hơn.** Từ fail cụ thể sang framework tư duy tổng quát.
