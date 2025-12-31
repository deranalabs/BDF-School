const express = require('express');
const router = express.Router();
const Presensi = require('../models/Presensi');
const authMiddleware = require('../middleware/auth');

// Lindungi semua rute presensi (wajib JWT)
router.use(authMiddleware);

// Ambil semua data presensi (opsional filter tanggal)
router.get('/', async (req, res) => {
  try {
    const { tanggal } = req.query;
    const presensi = await Presensi.getAll(tanggal);
    res.json({
      success: true,
      data: presensi
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Ambil detail presensi berdasarkan ID
router.get('/:id', async (req, res) => {
  try {
    const presensi = await Presensi.getById(req.params.id);
    if (!presensi) {
      return res.status(404).json({
        success: false,
        message: 'Presensi not found'
      });
    }
    res.json({
      success: true,
      data: presensi
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Ambil daftar presensi berdasarkan siswa
router.get('/siswa/:siswa_id', async (req, res) => {
  try {
    const presensi = await Presensi.getBySiswa(req.params.siswa_id);
    res.json({
      success: true,
      data: presensi
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Buat presensi baru
router.post('/', async (req, res) => {
  try {
    const { siswa_id, tanggal, status, keterangan } = req.body;
    
    if (!siswa_id || !tanggal || !status) {
      return res.status(400).json({
        success: false,
        message: 'Siswa ID, tanggal, and status are required'
      });
    }

    if (!['Hadir', 'Izin', 'Sakit', 'Alpha'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Status must be: Hadir, Izin, Sakit, or Alpha'
      });
    }

    const presensi = await Presensi.create({ 
      siswa_id, 
      tanggal, 
      status, 
      keterangan: keterangan || '' 
    });
    res.status(201).json({
      success: true,
      message: 'Presensi created successfully',
      data: presensi
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Perbarui presensi
router.put('/:id', async (req, res) => {
  try {
    const { siswa_id, tanggal, status, keterangan } = req.body;
    
    if (!siswa_id || !tanggal || !status) {
      return res.status(400).json({
        success: false,
        message: 'Siswa ID, tanggal, and status are required'
      });
    }

    if (!['Hadir', 'Izin', 'Sakit', 'Alpha'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Status must be: Hadir, Izin, Sakit, or Alpha'
      });
    }

    const presensi = await Presensi.update(req.params.id, { 
      siswa_id, 
      tanggal, 
      status, 
      keterangan: keterangan || '' 
    });
    res.json({
      success: true,
      message: 'Presensi updated successfully',
      data: presensi
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Hapus presensi
router.delete('/:id', async (req, res) => {
  try {
    const result = await Presensi.delete(req.params.id);
    if (result.deleted === 0) {
      return res.status(404).json({
        success: false,
        message: 'Presensi not found'
      });
    }
    res.json({
      success: true,
      message: 'Presensi deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

module.exports = router;
