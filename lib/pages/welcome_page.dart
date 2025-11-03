import 'package:flutter/material.dart';
import 'login_choice_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang
          Positioned.fill(
            child: Image.asset(
              'assets/images/bengkel.jpg', // ubah sesuai nama file kamu
              fit: BoxFit.cover,
            ),
          ),

          // Efek blur linear putih di bagian bawah
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 700,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0),
                      Colors.white.withValues(alpha: 1.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Konten teks dan tombol
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Kepercayaan Anda\nPrioritas Kami',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.09,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.1,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Banyak orang nunggu mesin rusak baru ke bengkel.\n'
                  'Padahal, mesin sehat itu investasi jangka panjang. Di sini, kami\n'
                  'bukan sekadar memperbaiki—kami merawat supaya\n'
                  'perjalananmu selalu aman, nyaman, dan bertenaga.',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.0284,
                    color: Colors.black87,
                    height: 1.5,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginChoicePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
