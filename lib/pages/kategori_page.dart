import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  int _selectedBottomIndex = 2; // Set to 2 for "Kategori" tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/LOGO_SERVIZIO_HITAM _5.png',
          height: 72.56,
          width: 129,
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'PURNA JUAL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'CreatoDisplay',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Container(height: 1.5, color: Colors.black)),
                ],
              ),
            ),

            // Category Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildCategoryCard(
                    'Layanan Bengkel',
                    'assets/images/icon/car-lift.png',
                  ),
                  _buildCategoryCard(
                    'Home Servis',
                    'assets/images/icon/house-repair.png',
                  ),
                  _buildCategoryCard(
                    'Paket Servis',
                    'assets/images/icon/toolbox_services.png',
                  ),
                  _buildCategoryCard(
                    'Kupon Servis',
                    'assets/images/icon/coupon.png',
                  ),
                  _buildCategoryCard(
                    'Aksesoris',
                    'assets/images/icon/toolbox.png',
                  ),
                  _buildCategoryCard(
                    'Oli dan Lipid',
                    'assets/images/icon/car-painting.png',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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

  Widget _buildCategoryCard(String title, String iconAsset) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12),
            child: Image.asset(iconAsset, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'CreatoDisplay',
            color: Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
