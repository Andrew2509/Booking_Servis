# Panduan Responsive Design untuk Aplikasi Flutter

## Overview

Aplikasi ini telah dioptimalkan untuk menampilkan tampilan yang konsisten di semua ukuran emulator dan perangkat. Semua komponen menggunakan sistem responsive design yang adaptif.

## File Utilitas Responsive

### 1. `responsive_helper.dart`

Berisi fungsi-fungsi helper untuk mendapatkan ukuran layar dan perhitungan responsif.

```dart
// Contoh penggunaan
double screenWidth = ResponsiveHelper.getScreenWidth(context);
double fontSize = ResponsiveHelper.getResponsiveFontSize(context, 16);
```

### 2. `breakpoints.dart`

Mendefinisikan breakpoint untuk berbagai ukuran layar.

```dart
// Contoh penggunaan
if (Breakpoints.isMobile(screenWidth)) {
  // Kode untuk mobile
}
```

### 3. `responsive_config.dart`

Konfigurasi untuk font size, spacing, dan ukuran komponen yang responsif.

```dart
// Contoh penggunaan
double titleSize = ResponsiveConfig.getTitleFontSize(context);
EdgeInsets padding = ResponsiveConfig.getScreenPadding(context);
```

## Widget Responsive

### 1. `ResponsiveTextField`

TextField yang sudah responsif dengan ukuran dan padding yang adaptif.

```dart
ResponsiveTextField(
  hintText: 'Masukkan email',
  prefixIcon: Icons.email,
)
```

### 2. `ResponsiveButton`

Button yang responsif dengan ukuran yang adaptif.

```dart
ResponsiveButton(
  text: 'Login',
  onPressed: () {},
  backgroundColor: Colors.red,
)
```

### 3. `ResponsiveWrapper`

Wrapper untuk menampilkan widget berbeda berdasarkan ukuran layar.

```dart
ResponsiveWrapper(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)
```

## Perubahan yang Dilakukan

### 1. RegisterPage

- Mengganti ukuran fixed dengan MediaQuery
- Menambahkan SafeArea dan SingleChildScrollView
- Menggunakan width: double.infinity untuk input fields
- Menggunakan height responsif untuk header

### 2. LoginPage

- Mengganti ukuran fixed dengan MediaQuery
- Menggunakan width: double.infinity untuk semua komponen
- Menambahkan SingleChildScrollView untuk mencegah overflow

### 3. LoginChoicePage

- Menggunakan MediaQuery untuk ukuran gambar
- Menggunakan height responsif untuk tombol

### 4. WelcomePage

- Menggunakan font size responsif
- Menggunakan MediaQuery untuk ukuran teks

### 5. SplashScreen

- Menggunakan MediaQuery untuk ukuran logo
- Menambahkan SafeArea

## Breakpoint yang Digunakan

- **Mobile Small**: < 360px
- **Mobile Medium**: 360px - 400px
- **Mobile Large**: 400px - 600px
- **Tablet Small**: 600px - 768px
- **Tablet Medium**: 768px - 900px
- **Tablet Large**: 900px - 1024px
- **Desktop Small**: 1024px - 1200px
- **Desktop Medium**: 1200px - 1440px
- **Desktop Large**: > 1440px

## Tips Penggunaan

1. **Selalu gunakan MediaQuery** untuk ukuran yang responsif
2. **Gunakan SafeArea** untuk menghindari notch dan status bar
3. **Gunakan SingleChildScrollView** untuk mencegah overflow
4. **Gunakan width: double.infinity** untuk komponen yang harus mengisi lebar layar
5. **Gunakan ResponsiveConfig** untuk konsistensi ukuran font dan spacing

## Testing

Aplikasi telah diuji pada berbagai ukuran emulator:

- Pixel 3a (360x640)
- Pixel 4 (393x786)
- Pixel 5 (393x851)
- Tablet (768x1024)
- Desktop (1024x768)

Semua tampilan akan konsisten dan tidak ada overflow atau layout yang berantakan.
