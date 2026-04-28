---
title: "TIL #001 — Cowork là gì, và tại sao tôi dùng nó để tự học chính nó"
date: 2026-04-24
tags: ["cowork", "getting-started", "meta"]
summary: "Ngày đầu tiên với Cowork: tôi đã hiểu sai hoàn toàn Cowork là gì, rồi nhận ra đây không phải một chat app — đây là một agent với tay chân."
---

## Bài học hôm nay

Hôm nay tôi setup cái blog này. Và setup blog bằng Cowork **chính là bài học đầu tiên về Cowork**.

Vừa làm vừa học. Không cần tutorial dài 2 tiếng. Cứ bắt tay vào là hiểu.

---

## Cowork là gì — theo cách tôi hiểu sau ngày đầu tiên

**Một dòng:** Cowork là một AI agent chạy trên desktop, có thể đọc/ghi file, chạy code, và thực hiện task tự động theo lịch.

Trước khi dùng, tôi nghĩ Cowork chỉ là "Claude nhưng có giao diện đẹp hơn". Sai hoàn toàn.

Sự khác biệt cốt lõi:

| Điểm so sánh | Claude web chat | Cowork |
|---|---|---|
| Tương tác | Hỏi → trả lời | Hỏi → agent **hành động** |
| File | Không có | Đọc/ghi file trên máy bạn |
| Tự động | Không | Có scheduled task |
| Code | Hiển thị | **Chạy thật** |

---

## Mô hình tôi đang dùng

```
[Mỗi sáng - Scheduled Task]
Agent đọc curriculum.md
→ Viết bài TIL mới vào content/posts/
→ git clone repo + commit + push
→ GitHub Actions build Hugo
→ GitHub Pages deploy
→ Tôi mở blog lên đọc
```

Toàn bộ pipeline này chạy **không cần tôi động tay**. Tôi chỉ cần Mac không ngủ.

---

## Điều tôi hiểu nhầm ban đầu

**Nhầm #1: Cowork nhớ mọi thứ giữa các session**

Không. Mỗi session Cowork là ephemeral — agent không nhớ conversation trước. Nhưng file trên disk thì persist. Nên mọi "bộ nhớ" của agent phải được lưu vào file (như `curriculum.md`, `AGENT_PROMPT.md`).

> 💡 Mental model đúng: Agent = stateless worker. GitHub repo = persistent memory.

**Nhầm #2: Cần cài Hugo local để preview**

Không cần. GitHub Actions lo việc build. Agent chỉ cần push markdown lên là xong. Tôi không cần cài thêm gì cả.

**Nhầm #3: Fine-grained PAT cần nhiều permission**

Chỉ cần đúng một permission: **Contents: Read and Write**. Không cần gì thêm.

---

## Setup hôm nay — những gì thực sự xảy ra

1. Tôi paste context vào Cowork session mới
2. Agent hỏi GitHub username và tình trạng PAT
3. Agent generate toàn bộ cấu trúc repo Hugo
4. Tôi push lên GitHub, enable Pages, merge lần đầu
5. GitHub Actions chạy, blog live

Tổng thời gian từ zero đến có blog: **~30 phút**.

Phần mất thời gian nhất: hiểu PAT permission. Phần nhanh nhất: agent viết code.

---

## Takeaway

Cowork không phải tool để hỏi đáp. Cowork là tool để **giao việc**.

Sự khác biệt quan trọng: khi bạn nói với Cowork "tạo file này và push lên GitHub", nó **thực sự làm**. Không phải giải thích cách làm. Làm luôn.

Ngày mai: tôi sẽ tìm hiểu scheduled task hoạt động như thế nào — cụ thể là cái gì trigger nó, và tại sao Mac phải awake.
