import 'dart:async';
import '../services/api_service.dart';

class UserProfileService {
  static String _nama = '';
  static String _phone = '';
  static String _email = '';
  static String _alamat = '';
  static String _photoUrl = '';
  static bool _isLoading = false;
  static bool _isInitialized = false;

  // Getters
  static String get nama => _nama;
  static String get phone => _phone;
  static String get email => _email;
  static String get alamat => _alamat;
  static String get photoUrl => _photoUrl;
  static bool get isLoading => _isLoading;
  static bool get isInitialized => _isInitialized;

  // Load profile from API
  static Future<void> loadProfile() async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      final apiService = ApiService();
      final user = await apiService.getCurrentUser();

      _nama = user.name;
      _phone = user.phone ?? '';
      _email = user.email ?? '';
      _photoUrl = user.photoUrl ?? '';
      // Note: alamat tidak ada di backend saat ini, tetap kosong atau bisa ditambahkan nanti
      _alamat = '';

      _isInitialized = true;
      print('✅ Profile loaded from API: $_nama, $_email, $_phone, photo: $_photoUrl');
    } catch (e) {
      print('❌ Error loading profile: $e');
      // Keep existing values if API call fails
      if (!_isInitialized) {
        // Set default values if first load fails
        _nama = 'User';
        _phone = '';
        _email = '';
        _alamat = '';
      }
    } finally {
      _isLoading = false;
    }
  }

  // Update profile locally (for immediate UI update)
  static void updateProfileLocal({
    String? nama,
    String? phone,
    String? email,
    String? alamat,
    String? photoUrl,
  }) {
    if (nama != null) _nama = nama;
    if (phone != null) _phone = phone;
    if (email != null) _email = email;
    if (alamat != null) _alamat = alamat;
    if (photoUrl != null) _photoUrl = photoUrl;
  }

  // Upload photo
  static Future<String> uploadPhoto(dynamic photoFile) async {
    try {
      final apiService = ApiService();
      final result = await apiService.uploadPhoto(photoFile);

      if (result['data'] != null && result['data']['user'] != null) {
        final photoUrl = result['data']['user']['photo_url'] ?? '';
        _photoUrl = photoUrl;
        print('✅ Photo uploaded successfully: $photoUrl');
        return photoUrl;
      }

      throw Exception('Photo URL tidak ditemukan dalam response');
    } catch (e) {
      print('❌ Error uploading photo: $e');
      rethrow;
    }
  }

  // Update profile to backend
  static Future<void> updateProfile({
    String? nama,
    String? phone,
    String? email,
    String? alamat,
  }) async {
    try {
      final apiService = ApiService();
      await apiService.updateProfile(
        name: nama,
        phone: phone,
        email: email,
        address: alamat,
      );

      // Update local values after successful API call
      updateProfileLocal(
        nama: nama,
        phone: phone,
        email: email,
        alamat: alamat,
      );

      print('✅ Profile updated successfully');
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  // Clear profile data
  static void clearProfile() {
    _nama = '';
    _phone = '';
    _email = '';
    _alamat = '';
    _photoUrl = '';
    _isInitialized = false;
  }
}
