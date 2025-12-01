import 'package:flutter/material.dart';

import '../widgets/bottom_navbar.dart';
import '../services/vehicle_service.dart';
import '../services/user_profile_service.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/google_sign_in_service.dart';
import '../models/vehicle_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedBottomIndex = 3;
  bool _isLoadingProfile = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // Refresh to show latest vehicles
  }

  Future<void> _loadProfile() async {
    if (_isLoadingProfile) return;
    
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      await UserProfileService.loadProfile();
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
          _isLoadingProfile = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset(
                'assets/images/logo-otw-b 2.png',
                width: 142,
                height: 81,
                fit: BoxFit.contain,
              ),
            ),
            _buildGradientHeader(),
            const SizedBox(height: 20),
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildSectionTitle('Kendaraan anda'),
            const SizedBox(height: 8),
            VehicleService.vehicles.isEmpty
                ? _buildPlaceholderCard(
                  icon: Icons.directions_car,
                  label: 'Anda belum mendaftarkan kendaraan anda',
                )
                : _buildVehicleList(),
            const SizedBox(height: 20),
            _buildSectionTitle('Lainnya'),
            const SizedBox(height: 8),
            _buildActionGroup(
              items: const [Icons.notifications, Icons.help_outline, Icons.logout],
              labels: const ['Pengaturan Notifikasi', 'Bantuan & FAQ', 'Keluar'],
              onTap: (index) {
                if (index == 2) {
                  _handleLogout();
                }
              },
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
          Positioned(
            left: 16,
            top: 16,
            child: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: 'CreatoDisplay',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    if (_isLoadingProfile) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE0E0E0),
                backgroundImage: UserProfileService.photoUrl.isNotEmpty
                    ? NetworkImage(UserProfileService.photoUrl)
                    : null,
                child: UserProfileService.photoUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 32)
                    : null,
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image load error
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserProfileService.nama.isNotEmpty
                          ? UserProfileService.nama
                          : 'User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'CreatoDisplay',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      UserProfileService.email.isNotEmpty
                          ? UserProfileService.email
                          : 'Email belum diisi',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontFamily: 'CreatoDisplay',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/edit-profile');
                  // Reload profile after editing
                  if (result == true) {
                    _loadProfile();
                  }
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFF25A2FC),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFEEEEEE)),
          Row(
            children: [
              const Icon(Icons.call, size: 18, color: Colors.black54),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  UserProfileService.phone.isNotEmpty
                      ? UserProfileService.phone
                      : 'Nomor telepon belum diisi',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.black54),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  UserProfileService.alamat.isNotEmpty
                      ? UserProfileService.alamat
                      : 'Alamat belum diisi',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'CreatoDisplay',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'CreatoDisplay',
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard({
    required IconData icon,
    required String label,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'CreatoDisplay',
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGroup({
    required List<IconData> items,
    required List<String> labels,
    Function(int)? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Column(
        children: List.generate(
          labels.length,
          (index) => Column(
            children: [
              InkWell(
                onTap: onTap != null ? () => onTap(index) : null,
                child: Row(
                  children: [
                    Icon(
                      items[index],
                      size: 20,
                      color: index == 2 ? Colors.red : Colors.black54,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'CreatoDisplay',
                          color: index == 2 ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
              if (index != labels.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Color(0xFFEEEEEE), height: 1),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Keluar',
          style: TextStyle(
            fontFamily: 'CreatoDisplay',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(
            fontFamily: 'CreatoDisplay',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'CreatoDisplay',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'CreatoDisplay',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Logout from API
      try {
        await ApiService().logout();
      } catch (e) {
        // Continue even if API logout fails
        print('Warning: API logout failed: $e');
      }

      // Sign out from Google
      try {
        await GoogleSignInService().signOut();
      } catch (e) {
        // Continue even if Google sign out fails
        print('Warning: Google sign out failed: $e');
      }

      // Clear auth data
      await AuthService().clearAuth();

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to login page and clear navigation stack
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal keluar: ${e.toString()}',
              style: const TextStyle(fontFamily: 'CreatoDisplay'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildVehicleList() {
    final vehicles = VehicleService.vehicles;
    // Tampilkan hanya 1 kendaraan terbaru
    final displayedVehicles = vehicles.take(1).toList();

    return Column(
      children: [
        ...displayedVehicles.map((vehicle) {
          return _buildVehicleCard(vehicle, vehicles.length > 1);
        }).toList(),
      ],
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle, bool showViewButton) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            children: [
              // Car icon with glass effect background
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Vehicle details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.displayName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicle.nomorPolisi,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'CreatoDisplay',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Tombol "Lihat" di dalam card
          if (showViewButton) ...[
            const Divider(height: 20, color: Color(0xFFEEEEEE)),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/kendaraan');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF4AC6E5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'CreatoDisplay',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4AC6E5),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Color(0xFF4AC6E5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

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
