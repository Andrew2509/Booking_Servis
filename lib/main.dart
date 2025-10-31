import 'package:flutter/material.dart';
import 'package:booking_servis/pages/splash_screen.dart';
import 'package:booking_servis/pages/login_page.dart';

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
      ),
      home: const SplashScreen(),
      routes: {'/login': (context) => const LoginPage()},
      debugShowCheckedModeBanner: false,
    );
  }
}
