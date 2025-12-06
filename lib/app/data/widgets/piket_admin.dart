// --- CARD UNTUK ADMIN ---
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:godsseo/app/data/models/piket_task_model.dart';
import 'package:godsseo/app/modules/piket_admin/controllers/piket_admin_controllers.dart';

Widget(BuildContext context, int index, PiketTask task) {
    // FIX: Panggil controller secara eksplisit biar tidak error "Undefined"
    final controller = Get.find<PiketAdminController>(); 

    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 16),
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
            width: 45, height: 45,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForTitle(task.title), 
              color: const Color(0xFF0054DA), 
              size: 24
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
                  Text(task.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(task.location, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
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
              task.isDone ? "Selesai" : "Belum", 
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: task.isDone ? Colors.green : Colors.orange)
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Tombol Edit
          IconButton(
            onPressed: () => _showTaskDialog(context, index, task),
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            tooltip: "Edit Tugas",
          ),
          
          // Tombol Hapus
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Hapus Tugas?",
                middleText: "Yakin ingin menghapus ${task.title}?",
                textConfirm: "Hapus",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () => controller.deleteTask(index), // Controller aman dipanggil
                textCancel: "Batal"
              );
            },
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            tooltip: "Hapus Tugas",
          ),
        ],
      ),
    );
  }

  // --- DIALOG ADD/EDIT ---
  void _showTaskDialog(BuildContext context, int? index, PiketTask? task) {
    // FIX: Panggil controller secara eksplisit di sini juga
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
              decoration: const InputDecoration(labelText: "Judul (Misal: Sapu Teras)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationC,
              decoration: const InputDecoration(labelText: "Lokasi (Misal: Lantai 1)", border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0054DA)),
        onPressed: () {
          if (titleC.text.isNotEmpty && locationC.text.isNotEmpty) {
            if (isEdit) {
              controller.editTask(index, titleC.text, locationC.text);
            } else {
              controller.addTask(titleC.text, locationC.text);
            }
          }
        },
        child: Text(isEdit ? "Simpan" : "Tambah", style: const TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Batal", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  // --- HELPER ICON ---
  IconData _getIconForTitle(String title) {
    if (title.toLowerCase().contains("sapu")) return Icons.cleaning_services;
    if (title.toLowerCase().contains("pel")) return Icons.water_drop;
    if (title.toLowerCase().contains("cuci")) return Icons.soap;
    if (title.toLowerCase().contains("sampah")) return Icons.delete;
    return Icons.work;
  }