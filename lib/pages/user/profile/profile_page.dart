import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../account/account_info_page.dart';
import '../account/security_page.dart';
import '../help/bantuan_page.dart';
import '../about/tentang_siruma_page.dart';

class ProfilePage extends StatefulWidget {
  final String namaPengguna;

  const ProfilePage({super.key, this.namaPengguna = 'Pengguna'});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String namaPengguna;
  XFile? fotoProfil;
  final ImagePicker _imagePicker = ImagePicker();
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  @override
  void initState() {
    super.initState();
    namaPengguna = widget.namaPengguna;
  }

  String get inisial {
    final words = namaPengguna.trim().split(' ');
    if (words.isEmpty || words.first.isEmpty) return 'U';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  Future<void> _pilihFoto(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1000,
    );

    if (image != null && mounted) {
      setState(() {
        fotoProfil = image;
      });
    }
  }

  void _editProfil() {
    final controller = TextEditingController(text: namaPengguna);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                14,
                22,
                MediaQuery.of(context).viewInsets.bottom + 24,
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

                    // FOTO PROFIL
                    GestureDetector(
                      onTap: () async {
                        final source = await showModalBottomSheet<ImageSource>(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => SafeArea(
                            child: Wrap(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(18),
                                  child: Text(
                                    'Pilih Foto Profil',
                                    style: TextStyle(
                                      fontSize: 16,
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
                                  onTap: () => Navigator.pop(
                                    context,
                                    ImageSource.camera,
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.photo_library_outlined,
                                    color: primaryGreen,
                                  ),
                                  title: const Text('Pilih dari Galeri'),
                                  onTap: () => Navigator.pop(
                                    context,
                                    ImageSource.gallery,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        );

                        if (source != null) {
                          await _pilihFoto(source);
                          setSheetState(() {});
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: const Color(0xFFE4F2EA),
                            backgroundImage: fotoProfil != null
                                ? FileImage(File(fotoProfil!.path))
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

                    // INPUT NAMA
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
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama lengkap',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: primaryGreen,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F8F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // TOMBOL SIMPAN
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final namaBaru = controller.text.trim();

                          if (namaBaru.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nama lengkap tidak boleh kosong.',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            namaPengguna = namaBaru;
                          });

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
        );
      },
    ).whenComplete(() {
      controller.dispose();
    });
  }

  void _showInfo(String title, String description) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup', style: TextStyle(color: primaryGreen)),
          ),
        ],
      ),
    );
  }

  void _konfirmasiKeluar() {
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

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = primaryGreen,
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
              child: Icon(icon, color: iconColor, size: 21),
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
                              width: 86,
                              height: 86,
                              fit: BoxFit.cover,
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
                  const Text(
                    'Pengguna SIRUMA',
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _editProfil,
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

            Align(
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
                  _menuItem(
                    icon: Icons.person_outline,
                    title: 'Informasi Akun',
                    subtitle: 'Lihat informasi akun pengguna',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AccountInfoPage(namaPengguna: namaPengguna),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFE9EFEB)),
                  _menuItem(
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
                  _menuItem(
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

                  _menuItem(
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
                onPressed: _konfirmasiKeluar,
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
