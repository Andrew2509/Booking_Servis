class Order {
  final String id;
  final String vehicleName;
  final String nomorPolisi;
  final String serviceType;
  final String maintenance;
  final DateTime orderDate;
  final String timeSlot;
  final String status; // 'Pending', 'Proses', 'Selesai', 'Batal'
  final DateTime? estimatedCompletion;
  final String? notes;
  final String? kmMasuk;
  final String? kmKeluar;

  Order({
    required this.id,
    required this.vehicleName,
    required this.nomorPolisi,
    required this.serviceType,
    required this.maintenance,
    required this.orderDate,
    required this.timeSlot,
    required this.status,
    this.estimatedCompletion,
    this.notes,
    this.kmMasuk,
    this.kmKeluar,
  });

  String get formattedOrderDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${orderDate.day} ${months[orderDate.month - 1]} ${orderDate.year}, ${timeSlot}';
  }

  String? get formattedEstimatedCompletion {
    if (estimatedCompletion == null) return null;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${estimatedCompletion!.day} ${months[estimatedCompletion!.month - 1]} ${estimatedCompletion!.year}, 09:00';
  }
}

