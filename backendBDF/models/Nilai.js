const db = require('../config/database');

class Nilai {
  static async create(data) {
    const { siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'INSERT INTO nilai (siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran],
        function(err) {
          if (err) reject(err);
          else resolve({ id: this.lastID, ...data });
        }
      );
    });
  }

  static async getAll(siswa_id, semester, tahun_ajaran) {
    let query = 'SELECT n.*, s.nama as nama_siswa, s.nis, s.kelas FROM nilai n JOIN siswa s ON n.siswa_id = s.id';
    let params = [];
    
    if (siswa_id) {
      query += ' WHERE n.siswa_id = ?';
      params.push(siswa_id);
    }
    
    if (semester) {
      query += params.length > 0 ? ' AND n.semester = ?' : ' WHERE n.semester = ?';
      params.push(semester);
    }
    
    if (tahun_ajaran) {
      query += params.length > 0 ? ' AND n.tahun_ajaran = ?' : ' WHERE n.tahun_ajaran = ?';
      params.push(tahun_ajaran);
    }
    
    query += ' ORDER BY s.nama, n.mata_pelajaran';
    
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
        'SELECT n.*, s.nama as nama_siswa, s.nis, s.kelas FROM nilai n JOIN siswa s ON n.siswa_id = s.id WHERE n.id = ?',
        [id],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  static async update(id, data) {
    const { siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran } = data;
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE nilai SET siswa_id = ?, mata_pelajaran = ?, tugas = ?, uts = ?, uas = ?, semester = ?, tahun_ajaran = ? WHERE id = ?',
        [siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran, id],
        function(err) {
          if (err) reject(err);
          else resolve({ id, ...data });
        }
      );
    });
  }

  static async delete(id) {
    return new Promise((resolve, reject) => {
      db.run('DELETE FROM nilai WHERE id = ?', [id], function(err) {
        if (err) reject(err);
        else resolve({ deleted: this.changes });
      });
    });
  }

  static async getRapor(siswa_id, semester, tahun_ajaran) {
    return new Promise((resolve, reject) => {
      db.all(
        'SELECT n.*, (n.tugas * 0.3 + n.uts * 0.3 + n.uas * 0.4) as total FROM nilai n WHERE n.siswa_id = ? AND n.semester = ? AND n.tahun_ajaran = ? ORDER BY n.mata_pelajaran',
        [siswa_id, semester, tahun_ajaran],
        (err, rows) => {
          if (err) reject(err);
          else resolve(rows);
        }
      );
    });
  }
}

module.exports = Nilai;
