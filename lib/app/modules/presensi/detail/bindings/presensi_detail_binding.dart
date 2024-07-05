import 'package:get/get.dart';

import '../controllers/presensi_detail_controller.dart';

class PresensiDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiDetailController>(
      () => PresensiDetailController(),
    );
  }
}
