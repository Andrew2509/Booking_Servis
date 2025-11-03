import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mi.dart';

import '../widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Container(
              width: 390,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFED0707),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo_servizio_putih .png',
                    height: 35,
                    width: 123,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Card
                      SizedBox(
                        width: 358,
                        height: 123,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black,
                                Colors.grey[800]!,
                                Colors.grey[700]!,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Selamat Siang, Dzaky',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.grey[800]!.withOpacity(
                                                0.8,
                                              ),
                                              Colors.grey[700]!.withOpacity(
                                                0.8,
                                              ),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Text(
                                          'Pelanggan BestProfit',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      _buildStatusItem(
                                        icon: Icons.favorite_border,
                                        title: 'Level Pro Save',
                                        subtitle: '156 Poin',
                                      ),
                                      Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey[600],
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                      ),
                                      _buildStatusItem(
                                        icon: Icons.wallet_outlined,
                                        title: 'My Gift',
                                        subtitle: 'Rp 25.000',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Categories Section (red gradient panel matching design)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFED0707), // app red (top)
                              Color(0xFFB00000), // darker red (middle)
                              Color(0xFF8B0000), // dark red (bottom)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PILIHAN KATEGORI',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Nikmati kemudahan layanan perawatan mobil Anda',
                              style: TextStyle(
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Row of category tiles
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder:
                                          (context) => DraggableScrollableSheet(
                                            initialChildSize: 0.45,
                                            minChildSize: 0.4,
                                            maxChildSize: 0.45,
                                            builder:
                                                (
                                                  context,
                                                  scrollController,
                                                ) => Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    controller:
                                                        scrollController,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                top: 8,
                                                              ),
                                                          width: 40,
                                                          height: 4,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors
                                                                    .grey[300],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  2,
                                                                ),
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                16.0,
                                                              ),
                                                          child: Text(
                                                            'BOOKING SERVIS',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'CreatoDisplay',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                        ),
                                                        _buildServiceOption(
                                                          'SERVIS DI BENGKEL',
                                                          'Layanan purna jual yang menawarkan jasa perbaikan berupa servis',
                                                          'assets/images/icon/car-lift.png',
                                                        ),
                                                        _buildServiceOption(
                                                          'SERVIZIO HOME SERVICE',
                                                          'Layanan bengkel yang siap menuju ke lokasi Anda',
                                                          'assets/images/icon/house-repair.png',
                                                        ),
                                                        _buildServiceOption(
                                                          'PERBAIKAN BODI & CAT',
                                                          'Layanan khusus perbaikan bodi dan cat standar pabrikan',
                                                          'assets/images/icon/car-painting.png',
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          ),
                                    );
                                  },
                                  child: _buildCategoryItem(
                                    imageAsset:
                                        'assets/images/icon/calendar.png',
                                    label: 'Booking servis',
                                    color: Colors.red,
                                  ),
                                ),
                                _buildCategoryItem(
                                  imageAsset:
                                      'assets/images/icon/house-repair.png',
                                  label: 'Home Servis',
                                  color: Colors.red,
                                ),
                                _buildCategoryItem(
                                  imageAsset: 'assets/images/icon/coupon.png',
                                  label: 'Kupon Servis',
                                  color: Colors.red,
                                ),
                                _buildCategoryItem(
                                  imageAsset: 'assets/images/icon/tracking.png',
                                  label: 'Order Tracking',
                                  color: Colors.red,
                                ),
                                _buildCategoryItem(
                                  imageAsset: 'assets/images/icon/car-lift.png',
                                  label: 'Layanan Bengkel',
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Vehicles Section
                      const Text(
                        'KENDARAAN SAYA',
                        style: TextStyle(
                          fontFamily: 'CreatoDisplay',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'Informasi tentang mobil saya',
                        style: TextStyle(
                          fontFamily: 'CreatoDisplay',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Add Vehicle Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFFFFFF), // putih di atas
                              Color(0xFFCDCDCD), // abu-abu di bawah
                            ],
                            stops: [0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tambahkan profil mobil anda untuk\npengalaman personalisasi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Dashed border container
                            Container(
                              width: double.infinity,
                              height: 169,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: CustomPaint(
                                painter: DashedBorderPainter(
                                  color: Colors.red,
                                  strokeWidth: 2,
                                  dashWidth: 8,
                                  dashSpace: 5,
                                  borderRadius: 12,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Three buttons row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: _buildVehicleInfoButton(
                                    'STNK Berlaku',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildVehicleInfoButton(
                                    'Nomor Polisi',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildVehicleInfoButton(
                                    'Servis Terakhir',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem({
    String? imageAsset,
    IconData? icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child:
              imageAsset != null
                  ? Image.asset(
                    imageAsset,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  )
                  : Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'CreatoDisplay',
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceOption(
    String title,
    String description,
    String iconAsset,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(2),
              child: Image.asset(iconAsset, width: 33, height: 33),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'CreatoDisplay',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontFamily: 'CreatoDisplay',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'PILIH LAYANAN',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[600],
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Iconify(Mi.arrow_right, color: Colors.red[600], size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          color: Colors.grey[600],
          fontFamily: 'CreatoDisplay',
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final path =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(borderRadius),
          ),
        );

    final dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path dest = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? dashWidth : dashSpace;
        if (distance + length > metric.length) {
          if (draw) {
            dest.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        }
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
