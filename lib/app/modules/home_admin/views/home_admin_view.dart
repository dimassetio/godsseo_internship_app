import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/bottom_bar.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:godsseo/app/modules/presensi/admin_history/views/presence_admin_card.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/home_admin_controller.dart';
import 'chart_painter.dart';

class HomeAdminView extends GetView<HomeAdminController> {
  const HomeAdminView({Key? key}) : super(key: key);

  // Helper simpel buat nama hari Indo
  String _getIndoDay(DateTime date) {
    List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find<AuthController>();
    final Color colorTop = const Color(0xFF0054DA);
    final Color colorBottom = const Color(0xFF0049B7);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorTop,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // HEADER BACKGROUND
          ClipPath(
            clipper: HeaderCurveClipper(),
            child: Container(
              height: 350,
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
          
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                // HEADER PROFILE & CLOCK
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              backgroundImage: (authC.user.foto.isEmptyOrNull)
                                  ? null
                                  : CachedNetworkImageProvider(authC.user.foto!),
                              child: authC.user.foto.isEmptyOrNull
                                  ? const Icon(Icons.person, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Hi", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                Text(
                                  authC.user.nickname ?? "Admin",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          DateFormat('HH.mm').format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // --- CHART CARD ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // --- BAGIAN TANGGAL (INTERAKTIF) ---
                            InkWell(
                              onTap: () => controller.pickDate(context),
                              child: Obx(() {
                                DateTime displayDate = controller.selectedDate.value;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayDate.day.toString(),
                                      style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w400,
                                          color: colorTop,
                                          height: 1),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "th", 
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorTop)
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              _getIndoDay(displayDate),
                                              style: const TextStyle(
                                                  color: Colors.amber, 
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              DateFormat('MMMM yyyy').format(displayDate),
                                              style: TextStyle(
                                                  color: colorTop.withOpacity(0.8), 
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(Icons.calendar_month_rounded, size: 16, color: colorTop.withOpacity(0.5))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                            
                            // Filter Dropdown
                            Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: controller.activeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: controller.activeFilter.value,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: controller.activeColor),
                                      style: TextStyle(
                                          color: controller.activeColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      items: <String>['All', 'On Time', 'Late', 'Izin']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) controller.changeFilter(val);
                                      },
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // --- CHART AREA (GESTURE ENABLED) ---
                        Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                            return GestureDetector(
                              // PENTING: Agar area kosong di grafik tetap bisa merespon sentuhan
                              behavior: HitTestBehavior.translucent,
                              
                              // Deteksi Tap (Tekan)
                              onTapDown: (details) {
                                controller.onChartTap(
                                    details.localPosition.dx,
                                    details.localPosition.dy,
                                    constraints.maxWidth,
                                    constraints.maxHeight);
                              },
                              
                              // Deteksi Drag (Geser Jari)
                              onPanUpdate: (details) {
                                 controller.onChartDrag(
                                    details.localPosition.dx,
                                    details.localPosition.dy,
                                    constraints.maxWidth,
                                    constraints.maxHeight);
                              },
                              
                              child: Container(
                                color: Colors.transparent,
                                width: double.infinity,
                                child: Obx(() => CustomPaint(
                                      size: Size.infinite,
                                      painter: ChartPainter(
                                        onTimeData: controller.weeklyOnTimeCounts.map((e) => e.toDouble()).toList(),
                                        lateData: controller.weeklyLateCounts.map((e) => e.toDouble()).toList(),
                                        izinData: controller.weeklyIzinCounts.map((e) => e.toDouble()).toList(),
                                        activeFilter: controller.activeFilter.value,
                                        maxY: controller.maxY.value.toDouble(),
                                        touchedCategory: controller.touchedCategory.value, 
                                      ),
                                    )),
                              ),
                            );
                          }),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Label Hari
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
                                .map((e) => Text(e,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: colorTop.withOpacity(0.6),
                                        fontWeight: FontWeight.bold)))
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // MENU GRID
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMenuButton(context, "Izin", Icons.mail_outline_rounded, () {
                        Get.toNamed(Routes.APPROVAL);
                      }, badgeCount: controller.pendingPermissionCount),
                      _buildMenuButton(context, "Presensi", Icons.fingerprint_rounded, () {
                        Get.toNamed(Routes.PRESENSI_ADMIN_HISTORY);
                      }),
                      _buildMenuButton(context, "Piket", Icons.cleaning_services_rounded, () {
                        Get.toNamed(Routes.PIKET_ADMIN);
                      }),
                      _buildMenuButton(context, "Jurnal", Icons.book_outlined, () {
                        Get.snackbar("Info", "Fitur Jurnal Coming Soon");
                      }),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // RECENT ACTIVITY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history_rounded, color: Colors.blueGrey[800]),
                          const SizedBox(width: 8),
                          Text("Today Presence",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[800])),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Obx(() {
                  if (controller.presensi.isEmpty) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Belum ada aktivitas"),
                    ));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.presensi.length,
                    itemBuilder: (context, index) {
                      var data = controller.presensi[index];
                      return PresenceAdminCard(data: data);
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GSBottomNavBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, IconData icon, VoidCallback onTap, {RxInt? badgeCount}) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                    ]),
                child: Icon(icon, color: primaryColor(context), size: 28),
              ),
            ),
            if (badgeCount != null)
              Obx(() => badgeCount.value > 0
                  ? Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2)),
                        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Center(
                          child: Text(
                            "${badgeCount.value}",
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w600))
      ],
    );
  }
}

class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var controlPoint = Offset(size.width / 2, size.height + 50);
    var endPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}