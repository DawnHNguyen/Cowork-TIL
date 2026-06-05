---
title: "TIL #030 — What's next: tương lai của AI agents và Cowork trong 12 tháng tới"
date: 2026-06-05
tags: ["cowork", "ai-agents", "future", "mcp", "multi-agent", "roadmap"]
summary: "Bài cuối cùng của series 30 ngày — nhìn về phía trước: agent sẽ thay đổi thế nào, và Cowork đang đi đâu."
---

## Bài học hôm nay

Đây là bài #030 — bài cuối cùng trong curriculum 30 ngày. Thay vì học thêm một feature cụ thể, hôm nay tôi muốn nhìn ra xa hơn: AI agents sẽ phát triển thế nào trong 12 tháng tới, và Cowork đang đứng ở đâu trong bức tranh đó?

Tôi đã dành buổi sáng đọc báo cáo từ Gartner, Google Cloud, Microsoft, và cả roadmap của MCP. Kết luận ngắn: chúng ta đang ở rất sớm trong cuộc chơi agent — nhưng tốc độ thay đổi nhanh đến mức thứ bạn học hôm nay có thể outdated trong 3 tháng. Và đó chính xác là lý do cần tiếp tục viết TIL.

## Agent không còn là chatbot — nó đang thành đồng nghiệp

Xu hướng rõ nhất từ mọi nguồn tôi đọc: agent đang chuyển từ "trợ lý trả lời câu hỏi" sang "thực thể tự chủ thực thi công việc." Theo Gartner, đến 2028, ít nhất 15% quyết định công việc sẽ do AI agents đưa ra một cách tự chủ — con số này gần như bằng 0 vào 2024.

Nghe thì xa, nhưng nhìn lại 30 bài TIL, tôi đã thấy điều này rồi. Bài #005, tôi setup scheduled task để agent tự viết blog mỗi sáng — không cần tôi có mặt. Bài #018–019, agent tự đọc Notion, tự draft email. Đó chính là "agent tự chủ" ở dạng nhỏ nhất.

Điều đáng chú ý: 40% enterprise applications dự kiến sẽ tích hợp AI agents chuyên biệt vào cuối 2026. Nhưng Gartner cũng cảnh báo — hơn 40% dự án agentic AI sẽ bị cancel trước cuối 2027, chủ yếu vì execution chứ không phải công nghệ. Lesson? Công nghệ ready rồi, nhưng cách tổ chức sử dụng nó thì chưa.

## MCP và A2A: hai protocol định hình tương lai

Nếu bạn đọc bài #016 về MCP, bạn biết nó là cách agent kết nối với tools bên ngoài. Nhưng tôi không ngờ MCP phát triển nhanh đến vậy: từ 2 triệu lượt download SDK/tháng khi ra mắt tháng 11/2024, đến tháng 3/2026 đã đạt 97 triệu lượt — tăng 4,750%. Hơn 10,000 MCP servers đang hoạt động trên ChatGPT, Claude, Cursor, Gemini, Copilot, và VS Code.

Nhưng MCP chỉ giải quyết "agent nói chuyện với tool." Còn "agent nói chuyện với agent" thì sao? Đó là lý do A2A (Agent-to-Agent Protocol) của Google ra đời. Hơn 150 tổ chức đã hỗ trợ A2A — bao gồm Google, Microsoft, AWS, Salesforce, SAP. Cả hai protocol giờ đều thuộc quản lý của Linux Foundation.

Tưởng tượng thế này: bạn có một Cowork agent chuyên viết report. Nó dùng MCP để kéo data từ Notion, dùng A2A để gọi một agent khác chuyên phân tích data, rồi agent thứ ba chuyên tạo chart. Đó không phải science fiction — đó là multi-agent orchestration, và nó đang xảy ra.

## Cowork đang đi đâu?

Nhìn lại 6 tháng đầu 2026, Cowork đã ship rất nhanh:

- **Tháng 1:** Ra mắt plugin system — 11 plugin open-source, bao gồm engineering, marketing, và nhiều domain khác
- **Tháng 2:** Private plugin marketplace cho Enterprise, 10 plugin mới theo department, 12 MCP connectors mới
- **Tháng 2:** Launch trên Windows (x64) với feature parity
- **Projects:** Giữ files và instructions trong một nơi, persistent trên máy
- **Opus 4.8:** Model mới nhất với Dynamic Workflows, ra mắt tháng 5/2026

Xu hướng rõ ràng: Cowork đang mở rộng từ "tool cá nhân" sang "platform cho team," và từ "single agent" sang "multi-agent workflow."

Một tính năng tôi đặc biệt hào hứng: **Dreaming** (research preview) trong Claude Managed Agents — agent có thể review lại các session cũ để tìm pattern và tự cải thiện memory. Hãy tưởng tượng agent Cowork của bạn mỗi đêm tự "ôn bài," nhớ bạn thích format báo cáo kiểu nào, tool nào bạn hay dùng. Đó là bước nhảy từ "stateless" (bài #002) sang "learns over time."

## Điều tôi hiểu nhầm

Khi bắt đầu series này, tôi nghĩ AI agents sẽ thay thế workflow hiện tại — bạn bỏ Excel, bỏ Notion, bỏ Gmail, và dùng agent làm hết. Sai.

Thực tế: agent không thay thế tools, nó **kết nối** tools. MCP là minh chứng — thay vì xây một super-app, cách tiếp cận đúng là để agent nói chuyện với mọi app bạn đang dùng. Cowork không phải Notion killer hay Gmail killer. Nó là layer ở giữa, điều phối mọi thứ.

Sai lầm thứ hai: tôi nghĩ "tương lai agent" là một thứ xa vời, kiểu 5–10 năm nữa. Nhưng 30 bài TIL vừa rồi cho thấy — tương lai đó đang xảy ra, từng tuần, từng bản update. Chỉ trong lúc tôi viết series, Anthropic đã ship plugin marketplace, Windows support, Projects, và model mới.

## Takeaway

Nếu bạn đọc được đến đây — cảm ơn đã theo dõi 30 bài TIL. Điều quan trọng nhất tôi học được không phải một feature cụ thể nào, mà là **mindset**: AI agent là đồng nghiệp bạn cần học cách làm việc cùng, không phải tool bạn chỉ cần bấm nút.

Curriculum 30 bài kết thúc ở đây, nhưng việc học thì không. Công nghệ này thay đổi mỗi tuần — và đó chính xác là lý do format TIL phù hợp. Mỗi ngày một bài nhỏ, tích lũy dần, thay vì cố đọc một cuốn sách dày rồi nó outdated trước khi bạn đọc xong.

See you ở bonus topics — nếu có. 🚀
