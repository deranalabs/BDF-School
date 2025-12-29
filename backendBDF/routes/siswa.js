const express = require('express');
const router = express.Router();
const Siswa = require('../models/Siswa');

// GET all siswa
router.get('/', async (req, res) => {
  try {
    const siswa = await Siswa.getAll();
    res.json({ success: true, data: siswa });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// GET siswa by ID
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

// POST new siswa
router.post('/', async (req, res) => {
  try {
    const { nama, nis, kelas, jurusan } = req.body;
    
    if (!nama || !nis || !kelas || !jurusan) {
      return res.status(400).json({ success: false, message: 'Nama, NIS, kelas, and jurusan are required' });
    }

    const newSiswa = await Siswa.create({ nama, nis, kelas, jurusan });
    res.status(201).json({ success: true, message: 'Siswa created successfully', data: newSiswa });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// PUT update siswa
router.put('/:id', async (req, res) => {
  try {
    const { nama, nis, kelas, jurusan } = req.body;
    
    if (!nama || !nis || !kelas || !jurusan) {
      return res.status(400).json({ success: false, message: 'Nama, NIS, kelas, and jurusan are required' });
    }

    const updatedSiswa = await Siswa.update(req.params.id, { nama, nis, kelas, jurusan });
    if (!updatedSiswa) {
      return res.status(404).json({ success: false, message: 'Siswa not found' });
    }
    
    res.json({ success: true, message: 'Siswa updated successfully', data: updatedSiswa });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// DELETE siswa
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
