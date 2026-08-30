# Helm Desk

تطبيق Flutter لموظفي الدعم الفني — واجهة أمامية لـ Helm Desk API.

---

## 1. طريقة تشغيل المشروع

### المتطلبات

- Flutter SDK `^3.9.2`
- Docker (لتشغيل الـ API المحلية)

### تشغيل الـ API

```bash
cd "../task-2-build/track-b-build-the-client"
docker compose up
```

الـ API تعمل على `http://localhost:4000`. التفاصيل الكاملة في [`docs/API_DOCS.md`](docs/API_DOCS.md).

### تشغيل تطبيق Flutter

```bash
flutter pub get
flutter run
```

### إعدادات الاتصال

| البيئة | عنوان الـ API |
|--------|----------------|
| Android Emulator | `http://10.0.2.2:4000` (افتراضي في `AppConfig`) |
| iOS Simulator / macOS | `http://localhost:4000` |

لتغيير العنوان عدّل `lib/app/config/app_config.dart`.

### حسابات الاختبار

| المستخدم | كلمة المرور |
|----------|-------------|
| `dana` | `ticket-desk-1` |
| `omar` | `ticket-desk-2` |
| `rana` | `ticket-desk-3` |
| `faris` | `ticket-desk-4` |
| `nour` | `ticket-desk-5` |

---

## 2. القرارات التقنية والتصميمية

### Architecture

- **Clean Architecture** مقسّمة حسب الميزة (`data` / `domain` / `presentation`).
- **Repository + UseCase** لكل عملية شبكة أو تخزين.
- **GetIt** لتسجيل الخدمات والـ Cubits.
- **Either** (`dartz`) لتمثيل النجاح/الفشل في طبقة الدومين.

### إدارة الحالة

- **Cubit** (`flutter_bloc`) لكل شاشة/ميزة.
- `UsecaseExecutor` داخل Cubits لتنفيذ UseCases مع إدارة loading/success/failure.
- لا يُستخدم `setState` لمنطق UI — الواجهة تُبنى من `BlocBuilder` / `BlocConsumer`.

### API والمصادقة و token refresh

- **Dio** مع سلسلة interceptors:
  - `AppInterceptor` — `Authorization: Bearer`, `Accept-Language`, `X-Platform`, `X-Current-Version`.
  - `RetryInterceptor` — إعادة الطلب عند `429` وفق `Retry-After` (حتى مرتين).
  - `TokenRefreshInterceptor` — عند `401 TOKEN_EXPIRED`: refresh صامت عبر `/auth/refresh` ثم إعادة الطلب الأصلي؛ `Completer` يمنع طلبات refresh متوازية.
  - `AuthInterceptor` — أي `401` غير `TOKEN_EXPIRED`: مسح الجلسة وحوار انتهاء الجلسة ثم التوجيه لتسجيل الدخول.
- الجلسة (`accessToken`, `refreshToken`, `agent`) في **Flutter Secure Storage**؛ اللغة والثيم في **SharedPreferences**.

### Pagination، البحث، والفلاتر

- **Cursor pagination** (`nextCursor`, `limit=25`) في صندوق الوارد مع pull-to-refresh و load-more.
- **بحث** بـ debounce 400ms → معامل `q`.
- **فلاتر**: الحالة (`open` / `pending` / `solved` / الكل) و«بلاغاتي» (`assignee=me`).

### التحديثات الحية (SSE)

- `SseService` singleton يتصل بـ `GET /events` (`text/event-stream`).
- يدعم `Last-Event-ID` وإعادة الاتصال تلقائياً عند انقطاع البث.
- الأحداث:
  - `ticket.updated` — تحديث عنصر في Inbox أو حقول البلاغ في التفاصيل.
  - `ticket.reply` — إضافة رد جديد في شاشة التفاصيل.
- يُوقف البث عند تسجيل الخروج.

### المرفقات

- الرفع عبر `POST /attachments` (base64) ثم إدراج مرجع في نص الرد:
  `[مرفق: filename (at_id)]` — لأن الـ API لا تربط المرفق مباشرة مع الرد.
- `ReplyBodyParser` يستخرج المرفق من نص الرد للعرض.
- عند الإرسال: اختيار صورة من المعرض (`image_picker`)، رفع، وتخزين محلي في `AttachmentCacheService`.
- عند الفتح: محاولة القراءة من الكاش → تحميل عبر `FileDownloadService` → معاينة الصور في dialog أو فتح الملف خارجياً؛ fallback بـ `access_token` في الرابط.

### قرارات أخرى

- **ETag / If-Match** لتحديث الحالة والأولوية؛ عند `409 VERSION_CONFLICT` أو `ALREADY_CLAIMED` يُعرض حوار ويُقدَّم البلاغ المحدَّث للمستخدم.
- **Claim** عبر `POST /tickets/:id/claim`.
- **Localization** عربي/إنجليزي (`assets/lang/`).
- **FailureX** و **LoadingHelper** لعرض الأخطاء والتحميل بشكل موحّد.
- **MainScreenTheme** كغلاف موحّد لكل الشاشات.
- لا يوجد offline cache للبلاغات — الاعتماد على الشبكة والـ SSE.

---

## 3. لو توفّر وقت أطول

- **UX/UI**: تعيين موظف (`assigneeId`)، عرض أسماء الموظفين، تحسين فلاتر Inbox والمحادثة.
- **اختبارات**: unit tests للـ Cubits/UseCases و integration tests للمسارات الحرجة (login, inbox, reply, conflict).
- **أداء**: تحسين إعادة بناء القوائم، lazy loading للردود الطويلة.
- **Offline / errors**: cache للبلاغات المفتوحة، retry ذكي، رسائل خطأ أكثر سياقاً.
- **Technical debt**: تفعيل `getCountryCode` (معلّق حالياً)، دعم أجهزة فعلية بتعديل `baseUrl` ديناميكياً، توسيع تغطية SSE في Inbox لأحداث `ticket.reply`.
