# Booking Servis App

Aplikasi pemesanan servis kendaraan berbasis Flutter.

## Persyaratan Sistem

- Flutter SDK versi 3.0.0 atau lebih tinggi
- Dart SDK versi 2.17.0 atau lebih tinggi
- Android Studio / VS Code dengan plugin Flutter
- Git

## Langkah-langkah Instalasi

# PUll yang Baru
   ```bash
   git status
   git stash save "Test"
   git pull origin main
   ```

1. **Clone Repository**
   ```bash
   git clone https://github.com/Andrew2509/Booking_Servis.git
   cd booking_servis
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

## Wireless Debugging (Android)

1. **Persiapan di HP Android**
   - Aktifkan mode Developer Options:
     - Buka Settings > About Phone
     - Tap Build Number 7 kali
     - Developer Options akan muncul di Settings
   - Di Developer Options, aktifkan:
     - USB Debugging
     - Wireless Debugging

2. **Koneksikan HP ke PC**
   - Sambungkan HP ke PC via USB
   - Pastikan HP terdeteksi (`flutter devices`)
   - Di Developer Options, pilih "Wireless Debugging"
   - Catat IP Address dan Port yang muncul

3. **Setup Wireless Debug**
   ```bash
   adb pair [IP_ADDRESS]:[PORT_PAIRING]   # Masukkan kode yang muncul di HP
   adb connect [IP_ADDRESS]:[PORT_DEBUG]   # Biasanya port berbeda dengan pairing
   ```

4. **Jalankan Aplikasi Wireless**
   - Lepas kabel USB
   - Pastikan HP dan PC dalam jaringan WiFi yang sama
   ```bash
   flutter run                            # Pilih device Android yang terdeteksi
   ```

Tips:
- Jika koneksi terputus, ulangi langkah "adb connect"
- IP Address bisa berubah jika HP reconnect ke WiFi
- Untuk performa lebih baik, gunakan jaringan 5GHz

## Struktur Proyek

```
booking_servis/
├── lib/
│   ├── main.dart              # Entry point aplikasi
│   ├── models/                # Model data
│   ├── pages/                 # Halaman UI
│   ├── services/              # Service layer
│   ├── utils/                 # Utilitas dan helpers
│   └── widgets/              # Widget yang dapat digunakan kembali
├── assets/
│   ├── fonts/                # Font custom
│   └── images/               # Gambar dan icon
└── test/                    # Unit dan widget tests
```

## Fitur Utama

1. **Autentikasi**
   - Login
   - Register
   - Verifikasi OTP
   - Lupa Password

2. **Booking Servis**
   - Pemilihan Jenis Servis
   - Pemilihan Jadwal
   - Konfirmasi Booking

3. **Manajemen Profil**
   - Edit Profil
   - Riwayat Servis
   - Status Booking

## Cara Penggunaan

1. **Login/Register**
   - Buka aplikasi
   - Pilih 'Register' jika belum punya akun
   - Masukkan data yang diperlukan
   - Verifikasi akun melalui kode OTP

2. **Booking Servis**
   - Login ke aplikasi
   - Pilih menu 'Booking'
   - Pilih jenis servis
   - Pilih jadwal yang tersedia
   - Konfirmasi booking
   - Tunggu notifikasi konfirmasi

3. **Cek Status Booking**
   - Login ke aplikasi
   - Buka menu 'Riwayat'
   - Lihat status booking terkini

## Troubleshooting

1. **Masalah Instalasi**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Error Build**
   - Pastikan versi Flutter dan Dart sesuai
   - Jalankan `flutter doctor` untuk cek masalah
   - Update dependencies jika diperlukan

3. **Crash pada Runtime**
   - Cek log error di console
   - Pastikan semua permission sudah diatur
   - Verifikasi koneksi internet

## Kontribusi

1. Fork repository
2. Buat branch fitur (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

## Kontak

Andrew - [@andrew2509](https://github.com/Andrew2509)

Project Link: [https://github.com/Andrew2509/Booking_Servis](https://github.com/Andrew2509/Booking_Servis)
