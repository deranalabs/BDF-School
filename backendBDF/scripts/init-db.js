const bcrypt = require('bcryptjs');
const { pool } = require('../config/database');

const tables = [
  `
  CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT DEFAULT 'admin',
    full_name TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    language TEXT DEFAULT 'id',
    dark_mode BOOLEAN DEFAULT FALSE,
    email_notif BOOLEAN DEFAULT TRUE,
    push_notif BOOLEAN DEFAULT FALSE,
    daily_digest BOOLEAN DEFAULT FALSE,
    employee_id TEXT,
    join_date TEXT,
    status TEXT DEFAULT 'Aktif',
    avatar TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  `,
  `
  CREATE TABLE IF NOT EXISTS siswa (
    id SERIAL PRIMARY KEY,
    nama TEXT NOT NULL,
    nis TEXT UNIQUE NOT NULL,
    kelas TEXT NOT NULL,
    jurusan TEXT NOT NULL,
    alamat TEXT,
    no_telp TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  `,
  `
  CREATE TABLE IF NOT EXISTS tugas (
    id SERIAL PRIMARY KEY,
    judul TEXT NOT NULL,
    deskripsi TEXT,
    deadline TEXT NOT NULL,
    kelas TEXT NOT NULL,
    guru TEXT NOT NULL,
    status TEXT DEFAULT 'aktif',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  `,
  `
  CREATE TABLE IF NOT EXISTS jadwal (
    id SERIAL PRIMARY KEY,
    hari TEXT NOT NULL,
    jam TEXT NOT NULL,
    mata_pelajaran TEXT NOT NULL,
    guru TEXT NOT NULL,
    kelas TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  `,
  `
  CREATE TABLE IF NOT EXISTS presensi (
    id SERIAL PRIMARY KEY,
    siswa_id INTEGER NOT NULL REFERENCES siswa(id) ON DELETE CASCADE,
    tanggal TEXT NOT NULL,
    status TEXT NOT NULL,
    keterangan TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  `,
  `
  CREATE TABLE IF NOT EXISTS nilai (
    id SERIAL PRIMARY KEY,
    siswa_id INTEGER NOT NULL REFERENCES siswa(id) ON DELETE CASCADE,
    mata_pelajaran TEXT NOT NULL,
    tugas REAL NOT NULL,
    uts REAL NOT NULL,
    uas REAL NOT NULL,
    semester TEXT NOT NULL,
    tahun_ajaran TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  `,
  `
  CREATE TABLE IF NOT EXISTS pengumuman (
    id SERIAL PRIMARY KEY,
    judul TEXT NOT NULL,
    isi TEXT NOT NULL,
    pengirim TEXT NOT NULL,
    prioritas TEXT DEFAULT 'medium',
    tanggal TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );
  `,
];

async function ensureAdmin() {
  const res = await pool.query('SELECT id FROM users WHERE username = $1 LIMIT 1', ['admin']);
  if (res.rowCount === 0) {
    const hashedPassword = await bcrypt.hash('admin123', 10);
    await pool.query(
      'INSERT INTO users (username, password, role) VALUES ($1, $2, $3)',
      ['admin', hashedPassword, 'admin']
    );
    console.log('Admin user created (username: admin, password: admin123)');
  } else {
    console.log('Admin user already exists');
  }
}

async function initDatabase() {
  try {
    for (const sql of tables) {
      await pool.query(sql);
    }
    console.log('Tables ensured (Postgres)');
    await ensureAdmin();
    console.log('Database initialization completed successfully!');
  } catch (err) {
    console.error('Database initialization failed:', err);
    process.exit(1);
  }
}

initDatabase();
