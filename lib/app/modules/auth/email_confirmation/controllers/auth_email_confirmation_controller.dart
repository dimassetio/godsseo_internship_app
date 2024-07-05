import 'dart:async';

import 'package:get/get.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:godsseo/app/routes/app_pages.dart';

class AuthEmailConfirmationController extends GetxController {
  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  var _email = "".obs;
  get email => this._email.value;
  set email(value) => this._email.value = value;

  var _password = "".obs;
  get password => this._password.value;
  set password(value) => this._password.value = value;

  getArgument() {
    if (Get.arguments is List) {
      email = Get.arguments[0];
      password = Get.arguments[1];
    }
  }

  Future signIn() async {
    try {
      isLoading = true;
      String? message = await authC.signIn(email, password);
      if (message == null) {
        Get.snackbar("Login Berhasil".tr, "Selamat datang di Godsseo-App".tr);
        Get.toNamed(Routes.HOME);
      } else {
        Get.snackbar("Error".tr, message.tr);
      }
    } catch (e) {
      Get.snackbar("Error".tr, e.toString().tr);
      print(e);
    } finally {
      isLoading = false;
    }
  }

  var _lastVerif = 0.obs;
  int get lastVerif => _lastVerif.value;
  set lastVerif(int value) => this._lastVerif.value = value;

  late Timer timer;

  setTimer() {
    lastVerif = 30;
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (lastVerif == 0) {
          timer.cancel();
        } else {
          lastVerif = lastVerif - 1;
        }
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    setTimer();
  }

  @override
  void onReady() {
    super.onReady();
    getArgument();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
