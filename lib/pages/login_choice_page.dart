import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class LoginChoicePage extends StatelessWidget {
  const LoginChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Logo di bagian atas
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Image.asset(
                'assets/images/logo-otw-b 2.png', // Ganti dengan logo biru Anda
                height: 120,
                fit: BoxFit.contain,
              ),
            ),

            // Gambar mobil biru
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Image.asset(
                    'assets/images/cars-gtr 1.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            // Bagian bawah dengan background biru rounded
            Expanded(
              flex: 5,
              child: Container(
                height: double.infinity,
                // width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF00AFFE), Color.fromARGB(255, 26, 24, 145)],
                    stops: [0.0, 1.5],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // Judul
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontFamily: 'CreatoDisplay',
                            fontWeight: FontWeight.w900,
                            fontSize: 25, // Dikurangi dari 28
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 8), // Dikurangi dari 12
                        // Deskripsi
                        const Text(
                          'Mulai perjalananmu bersama OTW MBENGKEL. Dari booking servis, cek sparepart, sampai update status kendaraan, semua bisa kamu lakukan langsung dari genggaman.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'CreatoDisplay',
                            fontWeight: FontWeight.w600,
                            fontSize: 12, // Dikurangi dari 12
                            color: Colors.white,
                            height: 1.5, // Dikurangi dari 1.5
                          ),
                        ),

                        const SizedBox(height: 24), // Dikurangi dari 32
                        // Tombol Masuk (Login)
                        SizedBox(
                          width: double.infinity,
                          height: 40, // Dikurangi dari 50
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20), // Dikurangi dari 16
                        // Tombol Buat Akun (Sign Up)
                        SizedBox(
                          width: double.infinity,
                          height: 40, // Dikurangi dari 50
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Buat Akun',
                              style: TextStyle(
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
