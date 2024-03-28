import 'package:get/get.dart';

import '../controllers/users_form_controller.dart';

class UsersFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersFormController>(
      () => UsersFormController(),
    );
  }
}
