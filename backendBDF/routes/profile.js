const express = require('express');
const { body, validationResult } = require('express-validator');
const authMiddleware = require('../middleware/auth');
const User = require('../models/User');

const router = express.Router();

// Ambil profil pengguna yang sedang login
router.get('/', authMiddleware, async (req, res) => {
  try {
    const userId = req.user.userId;
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    return res.json({
      success: true,
      data: {
        id: user.id,
        username: user.username,
        role: user.role,
        full_name: user.full_name || '',
        email: user.email || '',
        phone: user.phone || '',
        address: user.address || '',
        language: user.language || 'id',
        dark_mode: !!user.dark_mode,
        email_notif: user.email_notif ?? 1,
        push_notif: user.push_notif ?? 0,
        daily_digest: user.daily_digest ?? 0,
        employee_id: user.employee_id || '',
        join_date: user.join_date || '',
        status: user.status || 'Aktif',
        avatar: user.avatar || '',
      },
    });
  } catch (error) {
    console.error('Get profile error:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
});

// Perbarui profil pengguna
router.put(
  '/',
  authMiddleware,
  [
    body('full_name').optional().isString().withMessage('full_name must be string'),
    body('email').optional().isEmail().withMessage('email tidak valid'),
    body('phone').optional().isString(),
    body('address').optional().isString(),
    body('language').optional().isString(),
    body('dark_mode').optional().isBoolean().withMessage('dark_mode must be boolean'),
    body('email_notif').optional().isBoolean().withMessage('email_notif must be boolean'),
    body('push_notif').optional().isBoolean().withMessage('push_notif must be boolean'),
    body('daily_digest').optional().isBoolean().withMessage('daily_digest must be boolean'),
    body('employee_id').optional().isString(),
    body('join_date').optional().isString(),
    body('status').optional().isString(),
    body('avatar').optional().isString().withMessage('avatar must be string'),
  ],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Validation failed',
          errors: errors.array(),
        });
      }

      const userId = req.user.userId;
      const payload = {
        full_name: req.body.full_name,
        email: req.body.email,
        phone: req.body.phone,
        address: req.body.address,
        language: req.body.language,
        dark_mode: req.body.dark_mode !== undefined ? (req.body.dark_mode ? 1 : 0) : undefined,
        email_notif: req.body.email_notif !== undefined ? (req.body.email_notif ? 1 : 0) : undefined,
        push_notif: req.body.push_notif !== undefined ? (req.body.push_notif ? 1 : 0) : undefined,
        daily_digest: req.body.daily_digest !== undefined ? (req.body.daily_digest ? 1 : 0) : undefined,
        employee_id: req.body.employee_id,
        join_date: req.body.join_date,
        status: req.body.status,
        avatar: req.body.avatar,
      };

      // buang undefined agar tidak menimpa nilai lama
      Object.keys(payload).forEach((key) => payload[key] === undefined && delete payload[key]);

      await User.updateProfile(userId, payload);

      const updated = await User.findById(userId);
      return res.json({
        success: true,
        message: 'Profil berhasil diperbarui',
        data: {
          id: updated.id,
          username: updated.username,
          role: updated.role,
          full_name: updated.full_name || '',
          email: updated.email || '',
          phone: updated.phone || '',
          address: updated.address || '',
          language: updated.language || 'id',
          dark_mode: !!updated.dark_mode,
          email_notif: updated.email_notif ?? 1,
          push_notif: updated.push_notif ?? 0,
          daily_digest: updated.daily_digest ?? 0,
          employee_id: updated.employee_id || '',
          join_date: updated.join_date || '',
          status: updated.status || 'Aktif',
          avatar: updated.avatar || '',
        },
      });
    } catch (error) {
      console.error('Update profile error:', error);
      return res.status(500).json({ success: false, message: 'Internal server error' });
    }
  }
);

module.exports = router;
