import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:godsseo/app/data/models/piket_task_model.dart';
import 'package:godsseo/app/data/models/user_model.dart';

class PiketAdminController extends GetxController {
  final List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
  
  var selectedDay = "".obs;
  var selectedDate = DateTime.now().obs;
  var taskList = <PiketTask>[].obs;
  
  // Data Petugas Harian (Global per hari)
  var dailyOfficers = <String>[].obs; 
  
  // Data User untuk Pilihan (HANYA MAGANG)
  var allUsers = <UserModel>[].obs;
  
  // Temp variable untuk checkbox di dialog
  var selectedAssignees = <String>[].obs; 
  
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initializeDate();
    fetchUsers();
    _refreshStreams();
  }

  // --- AMBIL DATA USER (FILTER MAGANG) ---
  void fetchUsers() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('users').get();
      var allData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();

      // Filter manual di aplikasi
      allUsers.value = allData.where((user) {
        // Sesuaikan dengan data di database kamu (misal 'Magang' atau 'magang')
        bool isMagang = user.role == 'Magang'; 
        bool isActive = user.isActive ?? true; 
        return isMagang && isActive;
      }).toList();

    } catch (e) {
      print("Error fetch users: $e");
    }
  }

  // --- LOGIC TANGGAL ---
  void initializeDate() {
    var now = DateTime.now();
    _updateDayAndDate(now);
  }

  void _updateDayAndDate(DateTime date) {
    String engDay = DateFormat('EEEE').format(date);
    Map<String, String> dayMap = {
      'Monday': 'Senin', 'Tuesday': 'Selasa', 'Wednesday': 'Rabu',
      'Thursday': 'Kamis', 'Friday': 'Jumat', 'Saturday': 'Sabtu', 'Sunday': 'Minggu'
    };
    selectedDay.value = dayMap[engDay] ?? "Senin";
    selectedDate.value = date;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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
      _updateDayAndDate(picked);
      _refreshStreams();
    }
  }

  void changeDay(String day) {
    selectedDay.value = day;
    int currentWeekday = selectedDate.value.weekday;
    int targetWeekday = days.indexOf(day) + 1;
    int difference = targetWeekday - currentWeekday;
    selectedDate.value = selectedDate.value.add(Duration(days: difference));
    _refreshStreams();
  }

  void _refreshStreams() {
    taskList.bindStream(streamTasks());
    dailyOfficers.bindStream(streamOfficers());
  }

  // --- STREAM TASKS (BACA MAP TANGGAL & LIST NAMA) ---
  Stream<List<PiketTask>> streamTasks() {
    return FirebaseFirestore.instance
        .collection('piket_schedule')
        .doc(selectedDay.value)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            var data = snapshot.data() as Map<String, dynamic>;
            var list = (data['tasks'] as List<dynamic>?) ?? [];
            
            // Format tanggal yang sedang dilihat
            String selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);

            return list.map((e) {
              var task = PiketTask.fromJson(e);
              
              // Ambil List Nama Pelaku di tanggal ini
              List<String> executors = task.completionMap[selectedDateStr] ?? [];

              if (executors.isNotEmpty) {
                task.isDone = true;
                // Gabungkan nama jadi string: "Budi, Andi"
                task.executorName = executors.join(", "); 
              } else {
                task.isDone = false;
                task.executorName = null;
              }
              return task;
            }).toList();
          }
          return <PiketTask>[]; 
        });
  }

  // --- STREAM OFFICERS ---
  Stream<List<String>> streamOfficers() {
    return FirebaseFirestore.instance
        .collection('piket_schedule')
        .doc(selectedDay.value)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            var data = snapshot.data() as Map<String, dynamic>;
            return List<String>.from(data['daily_officers'] ?? []);
          }
          return <String>[]; 
        });
  }

  Future<void> updateDailyOfficers(List<String> newOfficers) async {
    try {
      await FirebaseFirestore.instance
          .collection('piket_schedule')
          .doc(selectedDay.value)
          .set({
            'daily_officers': newOfficers
          }, SetOptions(merge: true));
      
      Get.back();
      Get.snackbar("Sukses", "Petugas piket hari ${selectedDay.value} diperbarui", 
        backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal update petugas");
    }
  }

  Future<void> _syncToFirestore() async {
    try {
      List<Map<String, dynamic>> updatedTasks = taskList.map((e) => e.toJson()).toList();
      await FirebaseFirestore.instance
          .collection('piket_schedule')
          .doc(selectedDay.value)
          .set({'tasks': updatedTasks}, SetOptions(merge: true));
    } catch (e) {
      Get.snackbar("Error", "Gagal sinkronisasi data");
    }
  }

  // --- CRUD TASKS ---
  Future<void> addTask(String title, String location) async {
    // Tambah task baru (assignees kosong karena pakai daily_officers)
    taskList.add(PiketTask(
      title: title, location: location
    ));
    await _syncToFirestore();
    Get.back(); 
    Get.snackbar("Sukses", "Tugas ditambahkan", backgroundColor: Colors.green, colorText: Colors.white);
  }

  Future<void> editTask(int index, String title, String location) async {
    var task = taskList[index];
    task.title = title;
    task.location = location;
    // completionMap dibiarkan utuh agar history aman
    taskList[index] = task;
    await _syncToFirestore();
    Get.back();
    Get.snackbar("Sukses", "Tugas diperbarui", backgroundColor: Colors.blue, colorText: Colors.white);
  }

  Future<void> deleteTask(int index) async {
    taskList.removeAt(index);
    await _syncToFirestore();
    Get.back();
    Get.snackbar("Dihapus", "Tugas telah dihapus", backgroundColor: Colors.red, colorText: Colors.white);
  }

  void toggleOfficerSelection(String nickname) {
    if (selectedAssignees.contains(nickname)) {
      selectedAssignees.remove(nickname);
    } else {
      selectedAssignees.add(nickname);
    }
  }

  double get progressValue {
    if (taskList.isEmpty) return 0.0;
    int doneCount = taskList.where((e) => e.isDone).length;
    return doneCount / taskList.length;
  }

  String get progressPercentage {
    if (taskList.isEmpty) return "0%";
    return "${(progressValue * 100).toInt()}%";
  }
}