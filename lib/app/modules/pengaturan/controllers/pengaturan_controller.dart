import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/dayoff_model.dart';
import 'package:godsseo/app/data/models/rules_model.dart';
import 'package:nb_utils/nb_utils.dart';

class PengaturanController extends GetxController {
  Rx<RulesModel> _rules = defaultRules.obs;
  RulesModel get rules => this._rules.value;
  set rules(RulesModel value) => this._rules.value = value;

  TextEditingController timeInC = TextEditingController();
  TextEditingController timeOutC = TextEditingController();
  TextEditingController lokasiC = TextEditingController();

  Rxn<TimeOfDay> selectedTimeIn = Rxn();
  Rxn<TimeOfDay> selectedTimeOut = Rxn();

  RxList<int> _selectedWeeklyOff = RxList();
  List<int> get selectedWeeklyOff => this._selectedWeeklyOff;
  set selectedWeeklyOff(value) => this._selectedWeeklyOff.value = value;

  var _isLoading = false.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  var _isEdit = false.obs;
  bool get isEdit => this._isEdit.value;
  set isEdit(value) => this._isEdit.value = value;

  Future<TimeOfDay?> pickTime(
    BuildContext context,
    TimeOfDay? initialTime,
  ) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.fromDateTime(DateTime.now()),
    );
  }

  Future saveRules() async {
    try {
      isLoading = true;
      rules.dateIn = selectedTimeIn.value ?? rules.dateIn;
      rules.dateOut = selectedTimeOut.value ?? rules.dateOut;
      rules.weeklyOff = selectedWeeklyOff;
      await rules.save();
    } on Exception catch (e) {
      Get.snackbar("Error".tr, e.toString());
    } finally {
      isLoading = false;
      isEdit = false;
    }
  }

  onRulesChanged(RulesModel value) {
    selectedTimeIn.value = value.dateIn;
    selectedTimeOut.value = value.dateOut;
    timeInC.text = timeFormatter(timeToDate(selectedTimeIn.value));
    timeOutC.text = timeFormatter(timeToDate(selectedTimeOut.value));
    lokasiC.text =
        "${value.coordinate.latitude} : ${value.coordinate.longitude}";
    selectedWeeklyOff = value.weeklyOff;
  }

  var _showPast = false.obs;
  bool get showPast => this._showPast.value;
  set showPast(value) => this._showPast.value = value;

  RxList<DayOffModel> daysoff = RxList();
  Stream<List<DayOffModel>> streamDaysOff(bool withPast) {
    var query =
        DayOffModel.collection.orderBy(DayOffModel.DATE, descending: withPast);
    if (!withPast) {
      query = query.where(
        DayOffModel.DATE,
        isGreaterThanOrEqualTo: toStartOfDay(DateTime.now()),
      );
    }
    return query.snapshots().map(
        (event) => event.docs.map((e) => DayOffModel.fromSnapshot(e)).toList());
  }

  bindDaysOff(bool value) {
    daysoff.bindStream(streamDaysOff(value));
  }

  Future deleteDayOff(DayOffModel model) async {
    try {
      isLoading = true;
      if (model.id.isEmptyOrNull) {
        Get.snackbar("Error", "Gagal mendeteksi data");
        return null;
      }
      await model.delete(model.id!);
      Get.back();
      Get.snackbar("Berhasil", "Data berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _rules.bindStream(rules.stream());
    ever(_rules, onRulesChanged);
    bindDaysOff(showPast);
    ever(_showPast, bindDaysOff);
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
