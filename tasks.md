# Tasks

## Completed
- Login & session: BASE_URL via `.env`, token disimpan/verifikasi; dashboard tampil setelah login.
- Dashboard data: fetch `/api/siswa`, `/api/tugas`, `/api/pengumuman`, `/api/presensi` via ApiClient dengan token.
- Logout: sidebar menutup drawer, hapus sesi, kembali ke `LoginScreen`.
- Backend: server Express jalan (port 3000), CORS pakai `ALLOWED_ORIGINS`, DB SQLite ter-init, admin demo `admin/admin123`.
- README: sudah berisi langkah run backend/frontend dan kredensial demo.
- Dashboard: error state + tombol retry jika fetch data gagal; status HTTP non-200 diperlakukan sebagai error.
- API endpoints tervalidasi via curl: auth, jadwal, presensi, siswa, nilai, tugas, pengumuman.

## Pending / To Do
- Tambah origin lain ke `ALLOWED_ORIGINS` jika akses dari device/host berbeda.
- (Opsional) Tambah seed data contoh (siswa/jadwal/tugas) untuk demo.

## Planning (step-by-step)
- Backend
  - [x] Pastikan `.env` berisi `PORT`, `ALLOWED_ORIGINS`, `JWT_SECRET`; jalankan backend `npm start`.
  - [x] Uji payload JSON valid pada POST/PUT (hindari string ter-escape) untuk mencegah `Unexpected token` di body-parser.
  - [x] Tes minimal endpoint (curl):
    - [x] `/api/auth/login`
    - [x] `/api/jadwal`
    - [x] `/api/presensi`
    - [x] `/api/siswa`
    - [x] `/api/nilai`
    - [x] `/api/tugas`
    - [x] `/api/pengumuman`
- Auth & Session
  - [x] Login: simpan token di SharedPreferences, set `isAuthenticated`.
  - [x] Restore: `GET /api/auth/verify` saat app start; gagal → hapus token, kembali ke login.
  - [x] Logout: clear token, reset state, ke `LoginScreen`.
- Dashboard
  - [x] Fetch paralel: `/api/siswa`, `/api/tugas`, `/api/pengumuman`, `/api/presensi`; tampilkan total dan tangani error parsial.
- Page CRUD
  - [x] Jadwal: GET/POST/PUT/DELETE `/api/jadwal`.
  - [x] Presensi: GET (opsional `?tanggal=`)/POST/PUT/DELETE `/api/presensi`.
  - [x] Siswa: GET/POST/PUT/DELETE `/api/siswa`.
  - [x] Nilai: GET `/api/siswa`; CRUD `/api/nilai`.
  - [x] Tugas: GET/POST/PUT/DELETE `/api/tugas`.
  - [x] Pengumuman: GET `/api/pengumuman`, `/latest`; CRUD `/api/pengumuman`.
- Profil/Pengaturan (opsional)
  - [ ] GET/PUT `/api/profile`; [ ] POST `/api/auth/change-password`.
