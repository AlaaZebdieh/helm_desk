# Helm Desk

تطبيق Flutter لموظفي الدعم الفني — واجهة أمامية لـ [Helm Desk API](../task-2-build/track-b-build-the-client).

## التشغيل

### 1. تشغيل الـ API

```bash
cd "../task-2-build/track-b-build-the-client"
docker compose up
```

الـ API تعمل على `http://localhost:4000`.

### 2. تشغيل التطبيق

```bash
flutter pub get
flutter run
```

- **Android Emulator**: يتصل تلقائياً عبر `http://10.0.2.2:4000`
- **iOS Simulator / macOS**: `http://localhost:4000`

### حسابات الاختبار

| المستخدم | كلمة المرور |
|----------|-------------|
| `dana` | `ticket-desk-1` |
| `omar` | `ticket-desk-2` |

## الميزات

- تسجيل دخول مع حفظ `accessToken` و `refreshToken`
- تجديد تلقائي عند `401 TOKEN_EXPIRED` مع إعادة الطلب
- صندوق وارد: فلاتر، بحث، pagination (cursor)
- تفاصيل البلاغ: محادثة، claim، تغيير status/priority
- ETag / If-Match مع معالجة `VERSION_CONFLICT` و `ALREADY_CLAIMED`
- رفع مرفقات (base64) مع الرد
- تحديثات حية عبر SSE مع `Last-Event-ID` وإعادة اتصال تلقائية
- إعادة محاولة عند `429` مع `Retry-After`

## القرارات المعمارية

- **Clean Architecture** + **Cubit** + **GetIt** — على نفس قالب المشروع
- `TokenRefreshInterceptor` قبل `AuthInterceptor` — refresh صامت ثم logout عند الفشل
- `SseService` singleton — بث واحد يحدّث Inbox و Detail
- لا offline cache — البساطة أولاً
- المرفقات تُرفع منفصلة ثم تُذكر في نص الرد (الـ API لا تربطهما مباشرة)

## لو توفّر وقت أطول

- شاشة تعيين موظف (`assigneeId`)
- prefetch أسماء الموظفين
- unit/integration tests
- تحسين UI/UX للفلاتر والمحادثة
