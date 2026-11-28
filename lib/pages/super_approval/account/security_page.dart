
import 'package:flutter/material.dart';
import '../../../core/services/profile_service.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final _formKey = GlobalKey<FormState>();
  final _passwordLamaController = TextEditingController();
  final _passwordBaruController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  bool _sembunyikanLama = true;
  bool _sembunyikanBaru = true;
  bool _sembunyikanKonfirmasi = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  Widget _fieldPassword({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: primaryGreen,
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: secondaryText,
              ),
            ),
            filled: true,
            fillColor: backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _simpanPerubahan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ProfileService.changePassword(
        oldPassword: _passwordLamaController.text,
        newPassword: _passwordBaruController.text,
        newPasswordConfirmation: _konfirmasiController.text,
      );

      if (!mounted) return;

      _passwordLamaController.clear();
      _passwordBaruController.clear();
      _konfirmasiController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diperbarui.'),
          backgroundColor: primaryGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final pesan = e.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesan),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Keamanan Akun',
          style: TextStyle(
            color: darkGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE5ECE8),
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFE4F2EA),
                      child: Icon(
                        Icons.shield_outlined,
                        color: primaryGreen,
                        size: 27,
                      ),
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lindungi Akun Anda',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gunakan password yang kuat untuk menjaga keamanan akun SIRUMA.',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Ubah Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Masukkan password lama dan password baru Anda.',
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 22),

              _fieldPassword(
                label: 'Password Lama',
                hint: 'Masukkan password lama',
                controller: _passwordLamaController,
                obscureText: _sembunyikanLama,
                onToggle: () {
                  setState(() {
                    _sembunyikanLama = !_sembunyikanLama;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password lama wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _fieldPassword(
                label: 'Password Baru',
                hint: 'Masukkan password baru',
                controller: _passwordBaruController,
                obscureText: _sembunyikanBaru,
                onToggle: () {
                  setState(() {
                    _sembunyikanBaru = !_sembunyikanBaru;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru wajib diisi.';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter.';
                  }
                  if (value == _passwordLamaController.text) {
                    return 'Password baru harus berbeda.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _fieldPassword(
                label: 'Konfirmasi Password Baru',
                hint: 'Masukkan ulang password baru',
                controller: _konfirmasiController,
                obscureText: _sembunyikanKonfirmasi,
                onToggle: () {
                  setState(() {
                    _sembunyikanKonfirmasi =
                        !_sembunyikanKonfirmasi;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password wajib diisi.';
                  }
                  if (value != _passwordBaruController.text) {
                    return 'Konfirmasi password tidak cocok.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _simpanPerubahan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryGreen.withValues(
                      alpha: 0.6,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  'Pastikan password baru Anda mudah diingat dan sulit ditebak.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
