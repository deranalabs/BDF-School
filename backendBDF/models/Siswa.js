const db = require('../config/database');

class Siswa {
  static async create(data) {
    const { nama, nis, kelas, jurusan, alamat, no_telp } = data;
    const result = await db.run(
      'INSERT INTO siswa (nama, nis, kelas, jurusan, alamat, no_telp) VALUES (?, ?, ?, ?, ?, ?)',
      [nama, nis, kelas, jurusan, alamat, no_telp]
    );
    return { id: result.lastID, ...data };
  }

  static async getAll() {
    const query = `
      SELECT s.*,
             COALESCE(COUNT(DISTINCT n.mata_pelajaran), 0) AS mapel_count
      FROM siswa s
      LEFT JOIN nilai n ON n.siswa_id = s.id
      GROUP BY s.id
      ORDER BY s.nama
    `;
    return db.all(query);
  }

  static async getById(id) {
    return db.get('SELECT * FROM siswa WHERE id = ?', [id]);
  }

  static async update(id, data) {
    const { nama, nis, kelas, jurusan, alamat, no_telp } = data;
    await db.run(
      'UPDATE siswa SET nama = ?, nis = ?, kelas = ?, jurusan = ?, alamat = ?, no_telp = ? WHERE id = ?',
      [nama, nis, kelas, jurusan, alamat, no_telp, id]
    );
    return { id, ...data };
  }

  static async delete(id) {
    const res = await db.run('DELETE FROM siswa WHERE id = ?', [id]);
    return { deleted: res.changes };
  }
}

module.exports = Siswa;
