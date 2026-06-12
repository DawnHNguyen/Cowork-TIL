---
title: "TIL #034 — Building a second brain với Cowork + Notion"
date: 2026-06-12
tags: ["cowork", "notion", "second-brain", "mcp", "connector", "automation", "productivity"]
summary: "Notion connector trong Cowork biến Notion thành bộ nhớ dài hạn cho agent — nhưng 'second brain' thật sự không phải cắm connector vào rồi xong, mà cần thiết kế database đúng cách để agent đọc/ghi hiệu quả."
---

## Bài học hôm nay

"Building a Second Brain" — khái niệm của Tiago Forte từ 2017 — nói về việc xây hệ thống lưu trữ kiến thức bên ngoài đầu, để bạn không phải nhớ mọi thứ. Ý tưởng gốc dùng PARA (Projects, Areas, Resources, Archives) để tổ chức note. Nhưng đến 2026, câu chuyện khác hẳn: **agent có thể đọc, ghi, và tổng hợp knowledge base thay bạn**.

Hôm nay tôi thử kết nối Cowork với Notion để biến Notion workspace thành "second brain" — nơi agent tự ghi chép, tra cứu, và tổng hợp kiến thức. Kết quả: hoạt động tốt hơn tôi nghĩ, nhưng phải setup đúng cách thì mới có giá trị thật.

## Notion connector hoạt động thế nào

Notion connector trong Cowork dùng MCP (Model Context Protocol) — giao thức cho phép agent giao tiếp với service bên ngoài. Khi bạn kết nối Notion lần đầu, Cowork xin quyền truy cập qua OAuth. Sau đó agent có thể:

| Khả năng | Ví dụ |
|---|---|
| **Search pages** | Tìm tất cả page chứa từ "KMP" trong workspace |
| **Read page content** | Đọc nội dung meeting note hôm qua |
| **Create pages** | Tạo page mới trong database "TIL Notes" |
| **Update properties** | Đổi status task từ "In Progress" sang "Done" |
| **Create databases** | Tạo database mới với custom schema |

Connector chỉ cần authorize 1 lần, active xuyên suốt các session. Agent chỉ thấy những gì bạn có quyền truy cập — nó không bypass Notion permissions.

## Thiết kế database cho agent-friendly

Đây là phần quan trọng nhất mà ít ai nói. Notion database bình thường — designed cho con người dùng — thường **không tối ưu cho agent đọc**. Tôi thử 2 cách:

**Cách 1 (fail):** Dùng Notion workspace có sẵn, đầy page lộn xộn, tag không nhất quán, có page tiếng Việt lẫn tiếng Anh, property name kiểu "Trạng thái" lẫn "Status". Agent search được nhưng kết quả nhiễu — phải filter thủ công trong prompt.

**Cách 2 (hiệu quả hơn):** Tạo một database riêng, schema cố định, property name bằng tiếng Anh, dùng select/multi-select thay vì free text:

```
Database: "Knowledge Base"
Properties:
  - Title (title)
  - Topic (select): cowork, kmp, android, general
  - Type (select): til, concept, debug-log, reference
  - Status (select): draft, reviewed, archived
  - Source (url)
  - Summary (rich_text)
  - Date Added (date)
```

Lý do property name nên bằng tiếng Anh: khi bạn prompt agent "tìm tất cả entry có Topic là cowork", agent map thẳng vào property name. Tiếng Anh giảm ambiguity, nhất là khi agent cần filter hoặc sort.

## Workflow: daily knowledge capture

Đây là chỗ Cowork + Notion tỏa sáng khi kết hợp với **scheduled tasks**. Tôi setup workflow thế này:

**Bước 1 — Capture thủ công trong ngày:** Mỗi khi đọc được gì hay, tôi tạo quick note trong Notion database với title và URL. Không cần format, không cần summary — chỉ cần raw capture.

**Bước 2 — Scheduled task chạy cuối ngày:** Cowork scheduled task chạy lúc 6 PM, với prompt:

> "Đọc tất cả entry trong Notion database 'Knowledge Base' có Status là 'draft'. Với mỗi entry: đọc source URL, viết summary 2-3 câu, gợi ý 1-2 tag cho Topic field. Update entry với summary và đổi Status sang 'reviewed'."

Agent sẽ dùng Notion connector để search draft entries, dùng web fetch để đọc source URL, rồi ghi ngược summary và tags vào Notion. Mỗi lần chạy mất khoảng 2-3 phút cho ~5 entries.

**Bước 3 — Weekly review:** Cuối tuần, chạy một task khác:

> "Đọc tất cả entry 'reviewed' trong tuần này từ Knowledge Base. Tổng hợp thành một weekly digest: nhóm theo Topic, highlight 3 insight quan trọng nhất, ghi chú connection giữa các topic nếu có. Tạo page mới trong database 'Weekly Digests'."

Kết quả: Notion không còn là graveyard of bookmarks mà trở thành knowledge base có curation tự động.

## Fail Wall

**Fail 1: Notion connector không fetch URL bên ngoài.**

Tôi nhầm tưởng connector có thể đọc link trong page rồi tự fetch nội dung. Không — connector chỉ đọc/ghi Notion. Muốn agent đọc source URL, phải kết hợp web search/web fetch tool riêng. Scheduled task thì có cả hai, nên workflow trên hoạt động — nhưng nếu bạn chạy manual trong session, phải prompt rõ "đọc URL bằng web fetch, rồi ghi vào Notion."

**Fail 2: Agent tạo duplicate entries.**

Lần đầu chạy scheduled task, agent tạo page mới thay vì update page cũ. Lý do: prompt của tôi không nói rõ "update existing entry" mà chỉ nói "viết summary." Agent hiểu là tạo page mới chứa summary. Fix: prompt phải explicit — "update property Summary của entry đó, KHÔNG tạo page mới."

**Fail 3: Overfit vào PARA.**

Ban đầu tôi cố áp dụng PARA framework y nguyên: Projects, Areas, Resources, Archives — mỗi cái một database. Quá phức tạp cho agent navigate. Agent phải search 4 databases, context window bị chiếm bởi metadata thay vì content. Cuối cùng tôi gộp thành 1 database "Knowledge Base" + 1 database "Weekly Digests". Đơn giản hơn = agent hiệu quả hơn.

## Takeaway

Second brain với Cowork + Notion không phải "cắm connector xong là magic." Bạn cần thiết kế database schema cho agent đọc dễ (property name nhất quán, dùng select thay free text), và viết scheduled task prompt rõ ràng phân biệt giữa create vs update. Khi setup đúng, agent trở thành librarian tự động: capture → summarize → organize → synthesize — vòng lặp mà con người thường bỏ cuộc sau tuần đầu tiên.

Đây là bài cuối trong curriculum 34 bài. Nếu bạn đã theo dõi từ bài #001 — cảm ơn bạn. Hành trình từ "Cowork là gì?" đến "second brain tự động" không dài, nhưng đủ để thay đổi cách tôi nghĩ về việc delegate cho AI.
