import 'dart:async';
import 'package:flutter/material.dart';
import 'verification_success_page.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final int codeLength = 4; // Changed to 4 digits
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isCodeComplete = false;
  int _remainingTime = 60;
  Timer? _timer;
  bool _canResend = false;

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

  void _resendCode() {
    setState(() {
      _remainingTime = 60;
      _canResend = false;
    });
    _startTimer();
    // TODO: Implement resend logic (API call)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Code resent successfully')));
  }

  String get _enteredCode => _controllers.map((c) => c.text).join();

  void _checkCodeComplete() {
    // Consider code complete only when every text controller has a non-empty value.
    // Previous logic used `!code.contains('')` which is always false because
    // every string contains the empty substring. That prevented the Confirm
    // button from ever becoming enabled. Use a clear check instead.
    final isComplete = _controllers.every((c) => c.text.trim().isNotEmpty);
    if (_isCodeComplete != isComplete) {
      setState(() {
        _isCodeComplete = isComplete;
      });
    }
  }

  void _onVerify() {
    final code = _enteredCode;
    if (code.length != codeLength) return;

    // Navigate to success page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VerificationSuccessPage()),
    );
  }

  Widget _buildCodeField(int index) {
    return SizedBox(
      width: 60,
      height: 60,
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
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() {
            if (value.isNotEmpty) {
              // move to next field
              if (index + 1 < codeLength) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
              }
            } else {
              // move to previous if empty
              if (index - 1 >= 0) {
                _focusNodes[index - 1].requestFocus();
              }
            }
          });
          Future.microtask(
            () => _checkCodeComplete(),
          ); // Check after state is updated
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Verification code',
                style: TextStyle(
                  fontFamily: 'CreatoDisplay',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'Kode verifikasi telah dikirim ke nomor Anda. \nAnda memiliki waktu (${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}) untuk dapat masuk menggunakan verifikasi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CreatoDisplay',
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(codeLength, (i) => _buildCodeField(i)),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _isCodeComplete ? _onVerify : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey[300]!;
                          }
                          return Colors.black;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontFamily: 'CreatoDisplay',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_canResend)
                TextButton(
                  onPressed: _resendCode,
                  child: const Text(
                    'Kirim ulang kode',
                    style: TextStyle(
                      fontFamily: 'CreatoDisplay',
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
