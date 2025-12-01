import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
import '../services/order_service.dart';
import '../services/user_profile_service.dart';

// Custom Painter for Dots Pattern used in the header.
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _bannerPageController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  final List<String> _bannerImages = [
    'assets/images/banner 1.png',
    'assets/images/banner 2.png',
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerPageController.hasClients) {
        final nextIndex = (_currentBannerIndex + 1) % _bannerImages.length;
        _bannerPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildBannerSection(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildBookingCard()),
                        const SizedBox(width: 10),
                        Expanded(child: _buildQueueCard()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildVehicleSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF004580), Color(0xFF47C3E7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: CustomPaint(
                painter: const DotsPatternPainter(),
                child: Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        UserProfileService.nama.split(' ').take(2).join(' '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '#SiapAmbilAntrianServisHariIni?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.28,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/logo-otw-b 2.png',
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Column(
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              controller: _bannerPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
              itemCount: _bannerImages.length,
              itemBuilder: (context, index) {
                return Image.asset(_bannerImages[index], fit: BoxFit.cover);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerImages.length,
            (index) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentBannerIndex == index
                        ? const Color(0xFF004580)
                        : Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard() {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF151719),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.25),
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/images/bengkel 1.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Booking\nServis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'CreatoDisplay',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    height: 1,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/logo-otw-b 2.png',
                height: 30,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQueueCard() {
    // Get the latest order
    final orders = OrderService.orders;
    final latestOrder = orders.isNotEmpty ? orders.first : null;

    // Format date: dd - MM - yyyy
    String formattedDate = '-';
    String timeDisplay = '-';
    if (latestOrder != null) {
      final day = latestOrder.orderDate.day.toString().padLeft(2, '0');
      final month = latestOrder.orderDate.month.toString().padLeft(2, '0');
      final year = latestOrder.orderDate.year.toString();
      formattedDate = '$day - $month - $year';
      // Extract time from timeSlot and format with spaces around colon (e.g., "10 : 00")
      final time = latestOrder.timeSlot.split(' - ').first;
      final timeParts = time.split(':');
      if (timeParts.length == 2) {
        timeDisplay = '${timeParts[0]} : ${timeParts[1]}';
      } else {
        timeDisplay = time;
      }
    }

    return Container(
      height: 170,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF151719), // Dark background as per Figma
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient blue background
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF41BDEB), Color(0xFF004580)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/cars-servis 1.png',
                  width: 41,
                  height: 29,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 18),
                const Expanded(
                  child: Text(
                    'Antrian Anda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'CreatoDisplay',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Body section with gradient blue background (not white!)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3FBBEC), Color(0xFF004580)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Antrian date row
                  Row(
                    children: [
                      const Text(
                        'Antrian :',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.28,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 2),
                  // Jam label
                  const Text(
                    'Jam :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'CreatoDisplay',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Large time display - centered
                  Center(
                    child: Text(
                      timeDisplay,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.28,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Divider at bottom
                  Container(
                    height: 0.5,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF41BDEB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mobil Anda :',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'CreatoDisplay',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: -0.28,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'CreatoDisplay',
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.info_outline, size: 18, color: Colors.black54),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: const Color(0xFF41BDEB).withOpacity(0.3),
            thickness: 1,
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Belum ada kendaraan yang di tambahkan',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'CreatoDisplay',
                fontWeight: FontWeight.w400,
                color: Color(0xFF9E9E9E),
                letterSpacing: -0.28,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/daftar-kendaraan');
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF3FBBEC), Color(0xFF004580)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 17.32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
