# Booking Servis App

Aplikasi pemesanan servis kendaraan berbasis Flutter dengan desain responsif yang mendukung berbagai ukuran layar.

## 📋 Deskripsi

Booking Servis App adalah aplikasi mobile yang memungkinkan pengguna untuk melakukan pemesanan servis kendaraan secara online. Aplikasi ini dibangun menggunakan Flutter dengan dukungan desain responsif untuk pengalaman pengguna yang optimal di berbagai perangkat.

## 🛠️ Persyaratan Sistem

- **Flutter SDK**: versi 3.7.2 atau lebih tinggi
- **Dart SDK**: versi 3.7.2 atau lebih tinggi
- **Android Studio** / **VS Code** dengan plugin Flutter
- **Git**
- **Android**: Android 5.0 (API level 21) atau lebih tinggi
- **iOS**: iOS 12.0 atau lebih tinggi (untuk pengembangan iOS)

## 📦 Dependencies Utama

- `google_fonts: ^6.2.1` - Font Google untuk tipografi
- `http: ^1.6.0` - HTTP client untuk API calls
- `shared_preferences: ^2.2.2` - Local storage
- `google_sign_in: ^6.2.1` - Autentikasi Google
- `image_picker: ^1.0.7` - Pilih gambar dari galeri/kamera
- `iconify_flutter: ^0.0.7` - Icon library

## 🚀 Langkah-langkah Instalasi

### 1. Clone Repository

```bash
git clone https://github.com/Andrew2509/Booking_Servis.git
cd booking_servis
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

```bash
flutter run
```

### 4. Pull Update Terbaru (Jika Sudah Ada Repository)

```bash
git status
git stash save "Backup perubahan lokal"
git pull origin main
git stash pop  # Jika perlu mengembalikan perubahan lokal
```

## 📶 Wireless Debugging (Android)

Panduan untuk melakukan debugging aplikasi Android tanpa kabel USB.

### 1. **Persiapan di HP Android**

- Aktifkan mode Developer Options:
  - Buka **Settings** > **About Phone**
  - Tap **Build Number** 7 kali
  - Developer Options akan muncul di Settings
- Di Developer Options, aktifkan:
  - ✅ **USB Debugging**
  - ✅ **Wireless Debugging**

### 2. **Koneksikan HP ke PC**

- Sambungkan HP ke PC via USB (sementara)
- Pastikan HP terdeteksi dengan menjalankan:
  ```bash
  flutter devices
  ```
- Di Developer Options, pilih **"Wireless Debugging"**
- Catat **IP Address** dan **Port** yang muncul

### 3. **Setup Wireless Debug**

```bash
# Pairing device (masukkan kode yang muncul di HP)
adb pair [IP_ADDRESS]:[PORT_PAIRING]

