import 'package:get/get.dart';

import '../controllers/auth_email_confirmation_controller.dart';

class AuthEmailConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthEmailConfirmationController>(
      () => AuthEmailConfirmationController(),
    );
  }
}
