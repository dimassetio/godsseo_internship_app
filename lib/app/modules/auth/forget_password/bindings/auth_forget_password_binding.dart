import 'package:get/get.dart';

import '../controllers/auth_forget_password_controller.dart';

class AuthForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthForgetPasswordController>(
      () => AuthForgetPasswordController(),
    );
  }
}
