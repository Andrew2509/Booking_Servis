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
            child: Image.asset('assets/images/bengkel.jpg', fit: BoxFit.cover),
          ),

          // Overlay gelap untuk meningkatkan kontras teks
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Konten teks dan tombol
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kepercayaan Anda\nPrioritas Kami',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Banyak orang nunggu mesin rusak baru ke bengkel. Padahal, mesin sehat itu investasi jangka panjang. Di sini, kami bukan sekadar memperbaiki—kami merawat supaya perjalananmu selalu aman, nyaman, dan bertenaga.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    height: 1.6,
                    fontFamily: 'CreatoDisplay',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
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
