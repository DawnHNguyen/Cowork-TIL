---
title: "TIL #013 — Bash trong Cowork: agent chạy shell command — và sandbox là gì"
date: 2026-05-12
tags: ["bash", "sandbox", "shell", "automation", "security"]
summary: "Agent không chỉ đọc/ghi file — nó còn có thể chạy shell command trong một môi trường Linux bị cô lập hoàn toàn, và đây là lý do bạn nên biết sandbox hoạt động thế nào."
---

## Bài học hôm nay

Hai bài trước tôi nói về Web Search và Web Fetch — agent tìm kiếm và đọc web. Nhưng hôm nay là lúc mọi thứ trở nên "nguy hiểm" hơn một chút: agent có thể **chạy shell command** trên máy bạn. Cụ thể, Cowork có một bash tool cho phép agent gõ lệnh terminal y như bạn mở Terminal lên gõ tay vậy.

Nghe tới đây chắc nhiều người giật mình: "Agent chạy command trên máy tôi? `rm -rf /` thì sao?" — và đó chính là lý do sandbox tồn tại.

## Bash tool hoạt động thế nào?

Khi Cowork cần chạy code hoặc lệnh shell, nó không chạy trực tiếp trên macOS của bạn. Thay vào đó, mọi thứ chạy trong một **isolated Linux VM** (virtual machine) — một môi trường Ubuntu 22 riêng biệt, tách hoàn toàn khỏi hệ điều hành chính.

Một vài điều quan trọng về môi trường này:

| Đặc điểm | Chi tiết |
|-----------|----------|
| OS | Ubuntu 22 (Linux) |
| Có sẵn | Python, Node.js, npm, pip, các CLI tool phổ biến |
| File access | Chỉ đọc/ghi được folder bạn đã kết nối (mount) |
| Network | Bị hạn chế — không tự do truy cập internet |
| Trạng thái | **Không lưu giữa các lần gọi** — mỗi lệnh bash là independent |

Điểm cuối cùng là cái hay nhất mà cũng khó chịu nhất: **mỗi lần gọi bash là một session riêng**. Nếu bạn `cd /tmp/mydir` ở lệnh thứ nhất, lệnh thứ hai sẽ không ở trong `/tmp/mydir` nữa. Không có cwd carryover, không có env carryover. Mỗi lệnh phải dùng absolute path.

## Sandbox — bức tường bảo vệ bạn

Sandbox trong Cowork được xây trên OS-level primitives:

- **macOS**: Dùng framework **Seatbelt** (TrustedBSD MAC) — cùng cơ chế Apple dùng để lock down Chrome renderer và iOS apps.
- **Linux**: Dùng **bubblewrap** — cùng sandbox mà Flatpak sử dụng cho third-party apps.

Sandbox enforce hai thứ chính:

**1. Filesystem isolation**: Agent chỉ đọc/ghi được folder bạn đã kết nối với Cowork. Folder hệ thống, file config, SSH keys — tất cả đều nằm ngoài tầm với. Và mọi child process cũng bị sandbox luôn. Nếu bash chạy `npm install`, rồi npm chạy postinstall script, rồi script đó gọi `curl` — cả bốn process đều nằm trong cùng một sandbox.

**2. Network isolation**: Truy cập mạng bị kiểm soát qua một proxy server bên ngoài sandbox. Agent không thể tự do gọi API hay download file từ internet mà không qua lớp kiểm soát.

## Ví dụ thực tế: tôi dùng bash để làm gì?

Tôi dùng bash trong Cowork thường xuyên hơn bạn nghĩ. Vài use case thực tế:

```bash
# Cài package Python rồi chạy script xử lý data
pip install pandas --break-system-packages
python3 /sessions/.../mnt/outputs/process_data.py

# List file trong folder đã mount
ls -la /sessions/.../mnt/Cowork-TIL/content/posts/

# Chạy Node script để generate nội dung
node /sessions/.../mnt/outputs/generate.js
```

Lưu ý quan trọng: **đường dẫn trong bash khác với đường dẫn của file tools** (Read/Write/Edit). Ví dụ, folder `/Users/you/Projects/MyApp` trên máy Mac sẽ được mount thành `/sessions/random-name/mnt/MyApp/` trong bash. Đây là nguồn gốc của rất nhiều bug khi tôi mới bắt đầu.

## Điều tôi hiểu nhầm

**Nhầm lẫn 1: "Bash chạy trên máy Mac của mình"**

Sai. Bash chạy trong Linux VM. Nếu bạn nhờ agent chạy `brew install something`, nó sẽ fail vì Linux không có Homebrew. Tôi đã thử chạy `open .` (lệnh mở Finder trên macOS) và nhận được error ngay. Đây là Linux, không phải macOS.

**Nhầm lẫn 2: "Mỗi lệnh bash nối tiếp nhau như terminal thật"**

Sai. Mỗi lần gọi bash tool là một phiên hoàn toàn mới. Bạn `export MY_VAR=hello` ở lệnh 1, lệnh 2 sẽ không biết `MY_VAR` là gì. Giải pháp: gộp nhiều lệnh vào một lần gọi duy nhất bằng `&&` hoặc viết script rồi chạy.

**Nhầm lẫn 3: "Agent có thể pip install thoải mái"**

Đúng một nửa. Pip hoạt động, nhưng phải thêm flag `--break-system-packages` vì môi trường không dùng virtual env mặc định. Tôi quên flag này khoảng 5 lần trước khi nhớ.

## Khi nào nên dùng bash thay vì file tools?

Quy tắc đơn giản:

- **Đọc/ghi file đơn lẻ** → dùng Read/Write/Edit (nhanh hơn, đường dẫn quen thuộc hơn)
- **Cần chạy code** (Python, Node) → dùng bash
- **Cần list directory** → dùng bash (`ls`)
- **Cần xử lý data phức tạp** (parse CSV, generate chart) → dùng bash + Python
- **Cần install package** → dùng bash (`pip install`, `npm install -g`)

Bash là "đôi tay" của agent. File tools là "con mắt và cây bút". Kết hợp cả hai mới ra workflow mạnh.

## Takeaway

Bash tool biến Cowork từ một trợ lý chỉ biết đọc-ghi file thành một agent có thể chạy code, xử lý data, và automate workflow thực sự. Sandbox đảm bảo bạn không cần lo agent phá máy — nhưng bạn cần hiểu rằng đây là Linux VM riêng biệt, không phải terminal Mac của bạn.

Bài tiếp theo: **Artifacts** — live HTML widget mà agent tạo ra có thể tái sử dụng được, một trong những feature "wow" nhất của Cowork.
