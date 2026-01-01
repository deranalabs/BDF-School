const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const bcrypt = require('bcryptjs');

const dbPath = path.join(__dirname, '..', 'database.sqlite');

function ensureAvatarColumn(db) {
  return new Promise((resolve, reject) => {
    db.all('PRAGMA table_info(users)', (err, rows) => {
      if (err) {
        console.error('Error reading users schema:', err.message);
        reject(err);
        return;
      }
      const hasAvatar = rows.some((r) => r.name === 'avatar');
      if (hasAvatar) {
        resolve();
        return;
      }
      db.run('ALTER TABLE users ADD COLUMN avatar TEXT', (alterErr) => {
        if (alterErr) {
          console.error('Error adding avatar column:', alterErr.message);
          reject(alterErr);
        } else {
          console.log('Added avatar column to users table');
          resolve();
        }
      });
    });
  });
}

async function initDatabase() {
  return new Promise((resolve, reject) => {
    const db = new sqlite3.Database(dbPath, (err) => {
      if (err) {
        console.error('Error opening database:', err.message);
        reject(err);
        return;
      }
      
      console.log('Connected to SQLite database');

      // Buat tabel users
      db.run(`
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          role TEXT DEFAULT 'admin',
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      `, (err) => {
        if (err) {
          console.error('Error creating users table:', err.message);
          reject(err);
          return;
        }
        console.log('Users table created or already exists');

        ensureAvatarColumn(db)
          .then(() => {
        // Buat tabel siswa
        db.run(`
          CREATE TABLE IF NOT EXISTS siswa (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            nis TEXT UNIQUE NOT NULL,
            kelas TEXT NOT NULL,
            jurusan TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        `, (err) => {
          if (err) {
            console.error('Error creating siswa table:', err.message);
            reject(err);
            return;
          }
          console.log('Siswa table created or already exists');

          // Buat tabel tugas
          db.run(`
            CREATE TABLE IF NOT EXISTS tugas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              judul TEXT NOT NULL,
              deskripsi TEXT,
              deadline TEXT NOT NULL,
              kelas TEXT NOT NULL,
              guru TEXT NOT NULL,
              status TEXT DEFAULT 'aktif',
              created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
              updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
          `, (err) => {
            if (err) {
              console.error('Error creating tugas table:', err.message);
              reject(err);
              return;
            }
            console.log('Tugas table created or already exists');

            // Buat tabel jadwal
            db.run(`
              CREATE TABLE IF NOT EXISTS jadwal (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                hari TEXT NOT NULL,
                jam TEXT NOT NULL,
                mata_pelajaran TEXT NOT NULL,
                guru TEXT NOT NULL,
                kelas TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
              )
            `, (err) => {
              if (err) {
                console.error('Error creating jadwal table:', err.message);
                reject(err);
                return;
              }
              console.log('Jadwal table created or already exists');

              // Buat tabel presensi
              db.run(`
                CREATE TABLE IF NOT EXISTS presensi (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  siswa_id INTEGER NOT NULL,
                  tanggal TEXT NOT NULL,
                  status TEXT NOT NULL,
                  keterangan TEXT,
                  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                  FOREIGN KEY (siswa_id) REFERENCES siswa (id)
                )
              `, (err) => {
                if (err) {
                  console.error('Error creating presensi table:', err.message);
                  reject(err);
                  return;
                }
                console.log('Presensi table created or already exists');

                // Buat tabel nilai
                db.run(`
                  CREATE TABLE IF NOT EXISTS nilai (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    siswa_id INTEGER NOT NULL,
                    mata_pelajaran TEXT NOT NULL,
                    tugas REAL NOT NULL,
                    uts REAL NOT NULL,
                    uas REAL NOT NULL,
                    semester TEXT NOT NULL,
                    tahun_ajaran TEXT NOT NULL,
                    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (siswa_id) REFERENCES siswa (id)
                  )
                `, (err) => {
                  if (err) {
                    console.error('Error creating nilai table:', err.message);
                    reject(err);
                    return;
                  }
                  console.log('Nilai table created or already exists');

                  // Buat tabel pengumuman
                  db.run(`
                    CREATE TABLE IF NOT EXISTS pengumuman (
                      id INTEGER PRIMARY KEY AUTOINCREMENT,
                      judul TEXT NOT NULL,
                      isi TEXT NOT NULL,
                      pengirim TEXT NOT NULL,
                      prioritas TEXT DEFAULT 'medium',
                      tanggal DATETIME DEFAULT CURRENT_TIMESTAMP,
                      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
                    )
                  `, (err) => {
                    if (err) {
                      console.error('Error creating pengumuman table:', err.message);
                      reject(err);
                      return;
                    }
                    console.log('Pengumuman table created or already exists');

                    // Periksa apakah user admin sudah ada
                    db.get(
                      'SELECT * FROM users WHERE username = ?',
                      ['admin'],
                      async (err, row) => {
                        if (err) {
                          console.error('Error checking admin user:', err.message);
                          reject(err);
                          return;
                        }

                        if (!row) {
                          // Buat user admin
                          try {
                            const hashedPassword = await bcrypt.hash('admin123', 10);
                            db.run(
                              'INSERT INTO users (username, password, role) VALUES (?, ?, ?)',
                              ['admin', hashedPassword, 'admin'],
                              function(err) {
                                if (err) {
                                  console.error('Error creating admin user:', err.message);
                                  reject(err);
                                } else {
                                  console.log('Admin user created (username: admin, password: admin123)');
                                  console.log('Database initialization completed successfully!');
                                  resolve();
                                }
                              }
                            );
                          } catch (error) {
                            console.error('Error hashing password:', error);
                            reject(error);
                          }
                        } else {
                          console.log('Admin user already exists');
                          console.log('Database initialization completed successfully!');
                          resolve();
                        }
                      }
                    );
                  });
                });
              });
            });
          });
        });
          })
          .catch((err) => {
            console.error('Initialization halted:', err.message);
            reject(err);
          });
      });
    });
  });
}

initDatabase().catch(err => {
  console.error('Database initialization failed:', err);
  process.exit(1);
});
