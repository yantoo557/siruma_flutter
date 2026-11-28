import 'package:flutter/material.dart';

import '../../../core/services/blok_service.dart';
import '../../../core/services/monitoring_service.dart';
import '../../../models/blok_model.dart';
import '../../../models/unit_model.dart';
import 'land_data_page.dart';
import '../draft/draft_list_page.dart';

class SelectUnitPage extends StatefulWidget {
  final int perumahanId;
  final String namaPerumahan;
  final String namaDeveloper;

  const SelectUnitPage({
    super.key,
    required this.perumahanId,
    required this.namaPerumahan,
    required this.namaDeveloper,
  });

  @override
  State<SelectUnitPage> createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  static const Color primaryGreen = Color(0xFF006B50);
  static const Color darkGreen = Color(0xFF173D32);
  static const Color backgroundColor = Color(0xFFF4F8F6);
  static const Color secondaryText = Color(0xFF718078);

  final TextEditingController _searchController = TextEditingController();

  List<BlokModel> _blokList = [];
  final Map<int, List<UnitModel>> _unitsByBlok = {};

  int? _selectedUnitId;
  bool _isLoading = true;
  bool _isContinuing = false;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBlokDanUnit();
  }

  Future<void> _loadBlokDanUnit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final blok = await BlokService.getBlok(widget.perumahanId);

      final Map<int, List<UnitModel>> unitMap = {};

      for (final item in blok) {
        final units = await BlokService.getUnit(item.id);

        // Hanya tampilkan unit yang aktif.
        unitMap[item.id] = units
            .where((unit) => unit.status.toLowerCase() == 'aktif')
            .toList();
      }

      if (!mounted) return;

      setState(() {
        _blokList = blok;
        _unitsByBlok
          ..clear()
          ..addAll(unitMap);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  List<UnitModel> _filteredUnitsFor(BlokModel blok) {
    final units = _unitsByBlok[blok.id] ?? [];
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) return units;

    return units.where((unit) {
      return unit.nomorUnit.toLowerCase().contains(query) ||
          blok.namaBlok.toLowerCase().contains(query);
    }).toList();
  }

  bool get _hasUnits {
    return _unitsByBlok.values.any((units) => units.isNotEmpty);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih unit rumah yang akan dinilai.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF52645D)),
                    ),
                    const SizedBox(height: 18),
                    _buildInformationCard(),
                    const SizedBox(height: 10),
                    _buildServerBadge(),
                    const SizedBox(height: 14),
                    _buildSearchField(),
                    const SizedBox(height: 20),
                    _buildContent(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: darkGreen,
              ),
            ),
          ),
          const Text(
            'Pilih Rumah',
            style: TextStyle(
              color: darkGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1EBE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Perumahan',
            style: TextStyle(fontSize: 12, color: secondaryText),
          ),
          const SizedBox(height: 5),
          Text(
            widget.namaPerumahan,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkGreen,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 11),
            child: Divider(height: 1, color: Color(0xFFE8EFEB)),
          ),
          const Text(
            'Developer Perumahan',
            style: TextStyle(fontSize: 12, color: secondaryText),
          ),
          const SizedBox(height: 5),
          Text(
            widget.namaDeveloper,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F4ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Data dari server',
        style: TextStyle(
          color: primaryGreen,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          _selectedUnitId = null;
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari nomor rumah atau blok',
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF89958F)),
        prefixIcon: const Icon(Icons.search, color: secondaryText, size: 22),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedUnitId = null;
                  });
                },
                icon: const Icon(Icons.close),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFD7E4DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFD7E4DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: primaryGreen),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 55),
        child: Center(child: CircularProgressIndicator(color: primaryGreen)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                color: secondaryText,
                size: 38,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal mengambil data blok dan unit.',
                style: TextStyle(
                  color: darkGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: secondaryText, fontSize: 11),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _loadBlokDanUnit,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: OutlinedButton.styleFrom(foregroundColor: primaryGreen),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasUnits) {
      return const Padding(
        padding: EdgeInsets.only(top: 35),
        child: Center(
          child: Text(
            'Belum ada unit aktif pada perumahan ini.',
            style: TextStyle(fontSize: 13, color: secondaryText),
          ),
        ),
      );
    }

    final visibleBlok = _blokList
        .where((blok) => _filteredUnitsFor(blok).isNotEmpty)
        .toList();

    if (visibleBlok.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 35),
        child: Center(
          child: Text(
            'Unit rumah tidak ditemukan.',
            style: TextStyle(fontSize: 13, color: secondaryText),
          ),
        ),
      );
    }

    return Column(
      children: visibleBlok.map((blok) {
        return _buildBlokSection(blok, _filteredUnitsFor(blok));
      }).toList(),
    );
  }

  Widget _buildBlokSection(BlokModel blok, List<UnitModel> units) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blok.namaBlok,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          const SizedBox(height: 10),
          ...units.map(
            (unit) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildUnitCard(blok, unit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitCard(BlokModel blok, UnitModel unit) {
    final isSelected = _selectedUnitId == unit.id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedUnitId = unit.id;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryGreen : const Color(0xFFE1EBE5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF7F2),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.home_outlined,
                color: primaryGreen,
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor rumah ${unit.nomorUnit}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    blok.namaBlok,
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Luas tanah ${unit.luasTanah} m²',
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? primaryGreen : const Color(0xFFB7C8C0),
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 13, 22, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5ECE8))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 47,
        child: ElevatedButton(
          onPressed: _selectedUnitId == null || _isContinuing
              ? null
              : _continueToLandData,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            disabledBackgroundColor: const Color(0xFFC9D6D1),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: const Text(
            'Lanjutkan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _continueToLandData() async {
    if (_isContinuing || _selectedUnitId == null) return;

    BlokModel? selectedBlok;
    UnitModel? selectedUnit;

    for (final blok in _blokList) {
      final units = _unitsByBlok[blok.id] ?? [];
      for (final unit in units) {
        if (unit.id == _selectedUnitId) {
          selectedBlok = blok;
          selectedUnit = unit;
          break;
        }
      }
      if (selectedUnit != null) break;
    }

    if (selectedBlok == null || selectedUnit == null) return;

    final blokTerpilih = selectedBlok;
    final unitTerpilih = selectedUnit;

    setState(() => _isContinuing = true);

    try {
      final draft = await MonitoringService.getDraftForUnit(unitTerpilih.id);

      if (!mounted) return;

      if (draft != null) {
        final action = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Draft sudah tersedia'),
            content: Text(
              'Rumah ${unitTerpilih.nomorUnit} sudah memiliki Draft monitoring. '
              'Silakan buka Draft Saya untuk melanjutkan Draft tersebut atau '
              'menghapusnya jika belum lengkap.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Buka Draft Saya'),
              ),
            ],
          ),
        );

        if (action == true && mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DraftListPage()),
          );
        }
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandDataPage(
            unitId: unitTerpilih.id,
            namaPerumahan: widget.namaPerumahan,
            namaBlok: blokTerpilih.namaBlok,
            nomorRumah: unitTerpilih.nomorUnit,
            luasTanah: unitTerpilih.luasTanah.toString(),
            nilaiBangunanPerM2: unitTerpilih.nilaiBangunanPerM2,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memeriksa Draft unit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isContinuing = false);
    }
  }

}
