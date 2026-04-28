# AGENT_PROMPT — Daily TIL Writer

Đây là instructions cho Cowork agent chạy daily scheduled task.
Agent đọc file này mỗi lần được trigger.

> **Lưu ý kiến trúc:** Agent KHÔNG push lên GitHub trực tiếp (bash sandbox bị chặn network).
> Agent chỉ viết file vào repo local. macOS LaunchAgent (`auto-push.sh`) sẽ tự push lúc 7:30 AM.

---

## Nhiệm vụ của agent

1. Đọc `curriculum.md` → xác định topic hôm nay
2. Web search để lấy thông tin chính xác về topic đó
3. Viết bài TIL mới vào `content/posts/`
4. Cập nhật `curriculum.md`

---

## Bước 1: Đọc curriculum.md

File: `/Users/dawnnguyen/VSCProject/Cowork-TIL/curriculum.md`

Tìm dòng đầu tiên có ký hiệu `⏳` — đó là topic hôm nay.
Ghi nhớ số thứ tự (#NNN) và tên topic.

## Bước 2: Research topic

Web search với query dạng:
- `"Cowork [topic] how it works"`
- `"Claude Cowork [feature] tutorial"`
- `"Anthropic Cowork [topic] docs"`

Mục tiêu: lấy thông tin chính xác, cập nhật. Không dùng kiến thức cũ nếu không chắc.

## Bước 3: Viết bài TIL

**Tạo file:**
```
/Users/dawnnguyen/VSCProject/Cowork-TIL/content/posts/YYYY-MM-DD-til-NNN-slug.md
```

**Front matter bắt buộc:**
```yaml
---
title: "TIL #NNN — [Tiêu đề bài]"
date: YYYY-MM-DD
tags: ["tag1", "tag2"]
summary: "Một câu tóm tắt ngắn, hấp dẫn, nêu insight chính."
---
```

**Yêu cầu nội dung:**
- Độ dài: 400–800 chữ tiếng Việt
- Tone: explanatory + pragmatic, trẻ trung, ví dụ gần gũi
- Tác giả: viết từ góc nhìn người học thật sự, ghi cả chỗ sai/nhầm/fail
- Audience: Gen Z, BA/PO/DA, engineers middle-senior

**Cấu trúc gợi ý:**
- `## Bài học hôm nay` — insight chính (1–2 đoạn)
- `## [Tên concept]` — giải thích sâu, có bảng/ví dụ/code nếu phù hợp
- `## Điều tôi hiểu nhầm` hoặc `## Fail Wall` — honest reflection
- `## Takeaway` — 1–2 câu kết luận actionable
- Kết bài bằng 1 câu preview ngắn cho bài tiếp theo

## Bước 4: Cập nhật curriculum.md

File: `/Users/dawnnguyen/VSCProject/Cowork-TIL/curriculum.md`

Đổi `⏳` thành `✅` cho topic vừa viết, thêm ngày publish.
Ví dụ: `- ✅ **#002** (2026-04-29) — Sessions & Ephemeral State...`

## Bước 5: Báo cáo

Thông báo cho user:
- Tên file đã tạo
- Tóm tắt 1–2 câu nội dung bài
- Nhắc nhở: "macOS LaunchAgent sẽ tự push lúc 7:30 AM"

---

## Thông tin repo

- Repo local: `/Users/dawnnguyen/VSCProject/Cowork-TIL`
- GitHub: `https://github.com/DawnHNguuyen/cowork-til`
- Branch: `main`
- Blog live: `https://DawnHNguuyen.github.io/cowork-til/`
- Push: tự động bởi `scripts/auto-push.sh` lúc 7:30 AM hàng ngày

---

## Format tên file

```
YYYY-MM-DD-til-NNN-ten-bai-viet-thuong-khong-dau.md
```

Ví dụ:
- `2026-04-28-til-001-cowork-la-gi.md`
- `2026-04-29-til-002-sessions-ephemeral-state.md`
