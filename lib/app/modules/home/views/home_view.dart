import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/dayoff_model.dart';
import 'package:godsseo/app/data/widgets/bottom_bar.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color colorTop = const Color(0xFF2979FF);
    final Color colorBottom = const Color(0xFF0D47A1);
    final double defaultPadding = 16.0;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: colorTop,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // --- HEADER BACKGROUND ---
          ClipPath(
            clipper: HeaderCurveClipper(),
            child: Container(
              height: 380,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colorTop, colorBottom],
                ),
              ),
            ),
          ),

          // --- KONTEN ---
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                // 1. HEADER PROFILE
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      defaultPadding,
                      20,
                      defaultPadding,
                      10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white,
                                backgroundImage: (authC.user.foto.isEmptyOrNull)
                                    ? null
                                    : CachedNetworkImageProvider(
                                        authC.user.foto!,
                                      ),
                                child: authC.user.foto.isEmptyOrNull
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Hai,",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    authC.user.nickname ?? "User",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // JAM DIGITAL
                        Obx(
                          () => Text(
                            timeFormatter(controller.now),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. REMINDER PIKET (PINDAH KE ATAS SINI)
                // Muncul hanya jika isPiketToday = true
                Obx(() {
                  if (controller.isPiketToday.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: 10,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.PIKET);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.amber[100], // Kuning lembut
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.amber[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.cleaning_services_rounded,
                                    color: Colors.amber[800],
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Jadwal Piket!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown[800],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Hari ini jadwal kamu piket.",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.brown[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.brown[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    height: 10,
                  ); // Spacer kecil kalau gak ada notif
                }),

                // 3. MAIN STATUS CARD
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF448AFF), Color(0xFF0052CC)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: colorBottom.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Badge
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Status: ${controller.status}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Jam Masuk & Keluar
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTimeWidget(
                                "Masuk",
                                controller.todayPresensi?.dateIn,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white30,
                              ),
                              _buildTimeWidget(
                                "Keluar",
                                controller.todayPresensi?.dateOut,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 15),
                        // Lokasi
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.address.value.isNotEmpty
                                      ? controller.address.value
                                      : "Mendeteksi lokasi...",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${decimalFormatter(controller.distance?.toInt())} m",
                                  style: TextStyle(
                                    color: colorBottom,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 4. RECENT ACTIVITY HEADER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: Colors.blueGrey[800],
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Riwayat Terbaru",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.PRESENSI_INDEX),
                        child: const Text(
                          "Lihat Semua",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                // 5. LIST ACTIVITY
                Obx(() {
                  if (controller.presensi.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "Belum ada aktivitas",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.presensi.length > 5
                        ? 5
                        : controller.presensi.length,
                    itemBuilder: (context, index) {
                      var data = controller.presensi[index];
                      String dateStr = data.dateIn != null
                          ? DateFormat('d MMM yyyy').format(data.dateIn!)
                          : "";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Get.toNamed(
                                Routes.PRESENSI_DETAIL,
                                arguments: data,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        (authC.user.foto.isEmptyOrNull)
                                        ? null
                                        : CachedNetworkImageProvider(
                                            authC.user.foto!,
                                          ),
                                    backgroundColor: colorTop.withOpacity(0.1),
                                    child: authC.user.foto.isEmptyOrNull
                                        ? Icon(Icons.person, color: colorTop)
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          authC.user.nama ?? "User",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              timeFormatter(data.dateIn),
                                              style: TextStyle(
                                                color: colorTop,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              "-",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              data.dateOut != null
                                                  ? timeFormatter(data.dateOut)
                                                  : "--:--",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorTop.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          authC.user.sekolah ?? "SMK",
                                          style: TextStyle(
                                            color: colorTop,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dateStr,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: Obx(
        () => SizedBox(
          width: 68,
          height: 68,
          child: FloatingActionButton(
            backgroundColor: controller.todayOff is DayOffModel
                ? Colors.grey
                : const Color(0xFF0052CC),
            onPressed: controller.todayOff is DayOffModel
                ? null
                : () => controller.presence(context),
            elevation: 4,
            shape: const CircleBorder(
              side: BorderSide(color: Colors.white, width: 4),
            ),
            child: const Icon(Icons.fingerprint, size: 32, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const GSBottomBar(currentIndex: 0),
    );
  }

  Widget _buildTimeWidget(String label, DateTime? time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          timeFormatter(time, defaultText: "--:--"),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // Mulai dari kiri atas
    path.lineTo(0, size.height - 100);

    // Titik Kontrol (Puncak lengkungan) - Lebih tinggi dari sebelumnya
    var controlPoint = Offset(size.width / 2, size.height);

    // Titik Akhir (Kanan bawah)
    var endPoint = Offset(size.width, size.height - 100);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0); // Ke kanan atas
    path.close(); // Tutup path (ke kiri atas lagi)
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
