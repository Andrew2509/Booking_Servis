import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _selectedBottomIndex = 2;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await OrderService.fetchBookings();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data order: ${e.toString()}';
      });
    }
  }

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
              _buildOrderHeader(),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                  ),
                                  child: Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'CreatoDisplay',
                                      color: Colors.red.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadOrders,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          )
                        : OrderService.orders.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                  ),
                                  child: Text(
                                    'Belum ada Orderan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'CreatoDisplay',
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadOrders,
                                child: _buildOrderList(),
                              ),
              ),
              const SizedBox(height: 80),
            ],
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

  Widget _buildOrderHeader() {
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
                'Orderan',
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

  Widget _buildOrderList() {
    final orders = OrderService.orders;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    Color statusColor;
    switch (order.status) {
      case 'Pending':
        statusColor = const Color(0xFFFFF9C4);
        break;
      case 'Proses':
        statusColor = const Color(0xFFFFE082);
        break;
      case 'Selesai':
        statusColor = const Color(0xFFC8E6C9);
        break;
      case 'Batal':
        statusColor = const Color(0xFFFFCDD2);
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Car icon with wrench
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.directions_car,
                      color: Colors.black,
                      size: 24,
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.build,
                          color: Colors.black,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Vehicle name and plate
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.vehicleName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      order.nomorPolisi,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'CreatoDisplay',
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // Status button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'CreatoDisplay',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Order details
          _buildDetailRow('MASUK', 'KM:', order.kmMasuk ?? ''),
          const SizedBox(height: 8),
          _buildDetailRow('Tgl Pemesanan', ':', order.formattedOrderDate),
          const SizedBox(height: 8),
          _buildDetailRow('Servis', ':', order.serviceType),
          const SizedBox(height: 8),
          if (order.formattedEstimatedCompletion != null)
            _buildDetailRow(
              'Estimasi Selesai',
              ':',
              order.formattedEstimatedCompletion!,
            ),
          if (order.formattedEstimatedCompletion != null)
            const SizedBox(height: 8),
          _buildDetailRow('KELUAR', 'KM:', order.kmKeluar ?? ''),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/order-detail',
                    arguments: order,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'CreatoDisplay',
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _showDeleteConfirmation(order.id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'CreatoDisplay',
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (order.status == 'Pending') ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    _showCancelConfirmation(order.id);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange[50],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Batalkan Antrian',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'CreatoDisplay',
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String separator, String value) {
    final isKmField = label == 'MASUK' || label == 'KELUAR';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'CreatoDisplay',
              color: Colors.black54,
            ),
          ),
        ),
        if (!isKmField) ...[
          Text(
            separator,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'CreatoDisplay',
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child:
              isKmField
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text(
                          separator,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'CreatoDisplay',
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            value.isEmpty ? '' : value,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'CreatoDisplay',
                              color:
                                  value.isEmpty
                                      ? Colors.grey[400]
                                      : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : Text(
                    value.isEmpty ? '-' : value,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'CreatoDisplay',
                      color: value.isEmpty ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(String orderId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Hapus Orderan',
              style: TextStyle(
                fontFamily: 'CreatoDisplay',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: const Text(
              'Apakah Anda yakin ingin menghapus orderan ini? Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(fontFamily: 'CreatoDisplay', fontSize: 14),
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
                  OrderService.removeOrder(orderId);
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Orderan berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Ya, Hapus',
                  style: TextStyle(
                    fontFamily: 'CreatoDisplay',
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showCancelConfirmation(String orderId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Batalkan Antrian',
              style: TextStyle(
                fontFamily: 'CreatoDisplay',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: const Text(
              'Apakah Anda yakin ingin membatalkan antrian ini?',
              style: TextStyle(fontFamily: 'CreatoDisplay', fontSize: 14),
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
                  OrderService.updateOrderStatus(orderId, 'Batal');
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Antrian berhasil dibatalkan'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Ya, Batalkan',
                  style: TextStyle(
                    fontFamily: 'CreatoDisplay',
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
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
