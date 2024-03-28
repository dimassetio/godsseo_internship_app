import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/data/widgets/dialog.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class UsersDetailController extends GetxController {
  UserModel? user;

  // Rxn<UserModel> _user = Rxn();
  // UserModel? get user => _user.value;
  // set user(UserModel? value) => _user.value = value;

  final _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(value) => _isLoading.value = value;

  Future resetPassword(context) async {
    try {
      isLoading = true;
      await showDialog(
        context: context,
        builder: (context) => GSDialog(
          title: "Kirim Email Reset Password?",
          subtitle:
              "Email berisi link untuk mereset passwrod akan dikirim ke ${user?.email}, lanjutkan?",
          confirmText: "Ya",
          onConfirm: () async {
            if (user?.email is String) {
              await authC.resetPassword(user!.email!);
            } else {
              Get.snackbar("Error", "user not detected");
            }
            Get.back(closeOverlays: true);
          },
          negativeText: "Batal",
        ),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
          title: "Nonaktifkan User?",
          subtitle: "User: ${user?.nickname} akan dinonaktifkan, lanjutkan?",
          confirmText: "Ya",
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
          negativeText: "Batal",
        ),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
