import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController piketTimeInC = TextEditingController(); // Controller Jam Piket
  TextEditingController timeOutC = TextEditingController();
  TextEditingController lokasiC = TextEditingController();

  Rxn<TimeOfDay> selectedTimeIn = Rxn();
  Rxn<TimeOfDay> selectedPiketTimeIn = Rxn(); // Variabel Jam Piket
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
      
      // Update Rules dari inputan UI
      // Menggunakan helper timeToDate untuk konversi TimeOfDay ke DateTime
      rules.dateIn = selectedTimeIn.value != null 
          ? timeToDate(selectedTimeIn.value!) 
          : rules.dateIn;
          
      rules.piketDateIn = selectedPiketTimeIn.value != null 
          ? timeToDate(selectedPiketTimeIn.value!) 
          : rules.piketDateIn;

      rules.dateOut = selectedTimeOut.value != null 
          ? timeToDate(selectedTimeOut.value!) 
          : rules.dateOut;
          
      // Update koordinat dari text field
      var latLong = lokasiC.text.split(',');
      if (latLong.length >= 2) {
         try {
           double lat = double.parse(latLong[0].trim());
           double lng = double.parse(latLong[1].trim());
           rules.coordinate = GeoPoint(lat, lng);
         } catch (e) {
           print("Format koordinat salah");
         }
      }

      rules.weeklyOff = selectedWeeklyOff;
      
      // Simpan menggunakan method save di model
      await rules.save();
      
      Get.snackbar("Berhasil", "Pengaturan disimpan", backgroundColor: Colors.green, colorText: Colors.white);
      
    } on Exception catch (e) {
      Get.snackbar("Error".tr, e.toString());
    } finally {
      isLoading = false;
      isEdit = false;
    }
  }

  onRulesChanged(RulesModel value) {
    // Load Jam Masuk Biasa
    selectedTimeIn.value = dateToTime(value.dateIn);
    timeInC.text = timeFormatter(value.dateIn);

    // Load Jam Masuk Piket
    if (value.piketDateIn != null) {
      selectedPiketTimeIn.value = dateToTime(value.piketDateIn!);
      piketTimeInC.text = timeFormatter(value.piketDateIn!);
    } else {
      // Default ke jam masuk biasa jika belum diset
      selectedPiketTimeIn.value = selectedTimeIn.value;
      piketTimeInC.text = timeInC.text;
    }

    // Load Jam Keluar
    selectedTimeOut.value = dateToTime(value.dateOut);
    timeOutC.text = timeFormatter(value.dateOut);
    
    // Load Lokasi
    lokasiC.text = "${value.coordinate.latitude}, ${value.coordinate.longitude}";
    
    // Load Libur Mingguan
    selectedWeeklyOff.assignAll(value.weeklyOff);
  }

  var _showPast = false.obs;
  bool get showPast => this._showPast.value;
  set showPast(value) => this._showPast.value = value;

  RxList<DayOffModel> daysoff = RxList();
  
  Stream<List<DayOffModel>> streamDaysOff(bool withPast) {
    var query = DayOffModel.collection.orderBy(DayOffModel.DATE, descending: withPast);
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
    // Bind stream dari dokumen rules
    _rules.bindStream(rules.stream());
    // Setiap ada perubahan di rules (dari stream), update UI
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
  
  // Helper: TimeOfDay -> DateTime (Hari ini + Jam Tertentu)
  DateTime timeToDate(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }
  
  // Helper: DateTime -> TimeOfDay
  TimeOfDay? dateToTime(DateTime? date) {
    if (date == null) return null;
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }
}