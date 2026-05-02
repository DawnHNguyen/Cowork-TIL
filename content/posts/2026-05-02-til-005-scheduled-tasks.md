---
title: "TIL #005 — Scheduled Tasks: cơ chế, limitations, và tại sao Mac phải awake"
date: 2026-05-02
tags: ["cowork", "scheduled-tasks", "automation", "macos", "workflow"]
summary: "Scheduled task là cách để agent tự chạy việc mỗi ngày — nhưng nó không phải cron job, và nếu Mac ngủ thì agent cũng ngủ theo."
---

## Bài học hôm nay

Bốn bài trước, mỗi lần muốn agent làm gì, tôi phải mở Cowork, gõ yêu cầu, chờ kết quả. Hôm nay tôi học cách **giao việc một lần, agent tự chạy mỗi ngày** — đó là Scheduled Tasks.

Ý tưởng nghe rất đẹp: viết instruction một lần, chọn lịch chạy (hàng ngày, hàng tuần, theo giờ), rồi cứ để agent lo. Thực tế thì... gần đúng vậy, nhưng có vài cái bẫy mà tôi phải đạp lên trước khi nó chạy trơn tru.

---

## Cách tạo Scheduled Task

Trong Cowork, bạn gõ `/schedule` vào thanh chat. Agent sẽ hỏi bạn vài câu: task làm gì, chạy khi nào, output ra đâu. Sau khi bạn confirm, nó tạo một file SKILL.md chứa toàn bộ instruction — và từ đó, mỗi lần đến giờ, Cowork tự mở một session mới và chạy task đó.

Các cadence có sẵn: **daily** (mỗi ngày), **weekdays** (thứ 2–6), **weekly** (mỗi tuần), **hourly** (mỗi giờ), hoặc **on demand** (chạy tay khi cần).

Điều quan trọng: mỗi lần chạy là một **session hoàn toàn mới**. Agent không nhớ lần chạy trước (nhớ bài #002 về ephemeral state chứ?). Mọi context cần thiết phải nằm trong file instruction. Đây là lý do instruction cho scheduled task phải cụ thể hơn nhiều so với chat thường — vì không có ai online để agent hỏi lại.

---

## Cơ chế bên dưới: không phải cron

Nếu bạn là dân dev, bạn có thể nghĩ scheduled task giống cron job trên server. Không phải. Cơ chế hoạt động:

1. Claude Desktop app giữ danh sách các scheduled tasks và thời gian chạy tiếp theo
2. Khi đến giờ, app tạo một session Cowork mới
3. Session này chạy với đầy đủ quyền: tất cả skills, plugins, connectors mà bạn đã cài
4. Kết quả được ghi ra file hoặc gửi qua connector (Slack, Notion, Gmail...) tùy instruction

Điểm mấu chốt: **tất cả chạy trên máy bạn, trong app Claude Desktop**. Không có server nào của Anthropic giữ lịch chạy hộ bạn. Đây vừa là ưu điểm (data không rời máy) vừa là nhược điểm lớn nhất — mà tôi sẽ nói ngay dưới đây.

---

## Limitation lớn nhất: Mac phải awake

Đây là thứ tôi mất nửa ngày mới hiểu. Scheduled task **chỉ chạy khi**:

- Mac đang thức (không sleep)
- App Claude Desktop đang mở

Nếu Mac sleep hoặc app đóng lúc đến giờ chạy → task bị skip. Khi Mac thức lại hoặc app được mở lại, Cowork sẽ **chạy bù** task đã bị miss — nhưng lúc đó có thể đã muộn nếu bạn cần output đúng 7 giờ sáng.

Ví dụ thực tế: tôi set task chạy lúc 7:00 AM mỗi ngày để viết blog post. Ngày đầu tiên, tôi gập laptop lúc 11 giờ đêm. Sáng mở ra lúc 8:30 — task chạy lúc 8:30 thay vì 7:00. Không sai, nhưng nếu tôi cần kết quả trước 8 giờ thì đã trễ rồi.

### Cách giữ Mac thức

Cowork có sẵn setting **"Keep computer awake"** trong Settings → Desktop app → General. Bật lên thì khi Claude Desktop đang mở, Mac sẽ không tự sleep do idle.

Nếu muốn kiểm soát chính xác hơn (kiểu chỉ giữ thức từ 6 AM đến 9 AM), dân dev có thể dùng `caffeinate` — một tool có sẵn trên macOS:

```bash
# Giữ Mac thức 3 tiếng (10800 giây)
caffeinate -i -t 10800
```

Hoặc tạo một LaunchAgent để tự chạy caffeinate vào giờ cố định. Nhưng thành thật mà nói, nếu bạn không phải dev thì cứ bật "Keep computer awake" là đủ — đừng overthink.

---

## Fail Wall

**Fail #1: Viết instruction quá vắn tắt**

Lần đầu tạo scheduled task, tôi viết: "Mỗi sáng, viết một bài TIL và lưu vào repo." Agent chạy, tạo ra một bài hoàn toàn generic, không đúng format, không đúng folder, title bằng tiếng Anh. Tôi quên mất: scheduled task chạy trong session mới, không có context từ conversation trước. Phải viết instruction chi tiết, chỉ rõ đường dẫn, format, ngôn ngữ, persona — mọi thứ.

**Fail #2: Quên rằng agent cần network cho một số task**

Tôi muốn scheduled task tự push code lên GitHub. Nhưng sandbox của Cowork không có network access ra ngoài theo kiểu đó. Task chạy, làm mọi thứ đúng, đến bước `git push` thì fail im lặng. Giải pháp: tách phần cần network ra ngoài — dùng macOS LaunchAgent hoặc cron job riêng cho git push.

**Fail #3: Nghĩ agent nhớ lần chạy trước**

Tôi viết task "tiếp tục từ hôm qua". Agent không biết hôm qua làm gì. Mỗi lần chạy là session mới. Muốn agent biết hôm qua làm gì thì phải cho nó đọc file — ví dụ đọc curriculum.md để biết bài nào đã viết rồi (chính xác là cách blog này vận hành).

---

## Takeaway

Scheduled Tasks biến Cowork từ "trả lời khi được hỏi" thành "tự làm việc theo lịch" — nhưng nó chạy trên máy bạn, phụ thuộc vào Mac thức và app mở. Viết instruction cho scheduled task phải cụ thể gấp đôi instruction thường, vì agent chạy một mình không hỏi lại được.

Công thức: **bật "Keep computer awake" + viết instruction chi tiết + đọc file thay vì dựa vào memory = scheduled task chạy ổn**.

Ngày mai: Skills trong Cowork là gì và tại sao chúng tồn tại — bài #006 sẽ mở ra Phase 2, nơi agent bắt đầu thay bạn làm việc với file Office.
