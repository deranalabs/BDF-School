const db = require('../config/database');

class Jadwal {
  static async create(data) {
    const { hari, jam, mata_pelajaran, guru, kelas } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO jadwal (hari, jam, mata_pelajaran, guru, kelas) VALUES (?, ?, ?, ?, ?)',
        [hari, jam, mata_pelajaran, guru, kelas],
        function(err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, ...data });
        }
      );
    });
  }

  static async getAll() {
    return new Promise((resolve, reject) => {
      db.all('SELECT * FROM jadwal ORDER BY hari, jam', (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }

  static async getById(id) {
    return new Promise((resolve, reject) => {
      db.get('SELECT * FROM jadwal WHERE id = ?', [id], (err, row) => {
        if (err) reject(err);
        else resolve(row);
      });
    });
  }

  static async update(id, data) {
    const { hari, jam, mata_pelajaran, guru, kelas } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE jadwal SET hari = ?, jam = ?, mata_pelajaran = ?, guru = ?, kelas = ? WHERE id = ?',
        [hari, jam, mata_pelajaran, guru, kelas, id],
        function(err) {
          if (err) reject(err);
          else resolve({ id, ...data });
        }
      );
    });
  }

  static async delete(id) {
    return new Promise((resolve, reject) => {
      db.run('DELETE FROM jadwal WHERE id = ?', [id], function(err) {
        if (err) reject(err);
        else resolve({ deleted: this.changes });
      });
    });
  }
}

module.exports = Jadwal;
