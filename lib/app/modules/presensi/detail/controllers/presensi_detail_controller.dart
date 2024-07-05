import 'package:get/get.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';

class PresensiDetailController extends GetxController {
  PresensiModel? presensi;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is PresensiModel) {
      presensi = Get.arguments;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
