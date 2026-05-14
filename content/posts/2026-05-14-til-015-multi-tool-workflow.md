---
title: "TIL #015 — Multi-tool workflow: kết hợp search + bash + file trong 1 task"
date: 2026-05-14
tags: ["cowork", "workflow", "multi-tool", "automation", "bash", "web-search"]
summary: "Agent không mạnh vì có nhiều tool — agent mạnh vì biết xài đúng tool, đúng thứ tự, trong cùng một lượt chạy."
---

## Bài học hôm nay

14 bài trước, tôi đã lần lượt học từng tool riêng lẻ: Web Search để tìm thông tin, Bash để chạy lệnh, Read/Write/Edit để thao tác file, Artifacts để hiển thị kết quả trực quan. Mỗi tool đều hay, nhưng nếu dùng riêng lẻ thì giống như có một bộ dao bếp mà mỗi lần chỉ lấy ra một con — bạn vẫn nấu được, nhưng chậm và vụng về.

Bài hôm nay là lúc tất cả các tool "nối dây" lại. Tôi gọi đó là **multi-tool workflow** — khi agent tự quyết định dùng tool nào, theo thứ tự nào, và truyền kết quả từ tool này sang tool kia trong cùng một task.

## Agent nghĩ gì khi nhận một task phức tạp?

Khi bạn giao cho Cowork một yêu cầu kiểu: *"Tìm 5 thư viện Kotlin Multiplatform phổ biến nhất, so sánh số star trên GitHub, rồi tạo một file markdown tổng hợp"*, agent không có một "nút bấm" nào gọi là "multi-tool". Thay vào đó, nó **tự phân tích** yêu cầu thành các bước:

| Bước | Tool được chọn | Lý do |
|------|---------------|-------|
| 1 | Web Search | Tìm danh sách thư viện KMP phổ biến |
| 2 | Web Search (lần 2) | Kiểm tra số star hiện tại trên GitHub |
| 3 | Bash | Có thể dùng để parse dữ liệu hoặc sắp xếp |
| 4 | Write | Tạo file markdown tổng hợp |
| 5 | Read | Đọc lại file vừa tạo để verify |

Điểm quan trọng: **bạn không cần chỉ đạo từng bước**. Bạn mô tả outcome mong muốn, agent tự lên kế hoạch. Đây chính là sự khác biệt giữa "dùng tool" và "orchestrate workflow".

## Anatomy của một multi-tool workflow

Sau khi thử nghiệm nhiều task phức tạp, tôi nhận ra hầu hết multi-tool workflow đều theo một pattern chung:

**Gather → Process → Output → Verify**

- **Gather**: Thu thập dữ liệu (Web Search, Read file, đọc từ MCP connector)
- **Process**: Xử lý, lọc, biến đổi dữ liệu (Bash script, logic trong đầu agent)
- **Output**: Tạo deliverable (Write file, tạo artifact, draft email)
- **Verify**: Kiểm tra lại kết quả (Read file, chạy test, so sánh)

Ví dụ thực tế mà tôi hay dùng:

```
"Đọc tất cả file .md trong thư mục content/posts,
đếm số bài theo từng tag,
rồi tạo một file thống kê tags.csv"
```

Agent sẽ: **Bash** (`ls` hoặc `find` để list file) → **Read** (đọc front matter từng file) → **Bash** (xử lý, đếm) → **Write** (tạo CSV) → **Read** (verify kết quả).

Không có dòng code nào tôi phải viết. Không có pipeline YAML nào phải config. Một câu prompt, agent tự lo.

## Khi nào nên dùng multi-tool workflow?

Không phải lúc nào cũng cần phức tạp. Đây là cách tôi phân loại:

**Dùng single tool** khi task chỉ có một bước rõ ràng: "tìm giá Bitcoin hiện tại", "đọc file README cho tôi", "tạo một file hello.py".

**Dùng multi-tool** khi task có ít nhất 2 trong 3 yếu tố sau:
1. Cần dữ liệu từ bên ngoài (search, fetch, connector)
2. Cần xử lý hoặc biến đổi dữ liệu (bash, logic)
3. Cần tạo output có cấu trúc (file, artifact, email draft)

## Điều tôi hiểu nhầm

**Nhầm lần 1: "Mình phải liệt kê từng tool trong prompt"**

Ban đầu tôi viết prompt kiểu: *"Dùng Web Search tìm X, rồi dùng Bash chạy Y, rồi dùng Write tạo Z."* Kết quả? Agent làm đúng nhưng rất máy móc — nếu bước search không ra kết quả, nó vẫn cố chạy bước bash với dữ liệu rỗng.

Cách tốt hơn: **mô tả outcome**, để agent tự chọn tool. *"Tìm thông tin về X, xử lý dữ liệu, và tạo file tổng hợp."* Agent sẽ linh hoạt hơn — nếu search không ra, nó sẽ thử fetch trực tiếp URL, hoặc hỏi lại bạn.

**Nhầm lần 2: "Multi-tool = agent sẽ chạy lâu hơn"**

Thực tế, agent có thể chạy các tool **song song** khi chúng không phụ thuộc nhau. Ví dụ: search 3 query cùng lúc, rồi mới gộp kết quả. Nhiều khi multi-tool workflow chỉ chậm hơn single tool vài giây.

**Nhầm lần 3: "Scheduled task không dùng được multi-tool"**

Sai hoàn toàn. Chính bài blog bạn đang đọc là sản phẩm của một scheduled task chạy multi-tool mỗi sáng: đọc curriculum → search topic → viết file → edit curriculum. Bốn tool, không có người giám sát, chạy tự động.

## Tips thực chiến

1. **Bắt đầu từ outcome, không phải từ tool.** Viết prompt mô tả kết quả mong muốn. Để agent tự chọn đường đi.

2. **Dùng TodoList.** Khi task phức tạp, agent sẽ tạo checklist nội bộ để track progress. Bạn sẽ thấy nó trong UI — rất tiện để theo dõi agent đang ở bước nào.

3. **Kiểm tra output.** Multi-tool workflow có nhiều bước = nhiều chỗ có thể sai. Luôn yêu cầu agent verify kết quả cuối cùng, hoặc tự mở file ra xem.

4. **Đừng sợ task lớn.** Cowork được thiết kế để xử lý task dài. Agent sẽ tự chia nhỏ, tự xử lý lỗi giữa chừng, và tự retry nếu cần.

## Takeaway

Multi-tool workflow là lúc Cowork thực sự "click" — bạn ngừng nghĩ về từng tool riêng lẻ và bắt đầu nghĩ về outcome. Hãy mô tả kết quả bạn muốn, để agent tự orchestrate phần còn lại.

Bài tiếp theo, chúng ta sẽ bước sang Phase 4 — nơi agent vươn ra ngoài máy tính của bạn. Bài #016 sẽ giải thích **MCP là gì** — Model Context Protocol — bằng ngôn ngữ mà một đứa 5 tuổi cũng hiểu được.
