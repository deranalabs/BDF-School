# BDF School Backend (Express + Postgres)

## Setup
1) Install dependencies
```bash
npm install
```
2) Siapkan `.env` (contoh singkat):
```env
NODE_ENV=development
PORT=3000
JWT_SECRET=your_strong_jwt_secret_here
DATABASE_URL=postgresql://postgres:password@host:port/railway
ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
# Optional override (berguna jika env mengabaikan DATABASE_URL)
PGHOST=host
PGPORT=port
PGUSER=postgres
PGPASSWORD=password
PGDATABASE=railway
```
3) Inisialisasi skema Postgres:
```bash
npm run init-db
```
4) Jalankan:
```bash
npm start
```
App menampilkan env, port, dan daftar endpoint saat start.

## Auth
- Login: `POST /api/auth/login` → JWT
- Register: `POST /api/auth/register`
- Verify: `GET /api/auth/verify`
- Sertakan header `Authorization: Bearer <token>` ke semua endpoint lain.

## Endpoint
- Auth: `/api/auth/*`
- Siswa: `/api/siswa`
- Tugas: `/api/tugas`
- Jadwal: `/api/jadwal`
- Presensi: `/api/presensi`
- Pengumuman: `/api/pengumuman`
- Nilai: `/api/nilai`
- Profil: `/api/profile`

## Uji cepat (local)
```bash
TOKEN=$(curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' | jq -r '.token')
curl -H "Authorization: Bearer $TOKEN" http://localhost:3000/api/auth/verify
curl -X POST http://localhost:3000/api/siswa \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"nama":"Budi","nis":"S100","kelas":"10A","jurusan":"IPA","alamat":"Jl. A","no_telp":"0811"}'
```

## Skema ringkas
- users: username, password (hash), role, profil (full_name, email, phone, address, language, dark_mode, notif, employee_id, join_date, status)
- siswa: nama, nis (unik), kelas, jurusan, alamat, no_telp
- tugas: judul, deskripsi, deadline, kelas, guru, status
- jadwal: hari, jam ("mulai-selesai"), mata_pelajaran, guru, kelas
- presensi: siswa_id, tanggal, status (Hadir/Izin/Sakit/Alpha), keterangan
- nilai: siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran
- pengumuman: judul, isi, pengirim, prioritas (low/medium/high), tanggal

## Catatan
- DB: Postgres (via `pg`), init dengan `npm run init-db`
- Keamanan: helmet + rate limit + trust proxy (untuk deploy di Railway/proxy)
- Semua route CRUD dilindungi JWT