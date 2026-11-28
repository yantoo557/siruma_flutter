import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/login_page.dart';
import '../../../core/config/api_config.dart';
import '../../../core/services/profile_service.dart';

import '../about/tentang_siruma_page.dart';
import '../help/bantuan_page.dart';
import '../account/security_page.dart';
import '../account/account_info_page.dart';

class ProfilePage extends StatefulWidget {
  final ValueChanged<String>? onNamaBerubah;

  const ProfilePage({super.key, this.onNamaBerubah});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final ImagePicker picker = ImagePicker();

  String namaPengguna = 'Super Approval';
  String email = '-';
  String username = '-';
  String role = 'Super Approval';
  String status = '-';
  String tanggalBergabung = 'Belum tersedia';

  String? fotoProfilUrl;
  XFile? fotoProfilLokal;

  bool sedangMemuat = true;
  bool sedangMenyimpan = false;
  bool sedangLogout = false;

  @override
  void initState() {
    super.initState();
    ambilProfil();
  }

  // Mengubah URL 127.0.0.1 dari Laravel menjadi IP laptop
  // yang dapat diakses oleh HP melalui jaringan Wi-Fi.
  String? sesuaikanUrlFoto(String? url) {
    if (url == null || url.isEmpty) return null;

    try {
      final photoUri = Uri.parse(url);
      final apiUri = Uri.parse(ApiConfig.baseUrl);

      return photoUri
          .replace(scheme: apiUri.scheme, host: apiUri.host, port: apiUri.port)
          .toString();
    } catch (_) {
      return url;
    }
  }

  Future<void> ambilProfil() async {
    try {
      final data = await ProfileService.getProfile();

      if (!mounted) return;

      setState(() {
        namaPengguna = data['nama']?.toString() ?? 'Super Approval';
        email = data['email']?.toString() ?? '-';
        username = data['username']?.toString() ?? '-';
        role = data['role']?.toString() ?? 'Super Approval';
        status = data['status']?.toString() ?? '-';

        final tanggal = data['tanggal_bergabung']?.toString();
        tanggalBergabung = formatTanggal(tanggal);

        fotoProfilUrl = sesuaikanUrlFoto(data['foto_profil']?.toString());

        sedangMemuat = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        sedangMemuat = false;
      });

      tampilkanInfo(
        'Gagal Memuat Profil',
        'Tidak dapat mengambil informasi profil dari server.\n\n$e',
      );
    }
  }

