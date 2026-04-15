import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class Fcm extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Fcm> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    try {
      String? token = await _messaging.getToken();
      debugPrint("🔥" * 20);
      debugPrint("FCM TOKEN EMULATOR LU: $token");
      debugPrint("🔥" * 20);
    } catch (e) {
      debugPrint("❌ Gagal dapet token: $e");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
          snackPosition: SnackPosition.TOP,
        );
      }
    });

    return this;
  }

  Future<void> subscribeToSchedules() async {
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isLoggedIn) return;

      await _messaging.subscribeToTopic('absen_global');

      final userId = authController.user.id;
      final piketDocs = await _firestore
          .collection('piket')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in piketDocs.docs) {
        final data = doc.data();
        if (data.containsKey('hari')) {
          await _messaging.subscribeToTopic('piket_${data['hari']}');
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
