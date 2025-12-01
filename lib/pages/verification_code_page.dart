import 'dart:async';
import 'package:flutter/material.dart';
import 'verification_success_page.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../models/user_model.dart';

class VerificationCodePage extends StatefulWidget {
  final String phone;
  final String type; // 'register' or 'login'
  final String? otpCode; // For development mode

  const VerificationCodePage({
    super.key,
    required this.phone,
    required this.type,
    this.otpCode,
  });

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final int codeLength = 4;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isCodeComplete = false;
  int _remainingTime = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isLoading = false;
  bool _isVerifying = false;
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(codeLength, (_) => FocusNode());
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _resendCode() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.resendOtp(phone: widget.phone, type: widget.type);

      if (mounted) {
        setState(() {
          _remainingTime = 60;
          _canResend = false;
        });
        _startTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kode OTP telah dikirim ulang'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Gagal mengirim ulang OTP';
        if (e is ApiException) {
          errorMessage = e.getErrorMessage();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
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

  String get _enteredCode => _controllers.map((c) => c.text).join();

  void _checkCodeComplete() {
    final isComplete = _controllers.every((c) => c.text.trim().isNotEmpty);
    if (_isCodeComplete != isComplete) {
      setState(() {
        _isCodeComplete = isComplete;
      });
    }
  }

  Future<void> _onVerify() async {
    final code = _enteredCode;
    if (code.length != codeLength || _isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      print('🔐 Verifying ${widget.type} OTP...');
      print('📱 Phone: ${widget.phone}');
      print('🔑 Code: $code');

      Map<String, dynamic> response;

      if (widget.type == 'register') {
        response = await _apiService.verifyRegister(
          phone: widget.phone,
          code: code,
        );
      } else {
        response = await _apiService.verifyLogin(
          phone: widget.phone,
          code: code,
        );
      }

      print('✅ Verification response: ${response.toString()}');

      // Save token and user data
      if (response['data'] != null) {
        final token = response['data']['token'];
        if (token != null) {
          await _authService.saveToken(token);
          _apiService.setToken(token);
          print('✅ Token saved successfully');
        }

        if (response['data']['user'] != null) {
          final user = User.fromJson(response['data']['user']);
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
            print('Warning: Failed to load profile after verification: $e');
            // Continue anyway, we already have the data from response
          }
          
          print('✅ User data saved: ${user.name}');
        }
      }

      if (mounted) {
        print(
          '✅ ${widget.type == 'register' ? 'Registration' : 'Login'} successful! Navigating to success page...',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VerificationSuccessPage(),
          ),
        );
      }
    } catch (e) {
      print('❌ Verification error: $e');
      if (mounted) {
        String errorMessage = 'Kode OTP tidak valid';
        if (e is ApiException) {
          errorMessage = e.getErrorMessage();
          print('📋 Error details: ${e.errors}');
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
          _isVerifying = false;
        });
      }
    }
  }

  Widget _buildCodeField(int index) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'CreatoDisplay',
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          setState(() {
            if (value.isNotEmpty) {
              if (index + 1 < codeLength) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
              }
            } else {
              if (index - 1 >= 0) {
                _focusNodes[index - 1].requestFocus();
              }
            }
          });
          Future.microtask(() => _checkCodeComplete());
        },
      ),
    );
  }

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
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 18,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Title
              const Text(
                'Verification code',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'Kode verifikasi telah dikirim ke nomor Anda.\nAnda memiliki waktu untuk dapat masuk menggunakan verifikasi.',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Code Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(codeLength, (i) => _buildCodeField(i)),
              ),

              const Spacer(),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (_isCodeComplete && !_isVerifying) ? _onVerify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isCodeComplete
                            ? const Color(0xFF00AFFE)
                            : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isVerifying
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
                            'Konfirmasi',
                            style: TextStyle(
                              fontFamily: 'CreatoDisplay',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend Code
              if (_canResend)
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _resendCode,
                    child: const Text(
                      'Kirim ulang kode',
                      style: TextStyle(
                        fontFamily: 'CreatoDisplay',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00AFFE),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
