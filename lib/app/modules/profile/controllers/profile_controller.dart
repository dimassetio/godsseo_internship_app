import 'dart:io';

import 'package:get/get.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  var selectedPhotoPath = ''.obs;

  final _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(value) => _isLoading.value = value;

  Future save() async {
    try {
      isLoading = true;
      UserModel user = authC.user;

      File? fileFoto = selectedPhotoPath.value.isEmptyOrNull
          ? null
          : File(selectedPhotoPath.value);

      await user.save(file: fileFoto);
      Get.snackbar("Berhasil".tr, "Foto profil berhasil diperbarui".tr);
    } catch (e) {
      printError(info: e.toString());
      Get.snackbar("Error".tr, e.toString());
    } finally {
      isLoading = false;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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
