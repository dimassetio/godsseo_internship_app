import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:godsseo/app/routes/app_pages.dart';


class PermissionController extends GetxController {
  final authC = Get.find<AuthController>();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMyPermissions() {
    String uid = authC.user.uid ?? FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('permissions')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  void goToAddPermission() {
    Get.toNamed(Routes.ADD_PERMISSION);
  }
}