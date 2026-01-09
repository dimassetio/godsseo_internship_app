import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/location_service.dart';
import 'package:godsseo/app/data/models/dayoff_model.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/models/rules_model.dart';
import 'package:godsseo/app/data/widgets/dialog.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  Rx<DateTime> _now = DateTime.now().obs;
  DateTime get now => this._now.value;
  Rxn<Position?> position = Rxn();

  RxString address = "".obs;
  RxBool isPiketToday = false.obs;

  Rx<RulesModel> _rules = defaultRules.obs;
  RulesModel get rules => this._rules.value;

  RxList<PresensiModel> presensi = RxList();

  Rxn<PresensiModel> _todayPresensi = Rxn();
  PresensiModel? get todayPresensi => this._todayPresensi.value;

  Rxn<double?> _distance = Rxn();
  double? get distance => this._distance.value;
  set distance(double? value) => this._distance.value = value;

  var isLoading = false.obs;
  final authC = Get.find<AuthController>();

  void streamPosition() async {
    try {
      isLoading.value = true;
      var _stream = await streamPositionService();
      position.bindStream(_stream);
    } finally {
      isLoading.value = false;
    }
  }

  bool get isWeeklyOff =>
      _rules.value.weeklyOff.contains(DateTime.now().weekday);
  Rxn<DayOffModel> _dayOff = Rxn();
  DayOffModel? get todayOff =>
      _dayOff.value ??
      (isWeeklyOff
          ? DayOffModel(
              date: toStartOfDay(DateTime.now()),
              description: getDayName(DateTime.now().weekday),
            )
          : null);

  Future<DayOffModel?> getTodayOff() async {
    try {
      isLoading.value = true;
      DateTime today = toStartOfDay(DateTime.now());
      var res = await DayOffModel.collection
          .where(DayOffModel.DATE, isEqualTo: today)
          .get()
          .then(
            (value) =>
                value.docs.map((e) => DayOffModel.fromSnapshot(e)).firstOrNull,
          );
      _dayOff.value = res;
      return res;
    } finally {
      isLoading.value = false;
    }
  }

  _onPositionChanged(Position? position) async {
    if (position is Position) {
      distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        rules.coordinate.latitude,
        rules.coordinate.longitude,
      );

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          address.value = "${place.subLocality}, ${place.locality}";
        }
      } catch (e) {
        address.value = "Lokasi tidak terdeteksi";
      }
    }
  }

  void checkPiketStatus() async {
    List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    String todayName = days[DateTime.now().weekday - 1];

    String myName = authC.user.nickname ?? authC.user.nama ?? "";
    if (myName.isEmpty) return;

    try {
      var doc = await FirebaseFirestore.instance
          .collection('piket_schedule')
          .doc(todayName)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        var officers = List<String>.from(data['daily_officers'] ?? []);

        if (officers.contains(myName)) {
          isPiketToday.value = true;
        } else {
          isPiketToday.value = false;
        }
      }
    } catch (e) {
      print("Error cek piket: $e");
    }
  }

  Stream<PresensiModel> _streamTodayPresensi() {
    return PresensiModel(userId: authC.user.id!).collectionReference
        .where(PresensiModel.DATE_IN, isGreaterThanOrEqualTo: toStartOfDay(now))
        .where(PresensiModel.DATE_IN, isLessThanOrEqualTo: toEndOfDay(now))
        .limit(1)
        .snapshots()
        .map(
          (value) =>
              value.docs
                  .map((e) => PresensiModel.fromSnapshot(e))
                  .firstOrNull ??
              PresensiModel(userId: authC.user.id!),
        );
  }

  Stream<List<PresensiModel>> _streamPresensi() {
    return PresensiModel(userId: authC.user.id!).collectionReference
        .orderBy(PresensiModel.DATE_IN, descending: true)
        .limit(7)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => PresensiModel.fromSnapshot(e)).toList(),
        );
  }

  // --- PERBAIKAN DI SINI (Konversi DateTime ke TimeOfDay) ---
  String get status {
    if (todayPresensi == null) return '?';

    if (todayPresensi!.dateIn is DateTime &&
        todayPresensi!.dateOut is DateTime) {
      return 'Done';
    }

    if (todayPresensi!.dateIn == null) {
      DateTime limitTime;
      if (isPiketToday.value && rules.piketDateIn != null) {
        limitTime = rules.piketDateIn!;
      } else {
        limitTime = rules.dateIn;
      }

      // Convert DateTime ke TimeOfDay sebelum compare
      return compareTime(dateToTime(now)!, dateToTime(limitTime)!) <= 0
          ? StatusPresensi.inTime
          : StatusPresensi.late;
    } else {
      // Convert DateTime ke TimeOfDay sebelum compare
      return compareTime(dateToTime(now)!, dateToTime(rules.dateOut)!) >= 0
          ? StatusPresensi.inTime
          : StatusPresensi.earlier;
    }
  }

  Future presence(BuildContext context) async {
    try {
      if (position.value == null) {
        throw 'Gagal mendapatkan data lokasi';
      }

      if (distance is double &&
          (distance ?? 0) > rules.distanceTolerance.toDouble()) {
        throw 'Anda berada di luar jangkauan';
      }

      if (todayPresensi == null) {
        throw 'Failed to load presensi data';
      } else {
        if (todayPresensi!.dateOut is DateTime) {
          throw 'Presensi hari ini sudah dilakukan';
        }
      }

      PresensiModel model = todayPresensi!;
      String jenisPresensi = '';
      if (model.dateIn == null) {
        jenisPresensi = 'Presensi Masuk';
      } else {
        jenisPresensi = 'Presensi Keluar';
      }

      var _isLoading = false.obs;
      await showDialog(
        context: context,
        builder: (context) => GSDialog(
          title: "Konfirmasi Presensi".tr,
          subtitle: "Pesan Konfirmasi Presensi".trParams({
            'jenis': jenisPresensi,
            'waktu': dateTimeFormatter(now),
            'jarak': distance?.toInt().toString() ?? '',
            'status': status,
          }),
          negativeText: 'Batal',
          confirmText: _isLoading.value ? 'Loading..'.tr : 'Ok'.tr,
          onConfirm: _isLoading.value
              ? null
              : () async {
                  try {
                    _isLoading.value = true;
                    model.addPresenceData(
                      dateTime: now,
                      status: status,
                      coordinate: posToGeo(position.value!),
                      distance: distance!.toInt(),
                      isPiket: isPiketToday.value,
                    );
                    await model.save();
                    Get.back();
                    Get.snackbar(
                      "Berhasil".tr,
                      "Presensi berhasil disimpan".tr,
                    );
                  } finally {
                    _isLoading.value = false;
                  }
                },
        ),
      );
    } catch (e) {
      Get.snackbar("Error".tr, e.toString().tr);
    }
  }

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _now.value = DateTime.now();
    });
    getTodayOff();
    streamPosition();
    checkPiketStatus();
    ever(position, _onPositionChanged);
    _rules.bindStream(defaultRules.stream());
    _todayPresensi.bindStream(_streamTodayPresensi());
    presensi.bindStream(_streamPresensi());
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
