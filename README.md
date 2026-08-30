# Flutter Template

قالب Flutter جاهز للبدء بمشروع ، مبني على Clean Architecture مع Cubit و GetIt.

## البنية

```
lib/
├── main.dart                 # نقطة الدخول
├── app_root.dart             # MaterialApp + Bloc + الترجمة
├── injection_container.dart  # DI المركزي
├── core/                     # شبكة، أخطاء، تخزين، خدمات
├── app/                      # ثيم، ويدجتس، تنقل، ترجمة
│   └── shared/               # طبقة مشتركة بين الفيتشرز
└── features/
    └── startup/              # إعدادات أولية (لغة، ثيم، شبكة)
```

## ما يوفره القالب

- **Clean Architecture**: Entity / Repository / UseCase / Cubit
- **DI**: GetIt مع `injection_container` لكل feature
- **الشبكة**: Dio مع interceptors (auth، تحديث التطبيق، logging)
- **التخزين**: SharedPreferences + Secure Storage
- **الترجمة**: JSON (`assets/lang/ar.json`, `en.json`)
- **الثيم**: Light / Dark مع ألوان مخصصة
- **ويدجتس جاهزة**: أزرار، حقول، dialogs، صور، shimmer...

## البدء

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## إضافة Feature جديد

1. أنشئ مجلد تحت `lib/features/<feature_name>/`
2. أضف `data/`, `domain/`, `presentation/`
3. أنشئ `injection_container.dart` للفيتشر
4. سجّله في `lib/injection_container.dart`
5. أضف المسارات في `app/navigation/app_router.dart`

## إعدادات مهمة قبل الإنتاج

| الملف | الغرض |
|-------|--------|
| `lib/app/config/app_config.dart` | Base URL وبيئة التشغيل |
| `lib/app/config/app_strings.dart` | اسم التطبيق وروابط المتاجر |
| `lib/injection_container.dart` | تفعيل Firebase عند الحاجة |
| `android/app/google-services.json` | Firebase Android |
| `ios/Runner/GoogleService-Info.plist` | Firebase iOS |

## Bundle ID

`com.example.untitled` — Android و iOS

## الاختبارات

```bash
flutter test
```
