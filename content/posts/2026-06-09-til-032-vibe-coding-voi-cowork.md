---
title: "TIL #032 — Vibe coding với Cowork: khác gì so với Claude Code?"
date: 2026-06-09
tags: ["vibe-coding", "cowork", "claude-code", "agentic-engineering", "workflow"]
summary: "Vibe coding không chỉ dành cho developer — Cowork biến nó thành công cụ cho knowledge worker, nhưng cách 'vibe' khác hoàn toàn so với Claude Code."
---

## Bài học hôm nay

Tháng 2/2025, Andrej Karpathy tweet một câu làm nổ tung cộng đồng dev: *"fully give in to the vibes, embrace exponentials, and forget that the code even exists."* Ông gọi đó là **vibe coding** — viết phần mềm bằng cách nói chuyện với AI, không cần đọc code.

Một năm sau, chính Karpathy nói vibe coding đã *passé*. Thuật ngữ mới: **agentic engineering** — bạn không viết code, bạn điều phối agent viết code, và bạn đóng vai oversight. Câu hỏi tôi tự hỏi hôm nay: nếu cả Cowork lẫn Claude Code đều là agent, thì "vibe" ở mỗi tool khác nhau chỗ nào?

## Hai loại vibe, hai loại người dùng

Cùng là "nói để agent làm", nhưng Cowork và Claude Code phục vụ hai mental model hoàn toàn khác:

| | **Cowork** | **Claude Code** |
|---|---|---|
| **Ai dùng** | Knowledge worker: BA, PO, marketer, ops | Developer, engineer |
| **Chạy ở đâu** | Desktop app, sandbox Linux VM | Terminal, bare metal, full filesystem |
| **Vibe coding kiểu gì** | "Tạo cho tôi slide deck từ data này" | "Refactor module auth, giữ backward compat" |
| **Bạn thấy code không** | Không, và không cần | Có, và nên review diff |
| **Risk profile** | Thấp — sandbox cách ly | Cao hơn — chạy trực tiếp trên máy |
| **Setup time** | Mở app, chạy luôn | Cần terminal, config, CLAUDE.md |

Nói cách khác: **Cowork là vibe coding cho người không code. Claude Code là agentic engineering cho người code.**

## Vibe coding trong Cowork trông như thế nào?

Khi tôi dùng Cowork để "vibe code", flow thường là:

1. **Mô tả outcome**: "Tạo báo cáo Excel so sánh 3 cloud provider, có chart"
2. **Agent tự plan**: search web → fetch data → gọi xlsx skill → tạo file
3. **Tôi review output**: mở file, check data, done

Tôi không viết một dòng code nào. Tôi thậm chí không biết agent dùng openpyxl hay thư viện gì. Đây đúng nghĩa là "forget that the code even exists" — nhưng khác với Karpathy, tôi không phải developer đang bỏ qua code. Tôi là người dùng đang giải quyết công việc.

Với Claude Code thì khác. Developer nói "implement feature X", agent viết code, nhưng developer **phải đọc diff**, phải hiểu architecture, phải biết khi nào agent hallucinate một API không tồn tại. Đó không còn là vibe — đó là engineering có AI hỗ trợ.

## Khi nào "vibe" trong Cowork thành vấn đề

Vibe coding nghe sướng, nhưng tôi đã gặp fail:

**Lần 1**: Tôi bảo "tạo slide deck về Q1 results" mà không nói audience là ai, tone gì, data ở đâu. Agent tạo ra 12 slide generic, toàn buzzword. Vibe quá — thiếu constraint.

**Lần 2**: Tôi bảo "merge 3 file PDF này" — ngon. Nhưng rồi tôi bảo "sửa nội dung trang 5" — agent không thể edit PDF text in-place kiểu Acrobat. Vibe coding không có nghĩa là magic coding.

**Bài học**: Vibe coding hoạt động tốt nhất khi bạn **vibe về outcome nhưng specific về constraint**. Không phải "làm cái gì đó hay ho" mà là "tạo file X, format Y, data từ Z, audience là W."

## Từ vibe coding đến agentic engineering — spectrum, không phải binary

Karpathy nói 80% code của ông giờ do AI viết. Nhưng ông không "vibe" — ông orchestrate. Tôi nghĩ Cowork và Claude Code nằm trên cùng một spectrum:

**Pure vibe** ← Cowork (knowledge worker) — Claude Code (developer) → **Pure engineering**

Ở đầu Cowork, bạn gần pure vibe nhất: mô tả outcome, nhận result, không cần biết implementation. Ở đầu Claude Code, bạn gần engineering nhất: review code, set constraint, hiểu system.

Và cả hai đều hợp lệ. Không phải mọi task đều cần bạn đọc code. Không phải mọi task đều nên "give in to the vibes."

## Điều tôi hiểu nhầm

Tôi từng nghĩ vibe coding = lười. Kiểu "không chịu học code nên nhờ AI." Sai. Vibe coding trong Cowork là **đúng tool cho đúng người**. Một BA không cần học Python để tạo report. Một marketer không cần biết pptx library để làm slide.

Ngược lại, tôi cũng từng nghĩ Claude Code = "vibe coding cho pro." Cũng sai. Claude Code yêu cầu bạn hiểu code, review output, maintain system. Nó là agentic engineering, không phải vibe.

## Takeaway

Vibe coding với Cowork là cách hợp lệ và hiệu quả để knowledge worker tận dụng AI — miễn bạn specific về constraint thay vì chỉ specific về vibe. Còn nếu bạn là developer, hãy dùng Claude Code và embrace agentic engineering: để AI viết, nhưng bạn phải hiểu và review.

Bài tiếp theo: **Cowork + KMP** — generate boilerplate, docs, test tự động cho Kotlin Multiplatform project.
