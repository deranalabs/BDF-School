const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, '..', 'database.sqlite');

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error opening database:', err.message);
  } else {
    console.log('Connected to SQLite database');
  }
});

// Aktifkan foreign key
db.run('PRAGMA foreign_keys = ON');

// Pastikan kolom profil/pengaturan tambahan ada di tabel users
const requiredColumns = [
  { name: 'full_name', type: 'TEXT' },
  { name: 'email', type: 'TEXT' },
  { name: 'phone', type: 'TEXT' },
  { name: 'address', type: 'TEXT' },
  { name: 'language', type: "TEXT DEFAULT 'id'" },
  { name: 'dark_mode', type: 'INTEGER DEFAULT 0' },
  { name: 'email_notif', type: 'INTEGER DEFAULT 1' },
  { name: 'push_notif', type: 'INTEGER DEFAULT 0' },
  { name: 'daily_digest', type: 'INTEGER DEFAULT 0' },
  { name: 'employee_id', type: 'TEXT' },
  { name: 'join_date', type: 'TEXT' },
  { name: 'status', type: "TEXT DEFAULT 'Aktif'" },
];

// Pastikan tabel tugas memiliki kolom status
const tugasRequiredColumns = [
  { name: 'status', type: "TEXT DEFAULT 'aktif'" },
];

// Pastikan tabel siswa memiliki kolom alamat & no_telp
const siswaRequiredColumns = [
  { name: 'alamat', type: 'TEXT' },
  { name: 'no_telp', type: 'TEXT' },
];

db.serialize(() => {
  db.all("PRAGMA table_info('users')", (err, rows) => {
    if (err) {
      console.error('Error reading users table info:', err.message);
      return;
    }
    const existing = rows.map((r) => r.name);
    requiredColumns.forEach((col) => {
      if (!existing.includes(col.name)) {
        const alterSql = `ALTER TABLE users ADD COLUMN ${col.name} ${col.type}`;
        db.run(alterSql, (alterErr) => {
          if (alterErr) {
            console.error(`Failed to add column ${col.name}:`, alterErr.message);
          } else {
            console.log(`Added missing column to users: ${col.name}`);
          }
        });
      }
    });
  });

  db.all("PRAGMA table_info('siswa')", (err, rows) => {
    if (err) {
      console.error('Error reading siswa table info:', err.message);
      return;
    }
    const existing = rows.map((r) => r.name);
    siswaRequiredColumns.forEach((col) => {
      if (!existing.includes(col.name)) {
        const alterSql = `ALTER TABLE siswa ADD COLUMN ${col.name} ${col.type}`;
        db.run(alterSql, (alterErr) => {
          if (alterErr) {
            console.error(`Failed to add column ${col.name} to siswa:`, alterErr.message);
          } else {
            console.log(`Added missing column to siswa: ${col.name}`);
          }
        });
      }
    });
  });

  db.all("PRAGMA table_info('tugas')", (err, rows) => {
    if (err) {
      console.error('Error reading tugas table info:', err.message);
      return;
    }
    const existing = rows.map((r) => r.name);
    tugasRequiredColumns.forEach((col) => {
      if (!existing.includes(col.name)) {
        const alterSql = `ALTER TABLE tugas ADD COLUMN ${col.name} ${col.type}`;
        db.run(alterSql, (alterErr) => {
          if (alterErr) {
            console.error(`Failed to add column ${col.name} to tugas:`, alterErr.message);
          } else {
            console.log(`Added missing column to tugas: ${col.name}`);
          }
        });
      }
    });
  });
});

module.exports = db;
