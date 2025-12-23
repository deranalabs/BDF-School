# BDF School

Aplikasi Flutter untuk manajemen sekolah (admin) dengan fitur jadwal, presensi, nilai, tugas, pengumuman, daftar siswa, profil, dan pengaturan. Sudah dilengkapi toast/snackbar feedback lintas platform.

## Teknologi
- Flutter
- Provider (state auth)
- Fluttertoast (hanya Android/iOS, desktop pakai SnackBar)

## Menjalankan
```bash
flutter pub get
flutter test
flutter run -d <device_id>
```

## Struktur utama
- `lib/main.dart` — entry app.
- `lib/state/auth_controller.dart` — autentikasi & session.
- `lib/utils/feedback.dart` — helper showFeedback (toast/snackbar).
- `lib/pages/`:
  - `auth/login_screen.dart`
  - `dashboard/` (+sidebar)
  - `jadwal/`, `presensi/`, `nilai/`, `tugas/`, `pengumuman/`, `siswa/`, `profile/`, `pengaturan/`

## Feedback (toast/snackbar)
- `showFeedback` otomatis pilih Fluttertoast (Android/iOS) atau SnackBar (desktop).
- Sudah dipasang di login/logout, dialog simpan jadwal, presensi (status/catatan/rekap), nilai, tugas, pengumuman, tambah siswa, profil, pengaturan.

## Testing & Lint
```bash
flutter test
flutter analyze
```

## Catatan Navigasi
Urutan sidebar: Dashboard (0), Jadwal (1), Presensi (2), Nilai (3), Tugas (4), Pengumuman (5), Daftar Siswa (6), Profil (7), Pengaturan (8).