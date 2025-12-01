import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tinggi safe area bottom (untuk system navigation bar)
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final totalHeight = 56.0 + bottomPadding;

    return Container(
      height: totalHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  index: 0,
                  onTap: () {
                    onTap(0);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                ),
                _buildNavItem(
                  icon: Icons.directions_car_outlined,
                  label: 'Kendaraan',
                  index: 1,
                  onTap: () {
                    onTap(1);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/kendaraan',
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(width: 64), // Space for center button
                _buildNavItem(
                  icon: Icons.history,
                  label: 'Order',
                  index: 2,
                  onTap: () {
                    onTap(2);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/order',
                      (route) => false,
                    );
                  },
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  index: 3,
                  onTap: () {
                    onTap(3);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/profile',
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          // Center Floating Button dengan Gradient
          Positioned(
            // Posisi center button: 24px dari atas navbar (56/2 - 4) + bottomPadding agar ikut naik
            top: -72 + bottomPadding,
            left: MediaQuery.of(context).size.width / 2 - 38,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ambil-antrian');
              },
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF47C3E7), Color(0xFF004580)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/images/icon/icon-service-p 2.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? const Color(0xFF004580)
                      : const Color(0xFF717171),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'CreatoDisplay',
                fontWeight: FontWeight.w400,
                fontSize: 9,
                color:
                    isSelected
                        ? const Color(0xFF004580)
                        : const Color(0xFF717171),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
