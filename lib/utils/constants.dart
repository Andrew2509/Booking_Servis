import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryRed = Color(0xFFED0707);
  static const Color primaryBlue = Color(0xFF00AFFE);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
}

class AppTextStyle {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: Colors.black,
  );
}

// API Configuration
class ApiConfig {
  // Ganti dengan IP address komputer Anda jika testing di device fisik
  // Untuk emulator Android: gunakan http://10.0.2.2:8000
  // Untuk iOS Simulator: gunakan http://localhost:8000
  // Untuk device fisik: gunakan IP komputer, contoh: http://192.168.1.5:8000

  // UNCOMMENT salah satu sesuai dengan environment Anda:

  // Untuk Emulator Android:
  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Untuk Device Físik (ganti dengan IP komputer Anda):
  static const String baseUrl = 'http://10.72.112.242:8000/api';

  static const Duration timeout = Duration(seconds: 30);
}
