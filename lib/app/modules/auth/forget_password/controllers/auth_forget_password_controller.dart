import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthForgetPasswordController extends GetxController {
  //TODO: Implement AuthForgetPasswordController
  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  TextEditingController emailC = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  Future<bool> resetPassword() async {
    try {
      isLoading = true;
      var res = await authC.resetPassword(emailC.text);
      if (res.isEmptyOrNull) {
        return true;
      } else {
        Get.snackbar("Error", "$res");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

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
}
