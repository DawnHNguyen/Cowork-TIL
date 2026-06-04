---
title: "TIL #028 — Mental Models: 5 cách nghĩ về Cowork giúp tôi dùng hiệu quả hơn"
date: 2026-06-04
tags: ["cowork", "mental-models", "delegation", "context-engineering", "productivity"]
summary: "Sau 27 bài TIL, tôi đúc kết 5 mental model giúp chuyển từ 'chat với AI' sang 'giao việc cho đồng nghiệp' — và output khác biệt rõ rệt."
---

## Bài học hôm nay

Hôm trước tôi gom hết fail lại thành Fail Wall tổng hợp. Hôm nay là bước tiếp theo: từ fail cụ thể, rút ra **framework tư duy tổng quát** — hay nói cách khác, mental models.

Mental model không phải lý thuyết suông. Nó là cách bạn *nghĩ* về một thứ trước khi bắt tay vào dùng. Và sau 27 bài viết cùng hàng trăm lần chạy agent, tôi nhận ra: **người dùng Cowork hiệu quả không giỏi prompt hơn — họ nghĩ về Cowork khác.**

## 5 Mental Models

### 1. "Đồng nghiệp mới, không phải chatbot"

Đây là mental model quan trọng nhất, và cũng là cái tôi mất lâu nhất để thấm.

ChatGPT dạy chúng ta một thói quen: gõ câu hỏi, nhận câu trả lời, copy-paste. Cowork không hoạt động như vậy. Cowork là **delegation, không phải conversation.** Bạn giao việc, agent mở file, làm việc, ghi kết quả vào folder của bạn.

Cách nghĩ đúng: tưởng tượng bạn có một đồng nghiệp mới — thông minh, chăm chỉ, nhưng chưa biết gì về project của bạn. Bạn sẽ không nói "làm đẹp cái này đi" mà sẽ nói "đây là file, đây là format mong muốn, đây là output path." Cụ thể, có boundary, có deliverable rõ ràng.

Sai: *"Tạo report đẹp về Q2."*
Đúng: *"Đọc file data-q2.csv, tạo báo cáo Word với 3 phần: tổng quan, phân tích theo khu vực, và đề xuất. Lưu vào folder Reports."*

### 2. "Context là tài nguyên, không phải miễn phí"

Anthropic gọi cái này là **context engineering** — và nó đang thay thế "prompt engineering" trong cách người ta nghĩ về việc dùng AI agent.

Context window của agent giống RAM máy tính: có giới hạn. Mỗi file bạn đưa vào, mỗi instruction dài dòng, mỗi output cũ còn lưu — đều chiếm chỗ. Khi hết chỗ, agent bắt đầu "quên" phần sớm nhất, và output bắt đầu drift.

Áp dụng thực tế:

| Thay vì | Hãy |
|---|---|
| Nhồi 5 file vào 1 session | Chia thành 2-3 session nhỏ |
| Viết prompt 500 từ | Viết 100 từ rõ ràng, đưa chi tiết vào file |
| Để agent xử lý 8 bước liên tục | Tách thành 3-4 task, mỗi task có output cụ thể |

Tôi học được điều này từ bài #004 (cách giao việc) nhưng phải fail thêm 10 lần nữa mới thực sự áp dụng.

### 3. "Research trước, output sau"

Đây là pattern tôi phát hiện rõ nhất khi dùng file skills (docx, pptx, xlsx). Agent tạo file rất giỏi — nhưng **chất lượng nội dung phụ thuộc hoàn toàn vào data đầu vào.**

Nếu bạn bảo "tạo slide deck về AI trends" mà không cho source, agent sẽ viết generic fluff. Nhưng nếu bạn bảo "search 5 bài mới nhất về AI trends, tóm tắt key findings, rồi tạo deck từ data đó" — kết quả khác một trời một vực.

Mental model: Cowork giống một nhân viên viết report cực nhanh, nhưng cần bạn chỉ cho nguồn dữ liệu trước. **Không có input tốt thì không có output tốt**, dù agent giỏi đến mấy. Garbage in, garbage out — quy tắc này vẫn đúng từ thời mainframe đến thời agent.

### 4. "File system là bộ nhớ dài hạn"

Cowork session là ephemeral — mỗi session bắt đầu lại từ đầu, agent không nhớ gì từ lần trước. Nhưng **file thì persistent.** Workspace folder của bạn tồn tại xuyên suốt mọi session.

Nghĩa là: nếu bạn muốn agent "nhớ" cách làm việc của bạn, hãy viết vào file. Global Instructions, CLAUDE.md, voice profile, template — đây không phải nice-to-have, đây là **bộ nhớ dài hạn thực sự** của hệ thống.

Tôi bắt đầu tạo một file `context.md` trong mỗi project folder, ghi rõ: project này làm gì, convention đang dùng, và output format mong muốn. Mỗi session mới, agent đọc file đó trước — và ngay lập tức hoạt động như thể nó đã biết project từ lâu.

Cái hay: bạn đang build persistent context bằng cách viết docs rõ ràng. Kỹ năng này hữu ích cho cả con người trong team, không chỉ agent.

### 5. "Skill là workflow đóng gói, không phải magic"

Ban đầu tôi nghĩ Skills trong Cowork là một loại "plugin thần kỳ." Dùng rồi mới hiểu: **Skill chỉ là một file SKILL.md chứa instructions chi tiết** mà agent đọc trước khi thực thi.

Nghĩa là: nếu bạn có một workflow lặp đi lặp lại (tạo report tuần, format email outreach, review document theo checklist), bạn hoàn toàn có thể đóng gói nó thành Skill. Không cần code, không cần API — chỉ cần viết instructions tốt.

Mental model đúng: Skill giống Standard Operating Procedure (SOP) cho agent. Viết SOP rõ → agent follow đúng → output consistent mỗi lần. Cũng giống hệt việc bạn viết SOP cho team member mới.

## Điều tôi hiểu nhầm

Tôi từng nghĩ mental model chỉ là buzzword, kiểu "hãy đổi mindset" nói cho có. Nhưng thực tế, mỗi lần output agent đi sai hướng, nguyên nhân gốc đều là tôi đang *nghĩ* sai về cách nó hoạt động. Khi sửa cách nghĩ (từ chatbot sang đồng nghiệp, từ prompt sang context, từ magic sang SOP), output cải thiện ngay — không cần thay đổi gì về mặt kỹ thuật.

## Takeaway

5 mental models này không mới hay phức tạp. Chúng đều quy về một nguyên tắc: **đối xử với agent như một team member thông minh nhưng mới vào — cần context rõ, task cụ thể, và tài liệu tốt.** Nếu bạn chỉ nhớ một thứ: viết prompt như bạn đang brief cho đồng nghiệp, không phải đang chat với bot.

Bài tiếp theo: **Cowork trong team — khi nhiều người dùng cùng 1 agent.** Từ cá nhân sang nhóm, mọi thứ phức tạp hơn đáng kể.
