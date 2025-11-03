import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';

class RiwayatOrderPage extends StatefulWidget {
  const RiwayatOrderPage({super.key});

  @override
  State<RiwayatOrderPage> createState() => _RiwayatOrderPageState();
}

class _RiwayatOrderPageState extends State<RiwayatOrderPage> {
  int _selectedTabIndex = 0;
  int _selectedBottomIndex = 1; // Set to 1 for "Orderan" tab

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
      body: Column(
        children: [
          // Red Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF8B0000), Color(0xFFED0707)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ORDER SAYA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Temukan Daftar Transaksi dan Booking Anda Disini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'CreatoDisplay',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Tab Buttons Section (White Background)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _buildTabButton('Semua', 0)),
                const SizedBox(width: 8),
                Expanded(child: _buildTabButton('Sales', 1)),
                const SizedBox(width: 8),
                Expanded(child: _buildTabButton('Servis', 2)),
                const SizedBox(width: 8),
                Expanded(child: _buildTabButton('Produk\nPurnajual', 3)),
              ],
            ),
          ),

          // Empty State Content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 70,
                    height: 70,
                    child: Center(
                      child: Image.asset(
                        'assets/images/icon/riwayat.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Anda belum memiliki riwayat order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CreatoDisplayItalic',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      'Belum ada pemesanan yang dilakukan melalui akun Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'CreatoDisplay',
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
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

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFED0707) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: 'CreatoDisplay',
            ),
          ),
        ),
      ),
    );
  }
}
