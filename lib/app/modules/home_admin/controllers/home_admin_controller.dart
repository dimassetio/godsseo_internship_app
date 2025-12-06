import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';

class HomeAdminController extends GetxController {
  RxList<PresensiModel> presensi = RxList();
  RxList<PresensiModel> weeklyPresensiData = RxList();

  var pendingPermissionCount = 0.obs;
  var isLoading = false.obs;

  // --- DATA CHART ---
  RxList<int> weeklyOnTimeCounts = <int>[0, 0, 0, 0, 0, 0, 0].obs;
  RxList<int> weeklyLateCounts = <int>[0, 0, 0, 0, 0, 0, 0].obs;
  RxList<int> weeklyIzinCounts = <int>[0, 0, 0, 0, 0, 0, 0].obs;

  RxInt maxY = 10.obs;
  RxString activeFilter = 'All'.obs;
  RxString touchedCategory = 'None'.obs; // Kategori yang sedang disentuh

  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    presensi.bindStream(_streamPresensiHariIni());
    weeklyPresensiData.bindStream(_streamPresensiMingguan());

    weeklyPresensiData.listen((_) {
      calculateWeeklyStats();
    });

    getUserMagang();
    streamPendingPermissions();
  }

  // --- INTERAKSI CHART (LOGIKA BARU) ---
  
  // Dipanggil saat TAP (Sekali tekan)
  void onChartTap(double dx, double dy, double width, double height) {
    _handleChartTouch(dx, dy, width, height, isToggle: true);
  }

  // Dipanggil saat DRAG (Geser jari)
  void onChartDrag(double dx, double dy, double width, double height) {
    _handleChartTouch(dx, dy, width, height, isToggle: false);
  }

  void _handleChartTouch(double dx, double dy, double width, double height, {required bool isToggle}) {
    // Hanya aktif kalau filter 'All'
    if (activeFilter.value != 'All') return;

    double leftPadding = 40.0;
    double bottomPadding = 20.0;
    double chartWidth = width - leftPadding;
    double chartHeight = height - bottomPadding;

    // Abaikan kalau sentuh area angka di kiri
    if (dx < leftPadding) return;

    double stepX = chartWidth / 6;
    double relativeX = dx - leftPadding;
    int index = (relativeX / stepX).round().clamp(0, 6);

    // Ambil data pada hari (index) tersebut
    double valOnTime = weeklyOnTimeCounts[index].toDouble();
    double valLate = weeklyLateCounts[index].toDouble();
    double valIzin = weeklyIzinCounts[index].toDouble();

    // Hitung posisi Y di layar
    double yOnTime = chartHeight - (valOnTime / maxY.value * chartHeight);
    double yLate = chartHeight - (valLate / maxY.value * chartHeight);
    double yIzin = chartHeight - (valIzin / maxY.value * chartHeight);

    // Hitung jarak jari ke masing-masing garis
    double distOnTime = (dy - yOnTime).abs();
    double distLate = (dy - yLate).abs();
    double distIzin = (dy - yIzin).abs();

    // Cari yang paling dekat (Tanpa batas toleransi, biar gampang kena)
    String closest = 'On Time';
    double minDistance = distOnTime;

    if (distLate < minDistance) {
      minDistance = distLate;
      closest = 'Late';
    }
    if (distIzin < minDistance) {
      closest = 'Izin';
    }

    // Update State
    if (isToggle) {
      // Kalau Tap: Bisa nyala/mati (Toggle)
      if (touchedCategory.value == closest) {
        touchedCategory.value = 'None';
      } else {
        touchedCategory.value = closest;
      }
    } else {
      // Kalau Drag: Langsung ganti (Pasti nyala)
      touchedCategory.value = closest;
    }
  }

  // --- FUNGSI LAINNYA ---

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0054DA),
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF0054DA)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      weeklyPresensiData.bindStream(_streamPresensiMingguan());
    }
  }

  void changeFilter(String filter) {
    activeFilter.value = filter;
    if (filter != 'All') {
      touchedCategory.value = filter;
    } else {
      touchedCategory.value = 'None';
    }
    update();
  }

  Color get activeColor {
    switch (activeFilter.value) {
      case 'On Time': return Colors.green;
      case 'Late': return Colors.red;
      case 'Izin': return Colors.orange;
      default: return const Color(0xFF0054DA);
    }
  }

  void calculateWeeklyStats() {
    List<int> onTime = [0, 0, 0, 0, 0, 0, 0];
    List<int> late = [0, 0, 0, 0, 0, 0, 0];
    List<int> izin = [0, 0, 0, 0, 0, 0, 0];

    for (var item in weeklyPresensiData) {
      if (item.dateIn != null) {
        int weekday = item.dateIn!.weekday;
        int index = weekday - 1;
        if (index >= 0 && index < 7) {
          if (item.statusIn == StatusPresensi.inTime) {
            onTime[index]++;
          } else if (item.statusIn == StatusPresensi.late) {
            late[index]++;
          } else {
            izin[index]++;
          }
        }
      }
    }

    weeklyOnTimeCounts.value = onTime;
    weeklyLateCounts.value = late;
    weeklyIzinCounts.value = izin;

    int maxOnTime = onTime.reduce((a, b) => a > b ? a : b);
    int maxLate = late.reduce((a, b) => a > b ? a : b);
    int maxIzin = izin.reduce((a, b) => a > b ? a : b);
    int grandMax = [maxOnTime, maxLate, maxIzin].reduce((a, b) => a > b ? a : b);
    maxY.value = (grandMax + 2).clamp(5, 100);
  }

  Stream<List<PresensiModel>> _streamPresensiHariIni() {
    return PresensiModel.collectionGroup
        .where(PresensiModel.DATE_IN, isGreaterThanOrEqualTo: toStartOfDay(DateTime.now()))
        .where(PresensiModel.DATE_IN, isLessThan: toEndOfDay(DateTime.now()))
        .orderBy(PresensiModel.DATE_IN, descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => PresensiModel.fromSnapshot(e)).toList());
  }

  Stream<List<PresensiModel>> _streamPresensiMingguan() {
    DateTime baseDate = selectedDate.value;
    DateTime startOfWeek = baseDate.subtract(Duration(days: baseDate.weekday - 1));
    startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));
    endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);

    return PresensiModel.collectionGroup
        .where(PresensiModel.DATE_IN, isGreaterThanOrEqualTo: startOfWeek)
        .where(PresensiModel.DATE_IN, isLessThanOrEqualTo: endOfWeek)
        .orderBy(PresensiModel.DATE_IN, descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => PresensiModel.fromSnapshot(e)).toList());
  }

  int get countMasuk => presensi.where((value) => value.statusIn == StatusPresensi.inTime).length;
  int get countTerlambat => presensi.where((value) => value.statusIn == StatusPresensi.late).length;
  int userMagang = 0;
  int get countBelum => userMagang - presensi.length;

  Future<int> getUserMagang() async {
    return 0;
  }

  void streamPendingPermissions() {
    FirebaseFirestore.instance
        .collection('permissions')
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .listen((event) {
      pendingPermissionCount.value = event.docs.length;
    });
  }
}