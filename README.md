# BDF School

Aplikasi Flutter untuk manajemen sekolah (admin) dengan fitur jadwal, presensi, nilai, tugas, pengumuman, daftar siswa, profil, dan pengaturan. Sudah dilengkapi toast/snackbar feedback lintas platform.

## Teknologi
- Flutter
- Provider (state auth)
- Fluttertoast (hanya Android/iOS, desktop pakai SnackBar)

## Menjalankan (End-to-End)
### 1) Backend (Node + SQLite)
```bash
cd backendBDF
npm install
npm run init-db   # buat/seed database & admin default (admin/admin123)
npm start         # jalankan API di port 3000
```
- Env backend (`backendBDF/.env`):
  - `PORT=3000`
  - `JWT_SECRET=<isi_secret_kuat>`
  - `DB_PATH=./database.sqlite`
  - `ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000` (tambahkan origin lain jika perlu, pisah koma)

### 2) Frontend (Flutter)
```bash
flutter pub get
flutter test       # optional
flutter run -d <device_id>
```
- Env frontend (`.env` di root proyek):
  - `BASE_URL=http://127.0.0.1:3000` (ubah ke host/IP backend yang bisa diakses device)
- Pastikan backend sudah jalan sebelum login di app.

### Kredensial demo
- admin / admin123

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