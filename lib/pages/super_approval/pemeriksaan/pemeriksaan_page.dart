import 'package:flutter/material.dart';

import 'detail_pemeriksaan_page.dart';

class PemeriksaanPage extends StatefulWidget {
  final String initialFilter;

  const PemeriksaanPage({super.key, this.initialFilter = 'Semua'});

  @override
  State<PemeriksaanPage> createState() => _PemeriksaanPageState();
}

class _PemeriksaanPageState extends State<PemeriksaanPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);

  late String filterAktif;

  @override
  void initState() {
    super.initState();
    filterAktif = widget.initialFilter;
  }

  final List<Map<String, dynamic>> pengajuan = [
    {
      'perumahan': 'Perumahan H',
      'blok': 'A',
      'unit': 'A1',
      'pengaju': 'Ahmad Fauzi',
      'tanggal': '13 November 2026',
      'status': 'Menunggu Pemeriksaan',
    },
    {
      'perumahan': 'Perumahan B',
      'blok': 'B',
      'unit': 'B2',
      'pengaju': 'Muhammad Rizal',
      'tanggal': '12 November 2026',
      'status': 'Menunggu Pemeriksaan',
    },
    {
      'perumahan': 'Perumahan C',
      'blok': 'A',
      'unit': 'A3',
      'pengaju': 'Andi Saputra',
      'tanggal': '11 November 2026',
      'status': 'Perlu Revisi',
    },
    {
      'perumahan': 'Perumahan D',
      'blok': 'C',
      'unit': 'C1',
      'pengaju': 'Siti Rahma',
      'tanggal': '10 November 2026',
      'status': 'Menunggu Pemeriksaan',
    },
  ];

  List<Map<String, dynamic>> get pengajuanTerfilter {
    if (filterAktif == 'Semua') return pengajuan;

    return pengajuan.where((item) => item['status'] == filterAktif).toList();
  }

  Color warnaStatus(String status) {
    switch (status) {
      case 'Menunggu Pemeriksaan':
        return const Color(0xFFD97706);
      case 'Perlu Revisi':
        return const Color(0xFF2563EB);
      case 'Disetujui':
        return const Color(0xFF16A34A);
      case 'Ditolak':
        return const Color(0xFFD64545);
      default:
        return darkGreen;
    }
  }

  Color latarStatus(String status) {
    switch (status) {
      case 'Menunggu Pemeriksaan':
        return const Color(0xFFFFF4DF);
      case 'Perlu Revisi':
        return const Color(0xFFEAF1FF);
      case 'Disetujui':
        return const Color(0xFFE8F7EE);
      case 'Ditolak':
        return const Color(0xFFFCECEC);
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pemeriksaan',
          style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilter(),
            Expanded(
              child: pengajuanTerfilter.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: pengajuanTerfilter.length,
                      itemBuilder: (context, index) {
                        final item = pengajuanTerfilter[index];
                        return _buildPengajuanCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Pengajuan',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Periksa dan tinjau pengajuan monitoring rumah.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    final filters = [
      'Semua',
      'Menunggu Pemeriksaan',
      'Perlu Revisi',
      'Disetujui',
      'Ditolak',
    ];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filterAktif == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: selected,
            showCheckmark: false,
            selectedColor: primaryGreen,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: selected ? primaryGreen : Colors.grey.shade200,
              ),
            ),
            onSelected: (_) {
              setState(() => filterAktif = filter);
            },
          );
        },
      ),
    );
  }

  Widget _buildPengajuanCard(Map<String, dynamic> item) {
    final status = item['status'] as String;
    final warna = warnaStatus(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPemeriksaanPage(
                data: {
                  'perumahan': item['perumahan'].toString(),
                  'blok': item['blok'].toString(),
                  'unit': item['unit'].toString(),
                  'pengaju': item['pengaju'].toString(),
                  'tanggal': item['tanggal'].toString(),
                  'status': item['status'].toString(),
                },
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3EF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      color: primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['perumahan'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: latarStatus(status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: warna,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Blok ${item['blok']} · Unit ${item['unit']}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pengaju: ${item['pengaju']}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    item['tanggal'],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const Spacer(),
                  const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: primaryGreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Pengajuan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Belum ada pengajuan pada kategori ini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
