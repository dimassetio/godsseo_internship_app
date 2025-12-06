import 'package:get/get.dart';

import '../controllers/presensi_index_controller.dart';

class PresensiIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiIndexController>(
      () => PresensiIndexController(),
    );
  }
}
