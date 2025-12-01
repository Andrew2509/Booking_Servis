import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';
import '../models/vehicle_model.dart';
import '../services/vehicle_service.dart';

class KendaraanPage extends StatefulWidget {
  const KendaraanPage({super.key});

  @override
  State<KendaraanPage> createState() => _KendaraanPageState();
}

class _KendaraanPageState extends State<KendaraanPage> {
  int _selectedBottomIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo-otw-b 2.png',
                  width: 142,
                  height: 81,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildKendaraanHeader(),
              Expanded(
                child:
                    VehicleService.vehicles.isEmpty
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            child: Text(
                              'Silahkan daftar kendaraan anda terlebih dahulu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'CreatoDisplay',
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        )
                        : _buildVehicleList(),
              ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            top: 660,
            bottom: 50,
            right: 24,
            child: GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, '/daftar-kendaraan');
                setState(() {}); // Refresh to show new vehicle
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF47C3E7), Color(0xFF004580)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
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

  Widget _buildKendaraanHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 100),
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
                'Kendaraan Anda',
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

  Widget _buildVehicleList() {
    final vehicles = VehicleService.vehicles;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return _buildVehicleCard(vehicle, index);
      },
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Bisa ditambahkan navigasi ke detail kendaraan nanti
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Car icon with glass effect
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ).withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Colors.black87,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Vehicle details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_number,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.nomorPolisi,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'CreatoDisplay',
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Delete button
                GestureDetector(
                  onTap: () => _showDeleteConfirmation(context, index, vehicle),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    int index,
    Vehicle vehicle,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Hapus Kendaraan',
            style: TextStyle(
              fontFamily: 'CreatoDisplay',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${vehicle.displayName} (${vehicle.nomorPolisi})?',
            style: const TextStyle(fontFamily: 'CreatoDisplay', fontSize: 14),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                VehicleService.removeVehicleByIndex(index);
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kendaraan berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Hapus',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
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
