import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  // Set token untuk authenticated requests
  void setToken(String? token) {
    _token = token;
  }

  // Get token
  String? getToken() {
    return _token;
  }

  // Helper method untuk membuat headers
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Helper method untuk handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    Map<String, dynamic> responseBody;

    try {
      responseBody = json.decode(response.body);
    } catch (e) {
      // If response is not JSON, include raw body in error
      String errorMessage = 'Invalid response format from server';
      if (statusCode >= 500) {
        errorMessage = 'Server Error (${statusCode}): ${response.body}';
      }
      throw ApiException(
        message: errorMessage,
        statusCode: statusCode,
        errors: null,
      );
    }

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    } else {
      // For server errors, include more details
      String errorMessage = responseBody['message'] ?? 'Terjadi kesalahan';
      if (statusCode >= 500) {
        errorMessage =
            responseBody['message'] ??
            'Server Error (${statusCode}): ${responseBody.toString()}';
        print('❌ Server error details: ${responseBody}');
      }
      throw ApiException(
        message: errorMessage,
        statusCode: statusCode,
        errors: responseBody['errors'],
      );
    }
  }

  // Register - Send OTP
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
  }) async {
    try {
      print('📤 Register request to: ${ApiConfig.baseUrl}/auth/register');
      print('📤 Request body: name=$name, phone=$phone');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/register'),
            headers: _getHeaders(),
            body: json.encode({'name': name, 'phone': phone}),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } on TimeoutException catch (e) {
      print('❌ Timeout error: ${e.message}');
      print('🔍 Cek:');
      print('   1. Apakah backend Laravel sudah berjalan? (php artisan serve)');
      print('   2. Apakah base URL benar? (${ApiConfig.baseUrl})');
      print('   3. Apakah device dan komputer dalam WiFi yang sama?');
      throw ApiException(
        message:
            'Timeout: Server tidak merespons. Pastikan backend Laravel sudah berjalan di ${ApiConfig.baseUrl.replaceAll('/api', '')}',
      );
    } on http.ClientException catch (e) {
      print('❌ Network error: ${e.message}');
      print('🔍 Base URL: ${ApiConfig.baseUrl}');
      throw ApiException(
        message:
            'Tidak dapat terhubung ke server. Pastikan backend Laravel sudah berjalan di ${ApiConfig.baseUrl.replaceAll('/api', '')}',
      );
    } on FormatException catch (e) {
      print('❌ Format error: ${e.message}');
      throw ApiException(message: 'Format response tidak valid: ${e.message}');
    } catch (e) {
      print('❌ Error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Gagal melakukan registrasi: ${e.toString()}',
      );
    }
  }

  // Verify Register
  Future<Map<String, dynamic>> verifyRegister({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/verify-register'),
            headers: _getHeaders(),
            body: json.encode({'phone': phone, 'code': code}),
          )
          .timeout(ApiConfig.timeout);

      final result = _handleResponse(response);

      // Save token jika berhasil
      if (result['data'] != null && result['data']['token'] != null) {
        setToken(result['data']['token']);
      }

      return result;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  // Login - Send OTP
  Future<Map<String, dynamic>> login({required String phone}) async {
    try {
      print('📤 Login request to: ${ApiConfig.baseUrl}/auth/login');
      print('📤 Request body: phone=$phone');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/login'),
            headers: _getHeaders(),
            body: json.encode({'phone': phone}),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } on TimeoutException catch (e) {
      print('❌ Timeout error: ${e.message}');
      print('🔍 Cek:');
      print('   1. Apakah backend Laravel sudah berjalan? (php artisan serve)');
      print('   2. Apakah base URL benar? (${ApiConfig.baseUrl})');
      print('   3. Apakah device dan komputer dalam WiFi yang sama?');
      throw ApiException(
        message:
            'Timeout: Server tidak merespons. Pastikan backend Laravel sudah berjalan di ${ApiConfig.baseUrl.replaceAll('/api', '')}',
      );
    } on http.ClientException catch (e) {
      print('❌ Network error: ${e.message}');
      print('🔍 Base URL: ${ApiConfig.baseUrl}');
      throw ApiException(
        message:
            'Tidak dapat terhubung ke server. Pastikan backend Laravel sudah berjalan di ${ApiConfig.baseUrl.replaceAll('/api', '')}',
      );
    } on FormatException catch (e) {
      print('❌ Format error: ${e.message}');
      throw ApiException(message: 'Format response tidak valid: ${e.message}');
    } catch (e) {
      print('❌ Error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal melakukan login: ${e.toString()}');
    }
  }

  // Verify Login
  Future<Map<String, dynamic>> verifyLogin({
    required String phone,
    required String code,
  }) async {
    try {
      print(
        '🔐 Verify login request to: ${ApiConfig.baseUrl}/auth/verify-login',
      );
      print('📤 Request body: phone=$phone, code=$code');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/verify-login'),
            headers: _getHeaders(),
            body: json.encode({'phone': phone, 'code': code}),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      final result = _handleResponse(response);

      // Save token jika berhasil
      if (result['data'] != null && result['data']['token'] != null) {
        final token = result['data']['token'];
        setToken(token);
        print('✅ Token saved: ${token.substring(0, 20)}...');
      }

      return result;
    } catch (e) {
      print('❌ Verify login error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOtp({
    required String phone,
    required String type, // 'register', 'login', 'reset_password'
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/resend-otp'),
            headers: _getHeaders(),
            body: json.encode({'phone': phone, 'type': type}),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  // Get Current User
  Future<User> getCurrentUser() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/auth/me'),
            headers: _getHeaders(includeAuth: true),
          )
          .timeout(ApiConfig.timeout);

      final result = _handleResponse(response);

      if (result['data'] != null && result['data']['user'] != null) {
        return User.fromJson(result['data']['user']);
      }

      throw ApiException(message: 'Data user tidak ditemukan');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  // Update Profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? address,
  }) async {
    try {
      print('📤 Update profile request to: ${ApiConfig.baseUrl}/auth/profile');
      
      final requestBody = <String, dynamic>{};
      if (name != null) requestBody['name'] = name;
      if (phone != null) requestBody['phone'] = phone;
      if (email != null) requestBody['email'] = email;
      if (address != null) requestBody['address'] = address;

      print('📤 Request body: $requestBody');

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}/auth/profile'),
            headers: _getHeaders(includeAuth: true),
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal mengupdate profile: ${e.toString()}');
    }
  }

  // Send OTP for phone verification (for profile update)
  Future<Map<String, dynamic>> sendPhoneVerificationOtp({
    required String phone,
  }) async {
    try {
      print('📤 Send phone verification OTP to: ${ApiConfig.baseUrl}/auth/verify-phone');
      print('📤 Request body: phone=$phone');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/verify-phone'),
            headers: _getHeaders(includeAuth: true),
            body: json.encode({'phone': phone}),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal mengirim kode OTP: ${e.toString()}');
    }
  }

  // Verify phone update OTP
  Future<Map<String, dynamic>> verifyPhoneUpdate({
    required String phone,
    required String code,
  }) async {
    try {
      print('📤 Verify phone update to: ${ApiConfig.baseUrl}/auth/verify-phone-code');
      print('📤 Request body: phone=$phone, code=$code');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/verify-phone-code'),
            headers: _getHeaders(includeAuth: true),
            body: json.encode({'phone': phone, 'code': code}),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal memverifikasi nomor telepon: ${e.toString()}');
    }
  }

  // Upload Profile Photo
  Future<Map<String, dynamic>> uploadPhoto(File photoFile) async {
    try {
      print('📤 Upload photo to: ${ApiConfig.baseUrl}/auth/upload-photo');

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/auth/upload-photo'),
      );

      // Add headers
      final headers = _getHeaders(includeAuth: true);
      request.headers.addAll(headers);

      // Add file
      final fileStream = http.ByteStream(photoFile.openRead());
      final fileLength = await photoFile.length();
      final multipartFile = http.MultipartFile(
        'photo',
        fileStream,
        fileLength,
        filename: photoFile.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      // Send request
      final streamedResponse = await request.send().timeout(ApiConfig.timeout);
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal mengupload foto: ${e.toString()}');
    }
  }

  // Google Login
  Future<Map<String, dynamic>> googleLogin({
    required String idToken,
    required String accessToken,
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    try {
      print('📤 Google login request to: ${ApiConfig.baseUrl}/auth/google');
      print('📤 Request body: email=$email, name=$name');
      print(
        '📤 ID Token: ${idToken.isNotEmpty ? "${idToken.substring(0, 20)}..." : "EMPTY"}',
      );
      print(
        '📤 Access Token: ${accessToken.isNotEmpty ? "${accessToken.substring(0, 20)}..." : "EMPTY"}',
      );

      // Validate idToken
      if (idToken.isEmpty) {
        throw ApiException(
          message:
              'ID Token tidak tersedia. Pastikan OAuth 2.0 Client ID sudah dikonfigurasi dengan benar.',
        );
      }

      // Ensure all values are strings and not null
      final requestBody = <String, dynamic>{
        'id_token': idToken.toString().trim(),
        'access_token': accessToken.toString().trim(),
        'email': email.toString().trim(),
        'name': name.toString().trim(),
      };

      // Add photo_url only if not null and not empty
      if (photoUrl != null && photoUrl.toString().trim().isNotEmpty) {
        requestBody['photo_url'] = photoUrl.toString().trim();
      }

      // Validate request body before sending
      if (requestBody['id_token'] == null ||
          requestBody['id_token'].toString().isEmpty) {
        throw ApiException(
          message: 'ID Token is null or empty in request body',
        );
      }

      print('📤 Full request body: ${json.encode(requestBody)}');
      print('📤 Request body keys: ${requestBody.keys.toList()}');
      print(
        '📤 ID Token in body: ${requestBody['id_token'] != null && requestBody['id_token'].toString().isNotEmpty ? "${requestBody['id_token'].toString().substring(0, requestBody['id_token'].toString().length > 20 ? 20 : requestBody['id_token'].toString().length)}..." : "NULL/EMPTY"}',
      );
      print(
        '📤 ID Token length: ${requestBody['id_token']?.toString().length ?? 0}',
      );

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/google'),
            headers: _getHeaders(),
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      // Log error details for 500 errors
      if (response.statusCode >= 500) {
        print('❌ Server Error (${response.statusCode})');
        print('📋 Response headers: ${response.headers}');
        print('📋 Full response body: ${response.body}');
      }

      final result = _handleResponse(response);

      // Save token jika berhasil
      if (result['data'] != null && result['data']['token'] != null) {
        final token = result['data']['token'];
        setToken(token);
        print('✅ Token saved: ${token.substring(0, 20)}...');
      }

      return result;
    } on TimeoutException catch (e) {
      print('❌ Timeout error: ${e.message}');
      throw ApiException(
        message:
            'Timeout: Server tidak merespons. Pastikan backend Laravel sudah berjalan di ${ApiConfig.baseUrl.replaceAll('/api', '')}',
      );
    } on http.ClientException catch (e) {
      print('❌ Network error: ${e.message}');
      throw ApiException(
        message:
            'Tidak dapat terhubung ke server. Pastikan backend Laravel sudah berjalan di ${ApiConfig.baseUrl.replaceAll('/api', '')}',
      );
    } on FormatException catch (e) {
      print('❌ Format error: ${e.message}');
      throw ApiException(message: 'Format response tidak valid: ${e.message}');
    } catch (e) {
      print('❌ Google login error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Gagal melakukan login dengan Google: ${e.toString()}',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
            headers: _getHeaders(includeAuth: true),
          )
          .timeout(ApiConfig.timeout);

      // Clear token
      setToken(null);
    } catch (e) {
      // Clear token even if logout fails
      setToken(null);
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal terhubung ke server: ${e.toString()}');
    }
  }

  // Test connection to backend
  Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔍 Testing connection to: ${ApiConfig.baseUrl}');
      print(
        '🔍 Base URL without /api: ${ApiConfig.baseUrl.replaceAll('/api', '')}',
      );

      // Try to connect to base URL (without /api)
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      print('🔍 Testing: $baseUrl');

      final response = await http
          .get(Uri.parse(baseUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 5));

      print('✅ Connection test successful!');
      print('📥 Status: ${response.statusCode}');
      print('📥 Response length: ${response.body.length} bytes');

      return {
        'success': true,
        'statusCode': response.statusCode,
        'message': 'Backend dapat diakses',
        'baseUrl': baseUrl,
      };
    } on TimeoutException catch (e) {
      print('❌ Connection timeout: ${e.message}');
      return {
        'success': false,
        'error': 'Timeout',
        'message':
            'Tidak dapat terhubung ke backend dalam 5 detik.\n\n'
            'Pastikan:\n'
            '1. Backend Laravel berjalan: php artisan serve --host=0.0.0.0 --port=8000\n'
            '2. Base URL benar: ${ApiConfig.baseUrl}\n'
            '3. Device dan komputer dalam WiFi yang sama (jika device fisik)\n'
            '4. Firewall tidak memblokir port 8000',
        'baseUrl': ApiConfig.baseUrl.replaceAll('/api', ''),
      };
    } on http.ClientException catch (e) {
      print('❌ Connection error: ${e.message}');
      return {
        'success': false,
        'error': 'Connection Error',
        'message':
            'Tidak dapat terhubung ke backend.\n\n'
            'Kemungkinan penyebab:\n'
            '1. Backend Laravel tidak berjalan\n'
            '2. Base URL salah: ${ApiConfig.baseUrl}\n'
            '3. Network error atau firewall memblokir\n'
            '4. Server tidak dapat diakses dari device ini',
        'baseUrl': ApiConfig.baseUrl.replaceAll('/api', ''),
      };
    } catch (e) {
      print('❌ Unexpected error: $e');
      return {
        'success': false,
        'error': 'Unknown Error',
        'message': 'Error tidak diketahui: ${e.toString()}',
        'baseUrl': ApiConfig.baseUrl.replaceAll('/api', ''),
      };
    }
  }

  // Create Booking
  Future<Map<String, dynamic>> createBooking({
    required String vehicleName,
    required String nomorPolisi,
    required String serviceType,
    required String maintenance,
    required DateTime orderDate,
    required String timeSlot,
    String? kmMasuk,
    String? notes,
  }) async {
    try {
      print('📤 Create booking request to: ${ApiConfig.baseUrl}/bookings');
      
      final requestBody = {
        'vehicle_name': vehicleName,
        'nomor_polisi': nomorPolisi,
        'service_type': serviceType,
        'maintenance': maintenance,
        'order_date': orderDate.toIso8601String(),
        'time_slot': timeSlot,
        if (kmMasuk != null && kmMasuk.isNotEmpty) 'km_masuk': kmMasuk,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      print('📤 Request body: ${json.encode(requestBody)}');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/bookings'),
            headers: _getHeaders(includeAuth: true),
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Create booking error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal membuat booking: ${e.toString()}');
    }
  }

  // Get User Bookings
  Future<Map<String, dynamic>> getBookings({String? status}) async {
    try {
      String url = '${ApiConfig.baseUrl}/bookings';
      if (status != null && status != 'all') {
        url += '?status=$status';
      }

      print('📤 Get bookings request to: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: _getHeaders(includeAuth: true),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Get bookings error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal mengambil data booking: ${e.toString()}');
    }
  }

  // Get Single Booking
  Future<Map<String, dynamic>> getBooking(String id) async {
    try {
      print('📤 Get booking request to: ${ApiConfig.baseUrl}/bookings/$id');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/bookings/$id'),
            headers: _getHeaders(includeAuth: true),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Get booking error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal mengambil data booking: ${e.toString()}');
    }
  }

  // Update Booking Status
  Future<Map<String, dynamic>> updateBookingStatus({
    required String id,
    required String status,
  }) async {
    try {
      print('📤 Update booking status request to: ${ApiConfig.baseUrl}/bookings/$id/status');
      print('📤 Request body: status=$status');

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}/bookings/$id/status'),
            headers: _getHeaders(includeAuth: true),
            body: json.encode({'status': status}),
          )
          .timeout(ApiConfig.timeout);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ Update booking status error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Gagal mengupdate status booking: ${e.toString()}');
    }
  }

  // Test API endpoint
  Future<Map<String, dynamic>> testApiEndpoint() async {
    try {
      print('🔍 Testing API endpoint: ${ApiConfig.baseUrl}/auth/register');

      // Try to access a simple endpoint (will likely return validation error, but that's OK)
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/register'),
            headers: _getHeaders(),
            body: json.encode({}),
          )
          .timeout(const Duration(seconds: 5));

      print('✅ API endpoint accessible!');
      print('📥 Status: ${response.statusCode}');
      print(
        '📥 Response: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...',
      );

      // Even if it's a validation error (422), that means the endpoint is accessible
      // Status 422 (Validation Error) is expected when testing with empty body
      if (response.statusCode >= 200 && response.statusCode < 500) {
        String statusMessage = 'API endpoint dapat diakses';
        if (response.statusCode == 422) {
          statusMessage =
              'API endpoint dapat diakses (422 = Validasi error, ini normal untuk test)';
        }
        return {
          'success': true,
          'statusCode': response.statusCode,
          'message': statusMessage,
          'endpoint': '${ApiConfig.baseUrl}/auth/register',
        };
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'message': 'API endpoint mengembalikan error ${response.statusCode}',
          'endpoint': '${ApiConfig.baseUrl}/auth/register',
          'response': response.body,
        };
      }
    } on TimeoutException catch (e) {
      print('❌ API endpoint timeout: ${e.message}');
      return {
        'success': false,
        'error': 'Timeout',
        'message':
            'Tidak dapat mengakses API endpoint dalam 5 detik.\n\n'
            'Pastikan backend Laravel berjalan dan dapat diakses.',
        'endpoint': '${ApiConfig.baseUrl}/auth/register',
      };
    } catch (e) {
      print('❌ API endpoint error: $e');
      return {
        'success': false,
        'error': 'Error',
        'message': 'Error mengakses API endpoint: ${e.toString()}',
        'endpoint': '${ApiConfig.baseUrl}/auth/register',
      };
    }
  }
}

// Custom Exception untuk API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errors;

  ApiException({required this.message, this.statusCode, this.errors});

  @override
  String toString() => message;

  // Helper method untuk mendapatkan error message yang lebih detail
  String getErrorMessage() {
    if (errors != null && errors is Map) {
      final errorMap = errors as Map<String, dynamic>;
      if (errorMap.isNotEmpty) {
        final firstError = errorMap.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }
    return message;
  }
}
