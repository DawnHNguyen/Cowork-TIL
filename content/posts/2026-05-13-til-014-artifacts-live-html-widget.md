---
title: "TIL #014 — Artifacts: live HTML widget tái sử dụng được là gì"
date: 2026-05-13
tags: ["artifacts", "live-artifacts", "dashboard", "cowork", "html"]
summary: "Artifacts trong Cowork không phải HTML tĩnh — nó là trang web sống, tự kéo data mới mỗi lần mở, và tồn tại xuyên session."
---

## Bài học hôm nay

Trước khi tìm hiểu, tôi nghĩ artifact chỉ là cái bảng HTML mà Claude render trong chat — giống kiểu "code preview" đẹp hơn một chút. Mở ra xem xong, đóng lại, hết. Nếu bạn cũng nghĩ vậy thì chúng ta cùng phe.

Thực tế, artifact trong Cowork — hay chính xác hơn là **live artifact** — là một thứ khác hẳn. Nó là một trang HTML interactive, được lưu lại vĩnh viễn trong tab riêng, và mỗi lần bạn mở nó, nó tự kéo dữ liệu mới từ các connector đã kết nối. Nghĩ nó như một mini dashboard cá nhân mà bạn build một lần, dùng mãi.

## Live Artifact vs Artifact trong chat

Nhiều người (bao gồm tôi) hay nhầm hai thứ này. Để phân biệt:

| | Artifact trong chat | Live Artifact trong Cowork |
|---|---|---|
| **Sống ở đâu** | Nằm trong conversation, phải scroll lại tìm | Tab "Live artifacts" riêng, mở bất cứ lúc nào |
| **Dữ liệu** | Tĩnh — snapshot tại thời điểm tạo | Động — kéo data mới mỗi lần mở |
| **Tồn tại** | Hết session là khó tìm lại | Persist xuyên session, có version history |
| **Connector** | Không kết nối app ngoài | Dùng được Notion, Gmail, Slack, Calendar... |

Điểm mấu chốt: live artifact có thể gọi `window.cowork.callMcpTool()` để query connector — nghĩa là nó không chỉ hiển thị data, nó chủ động đi lấy data mới nhất.

## Cách tạo một live artifact

Có hai cách:

**Cách 1 — Nói thẳng trong task:** Bạn describe cái bạn cần, mention connector nào nên dùng. Ví dụ: "Tạo dashboard hiển thị task đang mở từ Linear, Slack mention hôm nay, và lịch Google Calendar." Claude sẽ build artifact và tự lưu vào tab Live artifacts.

**Cách 2 — Từ tab Live artifacts:** Mở Cowork sidebar → chọn "Live artifacts" → click "New artifact" → chọn "Chat with Claude". Cách này phù hợp khi bạn muốn build artifact mà không lẫn vào task khác.

Một chi tiết tôi thấy hay: Claude thường sẽ **probe connector trước** bằng một query nhỏ để xem cấu trúc response thực tế, rồi mới viết HTML parser. Không phải kiểu "đoán rồi viết" — mà là "thử rồi viết". Thật ra agent cũng phải debug y như dev vậy.

## Vài use case thực tế

Thay vì liệt kê lý thuyết, đây là những thứ tôi thấy live artifact thực sự hữu ích:

**Morning brief cá nhân:** Mỗi sáng mở ra thấy: Slack mention chưa đọc, calendar hôm nay, PR đang chờ review. Không cần mở 3 app riêng lẻ.

**Project tracker:** Kéo data từ Linear hoặc Asana, hiển thị task theo status. Mở lại tuần sau, data tự cập nhật — không cần build lại.

**Competitive watch:** Theo dõi competitor đang ship gì, blog mới, pricing thay đổi. Build một lần, refresh mỗi khi mở.

Nói cách khác, live artifact biến Cowork từ "assistant trả lời câu hỏi" thành "assistant build tool cho bạn".

## Điều tôi hiểu nhầm

**Nhầm 1: "Artifact sync qua cloud."** Không. Live artifact sống trên máy bạn. Đổi máy = không thấy artifact cũ. Đây là limitation hiện tại, chưa có cloud sync.

**Nhầm 2: "Artifact luôn hỏi permission trước khi dùng connector."** Sai. Không giống session thông thường, live artifact dùng connector mà **không hỏi lại** sau khi bạn đã approve lúc tạo. Đây vừa là tiện lợi, vừa là thứ cần cẩn thận — đặc biệt nếu artifact kết nối connector có quyền write.

**Nhầm 3: "Cần biết code để tạo artifact."** Không. Bạn describe bằng ngôn ngữ tự nhiên, Claude viết HTML/JS. Bạn không cần biết `fetch()` hay `DOM manipulation`. Nhưng nếu biết một chút thì debug dễ hơn khi artifact không hiển thị đúng ý.

## Takeaway

Live artifact là feature biến Cowork từ chatbot thành platform. Bạn không chỉ hỏi rồi nhận câu trả lời — bạn nhờ agent build một công cụ, lưu lại, và dùng đi dùng lại. Nếu bạn đang dùng Cowork mà chưa thử tạo artifact, đây là lúc bắt đầu: hãy thử "Tạo morning brief với calendar và Slack mention" rồi xem kết quả.

Bài tiếp theo: tôi sẽ kết hợp tất cả tool đã học — search, bash, file — vào một workflow duy nhất. Multi-tool workflow, đúng kiểu "full combo".