  String formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) {
      return 'Belum tersedia';
    }

    try {
      final date = DateTime.parse(tanggal).toLocal();

      const bulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];

      return '${date.day} ${bulan[date.month - 1]} ${date.year}';
    } catch (_) {
      return tanggal;
    }
  }

  Future<void> pilihFoto(ImageSource source) async {
    try {
      final image = await picker.pickImage(
        source: source,
        imageQuality: 65,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image == null || !mounted) return;

      // Hanya preview, belum upload ke server.
      setState(() {
        fotoProfilLokal = image;
      });
    } catch (e) {
      if (!mounted) return;

      tampilkanInfo(
        'Gagal Memilih Foto',
        'Terjadi kesalahan saat memilih foto.\n\n$e',
      );
    }
  }

  Future<void> tampilkanPilihanFoto(StateSetter updateSheet) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (photoContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: primaryGreen,
                ),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(photoContext, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: primaryGreen,
                ),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(photoContext, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (source == null || !mounted) return;

    await pilihFoto(source);

    if (mounted) {
      updateSheet(() {});
    }
  }

  Future<void> simpanNama(String nama) async {
    if (nama.trim().isEmpty) {
      tampilkanInfo('Perhatian', 'Nama lengkap tidak boleh kosong.');
      return;
    }

    if (sedangMenyimpan) return;

    setState(() {
      sedangMenyimpan = true;
    });

    try {
      // Simpan nama terlebih dahulu.
      final data = await ProfileService.updateProfile(nama: nama.trim());

      if (!mounted) return;

      String? fotoBaru = fotoProfilUrl;

      // Upload foto hanya jika pengguna memilih foto baru.
      if (fotoProfilLokal != null) {
        final fotoData = await ProfileService.uploadProfilePhoto(
          File(fotoProfilLokal!.path),
        );

        fotoBaru = sesuaikanUrlFoto(fotoData['foto_profil']?.toString());
      }

      if (!mounted) return;

      setState(() {
        namaPengguna = data['nama']?.toString() ?? nama.trim();
        email = data['email']?.toString() ?? email;
        fotoProfilUrl = fotoBaru;
        fotoProfilLokal = null;
        sedangMenyimpan = false;
      });

      widget.onNamaBerubah?.call(namaPengguna);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui.'),
          backgroundColor: primaryGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        sedangMenyimpan = false;
      });

      tampilkanInfo(
        'Gagal Menyimpan',
        'Perubahan profil tidak berhasil disimpan.\n\n$e',
      );
    }
  }

  ImageProvider? get gambarProfil {
    if (fotoProfilLokal != null) {
      return FileImage(File(fotoProfilLokal!.path));
    }

    if (fotoProfilUrl != null && fotoProfilUrl!.isNotEmpty) {
      return NetworkImage(fotoProfilUrl!);
    }

    return null;
  }

  Widget avatarProfil({required double radius, required double ukuranHuruf}) {
    return CircleAvatar(
      key: ValueKey(fotoProfilUrl ?? fotoProfilLokal?.path ?? 'default'),
      radius: radius,
      backgroundColor: const Color(0xFFE5F2EA),
      backgroundImage: gambarProfil,
      child: gambarProfil == null
          ? Text(
              namaPengguna.isNotEmpty ? namaPengguna[0].toUpperCase() : 'S',
              style: TextStyle(
                fontSize: ukuranHuruf,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            )
          : null,
    );
  }

  void tampilkanEditProfil() {
    final controller = TextEditingController(text: namaPengguna);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, updateSheet) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 70,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      const Center(
                        child: Text(
                          'Edit Profil',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Center(
                        child: Text(
                          'Perbarui informasi profil kamu',
                          style: TextStyle(fontSize: 15, color: secondaryText),
                        ),
                      ),
                      const SizedBox(height: 50),

                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            await tampilkanPilihanFoto(updateSheet);
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              avatarProfil(radius: 78, ukuranHuruf: 55),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(13),
                                  decoration: const BoxDecoration(
                                    color: primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 23,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Center(
                        child: Text(
                          'Ketuk foto untuk mengubah',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 55),

                      const Text(
                        'Nama Lengkap',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: controller,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: primaryGreen,
                            size: 27,
                          ),
                          filled: true,
                          fillColor: backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 23,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: sedangMenyimpan
                              ? null
                              : () => simpanNama(controller.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: sedangMenyimpan
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Simpan Perubahan',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              fotoProfilLokal = null;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      controller.dispose();

      if (mounted && fotoProfilLokal != null) {
        setState(() {
          fotoProfilLokal = null;
        });
      }
    });
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFEDF7F2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: primaryGreen, size: 27),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: darkGreen,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          subtitle,
          style: const TextStyle(color: secondaryText, fontSize: 13),
        ),
      ),
        trailing: const Icon(Icons.chevron_right, color: secondaryText, size: 25),
        onTap: onTap,
      ),
    );
  }

  void tampilkanInfo(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: primaryGreen)),
          ),
        ],
      ),
    );
  }

  Future<void> konfirmasiLogout() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun SIRUMA?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (yakin != true || !mounted) return;

    setState(() {
      sedangLogout = true;
    });

    try {
      await ProfileService.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        sedangLogout = false;
      });

      tampilkanInfo(
        'Logout Gagal',
        'Tidak dapat keluar dari akun. Silakan coba kembali.\n\n$e',
      );
    }
  }

  void bukaInformasiAkun() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountInfoPage(
          namaPengguna: namaPengguna,
          email: email,
          role: role,
          status: status,
          tanggalBergabung: tanggalBergabung,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: darkGreen,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang profil',
            onPressed: sedangMemuat ? null : ambilProfil,
            icon: const Icon(Icons.refresh, color: primaryGreen),
          ),
        ],
      ),
      body: sedangMemuat
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : RefreshIndicator(
              color: primaryGreen,
              onRefresh: ambilProfil,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KARTU PROFIL
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE1E9E5)),
                      ),
                      child: Column(
                        children: [
                          avatarProfil(radius: 53, ukuranHuruf: 42),
                          const SizedBox(height: 22),

                          Text(
                            namaPengguna,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 8),

                          const Text(
                            'Administrator SIRUMA',
                            style: TextStyle(
                              fontSize: 15,
                              color: secondaryText,
                            ),
                          ),
                          const SizedBox(height: 28),

                          OutlinedButton.icon(
                            onPressed: tampilkanEditProfil,
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            label: const Text('Edit Profil'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryGreen,
                              side: const BorderSide(
                                color: primaryGreen,
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 27,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Pengaturan Akun',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // MENU PENGATURAN AKUN
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE1E9E5)),
                      ),
                      child: Column(
                        children: [
                          menuItem(
                            icon: Icons.person_outline,
                            title: 'Informasi Akun',
                            subtitle: 'Lihat informasi akun Super Approval',
                            onTap: bukaInformasiAkun,
                          ),
                          const Divider(height: 1, indent: 18, endIndent: 18),
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
                          const Divider(height: 1, indent: 18, endIndent: 18),
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
                          const Divider(height: 1, indent: 18, endIndent: 18),
                          menuItem(
                            icon: Icons.info_outline,
                            title: 'Tentang SIRUMA',
                            subtitle: 'Informasi aplikasi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TentangSirumaPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // LOGOUT
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton.icon(
                        onPressed: sedangLogout ? null : konfirmasiLogout,
                        icon: sedangLogout
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFD64545),
                                ),
                              )
                            : const Icon(
                                Icons.logout,
                                color: Color(0xFFD64545),
                              ),
                        label: Text(
                          sedangLogout
                              ? 'Sedang Keluar...'
                              : 'Keluar dari Akun',
                          style: const TextStyle(
                            color: Color(0xFFD64545),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF0CCCC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Center(
                      child: Text(
                        'SIRUMA • Versi 1.0.0',
                        style: TextStyle(fontSize: 11, color: secondaryText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
