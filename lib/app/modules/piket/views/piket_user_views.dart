import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/models/piket_task_model.dart';
import 'package:godsseo/app/modules/piket/controllers/piket_user_controllers.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class PiketUserView extends GetView<PiketUserController> {
  const PiketUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color headerColor = const Color(0xFF0052CC);
    final Color cardTop = const Color(0xFF2979FF);
    final Color cardBottom = const Color(0xFF003399);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: headerColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          ClipPath(
            clipper: HeaderCurveDownClipper(),
            child: Container(
              height: 200,
              width: double.infinity,
              color: headerColor,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // --- APP BAR ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Get.offAllNamed(Routes.HOME),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Jadwal Piket",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // --- KARTU HEADER BIRU ---
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [cardTop, cardBottom],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: cardBottom.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                var date = controller.selectedDate.value;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('d').format(date),
                                      style: const TextStyle(
                                        fontSize: 64,
                                        height: 1,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "th",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              controller.selectedDay.value,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              DateFormat(
                                                'MMMM yyyy',
                                              ).format(date),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.chevron_right,
                                              color: Colors.white70,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 30),
                              const Text(
                                "Minggu Ini",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 15),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: controller.days.map((day) {
                                  return Obx(() {
                                    bool isSelected =
                                        controller.selectedDay.value == day;
                                    bool hasDuty = controller.myDutyDays
                                        .contains(day);

                                    return GestureDetector(
                                      onTap: () => controller.changeDay(day),
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 4,
                                        ),
                                        child: Column(
                                          children: [
                                            RotatedBox(
                                              quarterTurns: 3,
                                              child: Text(
                                                day,
                                                style: TextStyle(
                                                  color: hasDuty
                                                      ? Colors.amberAccent
                                                      : Colors.white,
                                                  fontSize: 13,
                                                  fontWeight:
                                                      isSelected || hasDuty
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.amber
                                                    : hasDuty
                                                    ? Colors.amber
                                                    : Colors.white.withOpacity(
                                                        0.5,
                                                      ),
                                                shape: BoxShape.circle,
                                                border: (hasDuty && !isSelected)
                                                    ? Border.all(
                                                        color: Colors.white,
                                                        width: 1.5,
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- LIST TUGAS / ILUSTRASI ---
                        Obx(() {
                          // Cek apakah ini hari piket user?
                          bool isMyDuty = controller.myDutyDays.contains(
                            controller.selectedDay.value,
                          );

                          if (!isMyDuty) {
                            // ILUSTRASI BEBAS PIKET
                            return Container(
                              margin: const EdgeInsets.only(top: 40),
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.sentiment_very_satisfied_rounded,
                                    size: 80,
                                    color: Colors.blue[100],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Tidak Ada Piket Hari Ini",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Hari ini kamu tidak ada jadwal piket.\nNikmati harimu, kawan!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (controller.taskList.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: 60,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Belum ada tugas yang diinput.",
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.taskList.length,
                            itemBuilder: (context, index) {
                              var task = controller.taskList[index];
                              return _buildSlidableTaskCard(index, task);
                            },
                          );
                        }),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD TUGAS USER ---
  Widget _buildSlidableTaskCard(int index, PiketTask task) {
    String subtitleText = task.isDone && task.executorName != null
        ? "Selesai oleh: ${task.executorName}"
        : task.location;

    Color subtitleColor = task.isDone ? Colors.green[700]! : Colors.grey[600]!;

    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // BACKGROUND SLIDE (HIJAU/MERAH)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => controller.markTask(index, true),
                    child: Container(
                      width: 70,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C853),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.markTask(index, false),
                    child: Container(
                      width: 70,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF44336),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CARD UTAMA
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: 0,
            bottom: 0,
            left: task.isOpen ? -140 : 0,
            right: task.isOpen ? 140 : 0,
            child: GestureDetector(
              onTap: () {
                controller.toggleCard(index);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconForTitle(task.title),
                        color: const Color(0xFF0054DA),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // INFO LOKASI / PELAKU
                          Text(
                            subtitleText,
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                              fontWeight: task.isDone
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Indikator Status
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isDone
                            ? const Color(0xFF00C853)
                            : const Color(0xFFF44336),
                      ),
                      child: Icon(
                        task.isDone ? Icons.check : Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    if (title.toLowerCase().contains("sapu")) return Icons.cleaning_services;
    if (title.toLowerCase().contains("pel")) return Icons.water_drop;
    if (title.toLowerCase().contains("cuci")) return Icons.soap;
    if (title.toLowerCase().contains("sampah")) return Icons.delete;
    return Icons.work;
  }
}

class HeaderCurveDownClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var controlPoint = Offset(size.width / 2, size.height + 50);
    var endPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
