---
title: "TIL #017 — Plugins & Connectors: cách install và tại sao ecosystem này quan trọng"
date: 2026-05-16
tags: ["plugins", "connectors", "marketplace", "mcp", "ecosystem"]
summary: "Plugin là 'bộ toolkit đóng gói sẵn', connector là 'dây nối' đến app bên ngoài — hiểu đúng sự khác biệt thì mới cài đúng thứ mình cần."
---

## Bài học hôm nay

Hôm qua tôi đã hiểu MCP là gì — cái ổ cắm chuẩn giúp agent nói chuyện với thế giới bên ngoài. Nhưng hiểu protocol thôi chưa đủ. Hôm nay câu hỏi thực tế hơn: **làm sao để cài connector? Plugin là gì và khác connector chỗ nào? Ecosystem hiện tại ra sao?**

Nói ngắn gọn: nếu MCP là hệ thống ống nước, thì connector là từng ống nối cụ thể (ống đến Gmail, ống đến Notion), còn plugin là cả cái bếp lắp sẵn — bao gồm ống nước, bếp gas, dao thớt, và cả công thức nấu ăn.

## Connector, Skill, Plugin — bộ ba dễ nhầm

Đây là chỗ tôi mất gần một tiếng mới phân biệt được. Ba khái niệm này liên quan nhưng khác nhau hoàn toàn:

**Connector** là đường kết nối giữa Cowork và một dịch vụ bên ngoài. Mỗi connector thực chất là một MCP server đã được đóng gói sẵn. Ví dụ: Gmail connector cho phép agent search email, tạo draft. Notion connector cho phép agent đọc/ghi database. Bạn authorize một lần, dùng mãi xuyên session.

**Skill** là tập hợp instructions dạy agent cách làm một loại task cụ thể. Ví dụ: skill `docx` dạy agent cách tạo Word document chuyên nghiệp. Skill `pptx` dạy cách build slide deck. Skill không kết nối ra bên ngoài — nó thay đổi cách agent suy nghĩ và hành động.

**Plugin** là gói bundle chứa tất cả: connector + skill + slash command + sub-agent. Khi bạn install plugin Marketing chẳng hạn, bạn đồng thời có connector đến các analytics tool, skill viết content, và các command chuyên biệt — tất cả sẵn sàng dùng ngay mà không cần setup từng thứ.

Nói cách khác: **connector mang dữ liệu vào, skill định hình cách agent nghĩ, plugin đóng gói tất cả để phân phối.**

## Cách install — đơn giản hơn tôi tưởng

### Install Plugin từ Marketplace

Mở Cowork → click **Customize** ở sidebar → **Browse plugins**. Marketplace hiện ra với danh sách plugin theo category. Chọn plugin phù hợp, đọc mô tả và permission nó yêu cầu, click **Install**. Xong. Plugin active ngay lập tức.

Anthropic đã open-source 11 plugin chính thức vào tháng 1/2026, cover hầu hết các function phổ biến: Sales, Marketing, Legal, Finance, Support, Product, Data Analysis, Enterprise Search, và Research. Ngoài ra cộng đồng cũng đang đóng góp thêm plugin mới liên tục.

### Setup Connector riêng lẻ

Nếu bạn chỉ cần kết nối một dịch vụ cụ thể mà không muốn cài cả plugin lớn: Customize → **Connectors**. Bạn sẽ thấy hai loại: **Web connectors** (Gmail, Slack, Notion, Google Calendar...) và **Desktop connectors** (thường gắn với Claude Code workflow). Click connector cần thiết, authorize qua OAuth, và nó sẽ ready trong vài giây.

Hiện tại ecosystem đã có hơn 38 connector chính thức — từ Slack, Notion, Google Drive đến HubSpot, Jira, Salesforce, Snowflake, và nhiều nữa.

### Kích hoạt trong session

Một detail nhỏ mà tôi suýt bỏ qua: install xong chưa phải xong. Trong mỗi session mới, bạn có thể chọn connector nào active bằng cách click dấu **+** trong chat → **Connectors** → toggle on/off. Tại sao? Vì mỗi connector active sẽ chiếm token trong context window. Cài 38 connector nhưng chỉ bật 3 cái đang cần — đó là cách dùng thông minh.

Có một setting đáng chú ý: **"Load tools when needed"** vs **"Always load tools"**. Khuyến nghị của tôi: bắt đầu với "Load tools when needed" — agent sẽ chỉ load connector khi thực sự cần, tiết kiệm token đáng kể.

## Fail Wall

**Sai lầm 1: Cài hết mọi thứ rồi bật hết.** Lần đầu thấy marketplace, tôi hào hứng install 6 plugin cùng lúc và bật mọi connector. Kết quả? Agent chậm hẳn vì context window bị phình to với hàng đống tool definitions. Bài học: ít hơn là nhiều hơn. Chỉ bật những gì bạn thực sự dùng trong session hiện tại.

**Sai lầm 2: Nhầm connector với plugin.** Tôi tưởng install plugin Marketing là đã có connector đến Google Analytics. Không hẳn — plugin bundle những connector mà tác giả plugin quyết định bao gồm, không phải tất cả connector trên đời. Đọc kỹ mô tả plugin trước khi install.

**Sai lầm 3: Quên authorize.** Install connector xong, tôi gõ ngay "kiểm tra email" và agent báo lỗi. Hóa ra tôi install nhưng chưa authorize OAuth. Bước authorize tuy chỉ mất 10 giây nhưng không thể skip.

## Takeaway

Hiểu sự khác biệt giữa connector, skill, và plugin là bước đầu tiên để dùng Cowork hiệu quả. Đừng cài lung tung — hãy bắt đầu với 1–2 connector bạn dùng hàng ngày (Gmail, Notion, Slack), rồi mở rộng dần. Ecosystem đang lớn lên rất nhanh, và việc chọn đúng plugin giống như chọn đúng extension cho VS Code — nó quyết định trải nghiệm của bạn.

Ngày mai: tôi sẽ thực hành cụ thể với **Notion connector** — agent đọc/ghi Notion database, và liệu nó có thay thế được việc tôi tự mở Notion hay không.
