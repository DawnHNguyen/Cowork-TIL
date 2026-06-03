---
title: "TIL #028 — Mental Models: 5 cách nghĩ về Cowork giúp tôi dùng hiệu quả hơn"
date: 2026-06-03
tags: ["mental-model", "productivity", "cowork", "workflow", "reflection"]
summary: "Sau 27 bài TIL, tôi đúc kết 5 mental models giúp chuyển từ 'dùng thử cho vui' sang 'dùng thật có output'."
---

## Bài học hôm nay

27 bài viết, hàng chục lần thử-và-sai, vài lần muốn đập bàn phím — và cuối cùng thứ thay đổi cách tôi dùng Cowork không phải một feature cụ thể, mà là cách tôi *nghĩ* về nó.

Tool thì ai cũng có. Mental model mới là thứ quyết định bạn dùng nó như cái búa đóng đinh hay như cái búa đập màn hình. Hôm nay tôi chia sẻ 5 cách nghĩ đã giúp workflow của tôi đi từ "mở Cowork → gõ lung tung → đóng" sang "mở Cowork → xong việc → đi uống cà phê".

## 5 Mental Models

### 1. "Intern thông minh" — Không phải thần, không phải nô lệ

Cách nghĩ sai phổ biến nhất: hoặc kỳ vọng Cowork biết mọi thứ (rồi thất vọng), hoặc coi nó là tool chạy lệnh rồi micromanage từng bước.

Cách nghĩ đúng hơn: **Cowork giống intern năm cuối cực kỳ thông minh**. Nó đọc nhanh, viết tốt, biết nhiều pattern — nhưng không biết context cụ thể của bạn trừ khi bạn nói. Và nó cần bạn review output trước khi ship.

Hệ quả thực tế:
- Giao task kèm context ("file này dùng cho khách hàng fintech, tone formal") thay vì "viết cho tôi cái report"
- Review output như review PR của intern: không cần viết lại, nhưng cần đọc qua
- Khen khi output tốt... à không, khen thì nó không hiểu. Nhưng bạn sẽ vui hơn.

### 2. "Stateless colleague" — Mỗi session là ngày đầu đi làm

Đây là bài học tôi đã viết ở TIL #002, nhưng phải mất 25 bài nữa mới *thực sự* internalize. Cowork không nhớ gì giữa các session. Mỗi lần mở conversation mới, nó như đồng nghiệp bước vào phòng mà không biết hôm qua team bàn gì.

Hệ quả thực tế:
- Đừng expect nó nhớ project structure từ hôm qua. Cho nó đọc lại file, hoặc dùng Global Instructions để inject context tự động.
- Mỗi session mới = fresh start. Đây không phải bug, đây là **feature** — vì nó cũng không kéo theo bias hay lỗi từ session trước.
- Start new session khi topic đổi, khi output bắt đầu giảm chất lượng, hoặc khi context window quá dài.

### 3. "Outcome, không phải steps" — Nói cái bạn muốn, không phải cách làm

Sai lầm thời đầu: tôi viết prompt kiểu step-by-step recipe. "Bước 1: mở file X. Bước 2: tìm dòng Y. Bước 3: sửa thành Z." Kết quả? Agent follow đúng bước nhưng ra output sai, vì premise sai mà nó không biết push back.

Cách đúng: **mô tả outcome mong muốn + constraint**, để agent tự tìm đường.

| ❌ Step-by-step | ✅ Outcome-based |
|---|---|
| "Mở file report.md, thêm section mới ở cuối, viết 3 bullet points về X" | "Cập nhật report.md: thêm phần tóm tắt về X, tone phù hợp với phần còn lại của doc" |
| "Search Google cho Y, lấy link đầu tiên, fetch nó, tóm tắt" | "Tìm thông tin mới nhất về Y, ưu tiên source chính thức" |

Agent có nhiều tool và biết khi nào dùng cái nào — miễn là bạn nói rõ đích đến.

### 4. "Chat để nghĩ, Cowork để làm" — Tách thinking khỏi execution

Mental model này tôi học từ community: dùng chat thường (Claude.ai) khi cần brainstorm, phân tích, hỏi ý kiến. Chuyển sang Cowork khi đã biết mình muốn gì và cần agent **thực thi**: tạo file, fetch data, chạy script, cross-reference nhiều source.

Nếu bạn mở Cowork rồi nói "giúp tôi nghĩ xem nên làm gì với project này" — nó vẫn trả lời được, nhưng bạn đang dùng dao mổ trâu để gọt bút chì. Cowork shine nhất khi có task cụ thể cần hành động.

### 5. "Orchestrator + Specialists" — Bạn là PM, không phải IC

Khi task phức tạp, đừng cố nhét mọi thứ vào một prompt dài 500 từ. Hãy nghĩ mình là PM:
- Chia task thành phần nhỏ
- Giao từng phần cho Cowork (hoặc cho sub-agents nếu dùng Claude Code)
- Review và integrate output

Ví dụ thực tế: thay vì "viết cho tôi competitive analysis 5 trang về X, Y, Z" — tôi sẽ:
1. Session 1: "Research X — key metrics, recent news, market position"
2. Session 2: "Research Y — tương tự"
3. Session 3: "So sánh X vs Y vs Z dựa trên data từ 2 file này, output dạng docx"

Mỗi session ngắn gọn, focused, dễ review. Output cuối cùng tốt hơn nhiều so với one-shot.

## Điều tôi hiểu nhầm

Tôi từng nghĩ "dùng Cowork hiệu quả" = biết nhiều feature. Thực tế, người dùng giỏi nhất mà tôi thấy trong community chỉ dùng 3-4 tính năng — nhưng họ có mental model đúng. Họ biết khi nào delegate, khi nào tự làm, và biết structure task sao cho agent có đủ context để deliver.

Ngược lại, tôi đã thử dùng mọi connector, mọi skill, chain mọi thứ lại — và output thì... meh. Vì tôi quá focused vào "dùng tool" mà quên mất "giải quyết vấn đề".

## Takeaway

Mental model > feature knowledge. Nếu bạn chỉ nhớ một thứ: **Cowork là stateless intern cần outcome rõ ràng, không phải step-by-step recipe.** Cho nó context, nói rõ bạn muốn gì, rồi review output — bạn sẽ ngạc nhiên với kết quả.

---

*Bài tiếp theo: TIL #029 — Cowork trong team: khi nhiều người dùng cùng 1 agent. Khi tool không chỉ phục vụ một người mà phục vụ cả team, mọi thứ thay đổi.*
