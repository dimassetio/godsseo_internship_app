import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/location_service.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/models/rules_model.dart';
import 'package:godsseo/app/data/widgets/dialog.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  Rx<DateTime> _now = DateTime.now().obs;
  DateTime get now => this._now.value;
  Rxn<Position?> position = Rxn();

  Rx<RulesModel> _rules = defaultRules.obs;
  RulesModel get rules => this._rules.value;

  RxList<PresensiModel> presensi = RxList();

  Rxn<PresensiModel> _todayPresensi = Rxn();
  PresensiModel? get todayPresensi => this._todayPresensi.value;

  Rxn<double?> _distance = Rxn();
  double? get distance => this._distance.value;
  set distance(double? value) => this._distance.value = value;

  var isLoading = false.obs;

  void streamPosition() async {
    try {
      isLoading.value = true;
      var _stream = await streamPositionService();
      position.bindStream(_stream);
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
          rules.coordinate.longitude);
    }
  }

  Stream<PresensiModel> _streamTodayPresensi() {
    return PresensiModel(userId: authC.user.id!)
        .collectionReference
        .where(PresensiModel.DATE_IN, isGreaterThanOrEqualTo: toStartOfDay(now))
        .where(PresensiModel.DATE_IN, isLessThanOrEqualTo: toEndOfDay(now))
        .limit(1)
        .snapshots()
        .map((value) =>
            value.docs.map((e) => PresensiModel.fromSnapshot(e)).firstOrNull ??
            PresensiModel(userId: authC.user.id!));
  }

  Stream<List<PresensiModel>> _streamPresensi() {
    return PresensiModel(userId: authC.user.id!)
        .collectionReference
        .orderBy(PresensiModel.DATE_IN, descending: true)
        .limit(7)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => PresensiModel.fromSnapshot(e)).toList(),
        );
  }

  String get status => todayPresensi == null
      ? '?'
      : todayPresensi!.dateIn is DateTime && todayPresensi!.dateOut is DateTime
          ? 'Done'
          : todayPresensi!.dateIn == null
              ? compareTime(dateToTime(now)!, rules.dateIn) <= 0
                  ? StatusPresensi.inTime
                  : StatusPresensi.late
              : compareTime(dateToTime(now)!, rules.dateOut) >= 0
                  ? StatusPresensi.inTime
                  : StatusPresensi.earlier;

  Future presence(BuildContext context) async {
    try {
      // Validasi Rules
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

      // Tentukan jenis presensi
      PresensiModel model = todayPresensi!;
      String jenisPresensi = '';
      if (model.dateIn == null) {
        jenisPresensi = 'Presensi Masuk';
      } else {
        jenisPresensi = 'Presensi Keluar';
      }

      // Tampilkan dialog konfirmasi
      var _isLoading = false.obs;
      await showDialog(
        context: context,
        builder: (context) => GSDialog(
          title: "Konfirmasi Presensi",
          subtitle:
              "Anda akan melakukan $jenisPresensi pada ${dateTimeFormatter(now)} dengan jarak ${distance?.toInt()}M dari kantor. Status anda $status",
          negativeText: 'Batal',
          confirmText: _isLoading.value ? 'Loading..' : 'Ok',
          onConfirm: _isLoading.value
              ? null
              : () async {
                  try {
                    // Simpan data presensi
                    _isLoading.value = true;
                    model.addPresenceData(
                      dateTime: now,
                      status: status,
                      coordinate: posToGeo(position.value!),
                      distance: distance!.toInt(),
                    );
                    await model.save();
                    Get.back();
                    Get.snackbar("Success", "Presensi berhasil disimpan");
                  } finally {
                    _isLoading.value = false;
                  }
                },
        ),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _now.value = DateTime.now();
    });
    streamPosition();
    ever(
      position,
      _onPositionChanged,
    );
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
