import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/izin/permission/controller/permission_controller.dart';
import 'package:godsseo/app/routes/app_pages.dart'; // Pastikan ini diimport untuk Routes
import 'package:intl/intl.dart';

class PermissionView extends GetView<PermissionController> {
  const PermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Izin & Cuti", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamMyPermissions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          var rawDocs = snapshot.data?.docs ?? [];
          var docs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(rawDocs);

          docs.sort((a, b) {
            DateTime dateA = (a.data()['createdAt'] as Timestamp).toDate();
            DateTime dateB = (b.data()['createdAt'] as Timestamp).toDate();
            return dateB.compareTo(dateA);
          });
          
          int totalIzin = docs.where((d) => d['type'] == 'Izin').length;
          int totalSakit = docs.where((d) => d['type'] == 'Sakit').length;
          int totalPending = docs.where((d) => d['status'] == 'Pending').length;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard("Jumlah Izin", totalIzin, const Color(0xFFEBF4FF), Colors.blue)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard("Jumlah Sakit", totalSakit, const Color(0xFFEBF4FF), Colors.blue)),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.history, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        const Text("Riwayat Pengajuan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (totalPending > 0)
                      Text("$totalPending Pending", style: TextStyle(color: Colors.orange[700], fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              Expanded(
                child: docs.isEmpty 
                ? Center(child: Text("Belum ada riwayat", style: TextStyle(color: Colors.grey[400])))
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // Pass ID dokumen agar bisa dipakai di detail
                    return _buildHistoryCard(docs[index].id, docs[index].data());
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton.icon(
          onPressed: () => controller.goToAddPermission(), 
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Tambah Izin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF408BF9),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color bgColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: accentColor),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // UPDATE: Terima parameter docId
  Widget _buildHistoryCard(String docId, Map<String, dynamic> data) {
    String status = data['status'] ?? 'Pending';
    bool isApproved = status == 'Approved';
    bool isRejected = status == 'Rejected';
    
    Color statusBg = isApproved ? const Color(0xFFE6F6EC) : (isRejected ? const Color(0xFFFFEBEB) : const Color(0xFFFFF8C5));
    Color statusText = isApproved ? const Color(0xFF27A459) : (isRejected ? Colors.red : const Color(0xFFCFA006));
    
    String statusLabel = isApproved ? "Approved" : (isRejected ? "Rejected" : "Pending");

    DateTime start = (data['startDate'] as Timestamp).toDate();
    DateTime end = (data['endDate'] as Timestamp).toDate();
    String dateStr = DateFormat('d MMM yyyy').format(start);
    if (start.day != end.day) {
      dateStr += " - ${DateFormat('d MMM').format(end)}";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // NAVIGASI KE DETAIL DENGAN ARGUMENTS
            Get.toNamed(Routes.PERMISSION_DETAIL, arguments: {
              'id': docId, 
              'data': data
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                  child: Icon(data['type'] == "Sakit" ? Icons.medical_services : Icons.assignment, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['type'] ?? "-", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(data['reason'] ?? "-", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(dateStr, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(statusLabel, style: TextStyle(color: statusText, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}