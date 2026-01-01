const express = require('express');
const router = express.Router();
const Jadwal = require('../models/Jadwal');
const authMiddleware = require('../middleware/auth');

// Lindungi semua rute jadwal (wajib JWT)
router.use(authMiddleware);

// Ambil semua data jadwal
router.get('/', async (req, res) => {
  try {
    const jadwal = await Jadwal.getAll();
    res.json({ success: true, data: jadwal });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Ambil detail jadwal berdasarkan ID
router.get('/:id', async (req, res) => {
  try {
    const item = await Jadwal.getById(req.params.id);
    if (!item) {
      return res.status(404).json({ success: false, message: 'Jadwal not found' });
    }
    res.json({ success: true, data: item });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Buat jadwal baru
router.post('/', async (req, res) => {
  try {
    const { mapel, mata_pelajaran, kelas, guru, hari, jam_mulai, jam_selesai } = req.body;
    const mp = mata_pelajaran || mapel;
    if (!mp || !kelas || !guru || !hari || !jam_mulai || !jam_selesai) {
      return res.status(400).json({ success: false, message: 'mata_pelajaran/mapel, kelas, guru, hari, jam_mulai, jam_selesai required' });
    }

    const jam = `${jam_mulai}-${jam_selesai}`;

    const created = await Jadwal.create({ mata_pelajaran: mp, kelas: kelas, guru: guru, hari: hari, jam: jam });
    res.status(201).json({ success: true, message: 'Jadwal created successfully', data: created });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Perbarui jadwal
router.put('/:id', async (req, res) => {
  try {
    const { mapel, mata_pelajaran, kelas, guru, hari, jam_mulai, jam_selesai } = req.body;
    const mp = mata_pelajaran || mapel;
    if (!mp || !kelas || !guru || !hari || !jam_mulai || !jam_selesai) {
      return res.status(400).json({ success: false, message: 'mata_pelajaran/mapel, kelas, guru, hari, jam_mulai, jam_selesai required' });
    }

    const jam = `${jam_mulai}-${jam_selesai}`;

    const updated = await Jadwal.update(req.params.id, { mata_pelajaran: mp, kelas: kelas, guru: guru, hari: hari, jam: jam });
    if (!updated) {
      return res.status(404).json({ success: false, message: 'Jadwal not found' });
    }
    res.json({ success: true, message: 'Jadwal updated successfully', data: updated });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Hapus jadwal
router.delete('/:id', async (req, res) => {
  try {
    const deleted = await Jadwal.delete(req.params.id);
    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Jadwal not found' });
    }
    res.json({ success: true, message: 'Jadwal deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

module.exports = router;
