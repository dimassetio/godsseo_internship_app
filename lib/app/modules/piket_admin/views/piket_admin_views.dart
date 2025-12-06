import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/models/piket_task_model.dart';
import 'package:godsseo/app/modules/piket_admin/controllers/piket_admin_controllers.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class PiketAdminView extends GetView<PiketAdminController> {
  const PiketAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color headerColor = const Color(0xFF0052CC);
    final Color cardTop = const Color(0xFF2979FF);     
    final Color cardBottom = const Color(0xFF003399);  

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: headerColor,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // FAB Tambah Tugas
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(context, null, null),
        backgroundColor: const Color(0xFF0054DA),
        icon: const Icon(Icons.add_task, color: Colors.white),
        label: const Text("Tugas", style: TextStyle(color: Colors.white)),
      ),
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
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.offAllNamed(Routes.HOME_ADMIN),
                        ),
                      ),
                      
                      const Expanded(
                        child: Text(
                          "Manajemen Piket",
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
                        // --- KARTU UTAMA (KALENDER) ---
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
                              BoxShadow(color: cardBottom.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Kalender Picker
                              InkWell(
                                onTap: () => controller.pickDate(context),
                                child: Obx(() {
                                  var date = controller.selectedDate.value;
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(DateFormat('d').format(date), 
                                        style: const TextStyle(fontSize: 64, height: 1, fontWeight: FontWeight.w300, color: Colors.white)
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("th", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(controller.selectedDay.value, 
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                                              const SizedBox(width: 5),
                                              Text(DateFormat('MMMM yyyy').format(date), 
                                                style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                              const SizedBox(width: 5),
                                              const Icon(Icons.calendar_month, color: Colors.white70, size: 18)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Progress Bar
                              const Text("Progress Harian", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 8),
                              Obx(() => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: LinearProgressIndicator(
                                            value: controller.progressValue,
                                            backgroundColor: Colors.white24,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                                            minHeight: 8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(controller.progressPercentage, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              )),

                              const SizedBox(height: 30),
                              const Text("Pilih Hari", style: TextStyle(color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 15),

                              // --- LIST HARI (DIPERBAIKI: Rata, Besar, Touch Area Luas) ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: controller.days.map((day) {
                                  return Obx(() {
                                    bool isSelected = controller.selectedDay.value == day;
                                    return GestureDetector(
                                      onTap: () => controller.changeDay(day),
                                      behavior: HitTestBehavior.translucent, // Agar area kosong tetap bisa diklik
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // Touch Area Tambahan
                                        child: Column(
                                          children: [
                                            RotatedBox(
                                              quarterTurns: 3,
                                              child: Text(
                                                day, 
                                                style: TextStyle(
                                                  color: Colors.white, 
                                                  fontSize: 13, // Text Digedein dikit
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                                                )
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Container(
                                              width: 8, height: 8,
                                              decoration: BoxDecoration(
                                                color: isSelected ? Colors.amber : Colors.white.withOpacity(0.5),
                                                shape: BoxShape.circle,
                                                border: isSelected ? Border.all(color: Colors.white, width: 1.5) : null
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                }).toList(),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // --- SECTION PETUGAS HARIAN ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Petugas Piket", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003399))),
                            TextButton.icon(
                              onPressed: () => _showOfficerDialog(context),
                              icon: const Icon(Icons.edit, size: 16, color: Color(0xFF0054DA)),
                              label: const Text("Edit Petugas", style: TextStyle(fontSize: 12, color: Color(0xFF0054DA))),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF0054DA).withOpacity(0.1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        // List Avatar Petugas
                        Obx(() {
                          if (controller.dailyOfficers.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!)
                              ),
                              child: const Center(
                                child: Text("Belum ada petugas assigned.", style: TextStyle(color: Colors.grey)),
                              ),
                            );
                          }
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.dailyOfficers.map((name) {
                                return Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: const Color(0xFF0054DA),
                                    child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                                  ),
                                  label: Text(name, style: const TextStyle(fontSize: 12)),
                                  backgroundColor: const Color(0xFFF5F7FA),
                                  side: BorderSide.none,
                                );
                              }).toList(),
                            ),
                          );
                        }),

                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Daftar Tugas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003399)))
                        ),
                        const SizedBox(height: 10),

                        // List Tugas
                        Obx(() {
                          if (controller.taskList.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text("Belum ada tugas.", style: TextStyle(color: Colors.grey[500])),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.taskList.length,
                            itemBuilder: (context, index) {
                              var task = controller.taskList[index];
                              return _buildAdminTaskCard(context, index, task);
                            },
                          );
                        }),
                        
                        const SizedBox(height: 80), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- CARD ADMIN UPDATE ---
  Widget _buildAdminTaskCard(BuildContext context, int index, PiketTask task) {
    final controller = Get.find<PiketAdminController>();
    
    String subtitleText;
    if (task.isDone && task.executorName != null) {
      subtitleText = "Selesai oleh: ${task.executorName}";
    } else {
      subtitleText = task.location.isNotEmpty ? task.location : "Belum dikerjakan";
    }

    Color subtitleColor = task.isDone ? Colors.green[700]! : Colors.grey[600]!;

    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.blue.withOpacity(0.1))
      ),
      child: Row(
        children: [
           Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: task.isDone ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIconForTitle(task.title), 
              color: task.isDone ? Colors.green : const Color(0xFF0054DA), 
              size: 20
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () => _showTaskDialog(context, index, task),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(task.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 12, color: task.isDone ? Colors.green : Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitleText, 
                          style: TextStyle(
                            fontSize: 11, 
                            color: subtitleColor, 
                            fontWeight: FontWeight.w500
                          ), 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Badge Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task.isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              task.isDone ? "Done" : "Pending", 
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: task.isDone ? Colors.green : Colors.orange)
            ),
          ),
          
          const SizedBox(width: 8),
          
          IconButton(
            onPressed: () => _showTaskDialog(context, index, task),
            icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Hapus?",
                middleText: "Hapus ${task.title}?",
                textConfirm: "Hapus",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () => controller.deleteTask(index),
                textCancel: "Batal"
              );
            },
            icon: const Icon(Icons.delete, color: Colors.red, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showOfficerDialog(BuildContext context) {
    final controller = Get.find<PiketAdminController>();
    controller.selectedAssignees.clear();
    controller.selectedAssignees.addAll(controller.dailyOfficers);

    Get.defaultDialog(
      title: "Petugas Hari ${controller.selectedDay.value}",
      content: SizedBox(
        width: 300,
        height: 250,
        child: Column(
          children: [
            const Text("Pilih siapa saja yang piket hari ini:", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
                child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.allUsers.length,
                  itemBuilder: (context, i) {
                    var user = controller.allUsers[i];
                    String name = user.nickname ?? user.nama ?? "User";
                    return Obx(() {
                      bool isSelected = controller.selectedAssignees.contains(name);
                      return CheckboxListTile(
                        title: Text(name, style: const TextStyle(fontSize: 14)),
                        value: isSelected,
                        onChanged: (val) => controller.toggleOfficerSelection(name),
                        dense: true,
                        activeColor: const Color(0xFF0054DA),
                        secondary: CircleAvatar(
                          radius: 12,
                          backgroundImage: (user.foto != null) ? NetworkImage(user.foto!) : null,
                          child: (user.foto == null) ? const Icon(Icons.person, size: 12) : null,
                        ),
                      );
                    });
                  },
                )),
              ),
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0054DA)),
        onPressed: () {
          controller.updateDailyOfficers(List.from(controller.selectedAssignees));
        },
        child: const Text("Simpan Petugas", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
    );
  }

  void _showTaskDialog(BuildContext context, int? index, PiketTask? task) {
    final controller = Get.find<PiketAdminController>();
    final titleC = TextEditingController(text: task?.title ?? "");
    final locationC = TextEditingController(text: task?.location ?? "");
    bool isEdit = index != null;

    Get.defaultDialog(
      title: isEdit ? "Edit Tugas" : "Tambah Tugas Baru",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: titleC,
              decoration: const InputDecoration(labelText: "Judul Tugas", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationC,
              decoration: const InputDecoration(labelText: "Lokasi", border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0054DA)),
        onPressed: () {
          if (titleC.text.isNotEmpty) {
            if (isEdit) {
              controller.editTask(index, titleC.text, locationC.text);
            } else {
              controller.addTask(titleC.text, locationC.text);
            }
          }
        },
        child: Text(isEdit ? "Simpan" : "Tambah", style: const TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
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
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}