import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/dayoff_model.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/models/rules_model.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:nb_utils/nb_utils.dart';

class Performance {
  String userId;
  int masuk;
  int terlambat;
  int absen;

  Performance({
    required this.userId,
    this.masuk = 0,
    this.terlambat = 0,
    this.absen = 0,
  });
}

class PresensiAdminController extends GetxController {
  Rx<DateTime> _currentMonth =
      DateTime(DateTime.now().year, DateTime.now().month).obs;
  DateTime get currentMonth => _currentMonth.value;
  set currentMonth(DateTime value) =>
      _currentMonth.value = DateTime(value.year, value.month);

  RxList<UserModel> users = RxList();
  Future<List<UserModel>> getUsers() async {
    return UserModel.getCollectionReference
        .where(UserModel.ROLE, isEqualTo: Role.magang)
        .where(UserModel.IS_ACTIVE, isEqualTo: true)
        .get()
        .then(
          (value) => value.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
        );
  }

  Rx<int> _daysOff = 0.obs;
  int get daysOff => this._daysOff.value;
  set daysOff(int value) => this._daysOff.value = value;

  Future getDaysOff(DateTime date) async {
    bool useCurrentDate =
        date.year == DateTime.now().year && date.month == DateTime.now().month;

    int countDaysOff = await DayOffModel.collection
        .where(
          DayOffModel.DATE,
          isGreaterThanOrEqualTo: DateTime(date.year, date.month),
        )
        .where(
          DayOffModel.DATE,
          isLessThanOrEqualTo: useCurrentDate
              ? DateTime.now()
              : getNextMonth(date).add(Duration(days: -1)),
        )
        .get()
        .then((value) => value.docs.length);

    RulesModel rules = await defaultRules.getById() ?? defaultRules;
    int days = useCurrentDate ? DateTime.now().day : countDaysInMonth(date);
    int countWeeklyOff = 0;
    for (int day = 1; day <= days; day++) {
      DateTime newdate = DateTime(date.year, date.month, day);
      if (rules.weeklyOff.contains(newdate.weekday)) {
        countWeeklyOff++;
      }
    }

    daysOff = countDaysOff + countWeeklyOff;
  }

  RxList<Performance> performances = RxList();

  int get countTepatWaktu => performances.sumBy((value) => value.masuk);
  int get countTerlambat => performances.sumBy((value) => value.terlambat);
  int get countAbsen => performances.sumBy((value) => value.absen);

  Future<Performance?> getPerformances(UserModel user, DateTime month) async {
    if (user.id == null) {
      return null;
    }

    bool isSameMonth = month.year == DateTime.now().year &&
        month.month == DateTime.now().month;

    int activeDays =
        (isSameMonth ? DateTime.now().day : countDaysInMonth(month)) - daysOff;

    var res = Performance(userId: user.id!, absen: activeDays);
    var nextMonth = getNextMonth(month);
    await PresensiModel(userId: user.id!)
        .collectionReference
        .where(PresensiModel.DATE_IN, isGreaterThan: month)
        .where(PresensiModel.DATE_IN, isLessThan: nextMonth)
        .orderBy(PresensiModel.DATE_IN, descending: true)
        .get()
        .then((values) {
      for (var value in values.docs) {
        var presensi = PresensiModel.fromSnapshot(value);
        if (presensi.statusIn == StatusPresensi.inTime) {
          res.masuk++;
          res.absen--;
        } else if (presensi.statusIn == StatusPresensi.late) {
          res.terlambat++;
          res.absen--;
        }
      }
    });

    performances.removeWhere((element) => element.userId == user.id);
    performances.add(res);

    return res;
  }

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

  @override
  void onInit() {
    super.onInit();
    getDaysOff(currentMonth);
    ever(_currentMonth, (callback) => getDaysOff(callback));
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
