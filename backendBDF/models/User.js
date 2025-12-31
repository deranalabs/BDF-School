const db = require('../config/database');
const bcrypt = require('bcryptjs');

class User {
  static async findByUsername(username) {
    return new Promise((resolve, reject) => {
      db.get(
        'SELECT * FROM users WHERE username = ?',
        [username],
        (err, row) => {
          if (err) {
            reject(err);
          } else {
            resolve(row || null);
          }
        }
      );
    });
  }

  static async existsByUsername(username) {
    return new Promise((resolve, reject) => {
      db.get(
        'SELECT 1 FROM users WHERE username = ?',
        [username],
        (err, row) => {
          if (err) {
            reject(err);
          } else {
            resolve(!!row);
          }
        }
      );
    });
  }

  static async create(userData) {
    return new Promise(async (resolve, reject) => {
      try {
        const hashedPassword = await bcrypt.hash(userData.password, 10);
        db.run(
          `INSERT INTO users (
            username, password, role,
            full_name, email, phone, address,
            language, dark_mode, email_notif, push_notif, daily_digest,
            employee_id, join_date, status
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [
            userData.username,
            hashedPassword,
            userData.role || 'admin',
            userData.full_name || '',
            userData.email || '',
            userData.phone || '',
            userData.address || '',
            userData.language || 'id',
            userData.dark_mode ? 1 : 0,
            userData.email_notif !== undefined ? (userData.email_notif ? 1 : 0) : 1,
            userData.push_notif !== undefined ? (userData.push_notif ? 1 : 0) : 0,
            userData.daily_digest !== undefined ? (userData.daily_digest ? 1 : 0) : 0,
            userData.employee_id || '',
            userData.join_date || '',
            userData.status || 'Aktif'
          ],
          function(err) {
            if (err) {
              reject(err);
            } else {
              resolve(this.lastID);
            }
          }
        );
      } catch (error) {
        reject(error);
      }
    });
  }

  static async verifyPassword(plainPassword, hashedPassword) {
    return await bcrypt.compare(plainPassword, hashedPassword);
  }

  static async findById(id) {
    return new Promise((resolve, reject) => {
      db.get(
        'SELECT * FROM users WHERE id = ?',
        [id],
        (err, row) => {
          if (err) {
            reject(err);
          } else {
            resolve(row || null);
          }
        }
      );
    });
  }

  static async updateProfile(id, data) {
    const fields = [
      'full_name',
      'email',
      'phone',
      'address',
      'language',
      'dark_mode',
      'email_notif',
      'push_notif',
      'daily_digest',
      'employee_id',
      'join_date',
      'status'
    ];

    const updates = [];
    const params = [];

    fields.forEach((field) => {
      if (data[field] !== undefined) {
        updates.push(`${field} = ?`);
        params.push(data[field]);
      }
    });

    if (updates.length === 0) return;

    params.push(id);

    return new Promise((resolve, reject) => {
      db.run(
        `UPDATE users SET ${updates.join(', ')} WHERE id = ?`,
        params,
        function (err) {
          if (err) {
            reject(err);
          } else {
            resolve(this.changes);
          }
        }
      );
    });
  }

  static async updatePassword(id, newPassword) {
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    return new Promise((resolve, reject) => {
      db.run(
        'UPDATE users SET password = ? WHERE id = ?',
        [hashedPassword, id],
        function (err) {
          if (err) {
            reject(err);
          } else {
            resolve(this.changes);
          }
        }
      );
    });
  }
}

module.exports = User;
