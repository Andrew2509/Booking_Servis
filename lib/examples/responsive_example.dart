import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../utils/responsive_config.dart';
import '../utils/breakpoints.dart';
import '../widgets/responsive_wrapper.dart';
import '../widgets/responsive_textfield.dart';
import '../widgets/responsive_button.dart';

class ResponsiveExamplePage extends StatelessWidget {
  const ResponsiveExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Responsive Example',
          style: TextStyle(
            fontSize: ResponsiveConfig.getTitleFontSize(context),
            fontFamily: 'CreatoDisplay',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveConfig.getScreenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title dengan font size responsif
              Text(
                'Contoh Responsive Design',
                style: TextStyle(
                  fontSize: ResponsiveConfig.getTitleFontSize(context),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CreatoDisplay',
                ),
              ),

              SizedBox(height: ResponsiveConfig.getMediumSpacing(context)),

              // Subtitle
              Text(
                'Aplikasi ini menggunakan sistem responsive design yang adaptif untuk semua ukuran layar.',
                style: TextStyle(
                  fontSize: ResponsiveConfig.getSubtitleFontSize(context),
                  fontFamily: 'CreatoDisplay',
                ),
              ),

              SizedBox(height: ResponsiveConfig.getLargeSpacing(context)),

              // Responsive TextField
              ResponsiveTextField(
                hintText: 'Masukkan email Anda',
                prefixIcon: Icons.email,
              ),

              SizedBox(height: ResponsiveConfig.getMediumSpacing(context)),

              // Responsive Button
              ResponsiveButton(
                text: 'Submit',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button pressed!')),
                  );
                },
                backgroundColor: const Color(0xFFED0707),
              ),

              SizedBox(height: ResponsiveConfig.getLargeSpacing(context)),

              // Responsive Wrapper untuk menampilkan konten berbeda
              ResponsiveWrapper(
                mobile: _buildMobileContent(context),
                tablet: _buildTabletContent(context),
                desktop: _buildDesktopContent(context),
              ),

              SizedBox(height: ResponsiveConfig.getLargeSpacing(context)),

              // Informasi ukuran layar
              _buildScreenInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Card(
      child: Padding(
        padding: ResponsiveConfig.getScreenPadding(context),
        child: Column(
          children: [
            Icon(
              Icons.phone_android,
              size: ResponsiveConfig.getTitleFontSize(context) * 2,
              color: Colors.blue,
            ),
            SizedBox(height: ResponsiveConfig.getSmallSpacing(context)),
            Text(
              'Mobile Layout',
              style: TextStyle(
                fontSize: ResponsiveConfig.getSubtitleFontSize(context),
                fontWeight: FontWeight.bold,
                fontFamily: 'CreatoDisplay',
              ),
            ),
            Text(
              'Tampilan ini dioptimalkan untuk perangkat mobile.',
              style: TextStyle(
                fontSize: ResponsiveConfig.getBodyFontSize(context),
                fontFamily: 'CreatoDisplay',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletContent(BuildContext context) {
    return Card(
      child: Padding(
        padding: ResponsiveConfig.getScreenPadding(context),
        child: Column(
          children: [
            Icon(
              Icons.tablet,
              size: ResponsiveConfig.getTitleFontSize(context) * 2,
              color: Colors.green,
            ),
            SizedBox(height: ResponsiveConfig.getSmallSpacing(context)),
            Text(
              'Tablet Layout',
              style: TextStyle(
                fontSize: ResponsiveConfig.getSubtitleFontSize(context),
                fontWeight: FontWeight.bold,
                fontFamily: 'CreatoDisplay',
              ),
            ),
            Text(
              'Tampilan ini dioptimalkan untuk perangkat tablet.',
              style: TextStyle(
                fontSize: ResponsiveConfig.getBodyFontSize(context),
                fontFamily: 'CreatoDisplay',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopContent(BuildContext context) {
    return Card(
      child: Padding(
        padding: ResponsiveConfig.getScreenPadding(context),
        child: Column(
          children: [
            Icon(
              Icons.desktop_windows,
              size: ResponsiveConfig.getTitleFontSize(context) * 2,
              color: Colors.orange,
            ),
            SizedBox(height: ResponsiveConfig.getSmallSpacing(context)),
            Text(
              'Desktop Layout',
              style: TextStyle(
                fontSize: ResponsiveConfig.getSubtitleFontSize(context),
                fontWeight: FontWeight.bold,
                fontFamily: 'CreatoDisplay',
              ),
            ),
            Text(
              'Tampilan ini dioptimalkan untuk perangkat desktop.',
              style: TextStyle(
                fontSize: ResponsiveConfig.getBodyFontSize(context),
                fontFamily: 'CreatoDisplay',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenInfo(BuildContext context) {
    final screenWidth = ResponsiveHelper.getScreenWidth(context);
    final screenHeight = ResponsiveHelper.getScreenHeight(context);

    return Card(
      child: Padding(
        padding: ResponsiveConfig.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Layar',
              style: TextStyle(
                fontSize: ResponsiveConfig.getSubtitleFontSize(context),
                fontWeight: FontWeight.bold,
                fontFamily: 'CreatoDisplay',
              ),
            ),
            SizedBox(height: ResponsiveConfig.getSmallSpacing(context)),
            Text(
              'Lebar: ${screenWidth.toStringAsFixed(0)}px',
              style: TextStyle(
                fontSize: ResponsiveConfig.getBodyFontSize(context),
                fontFamily: 'CreatoDisplay',
              ),
            ),
            Text(
              'Tinggi: ${screenHeight.toStringAsFixed(0)}px',
              style: TextStyle(
                fontSize: ResponsiveConfig.getBodyFontSize(context),
                fontFamily: 'CreatoDisplay',
              ),
            ),
            Text(
              'Tipe: ${Breakpoints.isMobile(screenWidth)
                  ? 'Mobile'
                  : Breakpoints.isTablet(screenWidth)
                  ? 'Tablet'
                  : 'Desktop'}',
              style: TextStyle(
                fontSize: ResponsiveConfig.getBodyFontSize(context),
                fontFamily: 'CreatoDisplay',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
