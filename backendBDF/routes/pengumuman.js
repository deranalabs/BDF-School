const express = require('express');
const router = express.Router();
const Pengumuman = require('../models/Pengumuman');
const authMiddleware = require('../middleware/auth');

// Lindungi semua rute pengumuman (wajib JWT)
router.use(authMiddleware);

// Ambil semua pengumuman
router.get('/', async (req, res) => {
  try {
    const pengumuman = await Pengumuman.getAll();
    res.json({
      success: true,
      data: pengumuman
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Ambil pengumuman terbaru
router.get('/latest', async (req, res) => {
  try {
    const { limit = 5 } = req.query;
    const pengumuman = await Pengumuman.getLatest(parseInt(limit));
    res.json({
      success: true,
      data: pengumuman
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Ambil detail pengumuman berdasarkan ID
router.get('/:id', async (req, res) => {
  try {
    const pengumuman = await Pengumuman.getById(req.params.id);
    if (!pengumuman) {
      return res.status(404).json({
        success: false,
        message: 'Pengumuman not found'
      });
    }
    res.json({
      success: true,
      data: pengumuman
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Buat pengumuman baru
router.post('/', async (req, res) => {
  try {
    const { judul, isi, pengirim, prioritas } = req.body;
    
    if (!judul || !isi || !pengirim) {
      return res.status(400).json({
        success: false,
        message: 'Judul, isi, and pengirim are required'
      });
    }

    if (!['low', 'medium', 'high'].includes(prioritas)) {
      return res.status(400).json({
        success: false,
        message: 'Prioritas must be: low, medium, or high'
      });
    }

    const pengumuman = await Pengumuman.create({ 
      judul, 
      isi, 
      pengirim, 
      prioritas: prioritas || 'medium' 
    });
    res.status(201).json({
      success: true,
      message: 'Pengumuman created successfully',
      data: pengumuman
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Perbarui pengumuman
router.put('/:id', async (req, res) => {
  try {
    const { judul, isi, pengirim, prioritas } = req.body;
    
    if (!judul || !isi || !pengirim) {
      return res.status(400).json({
        success: false,
        message: 'Judul, isi, and pengirim are required'
      });
    }

    if (!['low', 'medium', 'high'].includes(prioritas)) {
      return res.status(400).json({
        success: false,
        message: 'Prioritas must be: low, medium, or high'
      });
    }

    const pengumuman = await Pengumuman.update(req.params.id, { 
      judul, 
      isi, 
      pengirim, 
      prioritas: prioritas || 'medium' 
    });
    res.json({
      success: true,
      message: 'Pengumuman updated successfully',
      data: pengumuman
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Hapus pengumuman
router.delete('/:id', async (req, res) => {
  try {
    const result = await Pengumuman.delete(req.params.id);
    if (result.deleted === 0) {
      return res.status(404).json({
        success: false,
        message: 'Pengumuman not found'
      });
    }
    res.json({
      success: true,
      message: 'Pengumuman deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

module.exports = router;
