import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class ApprovalController extends GetxController {
  Stream<QuerySnapshot<Map<String, dynamic>>> streamPermissions() {
    return FirebaseFirestore.instance
        .collection('permissions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateStatus(String docId, String status) async {
    // Ambil data admin yang sedang login
    final authC = Get.find<AuthController>();
    String adminName = authC.user.nickname ?? authC.user.nama ?? "Admin";

    try {
      await FirebaseFirestore.instance.collection('permissions').doc(docId).update({
        'status': status,
        // --- AUDIT TRAIL ---
        'processedBy': adminName, // Nama Admin
        'processedAt': DateTime.now(), // Waktu Eksekusi
      });
      
      Get.snackbar(
        "Sukses", 
        "Status berhasil diubah menjadi $status",
        backgroundColor: status == "Approved" ? Colors.green : Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Gagal update status: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}