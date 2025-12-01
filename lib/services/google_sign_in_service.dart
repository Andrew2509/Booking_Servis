import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInResult {
  final GoogleSignInAccount account;
  final GoogleSignInAuthentication authentication;

  GoogleSignInResult({required this.account, required this.authentication});
}

class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;
  GoogleSignInService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    // ⚠️ PENTING: serverClientId HARUS menggunakan OAuth 2.0 Client ID untuk WEB APPLICATION
    // Bukan Android Client ID!
    //
    // Cara mendapatkan:
    // 1. Buka https://console.cloud.google.com/
    // 2. APIs & Services > Credentials
    // 3. + CREATE CREDENTIALS > OAuth 2.0 Client ID
    // 4. Application type: Web application (BUKAN Android!)
    // 5. Salin Client ID (format: xxxxx-xxxxx.apps.googleusercontent.com)
    //
    // Format harus: xxxxx-xxxxx.apps.googleusercontent.com
    serverClientId:
        '732958022618-0rm1q12lqfvcuu16fm2gi9cci6snl78a.apps.googleusercontent.com',
  );

  /// Sign in with Google
  /// Returns GoogleSignInResult if successful, null if user canceled
  Future<GoogleSignInResult?> signIn() async {
    try {
      print('🔐 GoogleSignInService: Starting sign-in process...');
      print(
        '🔐 Server Client ID: ${_googleSignIn.serverClientId ?? "NOT SET"}',
      );
      print('🔐 Scopes: ${_googleSignIn.scopes}');

      // Sign out first to ensure fresh sign in
      print('🔐 Signing out previous session...');
      await _googleSignIn.signOut();

      // Trigger the authentication flow
      print('🔐 Triggering Google Sign-In UI...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        print('⚠️ User canceled the sign-in');
        return null;
      }

      print('✅ Google account selected: ${googleUser.email}');

      // Obtain the auth details from the request
      print('🔐 Obtaining authentication tokens...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Debug: Log authentication details
      print('🔍 Authentication details:');
      print(
        '   - Access Token: ${googleAuth.accessToken != null ? "Available (${googleAuth.accessToken!.substring(0, 20)}...)" : "NULL"}',
      );
      print(
        '   - ID Token: ${googleAuth.idToken != null ? "Available (${googleAuth.idToken!.substring(0, 20)}...)" : "NULL"}',
      );
      print(
        '   - Server Client ID: ${_googleSignIn.serverClientId ?? "NOT SET"}',
      );

      // Validate that ID Token is available
      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        print('❌ ERROR: ID Token is null or empty!');
        print(
          '   - Server Client ID: ${_googleSignIn.serverClientId ?? "NOT SET"}',
        );
        print(
          '   - Make sure OAuth 2.0 Client ID for Web is correctly configured in Google Cloud Console',
        );
        print(
          '   - Verify the serverClientId matches the Web Client ID (not Android Client ID)',
        );
        print('   - Format should be: xxxxx-xxxxx.apps.googleusercontent.com');
        throw Exception(
          'ID Token tidak tersedia. Pastikan:\n'
          '1. OAuth 2.0 Client ID untuk Web application sudah dibuat di Google Cloud Console\n'
          '2. serverClientId di google_sign_in_service.dart menggunakan Web Client ID\n'
          '3. Format Client ID: xxxxx-xxxxx.apps.googleusercontent.com',
        );
      }

      print('✅ Google Sign-In successful!');
      return GoogleSignInResult(
        account: googleUser,
        authentication: googleAuth,
      );
    } catch (e) {
      print('❌ Google Sign-In error in service: $e');
      print('❌ Error type: ${e.runtimeType}');
      
      // Log additional details for PlatformException
      if (e is PlatformException) {
        print('❌ PlatformException code: ${e.code}');
        print('❌ PlatformException message: ${e.message}');
        print('❌ PlatformException details: ${e.details}');
        
        // Check for specific error codes
        final errorMessage = e.message ?? '';
        final errorDetails = e.details?.toString() ?? '';
        
        if (errorMessage.contains('12500') || errorDetails.contains('12500')) {
          print('⚠️ Error Code 12500 detected - Possible causes:');
          print('   1. OAuth Consent Screen in Testing mode - user not added as test user');
          print('   2. OAuth Consent Screen not properly configured');
          print('   3. OAuth 2.0 Client ID for Android not created');
        } else if (errorMessage.contains('10') || errorDetails.contains('10')) {
          print('⚠️ Error Code 10 detected - DEVELOPER_ERROR');
          print('   Check OAuth 2.0 Client ID configuration in Google Cloud Console');
        }
      }
      
      rethrow;
    }
  }

  /// Get current signed in user
  Future<GoogleSignInAccount?> getCurrentUser() async {
    return await _googleSignIn.signInSilently();
  }

  /// Sign out from Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  /// Check if user is signed in
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
