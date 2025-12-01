import '../models/vehicle_model.dart';

class VehicleService {
  static final List<Vehicle> _vehicles = [];

  static List<Vehicle> get vehicles => List.unmodifiable(_vehicles);

  static void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
  }

  static void removeVehicle(Vehicle vehicle) {
    _vehicles.remove(vehicle);
  }

  static void removeVehicleByIndex(int index) {
    if (index >= 0 && index < _vehicles.length) {
      _vehicles.removeAt(index);
    }
  }

  static void clearVehicles() {
    _vehicles.clear();
  }
}

