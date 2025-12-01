import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderService {
  static final List<Order> _orders = [];
  static final ApiService _apiService = ApiService();

  static List<Order> get orders => List.unmodifiable(_orders);

  // Add order locally (for offline support)
  static void addOrder(Order order) {
    _orders.insert(0, order); // Add to beginning for newest first
  }

  // Create booking via API
  static Future<Order> createBooking({
    required String vehicleName,
    required String nomorPolisi,
    required String serviceType,
    required String maintenance,
    required DateTime orderDate,
    required String timeSlot,
    String? kmMasuk,
    String? notes,
  }) async {
    try {
      final response = await _apiService.createBooking(
        vehicleName: vehicleName,
        nomorPolisi: nomorPolisi,
        serviceType: serviceType,
        maintenance: maintenance,
        orderDate: orderDate,
        timeSlot: timeSlot,
        kmMasuk: kmMasuk,
        notes: notes,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        
        // Parse order date
        final orderDateParsed = DateTime.parse(data['order_date']);
        final estimatedCompletion = data['estimated_completion'] != null
            ? DateTime.parse(data['estimated_completion'])
            : null;

        final order = Order(
          id: data['id'].toString(),
          vehicleName: data['vehicle_name'],
          nomorPolisi: data['nomor_polisi'],
          serviceType: data['service_type'],
          maintenance: data['maintenance'],
          orderDate: orderDateParsed,
          timeSlot: data['time_slot'],
          status: data['status'],
          estimatedCompletion: estimatedCompletion,
          notes: notes,
          kmMasuk: kmMasuk,
        );

        // Add to local list
        addOrder(order);
        
        return order;
      } else {
        throw Exception(response['message'] ?? 'Gagal membuat booking');
      }
    } catch (e) {
      print('❌ Error creating booking: $e');
      rethrow;
    }
  }

  // Fetch bookings from API
  static Future<List<Order>> fetchBookings({String? status}) async {
    try {
      final response = await _apiService.getBookings(status: status);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> bookingsData = response['data'];
        
        _orders.clear();
        
        for (var data in bookingsData) {
          final orderDate = DateTime.parse(data['order_date']);
          final estimatedCompletion = data['estimated_completion'] != null
              ? DateTime.parse(data['estimated_completion'])
              : null;

          final order = Order(
            id: data['id'].toString(),
            vehicleName: data['vehicle_name'],
            nomorPolisi: data['nomor_polisi'],
            serviceType: data['service_type'],
            maintenance: data['maintenance'],
            orderDate: orderDate,
            timeSlot: data['time_slot'],
            status: data['status'],
            estimatedCompletion: estimatedCompletion,
            notes: data['notes'],
            kmMasuk: data['km_masuk'],
            kmKeluar: data['km_keluar'],
          );

          _orders.add(order);
        }

        return _orders;
      } else {
        throw Exception(response['message'] ?? 'Gagal mengambil data booking');
      }
    } catch (e) {
      print('❌ Error fetching bookings: $e');
      rethrow;
    }
  }

  static Future<void> updateOrderStatus(String id, String status) async {
    try {
      // Update via API
      await _apiService.updateBookingStatus(id: id, status: status);
      
      // Update local
      final index = _orders.indexWhere((o) => o.id == id);
      if (index != -1) {
        final order = _orders[index];
        final updatedOrder = Order(
          id: order.id,
          vehicleName: order.vehicleName,
          nomorPolisi: order.nomorPolisi,
          serviceType: order.serviceType,
          maintenance: order.maintenance,
          orderDate: order.orderDate,
          timeSlot: order.timeSlot,
          status: status,
          estimatedCompletion: order.estimatedCompletion,
          notes: order.notes,
          kmMasuk: order.kmMasuk,
          kmKeluar: order.kmKeluar,
        );
        _orders[index] = updatedOrder;
      }
    } catch (e) {
      print('❌ Error updating order status: $e');
      rethrow;
    }
  }

  static void removeOrder(String id) {
    _orders.removeWhere((o) => o.id == id);
  }

  static void clearOrders() {
    _orders.clear();
  }
}

