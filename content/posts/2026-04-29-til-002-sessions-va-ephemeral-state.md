---
title: "TIL #002 — Sessions & Ephemeral State: tại sao agent không nhớ gì — và đây không phải bug"
date: 2026-04-29
tags: ["cowork", "sessions", "ephemeral-state", "memory", "mental-model"]
summary: "Agent không nhớ gì sau mỗi session — và khi hiểu tại sao, bạn sẽ thiết kế workflow hoàn toàn khác."
---

## Bài học hôm nay

Hôm qua tôi setup xong blog, chạy scheduled task đầu tiên, mọi thứ ngon lành. Sáng nay mở session mới, gõ "tiếp tục bài hôm qua đi" — agent nhìn tôi như người lạ.

Không nhớ. Không nhớ gì hết. Không nhớ tôi là ai, không nhớ blog ở đâu, không nhớ curriculum là cái gì.

Phản ứng đầu tiên: "Bug à?" Phản ứng sau 10 phút research: "À, nó được thiết kế như vậy."

---

## Session trong Cowork hoạt động thế nào

Mỗi lần bạn mở một session mới trong Cowork, agent bắt đầu từ **zero**. Không có conversation history từ session trước. Không có "nhớ lại lần trước mình nói gì". Thuật ngữ chính xác: **ephemeral state**.

Hình dung thế này:

| Cái gì | Persist không? | Giải thích |
|---|---|---|
| Conversation trong session | Có (trong session đó) | Agent nhớ mọi thứ bạn nói **trong cùng 1 session** |
| Conversation giữa các session | Không | Session mới = agent mới, trí nhớ trắng |
| File trên disk | Có | File bạn tạo/sửa vẫn nằm trên máy |
| `$HOME` của sandbox | Không | Mọi thứ ghi vào đây bay sạch khi session kết thúc |
| Memory trong Projects | Có | Nếu dùng Projects, Claude nhớ context giữa các session |

Điểm quan trọng nhất: **file trên disk persist, nhưng conversation thì không**.

Nghĩa là nếu bạn muốn agent "nhớ" điều gì đó, bạn phải ghi nó ra file. Không có cách khác (trừ khi bạn dùng Projects — nói thêm ở dưới).

---

## Tại sao lại thiết kế stateless?

Ban đầu tôi thấy vô lý. Chatbot nào mà không nhớ user? Nhưng nghĩ lại thì design này có lý do:

**An toàn hơn.** Mỗi session là isolated. Agent không vô tình dùng thông tin nhạy cảm từ session trước cho task không liên quan.

**Predictable hơn.** Agent luôn bắt đầu từ cùng 1 trạng thái. Không có "tại sao hôm nay nó chạy khác hôm qua" vì context cũ can thiệp.

**Scale được.** Không cần lưu trữ vô hạn conversation history cho mỗi user. Clean và gọn.

Mental model đúng: Cowork agent giống một **nhân viên mới đến mỗi sáng**, nhưng bàn làm việc (file system) thì vẫn y nguyên từ hôm qua. Bạn không cần giải thích lại mọi thứ — bạn chỉ cần để lại **ghi chú trên bàn**.

---

## Projects — ngoại lệ quan trọng

Cowork có một tính năng gọi là **Projects**. Khi bạn làm việc trong một Project, Claude có thể lưu memory giữa các session — nhưng **chỉ trong scope của Project đó**.

Cụ thể: memory trong Project A không leak sang Project B. Và standalone session (không thuộc project nào) thì vẫn stateless hoàn toàn.

Nếu bạn có workflow lặp lại nhiều lần (như blog này), dùng Project là cách tự nhiên nhất để agent giữ context.

---

## Fail Wall

**Fail #1: Ghi state vào `$HOME` của sandbox**

Tôi thử lưu một file config vào `$HOME/.config/` trong sandbox. Session sau, file biến mất. Hóa ra `$HOME` trong sandbox cũng ephemeral — nó không phải disk thật của máy bạn. Muốn persist thì phải ghi vào **workspace folder** (folder bạn đã mount cho Cowork).

**Fail #2: Nghĩ "agent sẽ tự biết đọc file cũ"**

Agent không tự biết file nào quan trọng. Nếu bạn muốn agent đọc `curriculum.md` mỗi sáng, bạn phải **nói rõ trong instruction**. Agent không tự suy luận "à chắc file này quan trọng lắm, đọc đi". Bạn phải viết: "Bước 1: đọc file curriculum.md".

**Fail #3: Paste context cũ vào session mới**

Tôi copy cả đoạn conversation cũ paste vào session mới, nghĩ agent sẽ "nhớ lại". Agent đọc được, nhưng nó xử lý như **thông tin mới**, không phải ký ức. Kết quả: nó lặp lại mọi thứ thay vì tiếp tục.

---

## Takeaway

Ephemeral state không phải limitation — nó là **design constraint** bắt bạn phải làm đúng. Thay vì dựa vào trí nhớ mơ hồ của agent, bạn externalize mọi thứ ra file: curriculum, instruction, config. Kết quả: workflow của bạn reproducible, debuggable, và không phụ thuộc vào "agent có nhớ không".

Quy tắc vàng: **nếu agent cần biết → ghi ra file. Nếu chưa ghi ra file → agent không biết.**

Ngày mai: tìm hiểu cách agent đọc/ghi file trên máy bạn — Workspace & Files, và tại sao folder bạn mount cho Cowork lại quan trọng đến vậy.
