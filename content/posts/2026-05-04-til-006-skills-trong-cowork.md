---
title: "TIL #006 — Skills trong Cowork là gì và tại sao chúng tồn tại"
date: 2026-05-04
tags: ["cowork", "skills", "automation", "workflow", "productivity"]
summary: "Skills là cách bạn dạy agent làm việc theo đúng ý bạn — không phải mỗi lần phải giải thích lại từ đầu."
---

## Bài học hôm nay

Năm bài trước, mỗi lần tôi muốn agent tạo file Word hay viết blog post, tôi phải giải thích: format thế nào, tone ra sao, lưu ở đâu, dùng font gì. Lần nào cũng vậy. Hôm nay tôi bước vào Phase 2 và câu hỏi đầu tiên là: **có cách nào để agent "nhớ" cách làm việc mà không cần tôi lặp lại mỗi lần không?**

Câu trả lời là **Skills** — và nó thay đổi cách tôi nghĩ về Cowork hoàn toàn.

---

## Skill là gì, nói đơn giản

Skill là một bộ instruction được viết sẵn, đóng gói trong một file (thường là `SKILL.md`), mà agent sẽ tự đọc và tuân theo khi gặp task phù hợp. Nghĩ như thế này: nếu prompt là câu bạn nói với agent, thì skill là **cuốn sổ tay** mà agent giở ra đọc trước khi bắt tay làm việc.

Ví dụ: Cowork có sẵn skill `docx` — chuyên tạo Word document. Khi bạn nói "tạo cho tôi một báo cáo Word", agent không cần bạn giải thích cách dùng python-docx hay format heading — nó tự đọc skill `docx`, trong đó đã có best practices về cách tạo file `.docx` chuyên nghiệp: margins, fonts, table of contents, page numbers, mọi thứ.

### Hai loại skill

| Loại | Giải thích | Ví dụ |
|------|-----------|-------|
| **Built-in skills** | Anthropic viết sẵn, cài sẵn trong Cowork | `docx`, `pptx`, `xlsx`, `pdf`, `canvas-design` |
| **Custom skills** | Bạn (hoặc team) tự tạo | Skill viết email theo brand voice công ty, skill tạo báo cáo theo template riêng |

Built-in skills xử lý những việc phổ biến: tạo slide, tạo spreadsheet, xử lý PDF. Custom skills là nơi mọi thứ trở nên thú vị — bạn dạy agent cách làm việc **theo cách của bạn**.

---

## Cách skill hoạt động bên trong

Đây là phần khiến tôi bất ngờ: skill không phải plugin hay extension nặng nề. Về bản chất, nó chỉ là **một file markdown chứa instruction chi tiết**. Khi Cowork bắt đầu một task, nó làm thế này:

1. **Đọc lướt header** của tất cả skill đã cài — chỉ tên và mô tả ngắn, rất nhẹ
2. **Quyết định skill nào liên quan** dựa trên task bạn yêu cầu
3. **Load toàn bộ instruction** của skill được chọn vào context
4. **Làm theo instruction** đó để hoàn thành task

Điều hay: nếu bạn cài 30 skills, agent không load hết 30 cái vào bộ nhớ. Nó chỉ load cái nào cần. Context window không bị "phình" vô nghĩa — đây là thiết kế có chủ đích.

Bạn có thể gọi skill bằng hai cách: gõ `/tên-skill` trong chat (ví dụ `/docx`), hoặc cứ mô tả task bình thường — agent tự nhận ra skill nào phù hợp và gọi nó. Cách thứ hai thuận tiện hơn nhưng đôi khi agent chọn sai skill, nên nếu cần chính xác thì gõ `/` cho chắc.

---

## Tại sao skills tồn tại (chứ không chỉ dùng prompt dài)?

Câu hỏi này tôi tự hỏi trước khi tìm hiểu. Tại sao không copy-paste một đoạn instruction dài vào mỗi conversation?

**Lý do 1: Tái sử dụng.** Viết instruction một lần, dùng mãi. Không cần nhớ và paste lại mỗi lần. Scheduled task (bài #005) cũng dùng skill — mỗi sáng agent chạy, nó tự đọc skill mà không cần ai nhắc.

**Lý do 2: Chất lượng output cao hơn.** Anthropic công bố rằng task dùng skill giảm từ 15 tin nhắn qua lại xuống còn 2, từ 12,000 tokens xuống 6,000. Agent không phải đoán bạn muốn gì — nó đã có sổ tay.

**Lý do 3: Chia sẻ được.** Trên plan Team hoặc Enterprise, bạn tạo skill rồi share cho cả team. Mọi người trong team gọi agent, agent làm theo cùng một tiêu chuẩn. Không còn chuyện mỗi người nhận output khác nhau vì prompt khác nhau.

**Lý do 4: Composable.** Một task có thể kích hoạt nhiều skill cùng lúc. Ví dụ bạn nói "tạo báo cáo Word từ data trong file Excel" — agent có thể dùng cả skill `xlsx` (để đọc data) và skill `docx` (để tạo Word). Skills hoạt động như LEGO blocks.

---

## Điều tôi hiểu nhầm

**Nhầm #1: Nghĩ skill là code phức tạp.** Tôi tưởng phải viết Python hay JavaScript gì đó. Thực tế, skill đơn giản nhất chỉ là một file `.md` viết bằng ngôn ngữ tự nhiên. Không cần biết code. Bạn viết "Khi tạo email, luôn dùng tone chuyên nghiệp, ký tên là [tên công ty], không dùng emoji" — đó đã là một skill rồi.

**Nhầm #2: Nghĩ agent tự biết tất cả format file.** Trước khi biết về skills, tôi nghĩ agent "tự biết" cách tạo PowerPoint đẹp. Sự thật: nếu không có skill `pptx`, agent vẫn tạo được file `.pptx` nhưng output sẽ generic hơn nhiều. Skill là nơi chứa best practices đã được Anthropic (hoặc bạn) đúc kết qua nhiều lần thử sai.

**Nhầm #3: Nghĩ phải gọi skill bằng tay mỗi lần.** Agent tự detect và tự gọi. Bạn nói "tạo slide deck cho buổi standup" — agent tự biết cần đọc skill `pptx`. Tất nhiên, đôi khi nó detect sai, nhưng hầu hết thời gian nó đúng.

---

## Takeaway

Skills biến Cowork từ "agent trả lời generic" thành "agent làm việc theo tiêu chuẩn của bạn". Nó chỉ là file markdown chứa instruction, nhưng hiệu quả thì lớn: output chất lượng hơn, ít qua lại hơn, và cả team dùng chung một chuẩn. Nếu bạn thấy mình lặp lại cùng một instruction quá 3 lần — đó là lúc biến nó thành skill.

Ngày mai: docx skill — tạo Word document chuyên nghiệp bằng 1 câu lệnh. Bài #007 sẽ là lần đầu tôi thực sự dùng một built-in skill để tạo file, và tôi sẽ kể cả chỗ output đẹp lẫn chỗ phải sửa tay.
