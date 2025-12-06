import 'package:get/get.dart';
import 'package:godsseo/app/modules/izin/addpermission/controllers/add_permission_controller.dart';

class AddPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPermissionController>(
      () => AddPermissionController(),
    );
  }
}