import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verification_code_page.dart';
import '../services/api_service.dart';
import '../services/google_sign_in_service.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isTestingConnection = false;
  final ApiService _apiService = ApiService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 19,
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/logo-otw-b 2.png',
              height: 57,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                'Log In / Masuk',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Dengan masuk, Anda menyetujui Syarat dan Ketentuan kami.',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 50),

              // Phone Number Label
              const Text(
                'Masukkan dengan Nomor Handphone',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Phone Number Input
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged:
                      (_) => setState(() {}), // Update state saat text berubah
                  decoration: InputDecoration(
                    hintText: 'Nomor Handphone yang terdaftar sebelumnya',
                    hintStyle: TextStyle(
                      fontFamily: 'CreatoDisplay',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00AFFE)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Helper Text
              Text(
                'Masukkan nomor handphone yang terdaftar untuk menerima kode verifikasi',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 50),

              // Masuk Button
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed:
                      (_phoneController.text.trim().isNotEmpty && !_isLoading)
                          ? _handleLogin
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (_phoneController.text.trim().isNotEmpty && !_isLoading)
                            ? const Color(0xFF00AFFE)
                            : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
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
                              fontFamily: 'CreatoDisplay',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 50),

              // Divider with "Atau"
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey[300], thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Atau',
                      style: TextStyle(
                        fontFamily: 'CreatoDisplay',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey[300], thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Google Sign In Button
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton.icon(
                  onPressed:
                      (_isGoogleLoading || _isLoading)
                          ? null
                          : _handleGoogleSignIn,
                  icon:
                      _isGoogleLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                          : Image.asset(
                            'assets/images/google_icon.png',
                            width: 24,
                            height: 24,
                          ),
                  label: const Text(
                    'Masuk dengan menggunakan Email Anda',
                    style: TextStyle(
                      fontFamily: 'CreatoDisplay',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Helper Text for Google Sign In
              Center(
                child: Text(
                  'Untuk informasi lebih lanjut, silakan lihat kebijakan Privasi kami.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'CreatoDisplay',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Test Connection Button (Debug)
              Center(
                child: TextButton.icon(
                  onPressed: _isTestingConnection ? null : _testConnection,
                  icon:
                      _isTestingConnection
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.wifi_find, size: 16),
                  label: Text(
                    _isTestingConnection
                        ? 'Menguji koneksi...'
                        : 'Test Koneksi ke Backend',
                    style: const TextStyle(
                      fontFamily: 'CreatoDisplay',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validasi input
    final phone = _phoneController.text.trim();

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
      print('🚀 Starting login process...');
      print('📱 Phone: $phone');

      final response = await _apiService.login(phone: phone);

      print('✅ Login response received: ${response.toString()}');

      if (mounted) {
        // Check if response is successful
        if (response['success'] == true) {
          // Check if response contains OTP (development mode)
          String? otpCode;
          if (response['data'] != null &&
              response['data']['otp_code'] != null) {
            otpCode = response['data']['otp_code'].toString();
            print('🔑 OTP Code (dev mode): $otpCode');
          }

          // Navigate to verification page with phone
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => VerificationCodePage(
                    phone: phone,
                    type: 'login',
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
            message: response['message'] ?? 'Gagal melakukan login',
            statusCode: null,
            errors: response['errors'],
          );
        }
      }
    } catch (e) {
      print('❌ Login error: $e');

      if (mounted) {
        String errorMessage = 'Gagal melakukan login';

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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      print('🔐 Starting Google Sign-In...');

      // Sign in with Google
      final googleResult = await _googleSignInService.signIn();

      if (googleResult == null) {
        // User canceled the sign-in
        if (mounted) {
          setState(() {
            _isGoogleLoading = false;
          });
        }
        return;
      }

      final googleUser = googleResult.account;
      final googleAuth = googleResult.authentication;

      print('✅ Google Sign-In successful');
      print('👤 User: ${googleUser.displayName}');
      print('📧 Email: ${googleUser.email}');
      print(
        '🔑 ID Token: ${googleAuth.idToken != null ? "${googleAuth.idToken!.substring(0, 20)}..." : "NULL"}',
      );
      print(
        '🔑 Access Token: ${googleAuth.accessToken != null ? "${googleAuth.accessToken!.substring(0, 20)}..." : "NULL"}',
      );

      // Check if idToken is available
      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        print('❌ ID Token is NULL or EMPTY');
        print('📋 Troubleshooting steps:');
        print(
          '   1. Pastikan OAuth 2.0 Client ID untuk Web application sudah dibuat di Google Cloud Console',
        );
        print(
          '   2. Pastikan serverClientId di google_sign_in_service.dart menggunakan Web Client ID (bukan Android Client ID)',
        );
        print(
          '   3. Format Client ID harus: xxxxx-xxxxx.apps.googleusercontent.com',
        );
        print('   4. Pastikan OAuth consent screen sudah dikonfigurasi');
        print('   5. Coba flutter clean dan rebuild aplikasi');
        throw Exception(
          'ID Token tidak tersedia.\n\n'
          'Solusi:\n'
          '1. Buat OAuth 2.0 Client ID untuk Web application di Google Cloud Console\n'
          '2. Pastikan serverClientId di google_sign_in_service.dart menggunakan Web Client ID\n'
          '3. Format: xxxxx-xxxxx.apps.googleusercontent.com\n'
          '4. Rebuild aplikasi setelah perubahan',
        );
      }

      // Validate email
      final email = googleUser.email;
      if (email.isEmpty) {
        throw Exception('Email tidak tersedia dari akun Google');
      }

      // Double check idToken is not null (should already be checked above)
      // This is redundant but kept for safety
      final idTokenValue = googleAuth.idToken;
      if (idTokenValue == null || idTokenValue.isEmpty) {
        throw Exception('ID Token tidak tersedia setelah validasi');
      }

      // Prepare data for backend
      final idToken = googleAuth.idToken!;
      final accessToken = googleAuth.accessToken ?? '';
      final name = googleUser.displayName ?? 'User';
      final photoUrl = googleUser.photoUrl;

      print('📤 Preparing to send to backend:');
      print(
        '   - ID Token: ${idToken.substring(0, 20)}... (length: ${idToken.length})',
      );
      print(
        '   - Access Token: ${accessToken.isNotEmpty ? "${accessToken.substring(0, 20)}..." : "EMPTY"}',
      );
      print('   - Email: $email');
      print('   - Name: $name');
      print('   - Photo URL: ${photoUrl ?? "NULL"}');

      // Send Google auth data to backend
      final response = await _apiService.googleLogin(
        idToken: idToken,
        accessToken: accessToken,
        email: email,
        name: name,
        photoUrl: photoUrl,
      );

      print('✅ Backend response: ${response.toString()}');

      if (mounted) {
        if (response['success'] == true && response['data'] != null) {
          // Save token and user data
          final token = response['data']['token'];
          final userData = response['data']['user'];

          if (token != null) {
            await _authService.saveToken(token);
            // Set token in ApiService
            _apiService.setToken(token);
          }

          if (userData != null) {
            final user = User.fromJson(userData);
            await _authService.saveUser(user);
            
            // Update UserProfileService dengan data dari backend
            UserProfileService.updateProfileLocal(
              nama: user.name,
              email: user.email ?? '',
              phone: user.phone ?? '',
              photoUrl: user.photoUrl ?? '',
            );
            
            // Load profile lengkap dari backend untuk memastikan data terbaru
            try {
              await UserProfileService.loadProfile();
            } catch (e) {
              print('Warning: Failed to load profile after Google login: $e');
              // Continue anyway, we already have the data from response
            }
          }

          // Navigate to home or main page
          // You may need to adjust this based on your app structure
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', // Adjust this route name
            (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ?? 'Login dengan Google berhasil',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          throw ApiException(
            message:
                response['message'] ?? 'Gagal melakukan login dengan Google',
            statusCode: null,
            errors: response['errors'],
          );
        }
      }
    } on PlatformException catch (e) {
      // Handle PlatformException (Google Sign-In specific errors)
      print('❌ PlatformException: ${e.code} - ${e.message}');
      print('❌ Details: ${e.details}');

      if (mounted) {
        String errorMessage = 'Gagal melakukan login dengan Google';
        String errorDetails = '';

        // Check error code
        if (e.code == 'sign_in_failed' || e.code == 'sign_in_canceled') {
          final errorMessageStr = e.message ?? '';
          final errorDetailsStr = e.details?.toString() ?? '';

          // Check for error code 12500 (SIGN_IN_CANCELLED or OAuth consent screen issue)
          if (errorMessageStr.contains('12500') ||
              errorDetailsStr.contains('12500')) {
            errorMessage = '❌ Error Google Sign-In (Error Code: 12500)';
            errorDetails =
                '\n\n🔧 KEMUNGKINAN PENYEBAB:\n\n'
                '1. OAuth Consent Screen dalam mode Testing:\n'
                '   - Jika app masih dalam mode Testing, pastikan email Anda sudah ditambahkan sebagai Test User\n'
                '   - Buka: APIs & Services > OAuth consent screen\n'
                '   - Scroll ke "Test users" dan tambahkan email Anda\n\n'
                '2. OAuth Consent Screen belum dikonfigurasi:\n'
                '   - Buka: APIs & Services > OAuth consent screen\n'
                '   - Pastikan semua informasi sudah diisi (App name, Support email, dll)\n'
                '   - Klik "Save and Continue" sampai selesai\n\n'
                '3. OAuth 2.0 Client ID untuk Android belum dibuat:\n'
                '   - Buka: APIs & Services > Credentials\n'
                '   - Buat OAuth 2.0 Client ID untuk Android\n'
                '   - Package name: com.example.booking_servis\n'
                '   - SHA-1: CE:11:31:64:61:7F:86:40:AF:97:0B:DF:18:68:E4:98:0A:79:43:B2\n\n'
                '4. Tunggu 5-10 menit setelah perubahan konfigurasi\n\n'
                '5. Clear cache dan rebuild:\n'
                '   flutter clean\n'
                '   flutter pub get\n'
                '   flutter run';
          }
          // Check for error code 10 (DEVELOPER_ERROR) - most common issue
          else if (errorMessageStr.contains('10') ||
              errorMessageStr.contains('DEVELOPER_ERROR') ||
              errorDetailsStr.contains('10') ||
              errorDetailsStr.contains('DEVELOPER_ERROR')) {
            errorMessage =
                '❌ Error Konfigurasi Google Sign-In (Error Code: 10)';
            errorDetails =
                '\n\n🔧 LANGKAH PERBAIKAN:\n\n'
                '1. Buka Google Cloud Console:\n'
                '   https://console.cloud.google.com/\n\n'
                '2. Pergi ke: APIs & Services > Credentials\n\n'
                '3. Buat OAuth 2.0 Client ID untuk Android:\n'
                '   - Klik "+ CREATE CREDENTIALS" > "OAuth 2.0 Client ID"\n'
                '   - Application type: Android\n'
                '   - Package name: com.example.booking_servis\n'
                '   - SHA-1: CE:11:31:64:61:7F:86:40:AF:97:0B:DF:18:68:E4:98:0A:79:43:B2\n\n'
                '4. Buat OAuth 2.0 Client ID untuk Web:\n'
                '   - Application type: Web application\n'
                '   - Copy Client ID (format: xxxxx-xxxxx.apps.googleusercontent.com)\n'
                '   - Pastikan serverClientId di google_sign_in_service.dart menggunakan Web Client ID ini\n\n'
                '5. Tunggu 5-10 menit setelah membuat\n\n'
                '6. Clear cache dan rebuild:\n'
                '   flutter clean\n'
                '   flutter pub get\n'
                '   flutter run';
          } else if (errorMessageStr.contains('sign_in_failed') ||
              errorDetailsStr.contains('sign_in_failed')) {
            errorMessage = 'Gagal melakukan sign-in dengan Google';
            errorDetails =
                '\n\nKemungkinan penyebab:\n'
                '1. OAuth 2.0 Client ID belum dibuat di Google Cloud Console\n'
                '2. SHA-1 certificate fingerprint belum ditambahkan\n'
                '3. Package name tidak sesuai\n'
                '4. Google Sign-In API belum diaktifkan\n'
                '5. OAuth consent screen belum dikonfigurasi';
          } else if (errorMessageStr.contains('network') ||
              errorDetailsStr.contains('network') ||
              errorMessageStr.contains('NETWORK')) {
            errorMessage = 'Error koneksi jaringan';
            errorDetails =
                '\n\nPastikan:\n'
                '1. Koneksi internet aktif\n'
                '2. Google Play Services terinstall dan update\n'
                '3. Tidak ada firewall yang memblokir';
          } else {
            errorMessage = 'Error Google Sign-In: ${e.message ?? e.code}';
            errorDetails =
                '\n\nDetail: ${e.details ?? "Tidak ada detail tambahan"}\n'
                'Cek console/log untuk detail error lengkap.';
          }
        } else if (e.code == 'sign_in_canceled') {
          // User canceled - don't show error
          if (mounted) {
            setState(() {
              _isGoogleLoading = false;
            });
          }
          return;
        } else {
          errorMessage = 'Error: ${e.message ?? e.code}';
          errorDetails =
              '\n\nDetail: ${e.details ?? "Tidak ada detail tambahan"}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage$errorDetails'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } on ApiException catch (e) {
      // Handle API errors
      print('❌ ApiException: ${e.message}');
      print('❌ Status code: ${e.statusCode}');
      print('❌ Errors: ${e.errors}');

      if (mounted) {
        String errorMessage = e.getErrorMessage();
        String errorDetails = '';

        // Add specific guidance for 500 errors
        if (e.statusCode == 500) {
          errorMessage = 'Error Server (500)';
          errorDetails =
              '\n\n🔧 Kemungkinan penyebab:\n'
              '1. Backend Laravel error - cek log Laravel\n'
              '2. Database connection error\n'
              '3. Missing migration atau kolom di database\n'
              '4. Error di controller atau service backend\n\n'
              '💡 Cek log backend Laravel untuk detail error:\n'
              '   php artisan serve (jika development)\n'
              '   tail -f storage/logs/laravel.log (jika production)';
        } else if (e.statusCode == 404) {
          errorMessage = 'Endpoint tidak ditemukan (404)';
          errorDetails =
              '\n\nPastikan:\n'
              '1. Endpoint /api/auth/google ada di backend\n'
              '2. Route sudah terdaftar dengan benar\n'
              '3. Base URL benar: ${ApiConfig.baseUrl}';
        } else if (e.statusCode == 422) {
          errorMessage = 'Validasi gagal (422)';
          errorDetails =
              '\n\nCek error detail di atas untuk field yang bermasalah.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage$errorDetails'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      // Handle other errors
      print('❌ Google Sign-In error: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error details: ${e.toString()}');

      if (mounted) {
        String errorMessage = 'Gagal melakukan login dengan Google';
        String errorDetails = '';

        final errorString = e.toString();

        // Check for common error patterns
        // Check for error code 12500 (SIGN_IN_CANCELLED or OAuth consent screen issue)
        if (errorString.contains('12500') ||
            (errorString.contains('ApiException') &&
                errorString.contains('12500'))) {
          errorMessage = '❌ Error Google Sign-In (Error Code: 12500)';
          errorDetails =
              '\n\n🔧 KEMUNGKINAN PENYEBAB:\n\n'
              '1. OAuth Consent Screen dalam mode Testing:\n'
              '   - Jika app masih dalam mode Testing, pastikan email Anda sudah ditambahkan sebagai Test User\n'
              '   - Buka: APIs & Services > OAuth consent screen\n'
              '   - Scroll ke "Test users" dan tambahkan email Anda\n\n'
              '2. OAuth Consent Screen belum dikonfigurasi:\n'
              '   - Buka: APIs & Services > OAuth consent screen\n'
              '   - Pastikan semua informasi sudah diisi (App name, Support email, dll)\n'
              '   - Klik "Save and Continue" sampai selesai\n\n'
              '3. OAuth 2.0 Client ID untuk Android belum dibuat:\n'
              '   - Buka: APIs & Services > Credentials\n'
              '   - Buat OAuth 2.0 Client ID untuk Android\n'
              '   - Package name: com.example.booking_servis\n'
              '   - SHA-1: CE:11:31:64:61:7F:86:40:AF:97:0B:DF:18:68:E4:98:0A:79:43:B2\n\n'
              '4. Tunggu 5-10 menit setelah perubahan konfigurasi\n\n'
              '5. Clear cache dan rebuild:\n'
              '   flutter clean\n'
              '   flutter pub get\n'
              '   flutter run';
        } else if (errorString.contains('ApiException: 10') ||
            errorString.contains('DEVELOPER_ERROR') ||
            (errorString.contains('sign_in_failed') &&
                errorString.contains('10'))) {
          errorMessage = '❌ Error Konfigurasi Google Sign-In (Error Code: 10)';
          errorDetails =
              '\n\n🔧 LANGKAH PERBAIKAN:\n\n'
              '1. Buka Google Cloud Console:\n'
              '   https://console.cloud.google.com/\n\n'
              '2. Pergi ke: APIs & Services > Credentials\n\n'
              '3. Buat OAuth 2.0 Client ID untuk Android:\n'
              '   - Application type: Android\n'
              '   - Package name: com.example.booking_servis\n'
              '   - SHA-1: CE:11:31:64:61:7F:86:40:AF:97:0B:DF:18:68:E4:98:0A:79:43:B2\n\n'
              '4. Buat OAuth 2.0 Client ID untuk Web:\n'
              '   - Application type: Web application\n'
              '   - Copy Client ID ke serverClientId di google_sign_in_service.dart\n\n'
              '5. Tunggu 5-10 menit setelah membuat\n\n'
              '6. Clear cache dan rebuild:\n'
              '   flutter clean\n'
              '   flutter pub get\n'
              '   flutter run';
        } else {
          errorMessage = 'Error: ${e.toString()}';
          errorDetails = '\n\nCek console/log untuk detail error lengkap.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage$errorDetails'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
    });

    try {
      print('🔍 Starting connection test...');

      // Test base connection
      final baseTest = await _apiService.testConnection();
      print('📊 Base connection test: $baseTest');

      // Test API endpoint
      final apiTest = await _apiService.testApiEndpoint();
      print('📊 API endpoint test: $apiTest');

      if (mounted) {
        String message = '';
        Color backgroundColor = Colors.green;

        if (baseTest['success'] == true && apiTest['success'] == true) {
          String statusInfo = 'Status: ${apiTest['statusCode']}';
          if (apiTest['statusCode'] == 422) {
            statusInfo = 'Status: 422 (Validasi error - ini normal untuk test)';
          }
          message =
              '✅ Koneksi berhasil!\n\n'
              'Base URL: ${baseTest['baseUrl']}\n'
              'API Endpoint: ${apiTest['endpoint']}\n'
              '$statusInfo\n\n'
              'Backend dapat diakses dengan baik!';
        } else if (baseTest['success'] == true) {
          message =
              '⚠️ Backend dapat diakses, tapi API endpoint bermasalah\n\n'
              '${apiTest['message'] ?? 'Error tidak diketahui'}';
          backgroundColor = Colors.orange;
        } else {
          message =
              '❌ Tidak dapat terhubung ke backend\n\n'
              '${baseTest['message'] ?? 'Error tidak diketahui'}\n\n'
              'Base URL: ${baseTest['baseUrl']}';
          backgroundColor = Colors.red;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Test connection error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saat test koneksi: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTestingConnection = false;
        });
      }
    }
  }
}
