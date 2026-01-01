const db = require('../config/database');

class Jadwal {
  static async create(data) {
    const { hari, jam, mata_pelajaran, guru, kelas } = data;
    const result = await db.run(
      'INSERT INTO jadwal (hari, jam, mata_pelajaran, guru, kelas) VALUES (?, ?, ?, ?, ?)',
      [hari, jam, mata_pelajaran, guru, kelas]
    );
    return { id: result.lastID, ...data };
  }

  static async getAll() {
    return db.all('SELECT * FROM jadwal ORDER BY hari, jam');
  }

  static async getById(id) {
    return db.get('SELECT * FROM jadwal WHERE id = ?', [id]);
  }

  static async update(id, data) {
    const { hari, jam, mata_pelajaran, guru, kelas } = data;
    await db.run(
      'UPDATE jadwal SET hari = ?, jam = ?, mata_pelajaran = ?, guru = ?, kelas = ? WHERE id = ?',
      [hari, jam, mata_pelajaran, guru, kelas, id]
    );
    return { id, ...data };
  }

  static async delete(id) {
    const res = await db.run('DELETE FROM jadwal WHERE id = ?', [id]);
    return { deleted: res.changes };
  }
}

module.exports = Jadwal;
