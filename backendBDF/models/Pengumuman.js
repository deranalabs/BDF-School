const db = require('../config/database');

class Pengumuman {
  static async create(data) {
    const { judul, isi, pengirim, prioritas } = data;
    const result = await db.run(
      'INSERT INTO pengumuman (judul, isi, pengirim, prioritas, tanggal) VALUES (?, ?, ?, ?, NOW())',
      [judul, isi, pengirim, prioritas || 'medium']
    );
    return { id: result.lastID, ...data, prioritas: prioritas || 'medium', tanggal: new Date().toISOString() };
  }

  static async getAll() {
    return db.all('SELECT * FROM pengumuman ORDER BY tanggal DESC');
  }

  static async getById(id) {
    return db.get('SELECT * FROM pengumuman WHERE id = ?', [id]);
  }

  static async update(id, data) {
    const { judul, isi, pengirim, prioritas } = data;
    await db.run(
      'UPDATE pengumuman SET judul = ?, isi = ?, pengirim = ?, prioritas = ? WHERE id = ?',
      [judul, isi, pengirim, prioritas || 'medium', id]
    );
    return { id, judul, isi, pengirim, prioritas: prioritas || 'medium' };
  }

  static async delete(id) {
    const res = await db.run('DELETE FROM pengumuman WHERE id = ?', [id]);
    return { deleted: res.changes };
  }

  static async getLatest(limit = 5) {
    return db.all('SELECT * FROM pengumuman ORDER BY tanggal DESC LIMIT ?', [limit]);
  }
}

module.exports = Pengumuman;
