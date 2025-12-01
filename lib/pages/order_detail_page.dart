import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            _buildGradientBanner(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderCard(statusColor),
                      const SizedBox(height: 16),
                      _buildInfoSection(),
                      if (order.notes != null && order.notes!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildNotesSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
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
                'Detail Orderan',
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

  Widget _buildOrderCard(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Car icon with wrench
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.directions_car, color: Colors.black, size: 28),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.build,
                          color: Colors.black,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Vehicle name and plate
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.vehicleName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.nomorPolisi,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'CreatoDisplay',
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              // Status button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'CreatoDisplay',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Orderan',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'CreatoDisplay',
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('MASUK', 'KM:', order.kmMasuk ?? ''),
          const SizedBox(height: 16),
          _buildDetailRow('Tgl Pemesanan', ':', order.formattedOrderDate),
          const SizedBox(height: 16),
          _buildDetailRow('Servis', ':', order.serviceType),
          const SizedBox(height: 16),
          _buildDetailRow('Perawatan', ':', order.maintenance),
          const SizedBox(height: 16),
          if (order.formattedEstimatedCompletion != null) ...[
            _buildDetailRow(
              'Estimasi Selesai',
              ':',
              order.formattedEstimatedCompletion!,
            ),
            const SizedBox(height: 16),
          ],
          _buildDetailRow('KELUAR', 'KM:', order.kmKeluar ?? ''),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan :',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'CreatoDisplay',
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            order.notes!,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'CreatoDisplay',
              color: Colors.black87,
              height: 1.5,
            ),
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
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'CreatoDisplay',
              color: Colors.black54,
            ),
          ),
        ),
        if (!isKmField) ...[
          Text(
            separator,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'CreatoDisplay',
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: isKmField
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        separator,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'CreatoDisplay',
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          value.isEmpty ? '' : value,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'CreatoDisplay',
                            color: value.isEmpty ? Colors.grey[400] : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'CreatoDisplay',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ],
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