# Connect untuk debugging (biasanya port berbeda dengan pairing)
adb connect [IP_ADDRESS]:[PORT_DEBUG]
```

### 4. **Jalankan Aplikasi Wireless**

- Lepas kabel USB
- Pastikan HP dan PC dalam jaringan WiFi yang sama

```bash
flutter run  # Pilih device Android yang terdeteksi
```

### 💡 Tips

- Jika koneksi terputus, ulangi langkah `adb connect`
- IP Address bisa berubah jika HP reconnect ke WiFi
- Untuk performa lebih baik, gunakan jaringan 5GHz
- Pastikan firewall tidak memblokir koneksi ADB

## 📁 Struktur Proyek

```
booking_servis/
├── lib/
│   ├── main.dart                    # Entry point aplikasi
│   ├── models/                      # Model data
│   │   ├── booking_model.dart       # Model booking
│   │   ├── order_model.dart         # Model order
│   │   ├── user_model.dart          # Model user
│   │   └── vehicle_model.dart       # Model kendaraan
│   ├── pages/                       # Halaman UI
│   │   ├── splash_screen.dart       # Splash screen
│   │   ├── welcome_page.dart        # Halaman selamat datang
│   │   ├── login_page.dart          # Halaman login
│   │   ├── register_page.dart       # Halaman registrasi
│   │   ├── home_page.dart           # Halaman utama
│   │   ├── profile_page.dart        # Halaman profil
│   │   ├── order_page.dart          # Halaman order
│   │   └── ...                      # Halaman lainnya
│   ├── services/                     # Service layer
│   │   ├── api_service.dart         # Service API
│   │   ├── auth_service.dart         # Service autentikasi
│   │   ├── google_sign_in_service.dart  # Service Google Sign In
│   │   ├── order_service.dart       # Service order
│   │   ├── user_profile_service.dart    # Service profil user
│   │   └── vehicle_service.dart     # Service kendaraan
│   ├── utils/                        # Utilitas dan helpers
│   │   ├── constants.dart            # Konstanta aplikasi
│   │   ├── responsive_helper.dart    # Helper responsive design
│   │   ├── responsive_config.dart    # Konfigurasi responsive
│   │   └── breakpoints.dart          # Breakpoints untuk responsive
│   ├── widgets/                      # Widget yang dapat digunakan kembali
│   │   ├── custom_button.dart        # Button custom
│   │   ├── custom_textfield.dart     # TextField custom
│   │   ├── bottom_navbar.dart        # Bottom navigation bar
│   │   ├── booking_card.dart        # Card booking
│   │   ├── otp_input_field.dart      # Input field OTP
│   │   └── responsive_wrapper.dart   # Wrapper responsive
│   └── examples/                     # Contoh kode
│       └── responsive_example.dart   # Contoh responsive design
├── assets/
│   ├── fonts/                        # Font custom (Poppins)
│   └── images/                        # Gambar dan icon
│       ├── icon/                      # Icon aplikasi
│       └── ...                        # Asset lainnya
├── test/                             # Unit dan widget tests
│   └── widget_test.dart
├── android/                          # Konfigurasi Android
├── ios/                              # Konfigurasi iOS
├── web/                              # Konfigurasi Web
├── windows/                          # Konfigurasi Windows
├── linux/                            # Konfigurasi Linux
├── macos/                            # Konfigurasi macOS
├── pubspec.yaml                      # Dependencies dan konfigurasi
└── README.md                         # Dokumentasi proyek
```

## ✨ Fitur Utama

### 1. **Autentikasi & Keamanan**

- ✅ Login dengan email dan password
- ✅ Registrasi akun baru
- ✅ Verifikasi OTP via email
- ✅ Login dengan Google Sign In
- ✅ Lupa password dengan reset via email
- ✅ Verifikasi kode OTP

### 2. **Booking & Pemesanan Servis**

- ✅ Pemilihan jenis perawatan/servis
- ✅ Pemilihan jadwal yang tersedia
- ✅ Pengambilan nomor antrian
- ✅ Konfirmasi data booking
- ✅ Detail order lengkap
- ✅ Status booking real-time

### 3. **Manajemen Kendaraan**

- ✅ Daftar kendaraan pengguna
- ✅ Tambah kendaraan baru
- ✅ Edit informasi kendaraan
- ✅ Hapus kendaraan

### 4. **Manajemen Profil**

- ✅ Edit profil pengguna
- ✅ Upload foto profil
- ✅ Riwayat servis
- ✅ Detail status booking

### 5. **Desain Responsif**

- ✅ Mendukung berbagai ukuran layar
- ✅ Breakpoints untuk mobile, tablet, dan desktop
- ✅ Widget responsif yang adaptif
- ✅ Pengalaman pengguna optimal di semua perangkat

## 📱 Cara Penggunaan

### 1. **Registrasi & Login**

- Buka aplikasi
- Pilih **'Register'** jika belum punya akun
- Isi data yang diperlukan (nama, email, password)
- Verifikasi akun melalui kode OTP yang dikirim ke email
- Atau gunakan **Google Sign In** untuk registrasi/login cepat
- Setelah login, Anda akan diarahkan ke halaman utama

### 2. **Menambah Kendaraan**

- Login ke aplikasi
- Buka menu **'Profil'** atau **'Kendaraan'**
- Pilih **'Tambah Kendaraan'**
- Isi informasi kendaraan (merk, model, nomor plat, dll)
- Simpan data kendaraan

### 3. **Booking Servis**

- Login ke aplikasi
- Pilih menu **'Booking'** atau **'Pilih Perawatan'**
- Pilih jenis servis/perawatan yang diinginkan
- Pilih kendaraan yang akan diservis
- Pilih jadwal yang tersedia
- Ambil nomor antrian
- Konfirmasi data booking
- Tunggu notifikasi konfirmasi dari sistem

### 4. **Cek Status Booking**

- Login ke aplikasi
- Buka menu **'Order'** atau **'Riwayat'**
- Lihat daftar booking yang telah dibuat
- Pilih booking untuk melihat detail lengkap
- Pantau status booking (Pending, Dikonfirmasi, Sedang Dikerjakan, Selesai)

### 5. **Edit Profil**

- Buka menu **'Profil'**
- Pilih **'Edit Profil'**
- Update informasi yang diinginkan
- Upload foto profil (opsional)
- Simpan perubahan

## 🔧 Troubleshooting

### 1. **Masalah Instalasi**

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### 2. **Error Build**

- Pastikan versi Flutter dan Dart sesuai (minimal 3.7.2)
- Jalankan `flutter doctor` untuk cek masalah
- Update dependencies jika diperlukan: `flutter pub upgrade`
- Hapus folder `build/` dan coba build lagi
- Untuk Android: pastikan `minSdkVersion` sesuai di `android/app/build.gradle`

### 3. **Crash pada Runtime**

- Cek log error di console dengan `flutter run -v`
- Pastikan semua permission sudah diatur di `AndroidManifest.xml` (Android) atau `Info.plist` (iOS)
- Verifikasi koneksi internet untuk fitur yang memerlukan API
- Pastikan API endpoint sudah dikonfigurasi dengan benar

### 4. **Masalah Google Sign In**

- Pastikan `google-services.json` (Android) atau `GoogleService-Info.plist` (iOS) sudah ditambahkan
- Verifikasi SHA-1 fingerprint sudah didaftarkan di Firebase Console
- Pastikan package name sesuai dengan konfigurasi Firebase

### 5. **Masalah Image Picker**

- Pastikan permission camera dan storage sudah diatur
- Untuk Android: tambah permission di `AndroidManifest.xml`
- Untuk iOS: tambah permission di `Info.plist`

### 6. **Masalah Responsive Design**

- Pastikan menggunakan widget responsif yang tersedia di `lib/widgets/`
- Gunakan `ResponsiveWrapper` untuk layout yang adaptif
- Cek breakpoints di `lib/utils/breakpoints.dart`
- Lihat contoh di `lib/examples/responsive_example.dart`

## 🎨 Desain Responsif

Aplikasi ini menggunakan sistem desain responsif yang mendukung berbagai ukuran layar:

- **Mobile**: < 600px (Smartphone)
- **Tablet**: 600px - 1024px (Tablet portrait/landscape)
- **Desktop**: > 1024px (Desktop dan layar besar)

### Menggunakan Responsive Helper

```dart
import 'package:booking_servis/utils/responsive_helper.dart';

