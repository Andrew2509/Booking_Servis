import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/vehicle_service.dart';

class DaftarKendaraanPage extends StatefulWidget {
  const DaftarKendaraanPage({super.key});

  @override
  State<DaftarKendaraanPage> createState() => _DaftarKendaraanPageState();
}

class _DaftarKendaraanPageState extends State<DaftarKendaraanPage> {
  final TextEditingController _nomorPolisiController = TextEditingController();
  final TextEditingController _modelTipeController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _warnaController = TextEditingController();

  @override
  void dispose() {
    _nomorPolisiController.dispose();
    _modelTipeController.dispose();
    _tahunController.dispose();
    _warnaController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_nomorPolisiController.text.isEmpty) {
      _showMessage('Silakan isi Nomor Polisi');
      return;
    }
    if (_modelTipeController.text.isEmpty) {
      _showMessage('Silakan isi Model/Tipe Mobil');
      return;
    }

    // Save vehicle data
    final vehicle = Vehicle(
      nomorPolisi: _nomorPolisiController.text.trim(),
      modelTipe: _modelTipeController.text.trim(),
      tahun:
          _tahunController.text.trim().isEmpty
              ? null
              : _tahunController.text.trim(),
      warna:
          _warnaController.text.trim().isEmpty
              ? null
              : _warnaController.text.trim(),
    );

    VehicleService.addVehicle(vehicle);

    // Navigate back to kendaraan page
    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopBar(),
              _buildGradientBanner(),
              _buildFormCard(),
              const SizedBox(height: 150),
              _buildContinueButton(),
              const SizedBox(height: 10),
              _buildPrivacyText(),
              const SizedBox(height: 20),
            ],
          ),
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
            height: 57,
            width: 101,
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
                'Daftar Kendaraan Anda',
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

  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Nomor Polisi'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nomorPolisiController,
            hint: 'Nomor Polisi harus sesuai dengan data di STNK anda*',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          _buildFieldLabel('Model/Tipe Mobil'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _modelTipeController,
            hint: 'Contoh : Honda Jazz atau Toyota Avanza',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          _buildFieldLabel('Tahun kendaraan (Opsional)'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _tahunController,
            hint: 'Contoh : 2025',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          _buildFieldLabel('Warna kendaraan (Opsional)'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _warnaController,
            hint: 'Contoh : Hitam Metalik',
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'CreatoDisplay',
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
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
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: 'CreatoDisplay', fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 10,
            fontFamily: 'CreatoDisplay',
            color: Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4AC6E5), Color(0xFF27A4FB)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleContinue,
          borderRadius: BorderRadius.circular(12),
          child: const Center(
            child: Text(
              'Lanjutkan ke Booking Antrian',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'CreatoDisplay',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Data anda aman dan hanya digunakan untuk kepentingan di OTW MBENGKEL',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[600],
          fontFamily: 'CreatoDisplay',
        ),
      ),
    );
  }
}

// Custom Painter for Dots Pattern
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
