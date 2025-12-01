import 'package:flutter/material.dart';
import 'verification_code_page.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isAgreed = false;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _isAgreed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Header dengan Back Button dan Logo
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    // Logo OTW
                    Image.asset(
                      'assets/images/logo-otw-b 2.png',
                      height: 57,
                      width: 101,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Content Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    const Text(
                      'Daftar Akun',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dengan mendaftar, Anda menyetujui Syarat dan Ketentuan kami.',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        letterSpacing: -0.28,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Nama Lengkap Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'CreatoDisplay',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            letterSpacing: -0.28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: TextField(
                            controller: _nameController,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama anda',
                              hintStyle: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFB0B0B0),
                                letterSpacing: -0.28,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Nomor Handphone Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nomor Handphone',
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'CreatoDisplay',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            letterSpacing: -0.28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Masukkan nomor handphone anda',
                              hintStyle: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFB0B0B0),
                                letterSpacing: -0.28,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // User Agreement Checkbox
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAgreed = !_isAgreed;
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  _isAgreed
                                      ? const Color(0xFF00AFFE)
                                      : Colors.grey[300],
                              border: Border.all(
                                color:
                                    _isAgreed
                                        ? const Color(0xFF00AFFE)
                                        : Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child:
                                _isAgreed
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Saya telah membaca dan menyetujui Perjanjian Pengguna\n dan Kebijakan Privasi',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'CreatoDisplay',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Masuk Button
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed:
                            (_isFormValid && !_isLoading)
                                ? _handleRegister
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isFormValid
                                  ? const Color(0xFF00AFFE)
                                  : Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: _isFormValid ? 1 : 0,
                          shadowColor: Colors.black.withOpacity(0.5),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'CreatoDisplay',
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Separator dengan "Atau"
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[300]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Text(
                            'Atau',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'CreatoDisplay',
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Google Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Google sign up
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey[300]!, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_icon1.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Daftar dengan akun google anda',
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: 'CreatoDisplay',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: -0.28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Footer Text dengan Privacy Policy Link
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 9,
                            fontFamily: 'CreatoDisplay',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            letterSpacing: -0.28,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Untuk informasi lebih lanjut, silakan lihat ',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Handle privacy policy navigation
                                },
                                child: const Text(
                                  'Kebijakan Privasi kami.',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 9,
                                    fontFamily: 'CreatoDisplay',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    // Validasi input
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor handphone tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🚀 Starting register process...');
      print('📝 Name: $name');
      print('📱 Phone: $phone');

      final response = await _apiService.register(
        name: name,
        phone: phone,
      );

      print('✅ Register response received: ${response.toString()}');

      if (mounted) {
        // Check if response is successful
        if (response['success'] == true) {
          // Check if response contains OTP (development mode)
          String? otpCode;
          if (response['data'] != null && response['data']['otp_code'] != null) {
            otpCode = response['data']['otp_code'].toString();
            print('🔑 OTP Code (dev mode): $otpCode');
          }

          // Navigate to verification page with phone
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationCodePage(
                phone: phone,
                type: 'register',
                otpCode: otpCode, // Pass OTP for development
              ),
            ),
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'OTP telah dikirim'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          throw ApiException(
            message: response['message'] ?? 'Gagal melakukan registrasi',
            statusCode: null,
            errors: response['errors'],
          );
        }
      }
    } catch (e) {
      print('❌ Register error: $e');
      
      if (mounted) {
        String errorMessage = 'Gagal melakukan registrasi';
        
        if (e is ApiException) {
          errorMessage = e.getErrorMessage();
          print('📋 Error details: ${e.errors}');
        } else {
          errorMessage = e.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
