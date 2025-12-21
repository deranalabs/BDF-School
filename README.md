# BDF School 📚

Aplikasi Flutter bertema dashboard sekolah bernama **BDF School** yang menghadirkan pengalaman modern untuk siswa. Pengguna dapat masuk menggunakan kredensial demo lalu mengakses beragam modul akademik seperti jadwal, tugas, presensi, nilai, notifikasi, hingga profil siswa.

## ✨ Fitur Utama
1. **Autentikasi demo**: Form login dengan validasi sederhana dan kredensial contoh `admin/admin123` agar mudah diuji @lib/pages/loginscreen.dart#141-299.
2. **Dashboard interaktif**: Menampilkan kartu presensi, statistik pelajaran, jadwal hari ini, daftar tugas, serta pengumuman terbaru dalam satu layar gulir @lib/pages/dashboard_screen.dart#144-333.
3. **Navigasi multi-halaman**: Drawer ke halaman jadwal, tugas, presensi, nilai, pengumuman, hingga profil lengkap siswa @lib/pages/dashboard_screen.dart#147-335.
4. **Notifikasi real-time (mock)**: Daftar notifikasi dengan status terbaca/tidak, badge indikator, dan layar detail khusus @lib/pages/dashboard_screen.dart#22-89.
5. **Tema konsisten**: Pemakaian palet biru modern, font Google Fonts, dan komponen kustom untuk menjaga tampilan profesional @lib/pages/loginscreen.dart#52-318.

## 🧱 Arsitektur Folder
```
bdf_school/
├── lib/
│   ├── main.dart                # Entry point & tema aplikasi
│   └── pages/
│       ├── loginscreen.dart     # Halaman login & kredensial demo
│       ├── dashboard_screen.dart# Dashboard utama & navigasi
│       ├── schedule_screen.dart # Jadwal lengkap
│       ├── tasks_screen.dart    # Daftar tugas detail
│       ├── presence_screen.dart # Presensi siswa
│       ├── grades_screen.dart   # Rekap nilai
│       ├── announcements_screen.dart
│       ├── notifications_screen.dart
│       └── profile_screen.dart  # Profil siswa
├── android/ ios/ macos/ linux/ windows/ web/ # Target platform
├── pubspec.yaml                 # Dependensi & konfigurasi Flutter
└── analysis_options.yaml        # Aturan lint
```

## 🛠️ Teknologi & Dependensi
- **Flutter** SDK ≥ 3.9.2 @pubspec.yaml#21-22
- `google_fonts` untuk tipografi dinamis @pubspec.yaml#37
- `provider` & `shared_preferences` disiapkan untuk manajemen state dan penyimpanan lokal @pubspec.yaml#39-40
- `flutter_svg` untuk dukungan ikon vektor @pubspec.yaml#38

## 🚀 Menjalankan Proyek
1. **Clone repo ini**
   ```bash
   git clone <url-repo-anda> && cd bdf_school
   ```
2. **Pasang dependensi**
   ```bash
   flutter pub get
   ```
3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```
4. **Masuk ke aplikasi**
   - Username: `admin`
   - Password: `admin123`

## 📱 Layar yang Tersedia
| Layar | Deskripsi |
| --- | --- |
| Login | Form autentikasi sederhana dengan tombol CTA gradien @lib/pages/loginscreen.dart#50-244 |
| Dashboard | Ringkasan jadwal, tugas, presensi, dan pengumuman @lib/pages/dashboard_screen.dart#144-333 |
| Tugas | Status tugas berdasarkan deadline @lib/pages/tasks_screen.dart#1-400 |
| Jadwal | Timeline pelajaran mingguan @lib/pages/schedule_screen.dart#1-400 |
| Presensi | Statistik kehadiran siswa @lib/pages/presence_screen.dart#1-400 |
| Nilai | Rekap nilai dan rata-rata per mata pelajaran @lib/pages/grades_screen.dart#1-400 |
| Pengumuman & Notifikasi | Daftar informasi terbaru sekolah @lib/pages/announcements_screen.dart#1-250 @lib/pages/notifications_screen.dart#1-250 |
| Profil | Detail informasi siswa termasuk progres akademik @lib/pages/profile_screen.dart#1-300 |

## 🧪 Rekomendasi Pengembangan Lanjutan
1. **Integrasi backend** untuk menggantikan data statis menjadi data nyata.
2. **Manajemen state** menggunakan `provider` atau `riverpod` untuk data lintas halaman.
3. **Autentikasi aman** (mis. JWT/Firebase Auth).
4. **Unit & widget test** untuk memastikan regresi dapat dicegah.

## 📄 Lisensi
Proyek ini belum memiliki lisensi resmi. Tambahkan lisensi (MIT, Apache 2.0, dsb.) bila ingin mempublikasikan.

---
Dikembangkan sebagai prototipe dashboard BDF School berbasis Flutter. Selamat berkontribusi! 🎉
