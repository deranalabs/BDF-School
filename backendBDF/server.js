const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const pkg = require('./package.json');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const authRoutes = require('./routes/auth');
const siswaRoutes = require('./routes/siswa');
const tugasRoutes = require('./routes/tugas');
const jadwalRoutes = require('./routes/jadwal');
const presensiRoutes = require('./routes/presensi');
const pengumumanRoutes = require('./routes/pengumuman');
const nilaiRoutes = require('./routes/nilai');
const profileRoutes = require('./routes/profile');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const allowedOrigins = (process.env.ALLOWED_ORIGINS || 'http://localhost:3000')
  .split(',')
  .map((o) => o.trim())
  .filter(Boolean);

// Middleware utama
app.set('trust proxy', 1);
app.use(helmet());
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(limiter);
app.use(cors({
  origin: allowedOrigins,
  credentials: true
}));
app.use(express.json());

// Pencatat request sederhana (metode, path, status, waktu)
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.originalUrl} ${res.statusCode} - ${duration}ms`);
  });
  next();
});

// Rute API
app.use('/api/auth', authRoutes);
app.use('/api/siswa', siswaRoutes);
app.use('/api/tugas', tugasRoutes);
app.use('/api/jadwal', jadwalRoutes);
app.use('/api/presensi', presensiRoutes);
app.use('/api/pengumuman', pengumumanRoutes);
app.use('/api/nilai', nilaiRoutes);
app.use('/api/profile', profileRoutes);

// Health check & meta
app.get('/', (req, res) => {
  res.json({
    name: pkg.name || 'BDF School API',
    version: pkg.version || '0.0.0',
    status: 'ok',
    env: process.env.NODE_ENV || 'development',
    port: PORT,
    docs: '/api',
  });
});

// Tangani 404 (endpoint tidak ditemukan)
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Endpoint not found' });
});

// Penangan error dasar
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  const status = err.status || 500;
  res.status(status).json({
    success: false,
    message: err.message || 'Internal server error',
  });
});

app.listen(PORT, () => {
  const banner = [
    '========================================',
    ` ${pkg.name || 'BDF School API'} v${pkg.version || '0.0.0'}`,
    ` Env     : ${process.env.NODE_ENV || 'development'}`,
    ` Port    : ${PORT}`,
    ` Origins : ${allowedOrigins.join(', ') || '-'}`,
    ' Endpoints:',
    '   - Auth        : /api/auth/login, /api/auth/verify',
    '   - Siswa       : /api/siswa',
    '   - Tugas       : /api/tugas',
    '   - Jadwal      : /api/jadwal',
    '   - Presensi    : /api/presensi',
    '   - Pengumuman  : /api/pengumuman',
    '   - Nilai       : /api/nilai',
    '   - Profile     : /api/profile',
    '========================================',
  ];
  console.log(banner.join('\n'));
});
