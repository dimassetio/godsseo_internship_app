import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:godsseo/app/data/models/piket_task_model.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

class PiketUserController extends GetxController {
  final List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
  
  var selectedDay = "".obs;
  var selectedDate = DateTime.now().obs;
  var taskList = <PiketTask>[].obs;
  var myDutyDays = <String>[].obs; 

  @override
  void onInit() {
    super.onInit();
    initializeDate();
    checkMySchedule(); 
    taskList.bindStream(streamTasksAndCheckHistory());
  }

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

  void changeDay(String day) {
    selectedDay.value = day;
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int targetWeekday = days.indexOf(day) + 1;
    int difference = targetWeekday - currentWeekday;
    
    selectedDate.value = now.add(Duration(days: difference));
    
    taskList.bindStream(streamTasksAndCheckHistory());
  }

  // --- STREAM + FILTERING + HISTORY ---
  Stream<List<PiketTask>> streamTasksAndCheckHistory() {
    final authC = Get.find<AuthController>();
    String myName = authC.user.nickname ?? authC.user.nama ?? "";

    return FirebaseFirestore.instance
        .collection('piket_schedule')
        .doc(selectedDay.value)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            var data = snapshot.data() as Map<String, dynamic>;
            
            // 1. Cek apakah saya Petugas Harian
            var officers = List<String>.from(data['daily_officers'] ?? []);
            bool isDailyOfficer = officers.contains(myName);

            // Jika bukan petugas hari ini, return kosong (task tidak muncul)
            if (!isDailyOfficer) {
              return <PiketTask>[]; 
            }

            var list = (data['tasks'] as List<dynamic>?) ?? [];
            var allTasks = list.map((e) => PiketTask.fromJson(e)).toList();
            String viewDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);

            return allTasks.map((task) {
              // Ambil List Pelaku pada tanggal ini
              List<String> executors = task.completionMap[viewDateStr] ?? [];
              
              // Cek Status: Apakah NAMA SAYA ada di list itu?
              task.isDone = executors.contains(myName);
              
              // Tampilkan gabungan nama pelaksana
              if (executors.isNotEmpty) {
                task.executorName = executors.join(", ");
              } else {
                task.executorName = null;
              }
              
              return task;
            }).toList();
          }
          return <PiketTask>[]; 
        });
  }

  void checkMySchedule() async {
    final authC = Get.find<AuthController>();
    String myName = authC.user.nickname ?? authC.user.nama ?? "";
    if (myName.isEmpty) return;

    List<String> foundDays = [];
    for (String day in days) {
      try {
        var doc = await FirebaseFirestore.instance.collection('piket_schedule').doc(day).get();
        if (doc.exists && doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          var officers = List<String>.from(data['daily_officers'] ?? []);
          if (officers.contains(myName)) {
            foundDays.add(day);
          }
        }
      } catch (e) {}
    }
    myDutyDays.value = foundDays;
  }

  void toggleCard(int index) {
    for (var i = 0; i < taskList.length; i++) {
      if (i != index) {
        var task = taskList[i];
        task.isOpen = false;
        taskList[i] = task;
      }
    }
    var currentTask = taskList[index];
    currentTask.isOpen = !currentTask.isOpen;
    taskList[index] = currentTask;
  }

  // --- MARK TASK (ADD/REMOVE NAMA KE LIST) ---
  Future<void> markTask(int index, bool done) async {
    final authC = Get.find<AuthController>();
    String myName = authC.user.nickname ?? authC.user.nama ?? "User";

    var task = taskList[index];
    task.isDone = done;
    task.isOpen = false;
    taskList[index] = task;

    try {
      var docRef = FirebaseFirestore.instance.collection('piket_schedule').doc(selectedDay.value);
      var doc = await docRef.get();
      if (!doc.exists) return;

      var data = doc.data() as Map<String, dynamic>;
      var masterList = (data['tasks'] as List<dynamic>?)?.map((e) => PiketTask.fromJson(e)).toList() ?? [];
      
      String todayStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);

      bool found = false;
      for (var masterTask in masterList) {
        if (masterTask.title == task.title && masterTask.location == task.location) {
          
          // Ambil list executor yg sudah ada atau buat baru
          List<String> currentExecutors = masterTask.completionMap[todayStr] ?? [];

          if (done) {
            // Tambahkan nama jika belum ada
            if (!currentExecutors.contains(myName)) {
              currentExecutors.add(myName);
            }
          } else {
            // Hapus nama saya
            currentExecutors.remove(myName);
          }

          // Update Map
          if (currentExecutors.isEmpty) {
            masterTask.completionMap.remove(todayStr); // Hapus key kalau kosong
          } else {
            masterTask.completionMap[todayStr] = currentExecutors;
          }

          found = true;
          break; 
        }
      }

      if (found) {
        List<Map<String, dynamic>> updatedTasksJson = masterList.map((e) => e.toJson()).toList();
        await docRef.update({'tasks': updatedTasksJson});
        
        if (done) {
           Get.snackbar("Selesai", "Tugas dicatat atas nama $myName", 
              snackPosition: SnackPosition.BOTTOM, 
              backgroundColor: const Color(0xFF00C853), colorText: Colors.white,
              margin: const EdgeInsets.all(10),
              duration: const Duration(seconds: 1)
            );
        }
      }

    } catch (e) {
      Get.snackbar("Error", "Gagal update status: $e");
    }
  }
}