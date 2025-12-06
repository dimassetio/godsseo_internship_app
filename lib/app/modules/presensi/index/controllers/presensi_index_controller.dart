import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class PresensiIndexController extends GetxController {
  UserModel get user => authC.user;
  var _currentMonth = DateTime(DateTime.now().year, DateTime.now().month).obs;
  DateTime get currentMonth => _currentMonth.value;
  set currentMonth(DateTime value) => _currentMonth.value = value;

  bool get isSameMonth =>
      currentMonth.year == DateTime.now().year &&
      currentMonth.month == DateTime.now().month;

  DateTime get nextMonth =>
      DateTime(_currentMonth.value.year, _currentMonth.value.month + 1);

  int get countTepatWaktu =>
      presensi.where((value) => value.statusIn == StatusPresensi.inTime).length;

  int get countTerlambat =>
      presensi.where((value) => value.statusIn == StatusPresensi.late).length;

  int get countAbsen =>
      (isSameMonth ? DateTime.now().day : countDaysInMonth(currentMonth)) -
      countTepatWaktu -
      countTerlambat;

  RxList<PresensiModel> presensi = RxList();

  Future pickMonth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentMonth,
        firstDate: DateTime(2024),
        lastDate: DateTime.now());
    if (pickedDate is DateTime) {
      currentMonth = DateTime(pickedDate.year, pickedDate.month);
    }
  }

  Stream<List<PresensiModel>> _streamPresensi() {
    return PresensiModel(userId: authC.user.id!)
        .collectionReference
        .where(PresensiModel.DATE_IN, isGreaterThan: currentMonth)
        .where(PresensiModel.DATE_IN, isLessThan: nextMonth)
        .orderBy(PresensiModel.DATE_IN, descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => PresensiModel.fromSnapshot(e)).toList(),
        );
  }

  @override
  void onInit() {
    super.onInit();
    presensi.bindStream(_streamPresensi());
    ever(_currentMonth, (callback) => presensi.bindStream(_streamPresensi()));
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
