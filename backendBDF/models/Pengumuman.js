const db = require('../config/database');

class Pengumuman {
  static async create(data) {
    const { judul, isi, pengirim, prioritas } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO pengumuman (judul, isi, pengirim, prioritas, tanggal) VALUES (?, ?, ?, ?, datetime("now"))',
        [judul, isi, pengirim, prioritas],
        function(err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, ...data, tanggal: new Date().toISOString() });
        }
      );
    });
  }

  static async getAll() {
    return new Promise((resolve, reject) => {
      db.all('SELECT * FROM pengumuman ORDER BY tanggal DESC', (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }

  static async getById(id) {
    return new Promise((resolve, reject) => {
      db.get('SELECT * FROM pengumuman WHERE id = ?', [id], (err, row) => {
        if (err) reject(err);
        else resolve(row);
      });
    });
  }

  static async update(id, data) {
    const { judul, isi, pengirim, prioritas } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE pengumuman SET judul = ?, isi = ?, pengirim = ?, prioritas = ? WHERE id = ?',
        [judul, isi, pengirim, prioritas, id],
        function(err) {
          if (err) reject(err);
          else resolve({ id, ...data });
        }
      );
    });
  }

  static async delete(id) {
    return new Promise((resolve, reject) => {
      db.run('DELETE FROM pengumuman WHERE id = ?', [id], function(err) {
        if (err) reject(err);
        else resolve({ deleted: this.changes });
      });
    });
  }

  static async getLatest(limit = 5) {
    return new Promise((resolve, reject) => {
      db.all(
        'SELECT * FROM pengumuman ORDER BY tanggal DESC LIMIT ?',
        [limit],
        (err, rows) => {
          if (err) reject(err);
          else resolve(rows);
        }
      );
    });
  }
}

module.exports = Pengumuman;
