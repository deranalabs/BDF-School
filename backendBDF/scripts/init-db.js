const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const bcrypt = require('bcryptjs');

const dbPath = path.join(__dirname, '..', 'database.sqlite');

async function initDatabase() {
  return new Promise((resolve, reject) => {
    const db = new sqlite3.Database(dbPath, (err) => {
      if (err) {
        console.error('Error opening database:', err.message);
        reject(err);
        return;
      }
      
      console.log('Connected to SQLite database');

      // Create users table
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

        // Check if admin user exists
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
              // Create admin user
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
}

initDatabase().catch(err => {
  console.error('Database initialization failed:', err);
  process.exit(1);
});
