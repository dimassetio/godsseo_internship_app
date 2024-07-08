import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
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
  var _currentMonth = DateTime(DateTime.now().year, DateTime.now().month).obs;
  DateTime get currentMonth => _currentMonth.value;
  set currentMonth(DateTime value) =>
      _currentMonth.value = DateTime(value.year, value.month);

  DateTime get nextMonth =>
      DateTime(_currentMonth.value.year, _currentMonth.value.month + 1);

  RxList<UserModel> users = RxList();
  Future<List<UserModel>> getUsers() async {
    return UserModel.getCollectionReference
        .where(UserModel.ROLE, isEqualTo: Role.magang)
        .get()
        .then(
          (value) => value.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
        );
  }

  RxList<Performance> performances = RxList();

  int get countTepatWaktu => performances.sumBy((value) => value.masuk);
  int get countTerlambat => performances.sumBy((value) => value.terlambat);
  int get countAbsen => performances.sumBy((value) => value.absen);

  Future<Performance?> getPerformances(UserModel user) async {
    if (user.id == null) {
      return null;
    }

    var res = Performance(
      userId: user.id!,
      absen: DateTime.now().day -
          countSundayInMonth(DateTime.now(), useCurrentDate: true),
    );

    await PresensiModel(userId: user.id!)
        .collectionReference
        .where(PresensiModel.DATE_IN, isGreaterThan: currentMonth)
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

  @override
  void onInit() {
    super.onInit();
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
