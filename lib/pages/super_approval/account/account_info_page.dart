import 'package:flutter/material.dart';

class AccountInfoPage extends StatelessWidget {
  final String namaPengguna;
  final String email;
  final String role;
  final String status;
  final String tanggalBergabung;

  const AccountInfoPage({
    super.key,
    this.namaPengguna = 'Super Approval',
    this.email = 'superapproval@siruma.com',
    this.role = 'Super Approval',
    this.status = 'Aktif',
    this.tanggalBergabung = 'Belum tersedia',
  });

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color secondaryText = Color(0xFF718078);

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF6F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryGreen, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: secondaryText),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: darkGreen,
        title: const Text(
          'Informasi Akun',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDENTITAS PENGGUNA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4F2EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: primaryGreen,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    namaPengguna,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Super Approval SIRUMA',
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Data Identitas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Column(
                children: [
                  _infoItem(
                    icon: Icons.person_outline,
                    label: 'Nama Lengkap',
                    value: namaPengguna,
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),
                  _infoItem(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: email,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Informasi Akun',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Column(
                children: [
                  _infoItem(
                    icon: Icons.badge_outlined,
                    label: 'Role / Hak Akses',
                    value: role,
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F5EE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            color: primaryGreen,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Expanded(
                          child: Text(
                            'Status Akun',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryText,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F5EE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: primaryGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),
                  _infoItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'Tanggal Bergabung',
                    value: tanggalBergabung,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Informasi akun hanya dapat dilihat oleh Super Approval.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
