const express = require('express');
const { body, validationResult } = require('express-validator');
const User = require('../models/User');
const { generateToken } = require('../utils/jwt');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// Registrasi (tanpa auto-login)
router.post('/register', [
  body('username').notEmpty().withMessage('Username is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  body('email').optional().isEmail().withMessage('Email tidak valid'),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array(),
      });
    }

    const { username, password, role, full_name, email, phone, address, employee_id, join_date, status } = req.body;

    const exists = await User.existsByUsername(username);
    if (exists) {
      return res.status(400).json({ success: false, message: 'Username sudah digunakan' });
    }

    const userId = await User.create({
      username,
      password,
      role: role || 'admin',
      full_name,
      email,
      phone,
      address,
      employee_id,
      join_date,
      status,
    });

    return res.status(201).json({
      success: true,
      message: 'Registrasi berhasil, silakan login',
      user: { id: userId, username, role: role || 'admin' },
    });
  } catch (error) {
    console.error('Register error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
});

router.post('/login', [
  body('username').notEmpty().withMessage('Username is required'),
  body('password').notEmpty().withMessage('Password is required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false, 
        message: 'Validation failed', 
        errors: errors.array() 
      });
    }

    const { username, password } = req.body;

    // Find user by username
    const user = await User.findByUsername(username);
    if (!user) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid username or password' 
      });
    }

    // Verify password
    const isValidPassword = await User.verifyPassword(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({ 
        success: false, 
        message: 'Invalid username or password' 
      });
    }

    // Generate JWT token
    const token = generateToken(user.id, user.username);

    res.json({
      success: true,
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        username: user.username,
        role: user.role
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Internal server error' 
    });
  }
});

// Ubah password
router.post('/change-password', authMiddleware, [
  body('currentPassword').notEmpty().withMessage('Current password is required'),
  body('newPassword').isLength({ min: 6 }).withMessage('New password must be at least 6 characters')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const userId = req.user.userId;
    const { currentPassword, newPassword } = req.body;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const isValid = await User.verifyPassword(currentPassword, user.password);
    if (!isValid) {
      return res.status(400).json({ success: false, message: 'Password saat ini salah' });
    }

    await User.updatePassword(userId, newPassword);

    return res.json({ success: true, message: 'Password berhasil diubah' });
  } catch (error) {
    console.error('Change password error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
});

// Endpoint verifikasi JWT
router.get('/verify', (req, res) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ 
      success: false, 
      message: 'No token provided' 
    });
  }

  try {
    const { verifyToken } = require('../utils/jwt');
    const decoded = verifyToken(token);
    
    res.json({
      success: true,
      message: 'Token is valid',
      decoded
    });
  } catch (error) {
    res.status(401).json({ 
      success: false, 
      message: 'Invalid token' 
    });
  }
});

module.exports = router;
