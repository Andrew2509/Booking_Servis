import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';
import '../services/vehicle_service.dart';
import '../models/vehicle_model.dart';
import '../services/order_service.dart';

class AmbilAntrianPage extends StatefulWidget {
  const AmbilAntrianPage({super.key});

  @override
  State<AmbilAntrianPage> createState() => _AmbilAntrianPageState();
}

class _AmbilAntrianPageState extends State<AmbilAntrianPage> {
  List<String> get _vehicles {
    return VehicleService.vehicles.map((v) => v.displayName).toList();
  }

  final List<String> _services = ['Servis Berkala', 'Tune Up', 'Ganti Oli'];

  final List<String> _timeSlots = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
  ];

  final GlobalKey _vehicleKey = GlobalKey();
  final GlobalKey _serviceKey = GlobalKey();
  final GlobalKey _dateKey = GlobalKey();

  String? _selectedVehicle;
  String? _selectedService;
  String? _selectedTimeSlot;
  String? _selectedMaintenance;
  DateTime? _selectedDateTime;
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  int _selectedBottomIndex = 4;

  @override
  void dispose() {
    _kmController.dispose();
    _notesController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final RenderBox box =
        _dateKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    // Calculate calendar size (smaller)
    const double calendarWidth = 320;
    const double calendarHeight = 355; // Height without confirm button
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double leftPosition = max(
      16.0,
      min(offset.dx, screenWidth - calendarWidth - 16),
    );
    final double topPosition = offset.dy + size.height + 4;
    final double maxHeight = screenHeight - topPosition - 16;
    final double actualHeight = min(calendarHeight, maxHeight);

    final date = await showDialog<DateTime>(
      context: context,
      barrierColor: Colors.transparent,
      builder:
          (context) => Stack(
            children: [
              // Invisible tap area to close dialog
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Calendar positioned below field
              Positioned(
                left: leftPosition,
                top: topPosition,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: calendarWidth,
                    height: actualHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _CustomDatePicker(
                      initialDate: _selectedDateTime ?? now,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 60)),
                      isCompact: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    if (date != null) {
      setState(() {
        _selectedDateTime = DateTime(date.year, date.month, date.day);
        _dateTimeController.text = _formatDateTime(_selectedDateTime!);
      });
    }
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    return '$day/$month/$year';
  }

  void _confirmAntrian() async {
    if (_selectedVehicle == null) {
      _showMessage('Silakan pilih kendaraan');
      return;
    }
    if (_selectedService == null) {
      _showMessage('Silakan pilih jenis servis');
      return;
    }
    if (_selectedMaintenance == null) {
      _showMessage('Silakan pilih jarak KM');
      return;
    }
    if (_selectedDateTime == null) {
      _showMessage('Silakan pilih tanggal');
      return;
    }
    if (_selectedTimeSlot == null) {
      _showMessage('Silakan pilih slot waktu');
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Find vehicle data
      final vehicle = VehicleService.vehicles.firstWhere(
        (v) => v.displayName == _selectedVehicle,
        orElse: () => Vehicle(nomorPolisi: '', modelTipe: _selectedVehicle!),
      );

      // Create booking via API
      await OrderService.createBooking(
        vehicleName: vehicle.modelTipe,
        nomorPolisi: vehicle.nomorPolisi,
        serviceType: _selectedService!,
        maintenance: _selectedMaintenance!,
        orderDate: _selectedDateTime!,
        timeSlot: _selectedTimeSlot!,
        kmMasuk: _kmController.text.trim().isEmpty 
            ? null 
            : _kmController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      // Close loading
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      _showMessage('Antrian berhasil disiapkan', success: true);

      // Navigate to home page after a short delay to show the queue card
      if (context.mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        });
      }
    } catch (e) {
      // Close loading
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      String errorMessage = 'Gagal membuat booking';
      if (e.toString().contains('ApiException')) {
        errorMessage = e.toString().replaceAll('ApiException: ', '');
      } else {
        errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      }

      _showMessage(errorMessage);
    }
  }

  void _showMessage(String message, {bool success = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh vehicle list when page is opened or returned to
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: Image.asset(
                'assets/images/logo-otw-b 2.png',
                width: 142,
                height: 81,
                fit: BoxFit.contain,
              ),
            ),
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildFormCard(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF47C3E7), Color(0xFF004580)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: const DotsPatternPainter(),
              child: Container(),
            ),
          ),
          Positioned(
            left: 16,
            top: 8,
            child: const Text(
              'Ambil Antrian',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'CreatoDisplay',
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 30,
            child: const Text(
              'Silahkan buat jadwal servis anda',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'CreatoDisplay',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelectionField(
              key: _vehicleKey,
              label: 'Pilih kendaraan anda',
              value: _selectedVehicle,
              icon: Icons.directions_car,
              onTap: () {
                if (_vehicles.isEmpty) {
                  _showEmptyVehicleCard();
                } else {
                  _showDropdown(
                    key: _vehicleKey,
                    title: 'Pilih kendaraan anda',
                    items: _vehicles,
                    value: _selectedVehicle,
                    icon: Icons.directions_car,
                    onSelected:
                        (value) => setState(() => _selectedVehicle = value),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            _buildSelectionField(
              key: _serviceKey,
              label: 'Pilih jenis servis',
              value: _selectedService,
              icon: Icons.handyman,
              onTap:
                  () => _showDropdown(
                    key: _serviceKey,
                    title: 'Pilih jenis servis',
                    items: _services,
                    value: _selectedService,
                    icon: Icons.handyman,
                    onSelected:
                        (value) => setState(() => _selectedService = value),
                  ),
            ),
            const SizedBox(height: 12),
            _buildFieldLabel('Pilih jarak KM MOBIL'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/pilih-perawatan',
                  arguments: {'selectedValue': _selectedMaintenance},
                );
                if (result != null) {
                  setState(() {
                    _selectedMaintenance = result as String;
                  });
                }
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedMaintenance ??
                          'Masukkan jarak KM saat ini (contoh : 45000)',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'CreatoDisplay',
                        color:
                            _selectedMaintenance == null
                                ? Colors.grey
                                : Colors.black87,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldLabel('Pilih tanggal dan waktu servis'),
            const SizedBox(height: 6),
            _buildDateTimeField(),
            const SizedBox(height: 12),
            _buildFieldLabel('Slot waktu tersedia'),
            const SizedBox(height: 8),
            _buildTimeSlots(),
            const SizedBox(height: 16),
            _buildFieldLabel('Catatan Tambahan (opsional)'),
            const SizedBox(height: 6),
            TextField(
              controller: _notesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Deskripsikan sedikit masalah Anda atau permintaan khusus.',
                hintStyle: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'CreatoDisplay',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF004580)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _confirmAntrian,
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF22C55E), Color(0xFF22C55E)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Konfirmasi Ambil Antrian',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CreatoDisplay',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionField({
    required GlobalKey key,
    required String label,
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.black54),
                    const SizedBox(width: 10),
                    Text(
                      value ?? '-- Pilih --',
                      style: TextStyle(
                        fontSize: 12,
                        color: value == null ? Colors.black45 : Colors.black87,
                        fontFamily: 'CreatoDisplay',
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDropdown({
    required GlobalKey key,
    required String title,
    required List<String> items,
    required String? value,
    required IconData icon,
    required ValueChanged<String> onSelected,
  }) async {
    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final double menuHeight = items.length * 48.0;
    final double desiredWidth = max(size.width, 300.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double rightPosition = min(
      offset.dx + desiredWidth,
      screenWidth - 16,
    );
    final double leftPosition = max(16.0, rightPosition - desiredWidth);
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        leftPosition,
        offset.dy + size.height,
        rightPosition,
        offset.dy + size.height + menuHeight,
      ),
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      constraints: BoxConstraints.tightFor(width: desiredWidth),
      items:
          items
              .map(
                (item) => PopupMenuItem(
                  value: item,
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          item == value
                              ? const Color(0xFFD2F1FF)
                              : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(icon, size: 16, color: Colors.black54),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(fontFamily: 'CreatoDisplay'),
                          ),
                        ),
                        if (item == value)
                          const Icon(Icons.check, color: Color(0xFF0A7DCF)),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
    if (selected != null) onSelected(selected);
  }

  void _showEmptyVehicleCard() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder:
          (context, animation, secondaryAnimation) => Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top section with back button and title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 18, 12, 14),
                    child: Row(
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black87,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title
                        Expanded(
                          child: Text(
                            'Silahkan Daftar Kendaraan anda',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'CreatoDisplay',
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30), // Balance back button
                      ],
                    ),
                  ),
                  // Divider
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.withOpacity(0.15),
                  ),
                  // Center content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Plus button with blue gradient
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/daftar-kendaraan',
                            ).then((_) {
                              setState(() {}); // Refresh to show new vehicle
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF1976D2), Color(0xFF0D3D6C)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4AC6E5,
                                  ).withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Empty message
                        Text(
                          'Belum ada kendaraan yang di daftarkan.',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'CreatoDisplay',
                            color: Colors.black.withOpacity(0.55),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'CreatoDisplay',
      ),
    );
  }

  Widget _buildDateTimeField() {
    return SizedBox(
      key: _dateKey,
      height: 35,
      child: GestureDetector(
        onTap: _pickDateTime,
        child: AbsorbPointer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDDDDDD)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _dateTimeController,
              style: const TextStyle(fontFamily: 'CreatoDisplay'),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'hh / bb / tttt, --.--',
                hintStyle: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'CreatoDisplay',
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: Colors.black54,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children:
          _timeSlots.map((slot) {
            final isSelected = slot == _selectedTimeSlot;
            return GestureDetector(
              onTap:
                  () => setState(() {
                    _selectedTimeSlot = slot;
                  }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFD2F1FF) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        isSelected
                            ? const Color(0xFF0A7DCF)
                            : const Color(0xFFCCCCCC),
                  ),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isSelected ? const Color(0xFF0A7DCF) : Colors.black87,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isCompact;

  const _CustomDatePicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.isCompact = false,
  });

  @override
  State<_CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<_CustomDatePicker> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  final List<String> _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  final List<String> _dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _previousMonth() {
    final newMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    final firstMonth = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      1,
    );
    if (newMonth.isBefore(firstMonth)) {
      return;
    }
    setState(() {
      _currentMonth = newMonth;
    });
  }

  void _nextMonth() {
    final newMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    final lastMonth = DateTime(widget.lastDate.year, widget.lastDate.month, 1);
    if (newMonth.isAfter(lastMonth)) {
      return;
    }
    setState(() {
      _currentMonth = newMonth;
    });
  }

  void _previousYear() {
    final newMonth = DateTime(_currentMonth.year - 1, _currentMonth.month, 1);
    final firstMonth = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      1,
    );
    if (newMonth.isBefore(firstMonth)) {
      return;
    }
    setState(() {
      _currentMonth = newMonth;
    });
  }

  void _nextYear() {
    final newMonth = DateTime(_currentMonth.year + 1, _currentMonth.month, 1);
    final lastMonth = DateTime(widget.lastDate.year, widget.lastDate.month, 1);
    if (newMonth.isAfter(lastMonth)) {
      return;
    }
    setState(() {
      _currentMonth = newMonth;
    });
  }

  void _selectDate(DateTime date) {
    if (date.isBefore(widget.firstDate.subtract(const Duration(days: 1))) ||
        date.isAfter(widget.lastDate.add(const Duration(days: 1)))) {
      return;
    }
    setState(() {
      _selectedDate = date;
      // Update current month if selected date is in a different month
      if (date.month != _currentMonth.month ||
          date.year != _currentMonth.year) {
        _currentMonth = DateTime(date.year, date.month, 1);
      }
    });
    // Close dialog and return selected date
    Navigator.of(context).pop(_selectedDate);
  }

  List<DateTime> _getDaysInMonth() {
    final firstDayOfMonth = _currentMonth;
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final List<DateTime> days = [];

    // Add previous month's days
    final previousMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month - 1,
      0,
    );
    for (
      int i = previousMonth.day - firstDayWeekday + 1;
      i <= previousMonth.day;
      i++
    ) {
      days.add(DateTime(previousMonth.year, previousMonth.month, i));
    }

    // Add current month's days
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, i));
    }

    // Add next month's days to fill the grid
    final remainingDays = 42 - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month + 1, i));
    }

    return days;
  }

  String _formatSelectedDate() {
    final dayName = _dayNames[_selectedDate.weekday % 7];
    final monthName = _monthNames[_selectedDate.month - 1];
    return '$dayName, ${_selectedDate.day} $monthName';
  }

  bool _canGoPreviousMonth() {
    final firstMonth = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      1,
    );
    return _currentMonth.isAfter(firstMonth);
  }

  bool _canGoNextMonth() {
    final lastMonth = DateTime(widget.lastDate.year, widget.lastDate.month, 1);
    return _currentMonth.isBefore(lastMonth);
  }

  void _showMonthYearPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2E),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Tahun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'CreatoDisplay',
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _previousYear,
                          child: const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _nextYear,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Month grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final isCurrentMonth = month == _currentMonth.month;
                    final monthDate = DateTime(_currentMonth.year, month, 1);
                    final isAvailable =
                        !monthDate.isBefore(
                          DateTime(
                            widget.firstDate.year,
                            widget.firstDate.month,
                            1,
                          ),
                        ) &&
                        !monthDate.isAfter(
                          DateTime(
                            widget.lastDate.year,
                            widget.lastDate.month,
                            1,
                          ),
                        );

                    return GestureDetector(
                      onTap:
                          isAvailable
                              ? () {
                                setState(() {
                                  _currentMonth = DateTime(
                                    _currentMonth.year,
                                    month,
                                    1,
                                  );
                                });
                                Navigator.pop(context);
                              }
                              : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isCurrentMonth
                                  ? const Color(0xFF4AC6E5)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isCurrentMonth
                                    ? const Color(0xFF4AC6E5)
                                    : Colors.grey[700]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _monthNames[index],
                            style: TextStyle(
                              color:
                                  isAvailable
                                      ? (isCurrentMonth
                                          ? Colors.white
                                          : Colors.white)
                                      : Colors.grey[600],
                              fontSize: 14,
                              fontWeight:
                                  isCurrentMonth
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                              fontFamily: 'CreatoDisplay',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();
    isCurrentMonth(date) =>
        date.month == _currentMonth.month && date.year == _currentMonth.year;
    isSelected(date) =>
        date.day == _selectedDate.day &&
        date.month == _selectedDate.month &&
        date.year == _selectedDate.year;

    final double containerHeight =
        widget.isCompact ? 340 : MediaQuery.of(context).size.height * 0.7;

    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius:
            widget.isCompact
                ? BorderRadius.circular(12)
                : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
      ),
      child: Column(
        children: [
          // Header with selected date and close button (only if not compact)
          if (!widget.isCompact)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatSelectedDate(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'CreatoDisplay',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4AC6E5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.isCompact)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Selected date display
                  Text(
                    _formatSelectedDate(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'CreatoDisplay',
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Month and year navigation
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCompact ? 12 : 16,
              vertical: widget.isCompact ? 4 : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Toggle between month and year selection
                    _showMonthYearPicker();
                  },
                  child: Text(
                    '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.isCompact ? 14 : 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CreatoDisplay',
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _previousMonth,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color:
                              _canGoPreviousMonth()
                                  ? Colors.white
                                  : Colors.grey[600],
                          size: widget.isCompact ? 18 : 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _nextMonth,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              _canGoNextMonth()
                                  ? Colors.white
                                  : Colors.grey[600],
                          size: widget.isCompact ? 18 : 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Week day headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children:
                  _weekDays.map((day) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: widget.isCompact ? 10 : 12,
                            fontFamily: 'CreatoDisplay',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          // Calendar grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCompact ? 12 : 16,
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                  crossAxisSpacing: widget.isCompact ? 2 : 4,
                  mainAxisSpacing: widget.isCompact ? 2 : 4,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final date = days[index];
                  final isCurrent = isCurrentMonth(date);
                  final isSel = isSelected(date);

                  return GestureDetector(
                    onTap: () => _selectDate(date),
                    child: Container(
                      margin: EdgeInsets.all(widget.isCompact ? 1 : 2),
                      decoration: BoxDecoration(
                        color: isSel ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          widget.isCompact ? 4 : 8,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color:
                                isSel
                                    ? const Color(0xFF2C2C2E)
                                    : isCurrent
                                    ? Colors.white
                                    : Colors.grey[600],
                            fontSize: widget.isCompact ? 11 : 14,
                            fontWeight:
                                isSel ? FontWeight.w700 : FontWeight.normal,
                            fontFamily: 'CreatoDisplay',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DotsPatternPainter extends CustomPainter {
  const DotsPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    const double spacing = 20;
    const double radius = 2;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
