const express = require('express');
const router = express.Router();
const Siswa = require('../models/Siswa');
const authMiddleware = require('../middleware/auth');

// Lindungi semua rute siswa (wajib JWT)
router.use(authMiddleware);

// Ambil semua data siswa
router.get('/', async (req, res) => {
  try {
    const siswa = await Siswa.getAll();
    res.json({ success: true, data: siswa });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Ambil detail siswa berdasarkan ID
router.get('/:id', async (req, res) => {
  try {
    const siswa = await Siswa.getById(req.params.id);
    if (!siswa) {
      return res.status(404).json({ success: false, message: 'Siswa not found' });
    }
    res.json({ success: true, data: siswa });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// Buat data siswa baru
router.post('/', async (req, res) => {
  try {
    const { nama, nis, kelas, jurusan, alamat, no_telp } = req.body;
    
    if (!nama || !nis || !kelas || !jurusan || !alamat || !no_telp) {
      return res.status(400).json({ success: false, message: 'Nama, NIS, kelas, jurusan, alamat, dan no_telp wajib diisi' });
    }

    const newSiswa = await Siswa.create({ nama, nis, kelas, jurusan, alamat, no_telp });
    res.status(201).json({ success: true, message: 'Siswa created successfully', data: newSiswa });
  } catch (error) {
    if (error.code === 'SQLITE_CONSTRAINT') {
      return res.status(409).json({ success: false, message: 'NIS sudah digunakan' });
    }
    res.status(500).json({ success: false, message: error.message });
  }
});

// Perbarui data siswa
router.put('/:id', async (req, res) => {
  try {
    const { nama, nis, kelas, jurusan, alamat, no_telp } = req.body;
    
    if (!nama || !nis || !kelas || !jurusan || !alamat || !no_telp) {
      return res.status(400).json({ success: false, message: 'Nama, NIS, kelas, jurusan, alamat, dan no_telp wajib diisi' });
    }

    const updatedSiswa = await Siswa.update(req.params.id, { nama, nis, kelas, jurusan, alamat, no_telp });
    if (!updatedSiswa) {
      return res.status(404).json({ success: false, message: 'Siswa not found' });
    }
    
    res.json({ success: true, message: 'Siswa updated successfully', data: updatedSiswa });
  } catch (error) {
    if (error.code === 'SQLITE_CONSTRAINT') {
      return res.status(409).json({ success: false, message: 'NIS sudah digunakan' });
    }
    res.status(500).json({ success: false, message: error.message });
  }
});

// Hapus data siswa
router.delete('/:id', async (req, res) => {
  try {
    const deleted = await Siswa.delete(req.params.id);
    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Siswa not found' });
    }
    
    res.json({ success: true, message: 'Siswa deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

module.exports = router;
