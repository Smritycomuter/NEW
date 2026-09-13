# Online Complaint App

বাংলা ভাষার একটি Flutter ভিত্তিক অনলাইন অপরাধ অভিযোগ অ্যাপের ডেমো।

## চালানোর নিয়ম

1. Flutter SDK ইনস্টল করুন।
2. এই ফোল্ডার খুলুন।
3. `flutter pub get`
4. `flutter run`

Android APK বানাতে:

`flutter build apk --release`

APK সাধারণত পাওয়া যাবে:

`build/app/outputs/flutter-apk/app-release.apk`

## গুরুত্বপূর্ণ

বর্তমান সংস্করণটি UI/demo। Complaint ID লোকালি তৈরি হয় এবং ডেটা কোনো সার্ভারে পাঠানো হয় না।

Production version-এর জন্য যোগ করতে হবে:
- Firebase বা PHP/Node.js backend
- MySQL/Firestore database
- User authentication
- Evidence/file upload
- Admin dashboard
- Complaint status workflow
- HTTPS
- Server-side validation
- Role-based access control
- Audit logs
- Privacy policy ও data retention rules

## Codemagic build fix

This project includes `codemagic.yaml`. During the Codemagic build it automatically
runs `flutter create --platforms=android .` before building, which creates the
required Android project files if the `android/` folder is missing.

For an installable APK, use the **android-debug** workflow. The generated APK will
appear under the Codemagic build artifacts.
