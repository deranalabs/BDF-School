const { verifyToken } = require('../utils/jwt');

module.exports = function authMiddleware(req, res, next) {
  try {
    const header = req.header('Authorization');
    const token = header?.replace('Bearer ', '');
    if (!token) {
      return res.status(401).json({ success: false, message: 'No token provided' });
    }
    const decoded = verifyToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ success: false, message: 'Invalid token' });
  }
};
