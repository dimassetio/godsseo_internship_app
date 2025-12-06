import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageTranslation extends Translations {
  static const Locale localeID = Locale("id", "ID");
  static const Locale localeEN = Locale("en", "US");
  static const List<Locale> localeList = [localeEN, localeID];

  @override
  Map<String, Map<String, String>> get keys =>
      {'en_US': english, 'id_ID': indonesia};
}

Map<String, String> indonesia = {
  // AUTH MODULES
  "Data user tidak ditemukan": "Data user tidak ditemukan",
  "Email belum diverifikasi": "Email belum diverifikasi",
  "User tidak aktif": "User tidak aktif",
  "Gagal mendaftarkan user": "Gagal mendaftarkan user",
  "Login Berhasil": "Login Berhasil",
  "Selamat datang di Godsseo-App": "Selamat datang di Godsseo-App",
  "Error": "Error",
  "Kembali": "Kembali",
  "Verifikasi Email Dikirimkan!": "Verifikasi Email Dikirimkan!",
  "Kami telah mengirimkan verifikasi ke alamat email":
      "Kami telah mengirimkan verifikasi ke alamat email",
  "Kirim Ulang Verifikasi": "Kirim Ulang Verifikasi",
  "Silahkan periksa kotak masuk Anda dan ikuti langkah-langkah verifikasi untuk menyelesaikan proses pendaftaran. Klik Sign In jika anda telah melakukan verifikasi.":
      "Silahkan periksa kotak masuk Anda dan ikuti langkah-langkah verifikasi untuk menyelesaikan proses pendaftaran. Klik Sign In jika anda telah melakukan verifikasi.",
  "Sign In": "Sign In",
  "Sign Up": "Sign Up",
  "Reset Password": "Reset Password",
  "Masukkan email anda untuk mereset password":
      "Masukkan email anda untuk mereset password",
  "Reset": "Reset",
  "Periksa Email Anda": "Periksa Email Anda",
  "Kami telah mengirimkan email ke":
      "Kami telah mengirimkan email ke @email. Silahkan periksa email anda dan ikuti langkah-langkahnya untuk mereset password",
  "Login Gagal": "Login Gagal",
  "Role tidak terdeteksi": "Role tidak terdeteksi. Role anda adalah @role",
  "Email": "Email",
  "Email tidak valid": "Email tidak valid",
  "Bagian ini wajib diisi": "Bagian ini wajib diisi",
  "Password": "Password",
  "Lupa Password?": "Lupa Password?",
  "Tidak punya akun?": "Tidak punya akun?\nDaftar disini",
  "Register": "Register",
  "Name": "Name",
  "Password tidak sama!": "Password tidak sama!",
  "Konfirmasi Password": "Konfirmasi Password",
  "Sudah punya akun?": "Sudah punya akun? \nSign in disini!",

  // HOME MODULES
  "Done": "Selesai",
  "Gagal mendapatkan data lokasi": "Gagal mendapatkan data lokasi",
  "Anda berada di luar jangkauan": "Anda berada di luar jangkauan",
  "Failed to load presensi data": "Failed to load presensi data",
  "Presensi hari ini sudah dilakukan": "Presensi hari ini sudah dilakukan",
  "Presensi Masuk": "Presensi Masuk",
  "Presensi Keluar": "Presensi Keluar",
  "Konfirmasi Presensi": "Konfirmasi Presensi",
  "Pesan Konfirmasi Presensi":
      "Anda akan melakukan @jenis pada @waktu dengan jarak @jarak M dari kantor. Status anda @status",
  "Batal": "Batal",
  "Loading..": "Loading..", "Ok": "Ok",
  "Berhasil": "Berhasil",
  "Presensi berhasil disimpan": "Presensi berhasil disimpan",
  "Halo,": "Halo, @name",
  "Lama magang": "Ini hari ke-@days magang disini",
  "Hari ini": "Hari ini, @date",
  "Masuk": "Masuk",
  "Keluar": "Keluar",
  "Jarak Dari Kantor": "Jarak Dari Kantor",
  "Riwayat Presensi": "Riwayat Presensi",
  "Lihat semua": "Lihat semua",

  // HOME ADMIN
  "Presensi Hari Ini": "Presensi Hari Ini",
  "Terlambat": "Terlambat",
  "Belum": "Belum",

  // INDEX PRESENSI
  "Rekap Presensi Bulanan": "Rekap Presensi Bulanan",
  "Tepat Waktu": "Tepat Waktu",
  "Absen": "Absen",

  // DETAIL PRESENSI
  "Detail Presensi": "Detail Presensi",
  "Gagal memuat data presensi": "Gagal memuat data presensi",
  "Status": "Status",
  "Lokasi": "Lokasi",
  "Jarak dari kantor": "Jarak dari kantor",

  // PROFILE
  "Profil": "Profil",
  "Konfirmasi Log Out": "Konfirmasi Log Out",
  "Apakah anda yakin akan keluar dari aplikasi ini":
      "Apakah anda yakin akan keluar dari aplikasi ini",
  "Username": "Username",
  "Nama Lengkap": "Nama Lengkap",
  "Laki-Laki": "Laki-Laki",
  "Gender": "Gender",
  "Alamat": "Alamat",
  "Asal Sekolah": "Asal Sekolah",
  "Tanggal Masuk": "Tanggal Masuk",
  "Aktif": "Aktif",
  "Nonaktif": "Nonaktif",
  "Role": "Role",

  // USERS MODULE
  "Pengguna": "Pengguna",
  "Kirim Email Reset Password?": "Kirim Email Reset Password?",
  "Kirim ke":
      "Email berisi link untuk mereset passwrod akan dikirim ke @email, lanjutkan?",
  "User tidak ditemukan": "User tidak ditemukan",
  "Nonaktifkan User?": "Nonaktifkan User?",
  "User dinonaktifkan": "User: @name akan dinonaktifkan, lanjutkan?",
  "Ya": "Ya",
  "Detail Pengguna": "Detail Pengguna",
  "Edit": "Edit",
  "Nonaktifkan": "Nonaktifkan",
  "Email verification sent": "Email verification sent to @email",
  "Submit": "Submit",
  "Tambah": "Tambah",
  "Upload foto": "Upload foto",

  // PENGATURAN PRESENSI
  "Pengaturan Presensi": "Pengaturan Presensi",
  "Waktu Masuk": "Waktu Masuk",
  "Waktu Keluar": "Waktu Keluar",
  "Loading": "Loading",
  "Simpan": "Simpan",
  "Hari Libur": "Hari Libur",
  "Deskripsi": "Deskripsi",
  "Sembunyikan Kemarin": "Sembunyikan Kemarin",
  "Tampilkan Kemarin": "Tampilkan Kemarin",
  "Belum ada hari libur": "Belum ada hari libur",

  // HARI LIBUR
  "Form Hari Libur": "Form Hari Libur",
  "Tanggal": "Tanggal",
};

Map<String, String> english = {};
