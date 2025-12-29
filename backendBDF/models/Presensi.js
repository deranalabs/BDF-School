const db = require('../config/database');

class Presensi {
  static async create(data) {
    const { siswa_id, tanggal, status, keterangan } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO presensi (siswa_id, tanggal, status, keterangan) VALUES (?, ?, ?, ?)',
        [siswa_id, tanggal, status, keterangan],
        function(err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, ...data });
        }
      );
    });
  }

  static async getAll(tanggal) {
    const query = tanggal 
      ? 'SELECT p.*, s.nama as nama_siswa, s.nis FROM presensi p JOIN siswa s ON p.siswa_id = s.id WHERE p.tanggal = ? ORDER BY s.nama'
      : 'SELECT p.*, s.nama as nama_siswa, s.nis FROM presensi p JOIN siswa s ON p.siswa_id = s.id ORDER BY p.tanggal DESC, s.nama';
    const params = tanggal ? [tanggal] : [];
    
    return new Promise((resolve, reject) => {
      db.all(query, params, (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }

  static async getById(id) {
    return new Promise((resolve, reject) => {
      db.get(
        'SELECT p.*, s.nama as nama_siswa, s.nis FROM presensi p JOIN siswa s ON p.siswa_id = s.id WHERE p.id = ?', 
        [id], 
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  static async update(id, data) {
    const { siswa_id, tanggal, status, keterangan } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE presensi SET siswa_id = ?, tanggal = ?, status = ?, keterangan = ? WHERE id = ?',
        [siswa_id, tanggal, status, keterangan, id],
        function(err) {
          if (err) reject(err);
          else resolve({ id, ...data });
        }
      );
    });
  }

  static async delete(id) {
    return new Promise((resolve, reject) => {
      db.run('DELETE FROM presensi WHERE id = ?', [id], function(err) {
        if (err) reject(err);
        else resolve({ deleted: this.changes });
      });
    });
  }

  static async getBySiswa(siswa_id) {
    return new Promise((resolve, reject) => {
      db.all(
        'SELECT * FROM presensi WHERE siswa_id = ? ORDER BY tanggal DESC',
        [siswa_id],
        (err, rows) => {
          if (err) reject(err);
          else resolve(rows);
        }
      );
    });
  }
}

module.exports = Presensi;
