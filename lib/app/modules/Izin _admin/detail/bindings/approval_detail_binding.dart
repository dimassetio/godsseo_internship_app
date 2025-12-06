import 'package:get/get.dart';
import 'package:godsseo/app/modules/Izin%20_admin/detail/controller/approval_detail_controller.dart';
class ApprovalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApprovalDetailController>(
      () => ApprovalDetailController(),
    );
  }
}