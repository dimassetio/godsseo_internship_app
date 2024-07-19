import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/dayoff_model.dart';

class DayoffController extends GetxController {
  var _isLoading = false.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController tanggalC = TextEditingController();
  TextEditingController deskripsiC = TextEditingController();

  Rxn<DateTime> _selectedTanggal = Rxn();
  DateTime? get selectedTanggal => _selectedTanggal.value;
  set selectedTanggal(DateTime? value) => _selectedTanggal.value = value;

  Rxn<DayOffModel> _dayOff = Rxn();
  DayOffModel? get dayOff => _dayOff.value;
  set dayOff(DayOffModel? value) => _dayOff.value = value;

  Future pickDate(BuildContext context) async {
    DateTime? res = await showDatePicker(
        context: context,
        initialDate: selectedTanggal ?? DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(DateTime.now().year + 10));
    if (res is DateTime) {
      selectedTanggal = res;
      tanggalC.text = dateFormatter(res, withDays: true);
    }
  }

  Future save() async {
    try {
      isLoading = true;
      DayOffModel model = DayOffModel(
        id: dayOff?.id,
        date: selectedTanggal!,
        description: deskripsiC.text,
      );
      await model.save();
      Get.back();
      Get.snackbar("Berhasil", "Data berhasil disimpan");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
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
