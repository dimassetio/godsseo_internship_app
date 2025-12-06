import 'package:get/get.dart';

import '../controllers/dayoff_controller.dart';

class DayoffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DayoffController>(
      () => DayoffController(),
    );
  }
}
