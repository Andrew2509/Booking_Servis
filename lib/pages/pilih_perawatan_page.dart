import 'package:flutter/material.dart';

class PilihPerawatanPage extends StatefulWidget {
  final String? selectedValue;

  const PilihPerawatanPage({super.key, this.selectedValue});

  @override
  State<PilihPerawatanPage> createState() => _PilihPerawatanPageState();
}

class _PilihPerawatanPageState extends State<PilihPerawatanPage> {
  String? _selectedValue;

  final List<String> _maintenanceOptions = [
    'Tanpa Perawatan Berkala',
    '30 Bulan / 50.000 KM',
    '36 Bulan / 60.000 KM',
    '42 Bulan / 70.000 KM',
    '48 Bulan / 80.000 KM',
    '54 Bulan / 90.000 KM',
    '60 Bulan / 100.000 KM',
    '66 Bulan / 110.000 KM',
    '72 Bulan / 120.000 KM',
    'Lebih dari 72 / 120.000 KM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildGradientBanner(),
            Expanded(
              child: _buildMaintenanceList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          Image.asset(
            'assets/images/logo-otw-b 2.png',
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBanner() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4AC6E5), Color(0xFF27A4FB)],
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
          const Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pilih Perawatan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'CreatoDisplay',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceList() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: _maintenanceOptions.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFE0E0E0),
        ),
        itemBuilder: (context, index) {
          final option = _maintenanceOptions[index];
          final isSelected = _selectedValue == option;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedValue = option;
              });
              // Return selected value to previous page
              Navigator.pop(context, option);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0A7DCF)
                            : const Color(0xFFCCCCCC),
                        width: 2,
                      ),
                      color: isSelected
                          ? const Color(0xFF0A7DCF)
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'CreatoDisplay',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter for Dots Pattern
class DotsPatternPainter extends CustomPainter {
  const DotsPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
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