// Cek ukuran layar
if (ResponsiveHelper.isMobile(context)) {
  // Kode untuk mobile
} else if (ResponsiveHelper.isTablet(context)) {
  // Kode untuk tablet
} else {
  // Kode untuk desktop
}
```

Lihat dokumentasi lengkap di `lib/utils/RESPONSIVE_DESIGN_GUIDE.md`

## 🤝 Kontribusi

Kontribusi sangat diterima! Untuk berkontribusi:

1. **Fork** repository ini
2. **Buat branch** fitur baru (`git checkout -b feature/AmazingFeature`)
3. **Commit** perubahan Anda (`git commit -m 'Add some AmazingFeature'`)
4. **Push** ke branch (`git push origin feature/AmazingFeature`)
5. **Buat Pull Request**

### Pedoman Kontribusi

- Ikuti style code yang sudah ada
- Tambahkan komentar untuk kode yang kompleks
- Update dokumentasi jika diperlukan
- Test fitur baru sebelum membuat PR
- Pastikan tidak ada error atau warning

## 📦 Build untuk Production

### Android (APK)

```bash
flutter build apk --release
```

### Android (App Bundle)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 📄 Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

## 👤 Kontak & Informasi

**Developer**: Andrew  
**GitHub**: [@andrew2509](https://github.com/Andrew2509)  
**Project Link**: [https://github.com/Andrew2509/Booking_Servis](https://github.com/Andrew2509/Booking_Servis)

---

**Versi**: 1.0.0+1  
**Terakhir Diperbarui**: 2024
