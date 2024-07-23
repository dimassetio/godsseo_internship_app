import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/models/user_model.dart';

class HomeAdminController extends GetxController {
  //TODO: Implement HomeAdminController
  RxList<PresensiModel> presensi = RxList();

  Stream<List<PresensiModel>> _streamPresensi() {
    return PresensiModel.collectionGroup
        .where(PresensiModel.DATE_IN,
            isGreaterThanOrEqualTo: toStartOfDay(DateTime.now()))
        .where(PresensiModel.DATE_IN, isLessThan: toEndOfDay(DateTime.now()))
        .orderBy(PresensiModel.DATE_IN, descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => PresensiModel.fromSnapshot(e)).toList(),
        );
  }

  int get countMasuk =>
      presensi.where((value) => value.statusIn == StatusPresensi.inTime).length;

  int get countTerlambat =>
      presensi.where((value) => value.statusIn == StatusPresensi.late).length;

  int userMagang = 0;

  int get countBelum => userMagang - presensi.length;

  var _isLoading = false.obs;
  get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  Future<int> getUserMagang() async {
    int maxRetries = 5;
    int retryCount = 0;
    int delay = 1000;

    while (retryCount < maxRetries) {
      try {
        isLoading = true;
        var query = UserModel.getCollectionReference
            .where(UserModel.ROLE, isEqualTo: Role.magang)
            .where(UserModel.IS_ACTIVE, isEqualTo: true)
            .count();

        var querySnapshot = await query.get();
        userMagang = querySnapshot.count ?? 0;
        return userMagang;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          print('Failed after $retryCount attempts: $e');
          rethrow; // Re-throw the exception after max retries
        }
        await Future.delayed(Duration(milliseconds: delay * retryCount));
      } finally {
        isLoading = false;
      }
    }
    return 0;
  }

  @override
  void onInit() {
    super.onInit();
    presensi.bindStream(_streamPresensi());
    getUserMagang();
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
