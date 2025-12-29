const express = require('express');
const router = express.Router();
const Nilai = require('../models/Nilai');

// GET all nilai
router.get('/', async (req, res) => {
  try {
    const list = await Nilai.getAll();
    res.json({ success: true, data: list });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// GET nilai by ID
router.get('/:id', async (req, res) => {
  try {
    const item = await Nilai.getById(req.params.id);
    if (!item) {
      return res.status(404).json({ success: false, message: 'Nilai not found' });
    }
    res.json({ success: true, data: item });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// POST new nilai
router.post('/', async (req, res) => {
  try {
    const { siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran } = req.body;
    if (!siswa_id || !mata_pelajaran || tugas == null || uts == null || uas == null || !semester || !tahun_ajaran) {
      return res.status(400).json({ success: false, message: 'siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran required' });
    }

    const created = await Nilai.create({ siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran });
    res.status(201).json({ success: true, message: 'Nilai created successfully', data: created });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// PUT update nilai
router.put('/:id', async (req, res) => {
  try {
    const { siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran } = req.body;
    if (!siswa_id || !mata_pelajaran || tugas == null || uts == null || uas == null || !semester || !tahun_ajaran) {
      return res.status(400).json({ success: false, message: 'siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran required' });
    }

    const updated = await Nilai.update(req.params.id, { siswa_id, mata_pelajaran, tugas, uts, uas, semester, tahun_ajaran });
    if (!updated) {
      return res.status(404).json({ success: false, message: 'Nilai not found' });
    }
    res.json({ success: true, message: 'Nilai updated successfully', data: updated });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// DELETE nilai
router.delete('/:id', async (req, res) => {
  try {
    const deleted = await Nilai.delete(req.params.id);
    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Nilai not found' });
    }
    res.json({ success: true, message: 'Nilai deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

module.exports = router;