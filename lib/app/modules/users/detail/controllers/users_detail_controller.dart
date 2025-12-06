import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/data/widgets/dialog.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class UsersDetailController extends GetxController {
  UserModel? user;

  final _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(value) => _isLoading.value = value;

  Future resetPassword(context) async {
    try {
      isLoading = true;
      await showDialog(
        context: context,
        builder: (context) => GSDialog(
          title: "Kirim Email Reset Password?".tr,
          subtitle: "Kirim ke".trParams({"email": user?.email ?? ''}),
          confirmText: "Ya",
          onConfirm: () async {
            if (user?.email is String) {
              await authC.resetPassword(user!.email!);
            } else {
              Get.snackbar("Error".tr, "User tidak ditemukan".tr);
            }
            Get.back(closeOverlays: true);
          },
          negativeText: "Batal".tr,
        ),
      );
    } catch (e) {
      Get.snackbar("Error".tr, e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future disableUser(context) async {
    try {
      isLoading = true;
      await showDialog(
        context: context,
        builder: (context) => GSDialog(
          title: "Nonaktifkan User?".tr,
          subtitle:
              "User dinonaktifkan".trParams({'name': user?.nickname ?? ''}),
          confirmText: "Ya".tr,
          onConfirm: () async {
            // Nonaktifkan user
            user?.isActive = false;
            await user!.save();
            // Kalau untuk hapus sebenernya bisa,
            // tinggal ubah method di atas dengan method untuk hapus, seperti:
            // await user!.delete(user!.id!);
            Get.back(closeOverlays: true);
            Get.back();
          },
          negativeText: "Batal".tr,
        ),
      );
    } catch (e) {
      Get.snackbar("Error".tr, e.toString().tr);
    } finally {
      isLoading = false;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    user = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
