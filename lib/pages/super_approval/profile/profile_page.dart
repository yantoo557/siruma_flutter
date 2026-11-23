import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../account/account_info_page.dart';
import '../account/security_page.dart';
import '../about/tentang_siruma_page.dart';
import '../help/bantuan_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  String namaPengguna = 'Super Approval';
  final String email = 'superapproval@siruma.com';

  XFile? fotoProfil;
  final ImagePicker imagePicker = ImagePicker();

  String get inisial {
    final words = namaPengguna.trim().split(' ');
    if (words.isEmpty || words.first.isEmpty) return 'SA';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  Future<void> pilihFoto(ImageSource source) async {
    final image = await imagePicker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 600,
      maxHeight: 600,
    );

    if (image != null && mounted) {
      setState(() {
        fotoProfil = image;
      });
    }
  }

  void editProfil() {
    final controller = TextEditingController(text: namaPengguna);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            14,
            22,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Perbarui informasi profil kamu',
                  style: TextStyle(fontSize: 12, color: secondaryText),
                ),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: () async {
                    final source = await showModalBottomSheet<ImageSource>(
                      context: sheetContext,
                      backgroundColor: Colors.white,
                      builder: (context) => SafeArea(
                        child: Wrap(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(18),
                              child: Text(
                                'Pilih Foto Profil',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.camera_alt_outlined,
                                color: primaryGreen,
                              ),
                              title: const Text('Ambil Foto'),
                              onTap: () =>
                                  Navigator.pop(context, ImageSource.camera),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.photo_library_outlined,
                                color: primaryGreen,
                              ),
                              title: const Text('Pilih dari Galeri'),
                              onTap: () =>
                                  Navigator.pop(context, ImageSource.gallery),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (source != null) await pilihFoto(source);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFFE4F2EA),
                        backgroundImage: fotoProfil != null
                            ? ResizeImage(
                                FileImage(File(fotoProfil!.path)),
                                width: 192,
                                height: 192,
                              )
                            : null,
                        child: fotoProfil == null
                            ? Text(
                                inisial,
                                style: const TextStyle(
                                  color: primaryGreen,
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ketuk foto untuk mengubah',
                  style: TextStyle(
                    fontSize: 11,
                    color: primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 25),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nama Lengkap',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: primaryGreen,
                    ),
                    filled: true,
                    fillColor: backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final namaBaru = controller.text.trim();

                      if (namaBaru.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama tidak boleh kosong.'),
                          ),
                        );
                        return;
                      }

                      setState(() => namaPengguna = namaBaru);
                      Navigator.pop(sheetContext);

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil berhasil diperbarui.'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: secondaryText),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(controller.dispose);
  }

  void tampilkanInfo(String judul, String deskripsi) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(judul),
        content: Text(deskripsi),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup', style: TextStyle(color: primaryGreen)),
          ),
        ],
      ),
    );
  }

  void konfirmasiKeluar() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari aplikasi SIRUMA?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD64545),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Fitur logout akan diaktifkan setelah integrasi autentikasi.',
                  ),
                ),
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
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
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: secondaryText, size: 21),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: darkGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE4F2EA),
                      border: Border.all(color: primaryGreen, width: 2),
                    ),
                    child: ClipOval(
                      child: fotoProfil != null
                          ? Image.file(
                              File(fotoProfil!.path),
                              key: ValueKey(fotoProfil!.path),
                              width: 86,
                              height: 86,
                              fit: BoxFit.cover,
                              cacheWidth: 172,
                              cacheHeight: 172,
                              filterQuality: FilterQuality.low,
                            )
                          : Center(
                              child: Text(
                                inisial,
                                style: const TextStyle(
                                  color: primaryGreen,
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    namaPengguna,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 12, color: secondaryText),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F2EA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Super Approval',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: editProfil,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Edit Profil'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryGreen,
                      side: const BorderSide(color: primaryGreen),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pengaturan Akun',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5ECE8)),
              ),
              child: Column(
                children: [
                  menuItem(
                    icon: Icons.person_outline,
                    title: 'Informasi Akun',
                    subtitle: 'Lihat informasi akun Super Approval',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountInfoPage(
                            namaPengguna: namaPengguna,
                            email: email,
                            role: 'Super Approval',
                            status: 'Aktif',
                            tanggalBergabung: 'Belum tersedia',
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),
                  menuItem(
                    icon: Icons.lock_outline,
                    title: 'Keamanan Akun',
                    subtitle: 'Pengaturan keamanan akun',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecurityPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),
                  menuItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    subtitle: 'Informasi penggunaan aplikasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BantuanPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),
                  menuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang SIRUMA',
                    subtitle: 'Informasi aplikasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TentangSirumaPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 49,
              child: OutlinedButton.icon(
                onPressed: konfirmasiKeluar,
                icon: const Icon(Icons.logout, size: 19),
                label: const Text(
                  'Keluar dari Akun',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD64545),
                  side: const BorderSide(color: Color(0xFFF0CCCC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'SIRUMA',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Sistem Informasi Rumah dan Aset',
              style: TextStyle(fontSize: 10, color: secondaryText),
            ),
            const SizedBox(height: 4),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 10, color: secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
