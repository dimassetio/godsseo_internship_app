import 'package:get/get.dart';
import 'package:godsseo/app/modules/izin/permission_detail/controllers/permission_details_controllers.dart';


class Permission_Details_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionDetailController>(
      () => PermissionDetailController(),
    );
  }
}