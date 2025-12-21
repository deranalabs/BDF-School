# Project Tasks

## High Priority
1. **Role-Based Authentication**
   - Implement backend role handling (`student`, `teacher`).
   - Update login flow to return role and permissions.
   - Add Flutter guards + navigation differences for each role.
2. **Guru Dashboard Features**
   - Input/update nilai per mata pelajaran.
   - Presensi validation & manual overrides.
   - Broadcast pengumuman/tools untuk guru.
3. **Data Sync & Security**
   - Secure token storage + refresh flow.
   - Audit logging for guru/admin actions.

## Medium Priority
1. **Offline-Friendly Enhancements**
   - Cache jadwal, nilai, pengumuman untuk akses tanpa koneksi.
   - Background sync + conflict handling.
2. **Notifications**
   - Push notifications untuk tugas/penilaian baru.
   - Per-role notification rules.
3. **UI Polish**
   - Dedicated screens for guru (list siswa, tugas, nilai).
   - Improve responsive layouts (tablet/web).

## Low Priority / Future
1. **Analytics & Insights**
   - Learning progress charts per siswa.
   - Guru dashboards dengan ringkasan kelas.
2. **Integrations**
   - Kalender sekolah (ICS/Google Calendar export).
   - Payment/administrative modules.

## Notes
- Keep backend contracts documented via OpenAPI.
- Maintain migration scripts for database schema changes.
- Ensure Flutter tests cover role-based routing & repository logic.
