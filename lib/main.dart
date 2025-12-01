import 'package:flutter/material.dart';
import 'package:booking_servis/pages/splash_screen.dart';
import 'package:booking_servis/pages/login_page.dart';
import 'package:booking_servis/pages/home_page.dart';

import 'pages/ambil_antrian_page.dart';
import 'pages/order_page.dart';
import 'pages/order_detail_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_profile_page.dart';
import 'pages/kendaraan_page.dart';
import 'pages/verification_code_page.dart';
import 'pages/daftar_kendaraan_page.dart';
import 'pages/pilih_perawatan_page.dart';
import 'models/order_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Servis',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFED0707),
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/kendaraan': (context) => const KendaraanPage(),
        '/order': (context) => const OrderPage(),
        '/order-detail': (context) {
          final order = ModalRoute.of(context)!.settings.arguments as Order;
          return OrderDetailPage(order: order);
        },
        '/profile': (context) => const ProfilePage(),
        '/edit-profile': (context) => const EditProfilePage(),
        '/ambil-antrian': (context) => const AmbilAntrianPage(),
        '/verification_code': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          return VerificationCodePage(
            phone: args?['phone'] ?? '',
            type: args?['type'] ?? '',
            otpCode: args?['otpCode'],
          );
        },
        '/daftar-kendaraan': (context) => const DaftarKendaraanPage(),
        '/pilih-perawatan': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          return PilihPerawatanPage(selectedValue: args?['selectedValue']);
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
