import 'package:get/get.dart';
import 'package:godsseo/app/modules/piket_admin/controllers/piket_admin_controllers.dart';

class PiketAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PiketAdminController>(
      () => PiketAdminController(),
    );
  }
}