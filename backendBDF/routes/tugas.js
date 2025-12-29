const express = require('express');
const router = express.Router();
const Tugas = require('../models/Tugas');

// GET all tugas
router.get('/', async (req, res) => {
  try {
    const tugas = await Tugas.getAll();
    res.json({
      success: true,
      data: tugas
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// GET tugas by ID
router.get('/:id', async (req, res) => {
  try {
    const tugas = await Tugas.getById(req.params.id);
    if (!tugas) {
      return res.status(404).json({
        success: false,
        message: 'Tugas not found'
      });
    }
    res.json({
      success: true,
      data: tugas
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// POST create tugas
router.post('/', async (req, res) => {
  try {
    const { judul, deskripsi, deadline, kelas, guru } = req.body;
    
    if (!judul || !deadline || !kelas || !guru) {
      return res.status(400).json({
        success: false,
        message: 'Judul, deadline, kelas, and guru are required'
      });
    }

    const tugas = await Tugas.create({ 
      judul, 
      deskripsi: deskripsi || '', 
      deadline, 
      kelas, 
      guru 
    });
    res.status(201).json({
      success: true,
      message: 'Tugas created successfully',
      data: tugas
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// PUT update tugas
router.put('/:id', async (req, res) => {
  try {
    const { judul, deskripsi, deadline, kelas, guru } = req.body;
    
    if (!judul || !deadline || !kelas || !guru) {
      return res.status(400).json({
        success: false,
        message: 'Judul, deadline, kelas, and guru are required'
      });
    }

    const tugas = await Tugas.update(req.params.id, { 
      judul, 
      deskripsi: deskripsi || '', 
      deadline, 
      kelas, 
      guru 
    });
    res.json({
      success: true,
      message: 'Tugas updated successfully',
      data: tugas
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// DELETE tugas
router.delete('/:id', async (req, res) => {
  try {
    const result = await Tugas.delete(req.params.id);
    if (result.deleted === 0) {
      return res.status(404).json({
        success: false,
        message: 'Tugas not found'
      });
    }
    res.json({
      success: true,
      message: 'Tugas deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

module.exports = router;
