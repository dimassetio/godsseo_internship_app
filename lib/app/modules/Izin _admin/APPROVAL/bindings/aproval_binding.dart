import 'package:get/get.dart';
import 'package:godsseo/app/modules/Izin%20_admin/APPROVAL/controller/aproval_controller.dart';

class ApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApprovalController>(
      () => ApprovalController(),
    );
  }
}