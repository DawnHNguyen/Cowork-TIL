---
title: "TIL #020 — GitHub connector: từ 'không có' đến 'thực ra có' — và bài học về PAT"
date: 2026-05-21
tags: ["github", "connector", "mcp", "pat", "security"]
summary: "GitHub connector trong Cowork đã tồn tại, nhưng nếu bạn cần kiểm soát sâu hơn, GitHub MCP Server với PAT là con đường đáng học."
---

## Bài học hôm nay

Hôm qua tôi kết thúc bài Gmail connector bằng câu: *"Bài tiếp theo sẽ nói về GitHub connector — hay đúng hơn là tại sao nó không tồn tại chính thức."* Hóa ra câu đó đã sai ngay từ lúc viết. GitHub connector **có tồn tại** trong Cowork — và đây là bài học đầu tiên hôm nay: thông tin về AI tools thay đổi nhanh đến mức cái bạn "biết" tuần trước có thể đã lỗi thời.

Khi tôi lên curriculum cho series này, GitHub connector chưa phải là thứ bạn click một phát là xong. Nhưng tính đến thời điểm này, bạn hoàn toàn có thể vào **Settings → Connectors**, tìm GitHub, authorize qua OAuth, và agent sẽ có quyền truy cập repo của bạn. Vậy bài này còn gì để viết? Rất nhiều — vì câu chuyện thú vị nằm ở chỗ: có **hai con đường** để kết nối GitHub, và chúng phục vụ mục đích rất khác nhau.

## Con đường 1: GitHub connector qua Connectors Directory

Đây là cách đơn giản nhất. Bạn vào Settings → Connectors, tìm GitHub, click Connect, authorize bằng tài khoản GitHub của bạn. Done. Agent có thể browse repo, đọc code, xem issues, pull requests, commit history.

Cách này phù hợp nếu bạn chỉ cần agent **đọc và tham khảo** code. Ví dụ: *"Tóm tắt những thay đổi trong PR #42"*, hoặc *"Tìm file nào trong repo xử lý authentication"*. Connector quản lý OAuth token cho bạn, tự refresh, không cần config gì thêm.

Hạn chế? Bạn không kiểm soát được chính xác scope nào được cấp, và nếu bạn cần agent làm những thao tác nâng cao hơn — như tạo issue, quản lý project boards, hay trigger workflow — thì đôi khi connector mặc định không đủ.

## Con đường 2: GitHub MCP Server + Personal Access Token

Đây là con đường "tự tay cấu hình" mà dân dev sẽ thích hơn. GitHub có một **MCP server chính thức** tại `github/github-mcp-server` — đây không phải project community, mà là do chính GitHub phát triển và maintain.

Cách hoạt động: bạn tạo một Personal Access Token (PAT) trên GitHub, rồi cấu hình MCP server để kết nối qua token đó. Server này biến GitHub API thành một bộ tools mà agent có thể gọi trực tiếp.

Bộ tools khá phong phú, tôi nhóm lại thành 4 mảng chính:

**Repository & Code** — browse repo, đọc file, search code, xem commit history. Đây là nền tảng.

**Issues & Pull Requests** — tạo issue, update status, tạo PR, review diff. Đây là chỗ agent bắt đầu thực sự *làm việc* thay vì chỉ đọc.

**CI/CD & Actions** — xem status workflow runs, phân tích build failures. Hữu ích khi bạn muốn hỏi agent: *"CI đang fail ở step nào vậy?"*

**Projects** — list projects, xem board, quản lý items. Tính năng này mới được thêm đầu 2026.

## PAT: classic vs fine-grained

Đây là chỗ tôi mất thời gian nhiều nhất. GitHub có hai loại PAT:

**Classic PAT** (prefix `ghp_`) — dễ tạo, scope theo kiểu "tất cả repo" hoặc "tất cả issue". Điểm hay: GitHub MCP Server tự detect scope của token và **ẩn bớt tools** mà token không có quyền dùng. Nghĩa là nếu bạn chỉ cấp quyền đọc repo, agent sẽ không thấy tool tạo PR — giảm rủi ro agent gọi nhầm tool rồi fail.

**Fine-grained PAT** — cho phép chọn chính xác từng repo, từng permission. An toàn hơn nhiều, nhưng MCP Server không detect được scope tự động, nên sẽ hiện tất cả tools bất kể token có quyền hay không. Nếu agent gọi tool không có quyền, sẽ nhận lỗi 403.

Khuyến nghị của tôi: dùng **fine-grained PAT**, chọn đúng repo bạn cần, cấp quyền tối thiểu. Chấp nhận đôi khi agent gặp lỗi 403 — còn hơn là cấp quyền rộng rồi lo lắng.

## Setup thực tế

Với Claude Code (nếu bạn dùng terminal), setup rất gọn — chỉ một dòng lệnh để add MCP server qua HTTP transport, truyền PAT qua header Authorization.

Với Claude Desktop, phải chạy qua Docker container vì Desktop chưa hỗ trợ HTTP transport trực tiếp cho MCP. Config nằm trong file `claude_desktop_config.json`.

Với Cowork, bạn có thể dùng custom connector để add MCP server — hoặc đơn giản hơn, dùng luôn connector có sẵn trong directory.

## Điều tôi hiểu nhầm

Sai lầm lớn nhất: tôi tưởng PAT phải hardcode vào file config. Đúng là nhiều tutorial viết vậy, nhưng cách đúng là dùng **environment variable**. Lý do đơn giản: nếu bạn commit file config lên repo (mà nhiều người làm vì tiện), PAT của bạn nằm trong git history mãi mãi. Xóa file không đủ — phải rewrite history hoặc revoke token.

Sai lầm thứ hai: tôi tạo classic PAT với full scope vì "test cho nhanh", rồi quên revoke. Token đó có quyền đọc/ghi tất cả repo, kể cả repo private. May mà tôi nhớ revoke sau 2 ngày. Bài học: **không có PAT nào nên sống quá 30 ngày**, và luôn đặt expiration date khi tạo.

## Vậy chọn đường nào?

Nếu bạn là BA, PO, hoặc chỉ cần agent đọc code và tóm tắt PR — **connector có sẵn** là đủ. Setup 2 phút, không cần hiểu MCP hay PAT.

Nếu bạn là dev và muốn agent tạo issue, review code, check CI status — **GitHub MCP Server + fine-grained PAT** cho bạn kiểm soát chính xác agent được làm gì.

Nếu bạn dùng cả Cowork lẫn Claude Code — setup MCP Server một lần, dùng được ở cả hai nơi.

## Takeaway

GitHub connector trong Cowork đã không còn là "thứ không tồn tại" — nhưng hiểu cách PAT và MCP Server hoạt động vẫn là kiến thức nền tảng quan trọng. Không phải vì bạn *phải* dùng, mà vì khi connector mặc định không đủ, bạn biết chính xác phải làm gì tiếp theo.

Bài tiếp theo: tôi sẽ nói về **security trong Cowork** — PAT chỉ là một phần, còn scope, credential management, và cách không làm leak thông tin nhạy cảm mới là bức tranh toàn diện.
