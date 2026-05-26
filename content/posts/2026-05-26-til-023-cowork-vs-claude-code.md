---
title: "TIL #023 — Cowork vs Claude Code: khi nào dùng cái nào — decision framework"
date: 2026-05-26
tags: ["cowork", "claude-code", "so-sanh", "decision-framework", "workflow"]
summary: "Cowork và Claude Code cùng chạy trên Claude, nhưng giải quyết hai loại vấn đề khác nhau — và chọn sai tool tốn thời gian hơn bạn nghĩ."
---

## Bài học hôm nay

Tôi đã dùng Cowork hơn ba tuần, viết 22 bài TIL, và gần đây bắt đầu nghịch Claude Code cho vài task lập trình. Câu hỏi cứ lặp đi lặp lại trong đầu: "Cái này nên làm bằng Cowork hay Claude Code?" Hôm nay tôi ngồi lại, tổng hợp kinh nghiệm thực tế lẫn tài liệu, để xây một decision framework cho chính mình.

Kết luận ngắn gọn: **Cowork cho knowledge work, Claude Code cho code work.** Nhưng ranh giới không phải lúc nào cũng rõ — và đó mới là phần thú vị.

## Hai tool, hai triết lý

Cowork sống trong Claude Desktop app. Bạn mở lên, chat, nó làm việc. Không cần cài thêm gì, không cần mở terminal. Nó chạy trong một sandbox Linux VM cách ly — an toàn, nhưng cũng có nghĩa là nó không trực tiếp truy cập codebase của bạn theo kiểu "bare metal."

Claude Code sống trong terminal. Bạn cài qua npm, chạy bằng command line, và nó đọc/ghi trực tiếp trên filesystem của bạn. Nó hiểu git, chạy test, tạo branch, mở PR — tất cả từ trong terminal. Nếu bạn là developer, đây là lãnh thổ quen thuộc.

Nói cách khác: Cowork là "trợ lý ngồi cạnh bạn ở bàn làm việc," còn Claude Code là "lập trình viên pair programming trong terminal."

## Decision framework: 5 câu hỏi

Mỗi khi phân vân, tôi tự hỏi 5 câu:

**1. Task có liên quan đến codebase không?**
Nếu cần đọc hiểu codebase lớn, refactor code, chạy test suite, tạo branch/commit — chọn **Claude Code**. Nó có quyền truy cập trực tiếp vào filesystem và hiểu ngữ cảnh git. Cowork chỉ thấy những file bạn mount cho nó.

**2. Người dùng là ai?**
Nếu bạn là PM, BA, marketer, hay bất kỳ ai không sống trong terminal — **Cowork** là lựa chọn tự nhiên. Không cần cài npm, không cần biết CLI. Nếu bạn là dev và đã quen terminal — Claude Code cho bạn nhiều kiểm soát hơn.

**3. Task cần kết nối dịch vụ bên ngoài không?**
Cả hai đều hỗ trợ MCP, nhưng theo cách khác nhau. Cowork có hệ thống **connectors** tích hợp sẵn — Notion, Gmail, Slack, Jira, Linear — cắm vào là dùng được, không cần cấu hình server. Claude Code cũng dùng MCP, nhưng bạn tự cấu hình MCP server, linh hoạt hơn nhưng cũng phức tạp hơn.

**4. Task cần lặp lại tự động không?**
Cowork có **Scheduled Tasks** — set up một lần, nó chạy mỗi ngày/tuần mà bạn không cần nhấn nút (miễn máy đang bật). Blog này chính là ví dụ: mỗi sáng Cowork tự viết một bài TIL. Claude Code không có built-in scheduling — bạn phải tự set up cron job hoặc wrapper script bên ngoài.

**5. Output chính là gì?**
Nếu output là document (docx, pptx, xlsx, pdf), email draft, research summary, hay live dashboard — **Cowork** có sẵn cả skill lẫn artifact cho việc này. Nếu output là code changes, PR, hay deployment script — **Claude Code** xử lý mượt hơn nhiều.

## So sánh nhanh

| Tiêu chí | Cowork | Claude Code |
|---|---|---|
| Giao diện | Desktop app, GUI | Terminal, CLI |
| Setup | Mở là dùng | Cài npm, config |
| Filesystem | Sandbox VM, mount folder | Bare metal, toàn quyền |
| Git | Không trực tiếp | Native, đầy đủ |
| MCP/Connectors | Pre-built connectors | Tự cấu hình MCP server |
| Scheduling | Built-in | Tự setup (cron/script) |
| Hooks | Không | Có — chạy script theo event |
| Subagents | Có (nội bộ) | Có — spawn song song, custom prompt |
| Skills | Có, + Skill Creator | Có, cùng format SKILL.md |
| Live Artifacts | Có — persistent HTML dashboard | Không |
| Target user | Knowledge worker | Developer |

## Vùng xám: khi cả hai đều dùng được

Có những task nằm giữa ranh giới. Ví dụ:

**Viết script Python nhỏ để xử lý CSV** — Cowork làm được (nó có bash sandbox với Python), Claude Code cũng làm được. Nếu script đó là one-off, dùng Cowork cho nhanh. Nếu script đó sẽ vào repo và cần test — Claude Code hợp lý hơn.

**Tạo README cho project** — Cả hai làm được. Nhưng Claude Code đọc được cả codebase để viết README chính xác hơn, còn Cowork chỉ thấy file bạn mount.

**Research + tổng hợp thông tin** — Cowork mạnh hơn ở đây nhờ connectors (search Gmail, query Notion) và web search tích hợp.

## Điều tôi hiểu nhầm

Tôi tưởng Claude Code chỉ là "Cowork nhưng cho developer." Sai. Chúng có kiến trúc khác nhau hoàn toàn. Claude Code chạy trực tiếp trên OS, có hooks (chạy script khi event xảy ra), có subagents chạy song song với context riêng. Cowork chạy trong VM cách ly, an toàn hơn nhưng cũng bị giới hạn hơn về quyền truy cập.

Sai lầm ngược lại: tôi cũng từng nghĩ "Cowork chỉ dành cho non-tech." Không hẳn. Một senior engineer vẫn dùng Cowork để draft email, tổng hợp meeting notes, tạo slide deck, hay chạy scheduled report — những thứ không cần terminal. Không ai bắt bạn chọn một trong hai. Dùng cả hai, cho đúng việc.

## Takeaway

Đừng hỏi "Cowork hay Claude Code?" — hãy hỏi "Task này cần gì?" Nếu cần filesystem access sâu, git workflow, và code execution trực tiếp — Claude Code. Nếu cần connectors, scheduling, document generation, và GUI thân thiện — Cowork. Và nếu cả hai đều dùng được, chọn cái nào bạn đang mở sẵn.

Bài tiếp theo: **TIL #024 — Cowork cho Android/KMP dev** — 5 workflow thực tế mà mobile developer có thể áp dụng ngay với Cowork.
