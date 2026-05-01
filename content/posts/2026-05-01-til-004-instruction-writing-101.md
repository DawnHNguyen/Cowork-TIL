---
title: "TIL #004 — Cách 'giao việc' đúng cho agent: instruction writing 101"
date: 2026-05-01
tags: ["cowork", "prompt-engineering", "instructions", "workflow", "context-engineering"]
summary: "Agent không đọc được ý bạn — nó đọc instruction. Viết instruction tốt không phải về câu từ hoa mỹ, mà là cung cấp đủ context để agent tự ra quyết định đúng."
---

## Bài học hôm nay

Ba bài trước tôi học cách Cowork hoạt động — session, file, workspace. Hôm nay mới là bài quan trọng nhất: **cách nói chuyện với agent sao cho nó làm đúng việc bạn muốn**.

Nghe đơn giản, nhưng tôi đã tốn cả buổi chiều để hiểu tại sao cùng một yêu cầu, lúc thì agent trả kết quả tuyệt vời, lúc thì ra thứ hoàn toàn lệch hướng. Kết luận: vấn đề không nằm ở agent — nằm ở cách tôi viết instruction.

---

## Context > Câu từ

Năm 2026, cộng đồng AI đã bắt đầu dùng cụm từ "context engineering" thay cho "prompt engineering". Ý tưởng cốt lõi: **thứ bạn cung cấp cho agent trước khi nó làm việc quan trọng hơn cách bạn diễn đạt yêu cầu**.

Hồi mới dùng, tôi hay viết kiểu:

> "Viết cho tôi một báo cáo hay về doanh thu Q1."

Agent viết ra một bài generic, đúng ngữ pháp, nhưng vô hồn. Không sai — nhưng cũng không đúng. Vì tôi không cho nó biết: báo cáo cho ai đọc? Format nào? Dữ liệu ở đâu? "Hay" nghĩa là gì?

Sau nhiều lần thử, tôi đúc kết ra một công thức đơn giản:

**Instruction tốt = Outcome + Context + Constraints**

- **Outcome**: bạn muốn nhận được cái gì ở cuối (file Word? bảng tóm tắt? email draft?)
- **Context**: thông tin nền mà agent cần (dữ liệu ở folder nào, ai sẽ đọc, bối cảnh dự án)
- **Constraints**: giới hạn cụ thể (độ dài, ngôn ngữ, format, những gì KHÔNG nên làm)

Ví dụ viết lại:

> "Đọc file `revenue-q1.xlsx` trong workspace, tạo một báo cáo Word dài tối đa 2 trang. Người đọc là sếp bộ phận, không phải dân kỹ thuật. Tập trung vào 3 insight chính và 1 recommendation. Không dùng biểu đồ."

Cùng một agent, nhưng instruction thứ hai cho ra kết quả khác hoàn toàn.

---

## 5 nguyên tắc tôi rút ra

**1. Nói outcome trước, không nói step-by-step**

Thay vì "mở file X, đọc cột B, tính trung bình, rồi ghi vào file Y", hãy nói "Tính trung bình cột B từ file X và ghi kết quả vào file Y". Agent biết cách tự chọn tool — bạn chỉ cần nói đích đến.

Tuy nhiên, với workflow phức tạp nhiều bước (ví dụ: scheduled task), step-by-step lại cần thiết. Quy tắc: **task đơn → outcome. Task phức tạp → outcome + steps**.

**2. Cho ví dụ thay vì giải thích dài dòng**

Tôi muốn agent format bảng theo kiểu nhất định? Thay vì mô tả "cột đầu tiên là tên, cột thứ hai là số, căn phải", tôi paste thẳng một bảng mẫu. Agent hiểu ví dụ nhanh hơn mô tả — cái này gọi là "few-shot prompting" và nó hiệu quả kinh khủng.

**3. Nói rõ persona người đọc**

"Viết email cho khách hàng" khác xa "viết email cho dev trong team". Khi agent biết ai sẽ đọc, nó tự điều chỉnh ngôn ngữ, độ chi tiết, và tone. Đừng bắt agent đoán.

**4. Đặt constraint rõ ràng — nhưng bình tĩnh**

Agent mới (Claude 4.x) rất tuân thủ instruction. Bạn nói "tối đa 500 từ" thì nó giữ đúng 500 từ. Nhưng đừng viết "BẮT BUỘC PHẢI!!!" hay "CRITICAL: NEVER EVER" — giọng hoảng loạn không giúp agent hiểu hơn, chỉ làm rối prompt. Cứ viết bình thường, rõ ràng, là đủ.

**5. Dùng XML tags để tách phần**

Nếu instruction dài, hãy chia thành block bằng XML tags:

```xml
<context>
Dự án: blog TIL về Cowork
Repo: /Users/ban/VSCProject/Cowork-TIL
</context>

<task>
Viết bài TIL #004 về instruction writing.
Ngôn ngữ: Tiếng Việt. Độ dài: 400-800 từ.
</task>

<constraints>
- Không dùng tên thật
- Kết bài bằng preview bài tiếp theo
</constraints>
```

Claude parse XML tags cực tốt. Nó tách rõ đâu là context, đâu là việc cần làm, đâu là giới hạn — thay vì phải tự suy luận từ một đoạn text dài.

---

## Điều tôi hiểu nhầm

**Nhầm #1: "Prompt hay = câu từ hay"**

Tôi từng nghĩ phải viết instruction thật "đẹp", chọn từ cẩn thận, như viết brief cho agency. Không. Agent cần thông tin rõ ràng, không cần văn phong. "Tạo file Word, 2 trang, có executive summary" hiệu quả hơn "Hãy chuẩn bị một tài liệu chuyên nghiệp, trình bày đẹp mắt, phù hợp với tiêu chuẩn doanh nghiệp".

**Nhầm #2: "Agent sẽ tự hỏi lại nếu thiếu thông tin"**

Trong Cowork, agent **có** tool AskUserQuestion để hỏi lại. Nhưng trong scheduled task (chạy tự động, không ai online), nó không hỏi được — nó sẽ tự đoán. Và khi agent đoán, 50/50 là nó đoán sai. Bài học: viết instruction cho scheduled task phải cụ thể gấp đôi instruction thường.

**Nhầm #3: "Càng chi tiết càng tốt"**

Có lần tôi viết instruction dài 2 trang, liệt kê mọi edge case. Agent bị overload, quên mất yêu cầu chính, và tập trung vào edge case cuối cùng (recency bias). Instruction tốt là **vừa đủ** — đủ context để agent không đoán, nhưng không nhiều đến mức nó quên đâu là ưu tiên.

---

## Takeaway

Instruction writing là kỹ năng quan trọng nhất khi dùng Cowork. Không phải vì agent dốt — mà vì agent rất giỏi *làm đúng thứ bạn yêu cầu*. Vấn đề là bạn có yêu cầu đúng thứ bạn cần hay không.

Công thức: **Outcome + Context + Constraints**. Bắt đầu từ đó, thêm ví dụ nếu cần, dùng XML tags nếu dài. Đừng hoảng loạn trong prompt.

Ngày mai: Scheduled Tasks — cách để agent tự chạy việc mỗi ngày mà không cần bạn ngồi canh. Bài #005 sẽ giải thích cơ chế, limitations, và tại sao Mac phải awake.
