# Catatan Harian Project

> Aplikasi catatan harian (journaling) Flutter dengan integrasi Firebase, GetX state management, dan Quote of the Day API.

## Overview

**Catatan Harian** adalah aplikasi mobile cross-platform untuk mencatat aktivitas, perasaan, dan momen harian. User dapat menulis jurnal lengkap dengan mood, kategori, dan favorit, lalu melihat distribusi mood dalam tab tersendiri serta melacak entry di kalender.

## Fitur Utama

### Autentikasi
- Register & login dengan email/password
- Login dengan Google (Google Sign-In)
- Forgot password via email reset link
- OTP reset screen sebagai konfirmasi
- Auto-login dengan session persistence
- Auth middleware untuk proteksi route

### Journal CRUD
- **Create**: tulis jurnal dengan judul, content, mood emoji, kategori
- **Read**: list grid 2-kolom dengan card mood-tinted
- **Update**: edit jurnal di Detail screen (dual mode: read/edit)
- **Delete**: hapus dengan konfirmasi dialog
- **Favorite**: toggle bintang favorit
- Validasi: judul & content wajib diisi, max 100/10000 karakter

### Home Screen
- Quote of the Day dinamis dari [quotes.liupurnomo.com](https://quotes.liupurnomo.com/api/quotes/random)
- Fallback teks default jika API gagal
- Search by judul/content/kategori/mood
- Filter: Semua / Terbaru (7 hari) / Favorit / Emoji
- FAB untuk tambah jurnal baru

### Mood Tab
- Summary mood teratas berdasarkan range (Minggu ini / Bulan ini / Semua)
- Distribusi mood dengan progress bar
- List jurnal terurut berdasar mood

### Calendar Tab
- Grid kalender dengan mood emoji di tanggal yang punya entry
- Navigasi bulan (prev/next)
- List preview jurnal per tanggal terpilih

### Profile
- Avatar, nama, email, "Member since"
- Stat: Total Notes, Streak (hari berurutan), Fav Mood
- Edit nama
- Logout
- Hapus akun (cascade hapus semua jurnal)

## Tech Stack

| Layer | Tools |
|-------|-------|
| Framework | Flutter SDK ^3.12.0 |
| State Management | GetX ^4.7.3 |
| Backend | Firebase (Auth, Firestore) |
| Auth | firebase_auth ^6.5.1, google_sign_in ^7.2.0 |
| Database | cloud_firestore ^6.4.1 |
| Typography | google_fonts ^6.2.1 |
| Animation | lottie ^3.3.3 |
| Network | http ^1.2.2 |
| External API | quotes.liupurnomo.com (Quote of the Day) |

## Struktur Project

```
lib/
├── main.dart
├── firebase_options.dart
└── app/
    ├── data/                 # Model & repository
    │   ├── journal_entry.dart
    │   ├── journal_mood.dart
    │   └── journal_repository.dart
    ├── middleware/
    │   └── auth_middleware.dart
    ├── modules/              # GetX MVC modules
    │   ├── splash/
    │   ├── login/
    │   ├── register/
    │   ├── forgot_password/
    │   ├── otp_reset/
    │   ├── home/
    │   ├── create_journal/
    │   ├── detail_journal/
    │   ├── mood/
    │   ├── calendar/
    │   └── profile/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    ├── routes/
    │   ├── app_pages.dart
    │   └── app_routes.dart
    ├── services/
    │   ├── google_auth_service.dart
    │   └── quote_service.dart
    ├── theme/
    │   ├── app_colors.dart
    │   ├── app_spacing.dart
    │   ├── app_theme.dart
    │   └── app_typography.dart
    └── widgets/
        └── stitch_widgets.dart   # Komponen UI reusable
```

## Routes

| Path | View | Middleware |
|------|------|------------|
| `/splash` | SplashView | — |
| `/login` | LoginView | — |
| `/register` | RegisterView | — |
| `/forgot-password` | ForgotPasswordView | — |
| `/otp-reset` | OtpResetView | — |
| `/home` | HomeView | AuthMiddleware |
| `/create-journal` | CreateJournalView | AuthMiddleware |
| `/detail-journal` | DetailJournalView | AuthMiddleware |
| `/mood` | MoodView | AuthMiddleware |
| `/calendar` | CalendarView | AuthMiddleware |
| `/profile` | ProfileView | AuthMiddleware |

## Setup

### Prasyarat
- Flutter SDK ≥ 3.12.0
- Dart SDK ≥ 3.0.0
- Android Studio / Xcode untuk build native
- Akun Firebase

### Instalasi

```bash
# 1. Clone repo
git clone https://github.com/NixRascal/Catatan-harian-project.git
cd Catatan-Harian-Project

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase (akan generate firebase_options.dart)
dart pub global activate flutterfire_cli
flutterfire configure
```

### Firebase Console Setup
1. Buat project di [Firebase Console](https://console.firebase.google.com)
2. Aktifkan **Authentication** → Email/Password & Google sign-in method
3. Buat **Cloud Firestore database**
4. Register app:
   - Android: `com.kelompok6.catatan_harian_project`
   - iOS: `com.kelompok6.catatanHarianProject`
5. Download `google-services.json` ke `android/app/`
6. Download `GoogleService-Info.plist` ke `ios/Runner/`
7. Untuk Google Sign-In Android, tambahkan SHA-1 fingerprint debug & release di project settings

### Firestore Schema

Collection: `journals`

| Field | Type | Keterangan |
|-------|------|------------|
| `userId` | string | UID dari Firebase Auth |
| `title` | string | Judul jurnal |
| `content` | string | Isi jurnal |
| `mood` | string | Emoji mood |
| `moodLabel` | string | Label mood (calm, happy, dll) |
| `category` | string | Personal/Work/Study/dll |
| `tint` | string | Warna card |
| `isFavorite` | bool | Status favorit |
| `createdAt` | timestamp | Timestamp pembuatan |

### Firestore Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /journals/{doc} {
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## Jalankan App

```bash
# Cek device tersedia
flutter devices

# Run di Android emulator / device
flutter run

# Run di device spesifik
flutter run -d emulator-5554

# Hot reload: r | Hot restart: R | Quit: q
```

## Build Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (untuk Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Testing

Skenario functional testing lengkap tersedia di [`testing.md`](./testing.md) — 93 test case mencakup auth, CRUD jurnal, mood, calendar, profile, dan edge cases.

```bash
# Unit & widget test
flutter test

# Analyzer
flutter analyze
```

## API Eksternal

### Quote of the Day
- Endpoint: `GET https://quotes.liupurnomo.com/api/quotes/random`
- Tanpa API key, gratis, response JSON bahasa Indonesia
- Implementasi: `lib/app/services/quote_service.dart`
- Timeout: 8 detik, fallback ke teks default jika gagal

## Konvensi Coding

- **State Management**: GetX MVC (View → Controller → Repository/Service → Firebase)
- **Naming**: Module pakai snake_case folder, class PascalCase
- **Routing**: Definisi di `app_routes.dart`, page di `app_pages.dart`
- **Komponen UI**: Reusable widget di `widgets/stitch_widgets.dart`
- **Theme tokens**: Centralized di `theme/` (colors, spacing, typography)

## Platform Support

- Android (primary)
- iOS (secondary, butuh test di device fisik)
- Windows desktop & Chrome web — tersedia tapi belum dioptimasi

## Kontributor

**Kelompok 6** — Project tugas besar mata kuliah Pemrograman Mobile.

## Lisensi

Project ini dibuat untuk keperluan akademik.

---

**Version**: 1.0.0+1
**Flutter**: ≥ 3.12.0
**Last Updated**: 25 Mei 2026
