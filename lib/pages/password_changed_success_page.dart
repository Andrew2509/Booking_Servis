import 'package:flutter/material.dart';

class PasswordChangedSuccessPage extends StatelessWidget {
  const PasswordChangedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60.0),
      //   child: AppBar(
      //     backgroundColor: Colors.white,
      //     elevation: 0,
      //     leading: Padding(
      //       padding: const EdgeInsets.only(left: 8.0),
      //       child: IconButton(
      //         icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
      //         onPressed: () => Navigator.pop(context),
      //       ),
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/images/icon/dependable 1.png', // Make sure to add this image
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Password changed\nsuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'CreatoDisplay',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your password has been changed successfully, we will let you know if there are more problems with your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'CreatoDisplay',
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to login page
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', // Make sure to define this route
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back to login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'CreatoDisplay',
                      fontWeight: FontWeight.w600,
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
}
