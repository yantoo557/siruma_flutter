import 'package:flutter/material.dart';

import '../../../core/services/approval_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/profile_service.dart';
import '../../../models/approval_submission_model.dart';

import '../pemeriksaan/detail_pemeriksaan_page.dart';
import '../pemeriksaan/pemeriksaan_page.dart';
import '../notification/notification_page.dart';
import '../history/history_approval_page.dart';
import '../profile/profile_page.dart';

class SuperApprovalDashboardPage extends StatefulWidget {
  const SuperApprovalDashboardPage({super.key});

  @override
  State<SuperApprovalDashboardPage> createState() =>
      _SuperApprovalDashboardPageState();
}

class _SuperApprovalDashboardPageState
    extends State<SuperApprovalDashboardPage> {
  int _selectedIndex = 0;
  bool _hasUnreadNotifications = false;
  bool _isLoading = true;
  String? _loadError;
  String _pemeriksaanFilter = 'Semua';
  List<ApprovalSubmissionModel> _approvals = [];
  String _profileName = 'Super Approval';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _loadProfileName();
  }

  Future<void> _loadProfileName() async {
    try {
      final profile = await ProfileService.getProfile();
      final name = (profile['nama'] ?? profile['name'] ?? '').toString().trim();
      if (!mounted || name.isEmpty) return;
      setState(() {
        _profileName = name;
      });
    } catch (_) {
      // Pertahankan sapaan default jika profil gagal dimuat.
    }
  }

  Future<void> _loadDashboardData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      final results = await Future.wait([
        ApprovalService.getApprovals(),
        NotificationService.getNotifications(),
      ]);
      if (!mounted) return;
      final notifications = results[1] as Map<String, dynamic>;
      setState(() {
        _approvals = results[0] as List<ApprovalSubmissionModel>;
        _hasUnreadNotifications =
            ((notifications['unread_count'] as num?)?.toInt() ?? 0) > 0;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  int _countStatus(String status) => _approvals
      .where((item) => item.status.toUpperCase() == status)
      .length;

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'MENUNGGU':
        return 'Menunggu Pemeriksaan';
      case 'PERLU_REVISI':
        return 'Perlu Revisi';
      case 'DISETUJUI':
        return 'Disetujui';
      case 'DITOLAK':
        return 'Ditolak';
      default: return status;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  List<Map<String, dynamic>> get _summaryData => [
    {'title': 'Menunggu', 'count': _countStatus('MENUNGGU'), 'icon': Icons.schedule_outlined, 'color': const Color(0xFFD97706), 'filter': 'Menunggu Pemeriksaan', 'background': const Color(0xFFFFF5E5)},
    {'title': 'Revisi', 'count': _countStatus('PERLU_REVISI'), 'icon': Icons.replay_outlined, 'color': const Color(0xFF2563EB), 'filter': 'Perlu Revisi', 'background': const Color(0xFFEFF5FF)},
    {'title': 'Disetujui', 'count': _countStatus('DISETUJUI'), 'icon': Icons.check_circle_outline, 'color': const Color(0xFF16A34A), 'filter': 'Disetujui', 'background': const Color(0xFFEAF7EF)},
    {'title': 'Ditolak', 'count': _countStatus('DITOLAK'), 'icon': Icons.highlight_off, 'color': const Color(0xFFD64545), 'filter': 'Ditolak', 'background': const Color(0xFFFFEEEE)},
  ];

  List<ApprovalSubmissionModel> get _recentSubmissions {
    final items = [..._approvals];
    items.sort((a, b) {
      final aDate = a.tanggalMonitoring ?? a.tanggalApproval;
      final bDate = b.tanggalMonitoring ?? b.tanggalApproval;
      if (aDate == null && bDate == null) return b.id.compareTo(a.id);
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    return items.take(3).toList();
  }

  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color mutedText = Color(0xFF718078);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomePage(),
            PemeriksaanPage(
              key: ValueKey(_pemeriksaanFilter),
              initialFilter: _pemeriksaanFilter,
            ),
            const HistoryApprovalPage(),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHomePage() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildHeader(),
              const SizedBox(height: 26),
              _buildWelcomeCard(),
              const SizedBox(height: 26),
              _buildSectionHeading(
                'Ringkasan',
                trailing: 'Lihat pemeriksaan',
                onTrailingTap: () {
                  setState(() {
                    _pemeriksaanFilter = 'Semua';
                    _selectedIndex = 1;
                  });
                },
              ),
              const SizedBox(height: 13),
              _buildSummaryGrid(),
              const SizedBox(height: 27),
              _buildSectionHeading(
                'Pengajuan terbaru',
                trailing: 'Lihat semua',
                onTrailingTap: () {
                  setState(() {
                    _pemeriksaanFilter = 'Semua';
                    _selectedIndex = 1;
                  });
                },
              ),
              const SizedBox(height: 13),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_loadError != null)
                _buildLoadError()
              else if (_recentSubmissions.isEmpty)
                _buildEmptyRecent()
              else
                ..._recentSubmissions.map(_buildSubmissionCard),
            ]),
          ),
        ),
      ],
    ));
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Image.asset(
            'assets/images/siruma-logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.home_work_outlined,
              color: primaryGreen,
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIRUMA',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  color: darkGreen,
                ),
              ),
              Text(
                'Super Approval',
                style: TextStyle(
                  fontSize: 11,
                  color: mutedText,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _openNotifications,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: darkGreen,
                    size: 25,
                  ),
                  if (_hasUnreadNotifications)
                    Positioned(
                      top: 9,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE34B4B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(
          onUnreadChanged: (hasUnread) {
            if (!mounted) return;
            setState(() {
              _hasUnreadNotifications = hasUnread;
            });
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF087A5D), Color(0xFF064C3B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DASHBOARD',
                  style: TextStyle(
                    color: Color(0xFFBDE5D6),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Halo, $_profileName',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Siap meninjau pengajuan hari ini?',
                  style: TextStyle(
                    color: Color(0xFFD7EEE5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    setState(() {
                      _pemeriksaanFilter = 'Menunggu Pemeriksaan';
                      _selectedIndex = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Mulai periksa',
                          style: TextStyle(
                            color: primaryGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: primaryGreen,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFFD7EEE5),
              size: 39,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(
    String title, {
    String? trailing,
    VoidCallback? onTrailingTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: darkGreen,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: onTrailingTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              trailing,
              style: const TextStyle(
                color: primaryGreen,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    if (_isLoading) {
      return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) {
      return _buildLoadError();
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _summaryData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.62,
      ),
      itemBuilder: (context, index) {
        final item = _summaryData[index];
        return _buildSummaryCard(item);
      },
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> item) {
    final color = item['color'] as Color;
    final background = item['background'] as Color;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          setState(() {
            _pemeriksaanFilter = item['filter'] as String;
            _selectedIndex = 1;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8EFEB)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (item['count'] as int).toString(),
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 23,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(ApprovalSubmissionModel item) {
    final property = item.perumahan;
    final unit = 'Blok ${item.blok} · Unit ${item.unit}';
    final status = _statusLabel(item.status);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPemeriksaanPage(
                data: {
                  'approval_id': item.id.toString(),
                  'perumahan': item.perumahan,
                  'unit': 'Blok ${item.blok} · Unit ${item.unit}',
                  'pengaju': item.pengaju,
                  'tanggal': _formatDate(item.tanggalMonitoring),
                  'status': status,
                },
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFE8EFEB)),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5F0),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  color: primaryGreen,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unit,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatDate(item.tanggalMonitoring),
                      style: const TextStyle(
                        color: Color(0xFF929D97),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(status),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9AA69F),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final Color statusColor;
    final Color statusBackground;
    switch (status) {
      case 'Disetujui': statusColor = const Color(0xFF16A34A); statusBackground = const Color(0xFFEAF7EF); break;
      case 'Ditolak': statusColor = const Color(0xFFD64545); statusBackground = const Color(0xFFFFEEEE); break;
      case 'Perlu Revisi': statusColor = const Color(0xFF2563EB); statusBackground = const Color(0xFFEFF5FF); break;
      default: statusColor = const Color(0xFFD97706); statusBackground = const Color(0xFFFFF4DF);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: statusBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildLoadError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EFEB)),
      ),
      child: Column(
        children: [
          const Text('Data dashboard gagal dimuat.', style: TextStyle(color: darkGreen, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(_loadError ?? 'Periksa koneksi dan server API.', textAlign: TextAlign.center, style: const TextStyle(color: mutedText, fontSize: 11)),
          const SizedBox(height: 10),
          TextButton.icon(onPressed: _loadDashboardData, icon: const Icon(Icons.refresh), label: const Text('Coba lagi')),
        ],
      ),
    );
  }

  Widget _buildEmptyRecent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE8EFEB))),
      child: const Text('Belum ada pengajuan approval.', textAlign: TextAlign.center, style: TextStyle(color: mutedText, fontSize: 12)),
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        // Ambil ulang nama setelah pengguna kembali dari halaman Profil.
        if (index == 0) {
          _loadProfileName();
        }
      },
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE0F1EA),
      elevation: 8,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: Icon(Icons.fact_check_outlined),
          selectedIcon: Icon(Icons.fact_check_rounded),
          label: 'Pemeriksaan',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_rounded),
          selectedIcon: Icon(Icons.history_rounded),
          label: 'Riwayat',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }
}
