class Vehicle {
  final String nomorPolisi;
  final String modelTipe;
  final String? tahun;
  final String? warna;

  Vehicle({
    required this.nomorPolisi,
    required this.modelTipe,
    this.tahun,
    this.warna,
  });

  String get displayName {
    if (tahun != null && tahun!.isNotEmpty) {
      return '$modelTipe - $tahun';
    }
    return modelTipe;
  }
}
