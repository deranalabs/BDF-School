const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./routes/auth');
const siswaRoutes = require('./routes/siswa');
const tugasRoutes = require('./routes/tugas');
const jadwalRoutes = require('./routes/jadwal');
const presensiRoutes = require('./routes/presensi');
const pengumumanRoutes = require('./routes/pengumuman');
const nilaiRoutes = require('./routes/nilai');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: ['http://localhost:3000', 'http://192.168.110.83:3000', '*'],
  credentials: true
}));
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/siswa', siswaRoutes);
app.use('/api/tugas', tugasRoutes);
app.use('/api/jadwal', jadwalRoutes);
app.use('/api/presensi', presensiRoutes);
app.use('/api/pengumuman', pengumumanRoutes);
app.use('/api/nilai', nilaiRoutes);

// Health check
app.get('/', (req, res) => {
  res.json({ message: 'BDF School API is running' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log('Available endpoints:');
  console.log('- Auth: /api/auth/login, /api/auth/verify');
  console.log('- Siswa: /api/siswa');
  console.log('- Tugas: /api/tugas');
  console.log('- Jadwal: /api/jadwal');
  console.log('- Presensi: /api/presensi');
  console.log('- Pengumuman: /api/pengumuman');
  console.log('- Nilai: /api/nilai');
});
