import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/user_profile_service.dart';
import '../services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _originalPhoneNumber = '';
  bool _isPhoneVerified = true;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  File? _selectedPhoto;
  final ImagePicker _imagePicker = ImagePicker();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load profile from backend if not already loaded
      if (!UserProfileService.isInitialized) {
        await UserProfileService.loadProfile();
      }

      // Set controller values
      _namaController.text = UserProfileService.nama;
      _phoneController.text = UserProfileService.phone;
      _emailController.text = UserProfileService.email;
      _alamatController.text = UserProfileService.alamat;

      _originalPhoneNumber = _phoneController.text;
      _phoneController.addListener(_onPhoneChanged);
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memuat data profile: ${e.toString()}',
              style: const TextStyle(fontFamily: 'CreatoDisplay'),
            ),
            backgroundColor: Colors.red,
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

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _namaController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    if (_phoneController.text != _originalPhoneNumber &&
        _phoneController.text.isNotEmpty) {
      setState(() {
        _isPhoneVerified = false;
      });
    } else if (_phoneController.text == _originalPhoneNumber) {
      setState(() {
        _isPhoneVerified = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed top bar and banner
            _buildTopBar(),
            _buildGradientBanner(),
            // Scrollable content from profile picture to bottom
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Profile picture section
                    _buildProfilePictureSection(),
                    const SizedBox(height: 32),
                    // Form fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            label: 'Nama lengkap',
                            controller: _namaController,
                          ),
                          const SizedBox(height: 16),
                          _buildPhoneField(
                            label: 'Nomor Handphone',
                            controller: _phoneController,
                            helperText:
                                'Nomor ini adalah ID login utama Anda (VIA WhatsApp).',
                            isVerified: _isPhoneVerified,
                            onTap:
                                _isPhoneVerified
                                    ? null
                                    : _showVerificationDialog,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Email',
                            controller: _emailController,
                            helperText:
                                'Email akan digunakan untuk faktur dan pemulihan akun.',
                          ),
                          const SizedBox(height: 16),
                          _buildTextArea(
                            label: 'Alamat Lengkap',
                            controller: _alamatController,
                          ),
                          const SizedBox(height: 24),
                          // Save button
                          _buildSaveButton(),
                          const SizedBox(height: 40),
                          // Copyright
                          _buildCopyright(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          Image.asset(
            'assets/images/logo-otw-b 2.png',
            height: 57,
            width: 101,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBanner() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4AC6E5), Color(0xFF27A4FB)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: const DotsPatternPainter(),
              child: Container(),
            ),
          ),
          const Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'CreatoDisplay',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      // image_picker akan otomatis menangani permission request
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        setState(() {
          _selectedPhoto = File(image.path);
        });
        await _uploadPhoto();
      }
    } on PlatformException catch (e) {
      print('PlatformException picking image: $e');
      if (mounted) {
        String errorMessage = 'Gagal memilih foto';
        String details = '';

        if (e.code == 'channel-error' ||
            e.message?.contains('Unable to establish connection') == true) {
          errorMessage = 'Error: Native code belum terintegrasi';
          details =
              '\n\nSolusi:\n'
              '1. Stop aplikasi (Ctrl+C)\n'
              '2. Jalankan: flutter clean\n'
              '3. Jalankan: flutter pub get\n'
              '4. Jalankan: flutter run (BUKAN hot reload)\n'
              '5. Atau uninstall aplikasi dan install ulang';
        } else if (e.code == 'photo_access_denied' ||
            e.code == 'permission_denied' ||
            e.message?.contains('permission') == true) {
          errorMessage = 'Akses foto ditolak';
          details = '\n\nSilakan aktifkan permission di Settings aplikasi.';
        } else if (e.message != null) {
          errorMessage = 'Gagal memilih foto: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage$details'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        String errorMessage = 'Gagal memilih foto';
        String details = '';

        if (e.toString().contains('channel-error') ||
            e.toString().contains('Unable to establish connection')) {
          errorMessage = 'Error: Native code belum terintegrasi';
          details =
              '\n\nSolusi:\n'
              '1. Stop aplikasi dan jalankan: flutter clean\n'
              '2. Jalankan: flutter pub get\n'
              '3. Jalankan: flutter run (BUKAN hot reload)\n'
              '4. Atau uninstall aplikasi dan install ulang';
        } else if (e.toString().contains('permission') ||
            e.toString().contains('Permission')) {
          errorMessage = 'Permission diperlukan';
          details = '\n\nSilakan aktifkan permission di Settings aplikasi.';
        } else {
          errorMessage = 'Gagal memilih foto: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage$details'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedPhoto == null) return;

    setState(() {
      _isUploadingPhoto = true;
    });

    try {
      await UserProfileService.uploadPhoto(_selectedPhoto!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profile berhasil diupload'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error uploading photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupload foto: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
        });
      }
    }
  }

  Widget _buildProfilePictureSection() {
    final hasPhoto = UserProfileService.photoUrl.isNotEmpty;
    final displayPhoto =
        _selectedPhoto != null
            ? FileImage(_selectedPhoto!)
            : (hasPhoto ? NetworkImage(UserProfileService.photoUrl) : null);

    return Column(
      children: [
        // Profile picture
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey[400]!, width: 2),
              ),
              child:
                  _isUploadingPhoto
                      ? const Center(child: CircularProgressIndicator())
                      : displayPhoto != null
                      ? ClipOval(
                        child: Image(
                          image: displayPhoto as ImageProvider,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                      : const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4AC6E5),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: _isUploadingPhoto ? null : _pickImage,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Change photo button
        GestureDetector(
          onTap: _isUploadingPhoto ? null : _pickImage,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isUploadingPhoto)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF4AC6E5),
                  size: 18,
                ),
              const SizedBox(width: 6),
              Text(
                _isUploadingPhoto ? 'Mengupload...' : 'Ganti Foto Profil',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'CreatoDisplay',
                  fontWeight: FontWeight.w600,
                  color:
                      _isUploadingPhoto ? Colors.grey : const Color(0xFF4AC6E5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'CreatoDisplay',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, fontFamily: 'CreatoDisplay'),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'CreatoDisplay',
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhoneField({
    required String label,
    required TextEditingController controller,
    String? helperText,
    required bool isVerified,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'CreatoDisplay',
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (!isVerified) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 12,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verifikasi Wajib',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'CreatoDisplay',
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 14, fontFamily: 'CreatoDisplay'),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon:
                  !isVerified
                      ? IconButton(
                        icon: Icon(
                          Icons.verified_user,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        onPressed: onTap,
                        tooltip: 'Verifikasi Nomor',
                      )
                      : Icon(
                        Icons.verified,
                        color: Colors.green[600],
                        size: 20,
                      ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'CreatoDisplay',
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextArea({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'CreatoDisplay',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(fontSize: 14, fontFamily: 'CreatoDisplay'),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Masukkan alamat lengkap',
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'CreatoDisplay',
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showVerificationDialog() {
    _otpController.clear();
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor telepon tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _PhoneVerificationDialog(
          phoneNumber: phoneNumber,
          apiService: _apiService,
          onVerified: () {
            setState(() {
              _isPhoneVerified = true;
              _originalPhoneNumber = phoneNumber;
            });
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nomor berhasil diverifikasi'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    // Check if phone number is changed but not verified
    if (_phoneController.text.trim() != _originalPhoneNumber &&
        !_isPhoneVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan verifikasi nomor telepon terlebih dahulu',
            style: TextStyle(fontFamily: 'CreatoDisplay'),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Save to backend
      // Note: If phone was verified, it's already updated in backend via verifyPhoneUpdate
      // So we only send phone if it hasn't changed or if we need to update other fields
      final phoneToUpdate =
          _phoneController.text.trim() != _originalPhoneNumber &&
                  _isPhoneVerified
              ? _phoneController.text.trim()
              : null; // Don't send phone if unchanged (backend already has it)

      await UserProfileService.updateProfile(
        nama: _namaController.text.trim(),
        phone: phoneToUpdate,
        email: _emailController.text.trim(),
        alamat: _alamatController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile berhasil diperbarui',
              style: TextStyle(fontFamily: 'CreatoDisplay'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      print('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyimpan profile: ${e.toString()}',
              style: const TextStyle(fontFamily: 'CreatoDisplay'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            (_isPhoneVerified && !_isSaving && !_isLoading)
                ? _saveProfile
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4AC6E5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child:
            _isSaving
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_document, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildCopyright() {
    return const Center(
      child: Text(
        '© 2025 OTW MBENGKEL. by raihansaja',
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'CreatoDisplay',
          color: Colors.grey,
        ),
      ),
    );
  }
}

// Custom Painter for Dots Pattern
class DotsPatternPainter extends CustomPainter {
  const DotsPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    const double spacing = 20;
    const double radius = 2;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Phone Verification Dialog
class _PhoneVerificationDialog extends StatefulWidget {
  final String phoneNumber;
  final ApiService apiService;
  final VoidCallback onVerified;

  const _PhoneVerificationDialog({
    required this.phoneNumber,
    required this.apiService,
    required this.onVerified,
  });

  @override
  State<_PhoneVerificationDialog> createState() =>
      _PhoneVerificationDialogState();
}

class _PhoneVerificationDialogState extends State<_PhoneVerificationDialog> {
  final int codeLength = 4;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isCodeComplete = false;
  bool _isSendingOtp = false;
  bool _isVerifying = false;
  bool _canResend = false;
  int _remainingTime = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(codeLength, (_) => FocusNode());
    _sendOtp();
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

  Future<void> _sendOtp() async {
    if (_isSendingOtp) return;

    setState(() {
      _isSendingOtp = true;
    });

    try {
      await widget.apiService.sendPhoneVerificationOtp(
        phone: widget.phoneNumber,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kode OTP telah dikirim ke WhatsApp Anda'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Gagal mengirim kode OTP';
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
          _isSendingOtp = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isSendingOtp || !_canResend) return;

    await _sendOtp();
    setState(() {
      _remainingTime = 60;
      _canResend = false;
    });
    _startTimer();
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

  Future<void> _verifyCode() async {
    final code = _enteredCode;
    if (code.length != codeLength || _isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      await widget.apiService.verifyPhoneUpdate(
        phone: widget.phoneNumber,
        code: code,
      );

      if (mounted) {
        widget.onVerified();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Kode OTP tidak valid';
        if (e is ApiException) {
          errorMessage = e.getErrorMessage();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        // Clear OTP fields on error
        for (final controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
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
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _focusNodes[index].hasFocus
                  ? const Color(0xFF4AC6E5)
                  : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'CreatoDisplay',
          color: Colors.black,
        ),
        decoration: const InputDecoration(
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
                _verifyCode();
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
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.verified_user, color: Colors.orange[700], size: 24),
          const SizedBox(width: 8),
          const Text(
            'Verifikasi Nomor',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'CreatoDisplay',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kode verifikasi telah dikirim ke:',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'CreatoDisplay',
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.phoneNumber,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'CreatoDisplay',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(codeLength, (i) => _buildCodeField(i)),
            ),
            const SizedBox(height: 16),
            if (_canResend)
              Center(
                child: TextButton(
                  onPressed: _isSendingOtp ? null : _resendOtp,
                  child:
                      _isSendingOtp
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text(
                            'Kirim Ulang Kode',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'CreatoDisplay',
                              color: Color(0xFF4AC6E5),
                            ),
                          ),
                ),
              )
            else
              Center(
                child: Text(
                  'Kirim ulang dalam ${_remainingTime}s',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'CreatoDisplay',
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isVerifying ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Batal',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'CreatoDisplay',
              color: Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: (_isCodeComplete && !_isVerifying) ? _verifyCode : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4AC6E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              _isVerifying
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text(
                    'Verifikasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'CreatoDisplay',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      ],
    );
  }
}
