import 'package:flutter/material.dart';
import 'package:appsilma/database/database_helper.dart';

class LoginPage extends StatefulWidget {
  final String prefillContact;
  final String prefillPassword;

  const LoginPage({
    super.key,
    this.prefillContact = '',
    this.prefillPassword = '',
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  late final TextEditingController _contactController;
  late final TextEditingController _passwordController;

  static const Color _darkGreen = Color(0xFF1A5C38);
  static const Color _brightGreen = Color(0xFF2ECC71);
  static const Color _accentGreen = Color(0xFF27AE60);
  static const Color _bgColor = Color(0xFFF2F3F7);
  static const Color _cardColor = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _contactController = TextEditingController(text: widget.prefillContact);
    _passwordController = TextEditingController(text: widget.prefillPassword);
  }

  @override
  void dispose() {
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Login dengan database ──
  Future<void> _doLogin() async {
    final contact = _contactController.text.trim();
    final password = _passwordController.text.trim();

    if (contact.isEmpty || password.isEmpty) {
      _showSnackBar('Mohon isi semua kolom', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await DatabaseHelper.instance.loginUser(contact, password);

      if (!mounted) return;

      if (user != null) {
        Navigator.of(context).pushReplacementNamed(
          '/home',
          arguments: {'userId': user['id'], 'userName': user['name']},
        );
      } else {
        _showSnackBar('Email/WhatsApp atau kata sandi salah', isError: true);
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan, coba lagi', isError: true);
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
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  const SizedBox(height: 36),

                  // ── Logo ──
                  _buildLogo(),

                  const SizedBox(height: 16),

                  // ── Subtitle hijau ──
                  Text(
                    'MY SILMA SPORT CENTER ARENA',
                    style: TextStyle(
                      color: _accentGreen,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Judul utama ──
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Deskripsi ──
                  Text(
                    'Sistem Informasi Lapangan & Komunitas Badminton.\nBooking slot & Mabar lebih mudah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Card Form ──
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Label No. WhatsApp / Email ──
                        const Text(
                          'No. WhatsApp / Email',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ── Input WhatsApp / Email ──
                        _buildTextField(
                          controller: _contactController,
                          hintText: 'cth. 08123456789 atau nama@email.com',
                          prefixIcon: Icons.alternate_email_rounded,
                        ),

                        const SizedBox(height: 16),

                        // ── Label Kata Sandi + Lupa ──
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            const Text(
                              'Kata Sandi',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Lupa Kata Sandi?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _accentGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // ── Input Password ──
                        _buildPasswordField(),

                        const SizedBox(height: 14),

                        // ── Remember me + Face ID ──
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) {
                                      setState(
                                        () => _rememberMe = val ?? false,
                                      );
                                    },
                                    activeColor: _darkGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(color: Colors.grey[400]!),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Ingat Saya di perangkat ini',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),

                            // ── Face ID button ──
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _bgColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: _brightGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.face_retouching_natural,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Face ID',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Tombol Masuk ──
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _doLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _darkGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _darkGreen.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Masuk ke Akun',
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.person_outline_rounded, size: 20),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Daftar ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun MySILMA? ',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _accentGreen,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo dari file assets ──
  Widget _buildLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A5C38).withOpacity(0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset('assets/images/MySILMA Logo.png', fit: BoxFit.cover),
      ),
    );
  }

  // ── TextField biasa ──
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Icon(prefixIcon, color: Colors.grey[400], size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  // ── TextField Password ──
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Masukkan kata sandi akun',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: Colors.grey[400],
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
