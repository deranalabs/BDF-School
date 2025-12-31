import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard_page.dart';
import '../dashboard/sidebar.dart';
import '../jadwal/jadwal_page.dart';
import '../nilai/nilai_page.dart';
import '../pengumuman/pengumuman_page.dart';
import '../presensi/presensi_page.dart';
import '../siswa/daftar_siswa_page.dart';
import '../tugas/tugas_page.dart';
import '../pengaturan/pengaturan_page.dart';
import '../auth/login_screen.dart';
import '../../utils/feedback.dart';
import '../../state/auth_controller.dart';
import '../../utils/api_client.dart';
import '../../theme/brand.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _employeeId = TextEditingController();
  final _joinDate = TextEditingController();
  final _status = TextEditingController();
  bool _loading = false;
  bool _isDirty = false;
  String? _emailError;
  String? _phoneError;
  String _role = '';
  String _username = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiClient? _api;
  Map<String, String> _lastLoaded = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthController>(context, listen: false);
      setState(() {
        _api = ApiClient(auth);
      });
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _employeeId.dispose();
    _joinDate.dispose();
    _status.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (_api == null) return;
    setState(() => _loading = true);
    try {
      final res = await _api!.get('/api/profile');
      if (res.statusCode != 200) {
        throw Exception('Gagal memuat profil');
      }
      final data = jsonDecode(res.body)['data'] as Map<String, dynamic>;
      final fullName = (data['full_name'] ?? '').toString();
      final parts = fullName.split(' ');
      final first = parts.isNotEmpty ? parts.first : '';
      final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      setState(() {
        _firstName.text = first;
        _lastName.text = last;
        _email.text = (data['email'] ?? '').toString();
        _phone.text = (data['phone'] ?? '').toString();
        _address.text = (data['address'] ?? '').toString();
        _employeeId.text = (data['employee_id'] ?? '').toString();
        _joinDate.text = (data['join_date'] ?? '').toString();
        _status.text = (data['status'] ?? '').toString();
        _role = (data['role'] ?? '').toString();
        _username = (data['username'] ?? '').toString();
        _lastLoaded = {
          'first': _firstName.text,
          'last': _lastName.text,
          'email': _email.text,
          'phone': _phone.text,
          'address': _address.text,
          'employee_id': _employeeId.text,
          'join_date': _joinDate.text,
          'status': _status.text,
        };
        _isDirty = false;
        _emailError = null;
        _phoneError = null;
      });
    } catch (e) {
      if (mounted) showFeedback(context, 'Gagal memuat profil: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _resetForm() {
    _firstName.text = _lastLoaded['first'] ?? '';
    _lastName.text = _lastLoaded['last'] ?? '';
    _email.text = _lastLoaded['email'] ?? '';
    _phone.text = _lastLoaded['phone'] ?? '';
    _address.text = _lastLoaded['address'] ?? '';
    _employeeId.text = _lastLoaded['employee_id'] ?? '';
    _joinDate.text = _lastLoaded['join_date'] ?? '';
    _status.text = _lastLoaded['status'] ?? '';
    setState(() {
      _isDirty = false;
      _emailError = null;
      _phoneError = null;
    });
  }

  void _checkDirty() {
    final dirty = _firstName.text != (_lastLoaded['first'] ?? '') ||
        _lastName.text != (_lastLoaded['last'] ?? '') ||
        _email.text != (_lastLoaded['email'] ?? '') ||
        _phone.text != (_lastLoaded['phone'] ?? '') ||
        _address.text != (_lastLoaded['address'] ?? '') ||
        _employeeId.text != (_lastLoaded['employee_id'] ?? '') ||
        _joinDate.text != (_lastLoaded['join_date'] ?? '') ||
        _status.text != (_lastLoaded['status'] ?? '');
    if (dirty != _isDirty) {
      setState(() {
        _isDirty = dirty;
      });
    }
  }

  void _validateEmailPhone() {
    String? emailErr;
    String? phoneErr;
    final email = _email.text.trim();
    final phone = _phone.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (email.isEmpty) {
      emailErr = 'Email wajib diisi';
    } else if (!emailRegex.hasMatch(email)) {
      emailErr = 'Format email tidak valid';
    }
    final phoneDigits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (phoneDigits.isEmpty) {
      phoneErr = 'Nomor wajib diisi';
    } else if (phoneDigits.length < 8) {
      phoneErr = 'Nomor terlalu pendek';
    }
    setState(() {
      _emailError = emailErr;
      _phoneError = phoneErr;
    });
  }

  Future<void> _saveProfile() async {
    if (_api == null) return;
    _validateEmailPhone();
    if (_emailError != null || _phoneError != null) {
      return;
    }
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _email.text.isEmpty ||
        _phone.text.isEmpty ||
        _address.text.isEmpty) {
      showFeedback(context, 'Lengkapi semua field');
      return;
    }
    setState(() => _loading = true);
    try {
      final fullName = '${_firstName.text} ${_lastName.text}'.trim();
      final res = await _api!.put('/api/profile', body: {
        'full_name': fullName,
        'email': _email.text,
        'phone': _phone.text,
        'address': _address.text,
        'employee_id': _employeeId.text,
        'join_date': _joinDate.text,
        'status': _status.text,
      });
      if (res.statusCode != 200) {
        final msg = jsonDecode(res.body)['message'] ?? 'Gagal menyimpan profil';
        throw Exception(msg);
      }
      showFeedback(context, 'Profil berhasil disimpan');
      await _loadProfile();
      setState(() {
        _isDirty = false;
      });
    } catch (e) {
      if (mounted) showFeedback(context, 'Gagal menyimpan profil: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    void goTo(Widget page) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => page));
    }
    
    void logout() async {
      try {
        final authController = Provider.of<AuthController>(context, listen: false);
        await authController.logout();
        if (!mounted) return;
        _scaffoldKey.currentState?.closeDrawer();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    String initials = 'US';
    if (_username.isNotEmpty) {
      final len = min(2, _username.length);
      initials = _username.substring(0, len).toUpperCase();
    }

    Future<bool> _onWillPop() async {
      if (!_isDirty) return true;
      return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Perubahan belum disimpan'),
              content: const Text('Simpan perubahan sebelum keluar?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Buang'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop(false);
                    await _saveProfile();
                  },
                  child: const Text('Simpan'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Batal'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: BrandColors.gray100,
        appBar: AppBar(
          backgroundColor: BrandColors.navy900,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: const Text('Profile', style: BrandTextStyles.appBarTitle),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PengaturanPage()),
                ),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.settings, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
        drawer: Sidebar(
          selectedIndex: 7,
          onTapDashboard: () => goTo(const DashboardScreen()),
          onTapTugas: () => goTo(TugasPage()),
          onTapJadwal: () => goTo(JadwalPage()),
          onTapPresensi: () => goTo(PresensiPage()),
          onTapNilai: () => goTo(NilaiPage()),
          onTapPengumuman: () => goTo(const PengumumanPage()),
          onTapSiswa: () => goTo(const DaftarSiswaPage()),
          onTapSettings: () => goTo(const PengaturanPage()),
          onLogout: logout,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadProfile,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        if (_loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        if (!_loading) ...[
                          const SizedBox(height: 24),
                          _HeaderCard(
                            username: _username,
                            role: _role,
                            initials: initials,
                            employeeId: _employeeId.text,
                            joinDate: _joinDate.text,
                            status: _status.text.isNotEmpty ? _status.text : 'Aktif',
                          ),
                          const SizedBox(height: 16),
                          _PersonalInfoForm(
                            firstName: _firstName,
                            lastName: _lastName,
                            email: _email,
                            phone: _phone,
                            address: _address,
                            employeeId: _employeeId,
                            joinDate: _joinDate,
                            status: _status,
                            onSave: _saveProfile,
                            onReset: _resetForm,
                            loading: _loading,
                            onChanged: () {
                              _validateEmailPhone();
                              _checkDirty();
                            },
                            emailError: _emailError,
                            phoneError: _phoneError,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.username,
    required this.role,
    required this.initials,
    required this.employeeId,
    required this.joinDate,
    required this.status,
  });

  final String username;
  final String role;
  final String initials;
  final String employeeId;
  final String joinDate;
  final String status;

  @override
  Widget build(BuildContext context) {
    final roleLabel = role.isNotEmpty
        ? '${role[0].toUpperCase()}${role.length > 1 ? role.substring(1) : ''}'
        : 'Admin';
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BrandShadows.card,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: BrandColors.amber400, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BrandColors.navy900,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      initials.isNotEmpty ? initials : 'US',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: BrandColors.navy900,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            username.isNotEmpty ? username : 'User',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: BrandColors.navy900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            roleLabel,
            style: const TextStyle(
              fontSize: 14,
              color: BrandColors.gray700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: BrandColors.sand200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              employeeId.isNotEmpty ? 'ID: $employeeId' : 'ID: -',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: BrandColors.navy900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoItem(
                icon: Icons.calendar_today,
                label: 'Bergabung',
                value: joinDate.isNotEmpty ? joinDate : 'N/A',
              ),
              _InfoItem(
                icon: Icons.verified_user,
                label: 'Status',
                value: status.isNotEmpty ? status : 'Aktif',
                isActive: true,
              ),
              _InfoItem(
                icon: Icons.shield,
                label: 'Role',
                value: roleLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: BrandColors.navy900, size: 20),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: BrandColors.gray700,
          ),
        ),
        const SizedBox(height: 2),
        isActive
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: BrandColors.success,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.navy900,
                ),
              ),
      ],
    );
  }
}

class _PersonalInfoForm extends StatelessWidget {
  const _PersonalInfoForm({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.employeeId,
    required this.joinDate,
    required this.status,
    required this.onSave,
    required this.onReset,
    required this.loading,
    this.onChanged,
    this.emailError,
    this.phoneError,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController address;
  final TextEditingController employeeId;
  final TextEditingController joinDate;
  final TextEditingController status;
  final VoidCallback onSave;
  final VoidCallback onReset;
  final bool loading;
  final VoidCallback? onChanged;
  final String? emailError;
  final String? phoneError;

  @override
  Widget build(BuildContext context) {
    final emptyMenu = (BuildContext context, EditableTextState state) =>
        const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Informasi Pribadi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: BrandColors.navy900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Terverifikasi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B8DEF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Nama Depan',
                  child: TextField(
                    controller: firstName,
                    onChanged: (_) => onChanged?.call(),
                    contextMenuBuilder: emptyMenu,
                    decoration: _inputDecoration('Admin'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Nama Belakang',
                  child: TextField(
                    controller: lastName,
                    onChanged: (_) => onChanged?.call(),
                    contextMenuBuilder: emptyMenu,
                    decoration: _inputDecoration('Sekolah'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _LabeledField(
            label: 'Alamat Email',
            child: TextField(
              controller: email,
              onChanged: (_) => onChanged?.call(),
              contextMenuBuilder: emptyMenu,
              decoration: _inputDecoration('admin@sekolah.com', errorText: emailError),
            ),
          ),
          const SizedBox(height: 16),
          _LabeledField(
            label: 'Nomor Telepon',
            child: TextField(
              controller: phone,
              onChanged: (_) => onChanged?.call(),
              contextMenuBuilder: emptyMenu,
              decoration: _inputDecoration('081234567890', errorText: phoneError),
            ),
          ),
          const SizedBox(height: 16),
          _LabeledField(
            label: 'Alamat Lengkap',
            child: TextField(
              controller: address,
              onChanged: (_) => onChanged?.call(),
              contextMenuBuilder: emptyMenu,
              decoration: _inputDecoration('Alamat lengkap'),
            ),
          ),
          const SizedBox(height: 16),
          _LabeledField(
            label: 'ID Pegawai',
            child: TextField(
              controller: employeeId,
              readOnly: true,
              contextMenuBuilder: emptyMenu,
              decoration: _inputDecoration('ADM-2025-001', readOnly: true),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Tanggal Bergabung',
                  child: TextField(
                    controller: joinDate,
                    readOnly: true,
                    contextMenuBuilder: emptyMenu,
                    decoration: _inputDecoration('2025-01-01', readOnly: true),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Status',
                  child: TextField(
                    controller: status,
                    onChanged: (_) => onChanged?.call(),
                    contextMenuBuilder: emptyMenu,
                    decoration: _inputDecoration('Aktif'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  style: BrandButtons.primary().copyWith(
                    minimumSize: MaterialStateProperty.all(const Size.fromHeight(52)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    elevation: MaterialStateProperty.all(4),
                  ),
                  onPressed: loading ? null : onSave,
                  icon: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save, color: Colors.white, size: 18),
                  label: Text(
                    loading ? 'Menyimpan...' : 'Simpan Perubahan',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFd14343),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0x1Ad14343),
                  ),
                  onPressed: loading ? null : onReset,
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {bool readOnly = false, String? errorText}) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: readOnly ? BrandColors.gray300 : Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: readOnly ? BrandColors.gray300 : Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: BrandColors.navy900, width: 2),
      ),
      filled: true,
      fillColor: readOnly ? Colors.grey[100] : Colors.grey[50],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}