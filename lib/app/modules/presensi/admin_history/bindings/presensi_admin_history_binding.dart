import 'package:get/get.dart';

import '../controllers/presensi_admin_history_controller.dart';

class PresensiAdminHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiAdminHistoryController>(
      () => PresensiAdminHistoryController(),
    );
  }
}
