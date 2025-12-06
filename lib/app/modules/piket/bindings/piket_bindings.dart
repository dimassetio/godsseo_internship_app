import 'package:get/get.dart';
import 'package:godsseo/app/modules/piket/controllers/piket_user_controllers.dart';


class PiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PiketUserController>(
      () => PiketUserController(),
    );
  }
}