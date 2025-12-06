import 'package:get/get.dart';
import 'package:godsseo/app/modules/izin/permission/controller/permission_controller.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionController>(
      () => PermissionController(),
    );
  }
}