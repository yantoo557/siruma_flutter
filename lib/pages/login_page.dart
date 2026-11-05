
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  static const Color green = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF003D30);
  static const Color borderColor = Color(0xFFC9D8D3);
  static const Color subtitleColor = Color(0xFF71817B);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi login frontend.
    // Nantinya dihubungkan ke API Laravel SIRUMA.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login berhasil diuji'),
        backgroundColor: green,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF899A94),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 17,
      ),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: borderColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: green,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: darkGreen,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // LINGKARAN HIJAU PASTEL
                  Positioned(
                    top: -145,
                    right: -165,
                    child: Container(
                      width: 330,
                      height: 330,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF6F0),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // KONTEN LOGIN
                  SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 480,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                // JARAK ATAS
                                const SizedBox(height: 125),

                                // LOGO SIRUMA
                                Center(
                                  child: Image.asset(
                                    'assets/images/siruma-logo.png',
                                    width: 125,
                                    height: 90,
                                    fit: BoxFit.contain,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return const Icon(
                                        Icons.home_work_rounded,
                                        size: 75,
                                        color: green,
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // JUDUL
                                const Text(
                                  'Selamat Datang',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    color: darkGreen,
                                    letterSpacing: -0.4,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // SUBTITLE
                                const Text(
                                  'Silakan masuk untuk melanjutkan.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: subtitleColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                const SizedBox(height: 36),

                                // FORM EMAIL
                                _label('Email'),

                                TextFormField(
                                  controller: _emailController,
                                  keyboardType:
                                      TextInputType.emailAddress,
                                  textInputAction:
                                      TextInputAction.next,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: darkGreen,
                                  ),
                                  decoration: _inputDecoration(
                                    hint: 'Masukkan email Anda',
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Email wajib diisi';
                                    }

                                    if (!RegExp(
                                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                    ).hasMatch(value.trim())) {
                                      return 'Format email tidak valid';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 19),

                                // FORM PASSWORD
                                _label('Kata Sandi'),

                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  textInputAction:
                                      TextInputAction.done,
                                  onFieldSubmitted: (_) =>
                                      _handleLogin(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: darkGreen,
                                  ),
                                  decoration: _inputDecoration(
                                    hint: 'Masukkan kata sandi Anda',
                                    suffix: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 14,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                        child: Center(
                                          widthFactor: 1,
                                          child: Text(
                                            _obscurePassword
                                                ? 'Lihat'
                                                : 'Sembunyikan',
                                            style: const TextStyle(
                                              color: green,
                                              fontSize: 12,
                                              fontWeight:
                                                  FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Kata sandi wajib diisi';
                                    }
                                    return null;
                                  },
                                ),

                                // LUPA PASSWORD
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Silakan hubungi administrator '
                                            'untuk reset kata sandi.',
                                          ),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: green,
                                      padding:
                                          const EdgeInsets.only(
                                        top: 9,
                                        bottom: 8,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Lupa Kata Sandi?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 27),

                                // TOMBOL MASUK
                                SizedBox(
                                  height: 49,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: green,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor:
                                          green.withOpacity(0.6),
                                      elevation: 7,
                                      shadowColor:
                                          green.withOpacity(0.18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Masuk',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
