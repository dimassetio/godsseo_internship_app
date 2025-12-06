import 'package:get/get.dart';

import '../controllers/users_detail_controller.dart';

class UsersDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersDetailController>(
      () => UsersDetailController(),
    );
  }
}
