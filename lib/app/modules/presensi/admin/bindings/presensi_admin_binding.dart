import 'package:get/get.dart';

import '../controllers/presensi_admin_controller.dart';

class PresensiAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiAdminController>(
      () => PresensiAdminController(),
    );
  }
}
