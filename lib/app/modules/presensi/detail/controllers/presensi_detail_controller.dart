import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/models/rules_model.dart';
import 'package:intl/intl.dart';

class PresensiDetailController extends GetxController {
  // Data Presensi dari arguments
  Rxn<PresensiModel> presensi = Rxn(); 
  // Rules (diperlukan untuk jam batas)
  Rxn<RulesModel> rules = Rxn(); 

  @override
  void onInit() {
    super.onInit();
    
    // 1. Ambil data presensi dari arguments
    if (Get.arguments is PresensiModel) {
      presensi.value = Get.arguments;
    }
    
    // 2. Ambil rules terbaru untuk perhitungan waktu
    FirebaseFirestore.instance.collection('rules').doc('default').snapshots().listen((snap) {
      if (snap.exists) {
        rules.value = RulesModel.fromSnapshot(snap);
      }
    });
  }

  // --- HELPER UNTUK VIEW (MENAMPILKAN WAKTU BATAS YANG BERLAKU) ---

  // Getter untuk mendapatkan jam batas yang berlaku (sudah dalam format HH:mm)
  String get applicableLimitTime {
    final rulesData = rules.value;

    // Safety check rules:
    if (rulesData == null) return "--:--"; 

    // Tentukan jam batas: Jika Piket pakai piketDateIn, jika tidak pakai dateIn biasa
    DateTime limitTime;
    
    if (presensi.value?.isPiket == true && rulesData.piketDateIn != null) {
      limitTime = rulesData.piketDateIn!;
    } else {
      limitTime = rulesData.dateIn;
    }

    // Kembalikan dalam format jam HH:mm
    return DateFormat('HH:mm').format(limitTime);
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