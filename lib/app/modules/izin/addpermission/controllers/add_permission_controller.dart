import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/models/permission_model.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPermissionController extends GetxController {
  final authC = Get.find<AuthController>();
  
  var isLoading = false.obs;
  final reasonC = TextEditingController();
  var selectedType = "Sakit".obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  
  final ImagePicker picker = ImagePicker();
  var imagePath = "".obs; 

  @override
  void onClose() {
    reasonC.dispose();
    super.onClose();
  }

  Future<void> pickImage(bool fromCamera) async {
    PermissionStatus status;

    if (fromCamera) {
      status = await Permission.camera.request();
    } else {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.photos.request();
      }
    }

    if (status.isGranted || status.isLimited || status.isDenied) {
      try {
        final XFile? image = await picker.pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50,
        );
        
        if (image != null) {
          imagePath.value = image.path;
          update();
        }
      } catch (e) {
        debugPrint("Error picking image: $e");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<bool> checkOverlap(String uid, DateTime start, DateTime end) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('permissions')
        .where('uid', isEqualTo: uid)
        .where('status', whereIn: ['Pending', 'Approved'])
        .get();

    for (var doc in querySnapshot.docs) {
      DateTime existingStart = (doc['startDate'] as Timestamp).toDate();
      DateTime existingEnd = (doc['endDate'] as Timestamp).toDate();

      if (start.isBefore(existingEnd.add(const Duration(days: 1))) && 
          end.isAfter(existingStart.subtract(const Duration(days: 1)))) {
        return true;
      }
    }
    return false;
  }

  Future<void> submitPermission() async {
    if (reasonC.text.isEmpty) {
      Get.snackbar("Error", "Alasan wajib diisi", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (endDate.value.difference(startDate.value).inDays < 0) {
      Get.snackbar("Error", "Tanggal selesai tidak valid", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (selectedType.value == "Sakit" && imagePath.value.isEmpty) {
      Get.snackbar("Error", "Wajib lampirkan bukti foto sakit", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      String uid = authC.user.uid ?? FirebaseAuth.instance.currentUser!.uid;
      
      bool isOverlapping = await checkOverlap(uid, startDate.value, endDate.value);
      if (isOverlapping) {
        Get.snackbar("Error", "Sudah ada pengajuan di tanggal ini", backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }

      String userName = authC.user.nama ?? authC.user.nickname ?? "Karyawan";
      String urlFoto = "-";

      if (imagePath.value.isNotEmpty) {
        File file = File(imagePath.value);
        String ext = imagePath.value.split('.').last;
        String storagePath = 'permissions/$uid/${DateTime.now().millisecondsSinceEpoch}.$ext';
        Reference ref = FirebaseStorage.instance.ref().child(storagePath);
        await ref.putFile(file);
        urlFoto = await ref.getDownloadURL();
      }

      PermissionModel permissionData = PermissionModel(
        uid: uid,
        name: userName,
        type: selectedType.value,
        reason: reasonC.text,
        startDate: startDate.value,
        endDate: endDate.value,
        attachmentUrl: urlFoto,
        status: "Pending",
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('permissions').add(permissionData.toJson());

      Get.back(); 
      Get.snackbar("Berhasil", "Pengajuan izin terkirim", backgroundColor: Colors.green, colorText: Colors.white);

    } catch (e) {
      Get.snackbar("Error", "Gagal: $e", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}