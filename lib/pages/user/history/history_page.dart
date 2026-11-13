
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedFilter = 'Semua';

  final List<Map<String, dynamic>> monitoringList = [
    {
      'perumahan': 'Perumahan H',
      'blok': 'A',
      'unit': 'A1',
      'tanggal': '12 November 2026',
      'status': 'Menunggu Approval',
      'catatan': '',
    },
    {
      'perumahan': 'Perumahan H',
      'blok': 'A',
      'unit': 'A2',
      'tanggal': '10 November 2026',
      'status': 'Disetujui',
      'catatan': 'Monitoring telah disetujui.',
    },
    {
      'perumahan': 'Perumahan H',
      'blok': 'B',
      'unit': 'B1',
      'tanggal': '8 November 2026',
      'status': 'Ditolak',
      'catatan': 'Mohon lengkapi foto bagian belakang rumah.',
    },
  ];

  List<Map<String, dynamic>> get filteredList {
    if (selectedFilter == 'Semua') return monitoringList;

    return monitoringList
        .where((item) => item['status'] == selectedFilter)
        .toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFF16865D);
      case 'Ditolak':
        return const Color(0xFFD64545);
      default:
        return const Color(0xFFD58A19);
    }
  }

  Color getStatusBackground(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFFE6F5EE);
      case 'Ditolak':
        return const Color(0xFFFCEAEA);
      default:
        return const Color(0xFFFFF4DF);
    }
  }

  void showMonitoringDetail(Map<String, dynamic> item) {
    final status = item['status'] as String;
    final catatan = item['catatan'] as String;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Detail Monitoring',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _detailRow('Perumahan', item['perumahan']),
              _detailRow('Blok', item['blok']),
              _detailRow('Nomor Unit', item['unit']),
              _detailRow('Tanggal Pengajuan', item['tanggal']),
              const SizedBox(height: 16),
              const Text(
                'Status Monitoring',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: getStatusBackground(status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (catatan.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text(
                  'Catatan Approval',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  catatan,
                  style: const TextStyle(color: Color(0xFF5B6B66)),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006B50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 135,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF718078)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF26332E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006B50) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF006B50)
                : const Color(0xFFE0E7E3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF5B6B66),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMonitoringCard(Map<String, dynamic> item) {
    final status = item['status'] as String;

    return InkWell(
      onTap: () => showMonitoringDetail(item),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EEEA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['perumahan'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF26332E),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusBackground(status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: getStatusColor(status),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.home_outlined,
                  size: 17,
                  color: Color(0xFF718078),
                ),
                const SizedBox(width: 6),
                Text(
                  'Blok ${item['blok']} • Unit ${item['unit']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B6B66),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xFF718078),
                ),
                const SizedBox(width: 7),
                Text(
                  item['tanggal'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF718078),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF006B50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.chevron_right,
                  size: 17,
                  color: Color(0xFF006B50),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Riwayat Monitoring',
          style: TextStyle(
            color: Color(0xFF173D32),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
            child: const Text(
              'Pantau status monitoring rumah yang telah kamu ajukan.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF718078),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: const Text(
              'Daftar Pengajuan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26332E),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilter('Semua'),
                const SizedBox(width: 8),
                _buildFilter('Menunggu Approval'),
                const SizedBox(width: 8),
                _buildFilter('Disetujui'),
                const SizedBox(width: 8),
                _buildFilter('Ditolak'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history,
                          size: 48,
                          color: Color(0xFFB5C2BB),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada riwayat monitoring',
                          style: TextStyle(
                            color: Color(0xFF718078),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return _buildMonitoringCard(filteredList[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
