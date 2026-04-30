---
title: "TIL #003 — Workspace & Files: agent đọc/ghi file trên máy bạn như thế nào"
date: 2026-04-30
tags: ["cowork", "workspace", "files", "file-access", "sandbox"]
summary: "Agent có thể đọc và ghi file trên máy bạn — nhưng chỉ trong folder bạn cho phép, và cơ chế bên dưới không đơn giản như bạn nghĩ."
---

## Bài học hôm nay

Hôm qua tôi rút ra quy tắc vàng: "nếu agent cần biết → ghi ra file." Nghe hay đấy, nhưng hôm nay mới là lúc tìm hiểu *cơ chế thực sự* — agent đọc file bằng gì, ghi file ở đâu, và tại sao có lúc nó thấy file, có lúc nó không thấy gì.

Spoiler: mọi thứ xoay quanh một khái niệm đơn giản nhưng dễ hiểu nhầm — **workspace folder**.

---

## Workspace folder là gì

Khi bạn mở Cowork, Claude sẽ hỏi bạn chọn một folder trên máy. Đây không phải bước trang trí — nó là **ranh giới** cho mọi thứ agent được phép làm với file system của bạn.

Hình dung thế này: bạn đang cho một người lạ (rất giỏi) ngồi vào bàn làm việc. Thay vì đưa chìa khóa toàn bộ nhà, bạn chỉ mở **đúng 1 phòng** và nói "làm việc trong này". Folder bạn chọn chính là "phòng" đó.

Sau khi chọn folder:
- Agent **đọc** được mọi file trong folder đó (và subfolder)
- Agent **tạo mới, sửa, ghi** file vào folder đó
- Agent **không** đọc được file ngoài folder (trừ file bạn upload trực tiếp vào chat)

Nếu bạn không chọn folder nào? Agent vẫn chạy được, nhưng chỉ làm việc trong một thư mục tạm (outputs directory). File ở đó sẽ bị xóa giữa các session — giống ephemeral state mà tôi nói hôm qua.

---

## Ba "vùng" file bạn cần phân biệt

Đây là chỗ tôi bị rối nhất, nên vẽ lại thành bảng cho rõ:

| Vùng | Đường dẫn | Persist không? | Agent ghi được? | Ghi chú |
|---|---|---|---|---|
| **Workspace folder** | Folder bạn chọn khi mở Cowork | Có — trên disk thật | Có | Đây là "sân nhà" |
| **Outputs directory** | Thư mục tạm của session | Không — xóa khi session kết thúc | Có | Agent dùng làm nháp |
| **Uploads** | File bạn kéo thả vào chat | Có (bản gốc trên máy) | Không (read-only) | Agent chỉ đọc, không sửa file gốc |

Quy tắc đơn giản: **muốn giữ file → ghi vào workspace folder. Muốn thử nghiệm → ghi vào outputs. Upload chỉ để đọc.**

---

## File tools: Read, Write, Edit

Bên dưới, agent không dùng `cat` hay `vim` để đọc/ghi file. Nó có 3 tool chuyên dụng:

**Read** — đọc nội dung file. Agent đưa đường dẫn tuyệt đối, tool trả về nội dung kèm số dòng. Đọc được text, code, ảnh (PNG, JPG), PDF, cả Jupyter notebook. Nhưng Read chỉ đọc file, không đọc thư mục — muốn xem danh sách file thì phải dùng shell command `ls`.

**Write** — ghi toàn bộ nội dung vào file. Nếu file đã tồn tại thì ghi đè. Tool này dùng khi tạo file mới hoặc viết lại hoàn toàn.

**Edit** — thay thế một đoạn text cụ thể trong file. Thay vì ghi đè cả file, Edit chỉ gửi "diff" — đoạn cũ và đoạn mới. Nhanh hơn, an toàn hơn, và ít rủi ro mất nội dung hơn Write.

Có một rule quan trọng: **agent phải Read file trước khi Edit**. Nếu chưa đọc mà sửa, tool sẽ báo lỗi. Nghe phiền, nhưng logic: bạn không nên sửa thứ bạn chưa nhìn thấy.

---

## Sandbox: cái hộp cát agent chạy code

Ngoài file tools, agent còn có quyền chạy shell command trong một **Linux sandbox** — một môi trường cách ly chạy Ubuntu, có Python, Node.js, và các CLI tool cơ bản.

Điểm cần chú ý: đường dẫn trong sandbox **khác** đường dẫn file tools. Ví dụ, workspace folder của bạn ở `/Users/ban/MyProject` trong file tools, nhưng trong sandbox nó được mount ở một path khác kiểu `/sessions/.../mnt/MyProject/`. Agent phải "dịch" path khi chuyển giữa hai thế giới.

Mỗi lần gọi bash cũng là **độc lập** — không giữ lại working directory hay biến môi trường từ lần trước. Nghĩa là `cd /some/dir` ở lần gọi thứ nhất, sang lần gọi thứ hai agent lại quay về thư mục mặc định.

---

## Fail Wall

**Fail #1: Quên chọn folder, rồi thắc mắc file đi đâu**

Lần đầu dùng Cowork, tôi skip bước chọn folder vì nghĩ "để sau cũng được". Agent vẫn tạo file ngon lành, tôi thấy nó báo "đã tạo report.docx" — nhưng tìm trên máy không thấy. Hóa ra file nằm trong outputs directory, session kết thúc là bay. Từ đó tôi luôn chọn folder trước khi làm bất cứ gì.

**Fail #2: Nghĩ agent sửa trực tiếp file upload**

Tôi upload một file Word vào chat, bảo "sửa lỗi chính tả giúp". Agent sửa xong, giao file mới — nhưng file gốc trên máy tôi vẫn y nguyên. Upload là **read-only copy**. Agent đọc bản copy, tạo file mới trong workspace, chứ không chạm vào file gốc.

**Fail #3: Dùng đường dẫn tương đối**

Tôi viết instruction "đọc file `curriculum.md`" — agent không tìm được. Phải ghi **đường dẫn tuyệt đối** hoặc ít nhất chỉ rõ folder nào. File tools không hiểu "ở đây" là đâu trừ khi bạn nói rõ.

---

## Takeaway

Workspace folder là **hợp đồng tin tưởng** giữa bạn và agent. Bạn chọn folder nào thì agent chỉ làm việc trong đó — không hơn, không kém. Hiểu ba vùng (workspace, outputs, uploads) giúp bạn không bao giờ mất file hay thắc mắc "nó lưu ở đâu rồi".

Quy tắc: **chọn folder trước, hỏi sau. File quan trọng → workspace. File nháp → outputs. File gửi cho agent đọc → upload.**

Ngày mai: cách viết instruction cho agent sao cho nó hiểu đúng ý bạn — không thừa, không thiếu, không mơ hồ. Bài #004: Instruction Writing 101.
