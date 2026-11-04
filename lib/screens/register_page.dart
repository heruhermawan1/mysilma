import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appsilma/database/database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = true;
  bool _isLoading = false;
  String _selectedRole = 'pemain';
  String _selectedLevel = 'menengah';

  // ── Design tokens ──
  static const _green900 = Color(0xFF1A5C38);
  static const _green700 = Color(0xFF27AE60);
  static const _green400 = Color(0xFF2ECC71);
  static const _green50 = Color(0xFFEBF7F1);
  static const _neutral50 = Color(0xFFF7F8FA);
  static const _neutral100 = Color(0xFFF0F1F3);
  static const _neutral200 = Color(0xFFE4E6EA);
  static const _neutral400 = Color(0xFF9CA3AF);
  static const _neutral700 = Color(0xFF374151);
  static const _neutral900 = Color(0xFF111827);
  static const _white = Colors.white;

  // ── Password strength ──
  double get _strengthValue {
    final p = _passwordController.text;
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    return score / 4;
  }

  String get _strengthLabel {
    final v = _strengthValue;
    if (v == 0) return '';
    if (v <= 0.25) return 'Lemah';
    if (v <= 0.5) return 'Cukup';
    if (v <= 0.75) return 'Kuat';
    return 'Sangat Kuat';
  }

  Color get _strengthColor {
    final v = _strengthValue;
    if (v <= 0.25) return const Color(0xFFEF4444);
    if (v <= 0.5) return const Color(0xFFF59E0B);
    if (v <= 0.75) return _green700;
    return _green400;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── Validasi & simpan ke database ──
  Future<void> _doRegister() async {
    final nama = _namaController.text.trim();
    final wa = _whatsappController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    // Validasi field kosong
    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Nama, Email, dan Kata Sandi wajib diisi', isError: true);
      return;
    }

    // Validasi format email
    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$').hasMatch(email)) {
      _showSnackBar('Format email tidak valid', isError: true);
      return;
    }

    // Validasi password minimum
    if (password.length < 6) {
      _showSnackBar('Kata sandi minimal 6 karakter', isError: true);
      return;
    }

    // Validasi konfirmasi password
    if (password != confirm) {
      _showSnackBar('Konfirmasi kata sandi tidak cocok', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = DatabaseHelper.instance;

      // Cek email sudah terdaftar
      final existing = await db.getUserByEmail(email);
      if (existing != null) {
        _showSnackBar('Email sudah terdaftar, silakan login', isError: true);
        return;
      }

      // Generate ID user baru
      final userId = await db.generateId('USR', 'users');

      // Simpan user baru
      await db.insertUser({
        'id': userId,
        'name': nama,
        'email': email,
        'password': password,
        'phone': wa.isNotEmpty ? wa : null,
      });

      if (!mounted) return;

      _showSnackBar('Akun berhasil dibuat! Silakan masuk.');

      // Tunggu sebentar agar snackbar terlihat, lalu ke login
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      // Navigasi ke login dengan prefill contact & password
      Navigator.of(context).pushReplacementNamed(
        '/login',
        arguments: {
          'contact': wa.isNotEmpty ? wa : email,
          'password': password,
        },
      );
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _neutral50,
        body: SafeArea(
          child: Column(
            children: [
              _AppBarWidget(onBack: () => Navigator.of(context).maybePop()),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Hero header ──
                        _buildHeroHeader(),

                        // ── Form sections ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              _buildStepIndicator(),
                              const SizedBox(height: 28),

                              // Section: Data Diri
                              _SectionTitle(title: 'Data Diri'),
                              const SizedBox(height: 16),
                              _buildNamaField(),
                              const SizedBox(height: 14),
                              _buildWhatsAppField(),
                              const SizedBox(height: 14),
                              _buildEmailField(),

                              const SizedBox(height: 28),

                              // Section: Peran
                              _SectionTitle(title: 'Peran Utama di Aplikasi'),
                              const SizedBox(height: 14),
                              _buildRoleSelector(),

                              const SizedBox(height: 28),

                              // Section: Level
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const _SectionTitle(title: 'Level Bermain'),
                                  _Chip(label: 'Bisa diubah nanti'),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _buildLevelSelector(),

                              const SizedBox(height: 28),

                              // Section: Keamanan
                              _SectionTitle(title: 'Keamanan Akun'),
                              const SizedBox(height: 16),
                              _buildPasswordField(),
                              if (_passwordController.text.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                _buildStrengthBar(),
                              ],
                              const SizedBox(height: 14),
                              _buildConfirmField(),

                              const SizedBox(height: 28),

                              // Terms
                              _buildTermsRow(),

                              const SizedBox(height: 24),

                              // CTA — inline agar context pasti valid
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _doRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A5C38),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: const Color(
                                      0xFF1A5C38,
                                    ).withValues(alpha: 0.6),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Daftar & Buat Akun',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                ),
                              ),

                              const SizedBox(height: 24),
                              _buildDivider(),
                              const SizedBox(height: 20),
                              _buildGoogleButton(),
                              const SizedBox(height: 20),
                              _buildLoginRow(context),
                              const SizedBox(height: 36),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Hero Header
  // ────────────────────────────────────────────────────────────
  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _white,
        border: Border(bottom: BorderSide(color: _neutral200, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _green50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _green400.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: _green400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'KOMUNITAS RESMI PBSI AFILIASI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _green900,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Logo + Judul
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/MySILMA Logo.png',
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Daftar Akun Baru',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _neutral900,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'MySILMA · Badminton Sport Center',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: _neutral400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Info strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _green50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text('🏸', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12.5,
                        color: _neutral700,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'Bergabung dengan '),
                        TextSpan(
                          text: '32.400+ atlet',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _green900,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' di seluruh Indonesia. Booking GOR, cari sparring partner, & lacak statistik tanding.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Step Indicator
  // ────────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Step 1 — active
            _StepDot(number: '1', active: true),
            Expanded(child: Container(height: 2, color: _green700)),
            // Step 2 — inactive
            _StepDot(number: '2', active: false),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Informasi Dasar',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _green900,
              ),
            ),
            Text(
              'Verifikasi',
              style: TextStyle(fontSize: 11.5, color: _neutral400),
            ),
          ],
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Form Fields
  // ────────────────────────────────────────────────────────────
  Widget _buildNamaField() {
    return _InputField(
      controller: _namaController,
      label: 'Nama Lengkap',
      hint: 'Masukkan nama lengkap Anda',
      icon: Icons.person_outline_rounded,
      required: true,
    );
  }

  Widget _buildWhatsAppField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _FieldLabel(text: 'No. WhatsApp Aktif', required: true),
            Row(
              children: const [
                Icon(Icons.smartphone_outlined, size: 12, color: _green700),
                SizedBox(width: 4),
                Text(
                  'Untuk OTP & e-Tiket',
                  style: TextStyle(
                    fontSize: 11,
                    color: _green700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _neutral200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: _neutral200)),
                ),
                child: Row(
                  children: [
                    const Text('🇮🇩', style: TextStyle(fontSize: 15)),
                    const SizedBox(width: 5),
                    const Text(
                      '+62',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _neutral700,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: _neutral400,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _whatsappController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 14, color: _neutral900),
                  decoration: InputDecoration(
                    hintText: '8xx-xxxx-xxxx',
                    hintStyle: TextStyle(color: _neutral400, fontSize: 13.5),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return _InputField(
      controller: _emailController,
      label: 'Email Aktif',
      hint: 'nama@gmail.com',
      icon: Icons.mail_outline_rounded,
      required: true,
      keyboardType: TextInputType.emailAddress,
    );
  }

  // ────────────────────────────────────────────────────────────
  // Role Selector
  // ────────────────────────────────────────────────────────────
  Widget _buildRoleSelector() {
    return Column(
      children: [
        _RoleCard(
          selected: _selectedRole == 'pemain',
          icon: Icons.calendar_today_rounded,
          title: 'Pemain / Atlet',
          subtitle: 'Booking & Sparring',
          onTap: () => setState(() => _selectedRole = 'pemain'),
        ),
        const SizedBox(height: 12),
        _RoleCard(
          selected: _selectedRole == 'pemilik',
          icon: Icons.location_on_outlined,
          title: 'Pemilik GOR',
          subtitle: 'Kelola Lapangan',
          onTap: () => setState(() => _selectedRole = 'pemilik'),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Level Selector
  // ────────────────────────────────────────────────────────────
  Widget _buildLevelSelector() {
    // icon, label, sub, key, popular
    final levels = [
      (
        key: 'pemula',
        label: 'Pemula',
        sub: 'BEGINNER',
        icon: Icons.person_outline_rounded,
        popular: false,
      ),
      (
        key: 'menengah',
        label: 'Menengah',
        sub: 'INTERMEDIATE',
        icon: Icons.bar_chart_rounded,
        popular: true,
      ),
      (
        key: 'mahir',
        label: 'Mahir',
        sub: 'ADVANCED',
        icon: Icons.rocket_launch_outlined,
        popular: false,
      ),
    ];

    return Padding(
      // ruang untuk badge POPULER yang menonjol ke atas
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: levels.map((lvl) {
          final selected = _selectedLevel == lvl.key;

          // card yang selected lebih tinggi (extra vertical padding)
          final double vertPad = selected ? 24.0 : 16.0;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: lvl.key != 'mahir' ? 10 : 0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // ── Card ──
                  GestureDetector(
                    onTap: () => setState(() => _selectedLevel = lvl.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: vertPad,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF2D7A4F), Color(0xFF1A5C38)],
                              )
                            : null,
                        color: selected ? null : _white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? Colors.transparent : _neutral200,
                          width: 1.5,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF1A5C38,
                                  ).withValues(alpha: 0.35),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            lvl.icon,
                            size: 28,
                            color: selected ? _white : _neutral400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            lvl.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: selected ? 15 : 14,
                              fontWeight: FontWeight.w800,
                              color: selected ? _white : _neutral900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lvl.sub,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? _white.withValues(alpha: 0.7)
                                  : _neutral400,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Badge POPULER ──
                  if (lvl.popular)
                    Positioned(
                      top: -14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _green400,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _green400.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star_rounded, size: 10, color: _white),
                            SizedBox(width: 4),
                            Text(
                              'POPULER',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: _white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Password Fields
  // ────────────────────────────────────────────────────────────
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(text: 'Kata Sandi', required: true),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _neutral200),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 14, color: _neutral900),
            decoration: InputDecoration(
              hintText: 'Min. 8 karakter',
              hintStyle: const TextStyle(color: _neutral400, fontSize: 13.5),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: _neutral400,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _neutral400,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _strengthValue,
            backgroundColor: _neutral100,
            valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Text(
              'Kekuatan: ',
              style: TextStyle(fontSize: 11.5, color: _neutral400),
            ),
            if (_strengthValue > 0) ...[
              Icon(Icons.shield_outlined, size: 12, color: _strengthColor),
              const SizedBox(width: 3),
              Text(
                _strengthLabel,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: _strengthColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(text: 'Konfirmasi Kata Sandi', required: true),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _neutral200),
          ),
          child: TextField(
            controller: _confirmController,
            obscureText: _obscureConfirm,
            style: const TextStyle(fontSize: 14, color: _neutral900),
            decoration: InputDecoration(
              hintText: 'Ulangi kata sandi',
              hintStyle: const TextStyle(color: _neutral400, fontSize: 13.5),
              prefixIcon: const Icon(
                Icons.lock_reset_outlined,
                color: _neutral400,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _neutral400,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Terms
  // ────────────────────────────────────────────────────────────
  Widget _buildTermsRow() {
    return GestureDetector(
      onTap: () => setState(() => _agreeTerms = !_agreeTerms),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: _agreeTerms ? _green900 : _white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: _agreeTerms ? _green900 : _neutral200,
                width: 1.5,
              ),
            ),
            child: _agreeTerms
                ? const Icon(Icons.check_rounded, size: 13, color: _white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: _neutral700,
                  height: 1.55,
                ),
                children: [
                  const TextSpan(text: 'Saya menyetujui '),
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: const TextStyle(
                      color: _green700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' serta '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: const TextStyle(
                      color: _green700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' MySILMA.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Divider
  // ────────────────────────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: _neutral200, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'atau lanjutkan dengan',
            style: TextStyle(fontSize: 12, color: _neutral400),
          ),
        ),
        const Expanded(child: Divider(color: _neutral200, thickness: 1)),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Google Button
  // ────────────────────────────────────────────────────────────
  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _neutral200, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: _white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google G logo
            const SizedBox(width: 20, height: 20, child: _GoogleIcon()),
            const SizedBox(width: 10),
            const Text(
              'Daftar dengan Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Login Link
  // ────────────────────────────────────────────────────────────
  Widget _buildLoginRow(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13.5, color: _neutral400),
          children: [
            const TextSpan(text: 'Sudah punya akun? '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Text(
                  'Masuk di sini',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: _green700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Reusable Widgets
// ══════════════════════════════════════════════════════════════

class _AppBarWidget extends StatelessWidget {
  final VoidCallback onBack;
  const _AppBarWidget({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF111827),
            ),
          ),
          const Expanded(
            child: Text(
              'Register',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF1A5C38),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF1A5C38),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const _FieldLabel({required this.text, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool required;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.required = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label, required: required),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E6EA)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13.5,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selected ? const Color(0xFF1A5C38) : Colors.white;
    final Color iconBg = selected
        ? const Color(0xFF27AE60)
        : const Color(0xFFF0F1F3);
    final Color iconColor = selected ? Colors.white : const Color(0xFF374151);
    final Color titleColor = selected ? Colors.white : const Color(0xFF111827);
    final Color subtitleColor = selected
        ? Colors.white.withValues(alpha: 0.75)
        : const Color(0xFF9CA3AF);
    final Color chevronColor = selected
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF9CA3AF);
    final Color borderColor = selected
        ? Colors.transparent
        : const Color(0xFFE4E6EA);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1A5C38).withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // ── Icon circle ──
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),

            const SizedBox(width: 14),

            // ── Teks ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: subtitleColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // ── Chevron ──
            Icon(Icons.chevron_right_rounded, color: chevronColor, size: 22),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final String number;
  final bool active;
  const _StepDot({required this.number, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF27AE60) : const Color(0xFFE4E6EA),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Google "G" icon painted manually
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GooglePainter());
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    void arc(Color c, double start, double sweep, bool useCenter) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        sweep,
        useCenter,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.38,
      );
    }

    // Draw 4 colored arc segments
    const pi = 3.14159265;
    arc(const Color(0xFF4285F4), -pi / 6, pi * 2 / 3, false); // blue
    arc(const Color(0xFF34A853), pi / 2, pi * 2 / 3, false); // green
    arc(const Color(0xFFFBBC05), pi * 7 / 6, pi * 2 / 3, false); // yellow
    arc(const Color(0xFFEA4335), -pi * 5 / 6, pi * 2 / 3, false); // red

    // White bar for the "G" notch
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - r * 0.25, r * 0.9, r * 0.5),
      Paint()..color = Colors.white,
    );
    // Re-draw blue partial to make "G" shape
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 6,
      pi / 6,
      false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.38,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
