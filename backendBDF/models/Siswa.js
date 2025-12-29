const db = require('../config/database');

class Siswa {
  static async create(data) {
    const { nama, nis, kelas, jurusan } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO siswa (nama, nis, kelas, jurusan) VALUES (?, ?, ?, ?)',
        [nama, nis, kelas, jurusan],
        function(err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, ...data });
        }
      );
    });
  }

  static async getAll() {
    return new Promise((resolve, reject) => {
      db.all('SELECT * FROM siswa ORDER BY nama', (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }

  static async getById(id) {
    return new Promise((resolve, reject) => {
      db.get('SELECT * FROM siswa WHERE id = ?', [id], (err, row) => {
        if (err) reject(err);
        else resolve(row);
      });
    });
  }

  static async update(id, data) {
    const { nama, nis, kelas, jurusan } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE siswa SET nama = ?, nis = ?, kelas = ?, jurusan = ? WHERE id = ?',
        [nama, nis, kelas, jurusan, id],
        function(err) {
          if (err) reject(err);
          else resolve({ id, ...data });
        }
      );
    });
  }

  static async delete(id) {
    return new Promise((resolve, reject) => {
      db.run('DELETE FROM siswa WHERE id = ?', [id], function(err) {
        if (err) reject(err);
        else resolve({ deleted: this.changes });
      });
    });
  }
}

module.exports = Siswa;
