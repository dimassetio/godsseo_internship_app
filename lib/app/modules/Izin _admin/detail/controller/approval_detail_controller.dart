import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class ApprovalDetailController extends GetxController {
  final authC = Get.find<AuthController>();

  Future<void> updateStatus(String docId, String status) async {
    try {
      String adminName = authC.user.nickname ?? authC.user.nama ?? "Admin";

      await FirebaseFirestore.instance.collection('permissions').doc(docId).update({
        'status': status,
        'processedBy': adminName,
        'processedAt': DateTime.now(),
      });

      // Opsional: Kembali ke halaman list setelah update
      // Get.back(); 
      
      Get.snackbar(
        "Sukses", 
        "Pengajuan berhasil diubah menjadi $status",
        backgroundColor: status == "Approved" ? Colors.green : Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
      
      // Update UI lokal jika perlu (biasanya otomatis kalau pakai Stream di halaman list)
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Gagal update status: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}