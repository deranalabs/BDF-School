const db = require('../config/database');

class Tugas {
  static async create(data) {
    const { judul, deskripsi, deadline, kelas, guru, status = 'aktif' } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO tugas (judul, deskripsi, deadline, kelas, guru, status) VALUES (?, ?, ?, ?, ?, ?)',
        [judul, deskripsi, deadline, kelas, guru, status],
        function(err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, ...data });
        }
      );
    });
  }

  static async getAll() {
    return new Promise((resolve, reject) => {
      db.all('SELECT * FROM tugas ORDER BY deadline ASC', (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }

  static async getById(id) {
    return new Promise((resolve, reject) => {
      db.get('SELECT * FROM tugas WHERE id = ?', [id], (err, row) => {
        if (err) reject(err);
        else resolve(row);
      });
    });
  }

  static async update(id, data) {
    const { judul, deskripsi, deadline, kelas, guru, status } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE tugas SET judul = ?, deskripsi = ?, deadline = ?, kelas = ?, guru = ?, status = ? WHERE id = ?',
        [judul, deskripsi, deadline, kelas, guru, status, id],
        function(err) {
          if (err) reject(err);
          else resolve({ id, ...data });
        }
      );
    });
  }

  static async delete(id) {
    return new Promise((resolve, reject) => {
      db.run('DELETE FROM tugas WHERE id = ?', [id], function(err) {
        if (err) reject(err);
        else resolve({ deleted: this.changes });
      });
    });
  }
}

module.exports = Tugas;
