---
title: "TIL #033 — Cowork + KMP: generate boilerplate, docs, test tự động"
date: 2026-06-11
tags: ["kmp", "kotlin-multiplatform", "cowork", "boilerplate", "testing", "documentation", "workflow"]
summary: "Cowork có thể generate expect/actual boilerplate, viết KDoc, và scaffold test cho KMP project — nhưng bạn phải biết cách prompt đúng, không thì agent sẽ tạo ra code trông đẹp nhưng compile fail."
---

## Bài học hôm nay

Kotlin Multiplatform (KMP) là framework tuyệt vời — share business logic giữa Android, iOS, desktop, web. Nhưng ai đã dùng KMP đều biết: **boilerplate nhiều kinh khủng**. Mỗi lần thêm một feature mới vào shared module, bạn phải tạo expect declaration trong `commonMain`, rồi viết actual implementation cho `androidMain`, `iosMain`, có khi cả `desktopMain`. Cùng một interface, lặp đi lặp lại, chỉ khác phần platform-specific.

Hôm nay tôi thử dùng Cowork để automate phần nhàm chán đó. Kết quả: **tiết kiệm được ~60% thời gian setup**, nhưng cũng gặp vài cú fail đáng nhớ.

## Ba workflow thực tế

### 1. Generate expect/actual boilerplate

Đây là use case rõ nhất. Giả sử tôi cần một `PlatformLogger` — interface log khác nhau trên mỗi platform. Thay vì tự gõ, tôi bảo Cowork:

> "Tạo expect class PlatformLogger trong commonMain với 3 method: debug, info, error. Mỗi method nhận message: String. Tạo actual implementation cho androidMain dùng android.util.Log và iosMain dùng NSLog. Follow KMP project structure mới với shared module tách riêng."

Agent sẽ tạo ra 3 file:
- `shared/src/commonMain/kotlin/PlatformLogger.kt` — expect declaration
- `shared/src/androidMain/kotlin/PlatformLogger.kt` — actual với `android.util.Log`
- `shared/src/iosMain/kotlin/PlatformLogger.kt` — actual với `NSLog` qua Kotlin/Native interop

Điểm quan trọng: **phải nói rõ platform API muốn dùng**. Nếu không, agent sẽ đoán — và đoán sai. Lần đầu tôi không specify, agent tạo actual cho iOS bằng `println()` thay vì `NSLog`. Compile thì pass, nhưng vô nghĩa vì `println()` trên iOS không ra Xcode console.

### 2. Auto-generate KDoc documentation

KMP code thường thiếu documentation vì dev đã mệt với boilerplate rồi, không ai muốn viết thêm KDoc. Cowork giúp được:

> "Đọc tất cả file .kt trong shared/src/commonMain, thêm KDoc cho mỗi public class và public function. Giải thích purpose, params, return value, và ghi chú platform behavior nếu là expect declaration."

Agent sẽ scan code, hiểu context từ function name và implementation, rồi thêm KDoc block. Ví dụ:

```kotlin
/**
 * Platform-specific logger that routes messages 
 * to the native logging system.
 *
 * On Android: uses [android.util.Log]
 * On iOS: uses NSLog via Kotlin/Native interop
 *
 * @see PlatformLogger for expect declaration
 */
actual class PlatformLogger { ... }
```

Trick ở đây: **bảo agent đọc cả actual implementations** trước khi viết KDoc cho expect declaration. Nếu chỉ đọc expect, agent sẽ viết documentation chung chung kiểu "platform-specific implementation" mà không nói cụ thể mỗi platform làm gì.

### 3. Scaffold test trong commonTest

KMP cho phép viết shared test trong `commonTest` — test chạy trên tất cả platform targets. Đây là chỗ Cowork tỏa sáng:

> "Đọc file NetworkRepository.kt trong commonMain. Tạo unit test trong commonTest dùng kotlin.test framework. Cover happy path, error case, và edge case cho mỗi public function. Mock dependencies bằng interface, không dùng thư viện mock external."

Agent tạo ra test file với `@Test` annotation, `assertEquals`, `assertFailsWith`. Phần hay: agent hiểu rằng trong `commonTest` không nên dùng Mockito (JVM-only) hay Mockative (cần KSP setup) mà nên dùng **manual fake/stub qua interface** — cách portable nhất.

Nếu code dùng coroutines, prompt thêm:

> "Dùng kotlinx-coroutines-test, wrap test body trong runTest {}."

## Điều tôi hiểu nhầm

**Sai lầm 1: Nghĩ agent hiểu KMP project structure mặc định.**

KMP vừa đổi default project structure ở KotlinConf'26 — shared module giờ tách riêng khỏi app module (do AGP 9.0 không cho dùng `com.android.application` chung với KMP plugin nữa). Agent không tự biết bạn dùng structure cũ hay mới. Phải nói rõ: "project dùng structure mới với separate shared module" hoặc "project dùng composeApp module kiểu cũ."

**Sai lầm 2: Expect agent viết code compile-ready.**

Cowork chạy trong sandbox Linux — không có Android SDK, không có Xcode, không có Gradle. Agent **không thể compile check** code Kotlin. Nó viết dựa trên training data và web search. Nên luôn coi output là draft — paste vào IDE, chạy Gradle sync, fix lỗi. Thường thì fix nhỏ: sai import path, thiếu dependency declaration trong `build.gradle.kts`.

**Sai lầm 3: Tạo quá nhiều file trong một prompt.**

Lần đầu tôi bảo agent "tạo expect/actual cho 5 class cùng lúc", output bị lộn xộn — file path sai, actual class bị đặt nhầm source set. Chia nhỏ: **1 expect/actual pair per prompt** cho kết quả tốt nhất.

## Takeaway

Cowork không thay thế IDE cho KMP development — nhưng nó là **pre-processor tuyệt vời**. Dùng nó để generate boilerplate skeleton, viết documentation draft, và scaffold test structure. Sau đó đưa vào IDE để polish. Rule of thumb: **nếu bạn đang copy-paste code giữa source sets và chỉ đổi tên platform API, đó là việc nên delegate cho agent.**

Bài tiếp theo: **Cowork + Notion — xây second brain tự động**, nơi agent đọc/ghi Notion database để tổng hợp kiến thức hàng ngày.
