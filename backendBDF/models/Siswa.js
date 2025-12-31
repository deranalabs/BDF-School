const db = require('../config/database');

class Siswa {
  static async create(data) {
    const { nama, nis, kelas, jurusan, alamat, no_telp } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO siswa (nama, nis, kelas, jurusan, alamat, no_telp) VALUES (?, ?, ?, ?, ?, ?)',
        [nama, nis, kelas, jurusan, alamat, no_telp],
        function(err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, ...data });
        }
      );
    });
  }

  static async getAll() {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT s.*,
               COALESCE(COUNT(DISTINCT n.mata_pelajaran), 0) AS mapel_count
        FROM siswa s
        LEFT JOIN nilai n ON n.siswa_id = s.id
        GROUP BY s.id
        ORDER BY s.nama
      `;
      db.all(query, (err, rows) => {
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
    const { nama, nis, kelas, jurusan, alamat, no_telp } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE siswa SET nama = ?, nis = ?, kelas = ?, jurusan = ?, alamat = ?, no_telp = ? WHERE id = ?',
        [nama, nis, kelas, jurusan, alamat, no_telp, id],
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
