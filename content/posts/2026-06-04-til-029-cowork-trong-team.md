---
title: "TIL #029 — Cowork trong team: khi nhiều người dùng cùng 1 agent"
date: 2026-06-04
tags: ["cowork", "team", "collaboration", "enterprise", "connectors"]
summary: "Cowork không phải tool solo — nhưng cách nó hoạt động trong team rất khác so với bạn tưởng."
---

## Bài học hôm nay

Sau 28 bài viết, tôi toàn dùng Cowork một mình. Máy tôi, folder tôi, connector tôi authenticate. Nhưng nếu cả team 5–10 người cùng dùng thì sao? Ai quản lý connector? Session có share được không? Project thì sao?

Câu trả lời ngắn: Cowork trên Team/Enterprise plan có nhiều tính năng collaboration hơn bạn nghĩ — nhưng cũng có những giới hạn quan trọng mà nếu không biết trước, bạn sẽ thất vọng.

## Cowork trên Team plan vs. dùng cá nhân

Khi organization của bạn dùng Claude Team (5–75 người) hoặc Enterprise, Cowork được bật ở cấp organization. Admin vào **Organization settings** bật toggle, và tất cả member đều có quyền truy cập. Trên Enterprise, admin có thể granular hơn: tạo custom role kiểu "Cowork Enabled" rồi gán cho từng group, thay vì bật cho cả tổ chức.

Điểm khác biệt lớn nhất so với dùng cá nhân:

| Khía cạnh | Cá nhân (Pro/Max) | Team/Enterprise |
|---|---|---|
| Bật Cowork | Tự bật trong Settings | Admin bật cho cả org |
| Connectors | Tự add, tự authenticate | Admin add connector → member tự authenticate |
| Projects | Private mặc định | Chọn Public hoặc Private |
| Usage tracking | Không có | Admin xem analytics, spend limits |
| Plugins | Tự install | Admin set per-plugin policy |

## Connectors trong team: admin add, member authenticate

Đây là phần tôi thấy thiết kế khá thông minh. Flow hoạt động như sau:

**Bước 1 — Admin enable connector:** Owner/Primary Owner vào Organization settings → Connectors → Browse connectors → chọn connector (ví dụ Notion, Gmail, Slack) → "Add to your team."

**Bước 2 — Admin set quyền:** Admin có thể giới hạn connector chỉ được đọc (read-only) hoặc cho phép cả ghi (read-write). Ví dụ: cho phép team đọc Slack messages nhưng không cho agent gửi message.

**Bước 3 — Member authenticate:** Mỗi người tự đăng nhập vào connector bằng tài khoản cá nhân của mình. Claude sẽ kế thừa đúng quyền của người đó trong service gốc — nếu bạn không có access vào channel #finance trên Slack, connector cũng không đọc được.

Thiết kế này giải quyết được bài toán security mà tôi lo ngại nhất: không ai có thể dùng Cowork để truy cập data mà họ không có quyền xem trong hệ thống gốc.

## Projects: shared context, nhưng không shared sessions

Projects trên Team plan cho phép bạn tạo workspace chung với files, instructions, và memory riêng. Khi tạo project, bạn chọn:

- **Public**: mọi người trong org đều thấy và dùng được
- **Private**: chỉ người được invite mới truy cập

Ví dụ thực tế: team bạn có project "Sprint Planning" chứa template, past sprint data, và custom instructions cho agent. Mọi member mở project đó đều có cùng context — agent biết format, biết conventions, biết data nằm đâu.

**Nhưng — và đây là điểm nhiều người hiểu nhầm — sessions (conversations) trong project vẫn là private.** Bạn chat với agent trong project "Sprint Planning", đồng nghiệp bạn cũng chat trong project đó, nhưng hai người KHÔNG thấy conversation của nhau. Mỗi người có agent riêng, context riêng, kết quả riêng.

## Plugins: admin kiểm soát catalog

Trên Team/Enterprise, admin có thể set policy cho từng plugin:

- **Auto-installed**: plugin tự động có sẵn cho mọi member
- **Available**: member tự chọn install nếu muốn
- **Hidden**: không hiện trong catalog — member không biết plugin tồn tại

Điều này quan trọng cho các team có compliance requirements. Ví dụ: team legal có thể muốn ẩn plugin tạo file tự động, chỉ cho phép plugin đọc document.

## Điều tôi hiểu nhầm

Tôi nghĩ "Cowork trong team" nghĩa là nhiều người cùng nói chuyện với một agent instance, kiểu như group chat. Sai hoàn toàn.

Mỗi người vẫn có agent riêng. "Team" ở đây nghĩa là shared context (qua Projects), shared connector pool (admin manage, member authenticate), và centralized governance (usage analytics, spend limits, role-based access). Không có concept "shared agent" hay "shared session" — và khi nghĩ kỹ, điều đó hợp lý vì mỗi người có workflow, quyền truy cập, và nhu cầu khác nhau.

Một hiểu nhầm khác: tôi tưởng connector được add bởi admin thì tất cả member tự động truy cập được. Không — mỗi người vẫn phải authenticate riêng, và quyền phụ thuộc vào account cá nhân trong service gốc.

## Takeaway

Cowork trong team không phải "chia sẻ 1 agent" mà là "mỗi người có agent riêng, nhưng admin kiểm soát được: ai dùng gì, connector nào available, plugin nào cho phép, và chi phí bao nhiêu." Mental model đúng là: **shared governance, individual execution**.

Nếu bạn là admin đang deploy Cowork cho team: bắt đầu bằng việc enable connector ở read-only, để team dùng thử, rồi mở write access dần. An toàn hơn nhiều so với bật hết từ đầu.

*Bài tiếp theo: What's next — tương lai của AI agents và Cowork trong 12 tháng tới. Bài cuối cùng của series 30 ngày.*
