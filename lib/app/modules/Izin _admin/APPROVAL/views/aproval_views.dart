import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/Izin%20_admin/APPROVAL/controller/aproval_controller.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class ApprovalView extends GetView<ApprovalController> {
  const ApprovalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Daftar Pengajuan Izin"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamPermissions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada data pengajuan"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data();
              
              DateTime start = (data['startDate'] as Timestamp).toDate();
              DateTime end = (data['endDate'] as Timestamp).toDate();
              String dateStr = "${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}";

              bool isSakit = data['type'] == "Sakit";
              IconData iconData = isSakit ? Icons.medical_services_rounded : Icons.assignment_rounded;

              // --- LOGIKA AUDIT TRAIL ---
              String status = data['status'] ?? 'Pending';
              String? processedBy = data['processedBy'];
              Timestamp? processedAt = data['processedAt'];
              
              String auditText = "Menunggu Konfirmasi";
              Color statusColor = Colors.orange; // Warna default Pending

              if (status == 'Approved') {
                statusColor = Colors.green;
                auditText = "Disetujui";
              } else if (status == 'Rejected') {
                statusColor = Colors.red;
                auditText = "Ditolak";
              }

              // Jika sudah diproses, tambahkan info detailnya
              if (status != 'Pending' && processedBy != null) {
                auditText += " oleh $processedBy";
                if (processedAt != null) {
                  String timeStr = DateFormat('dd MMM HH:mm').format(processedAt.toDate());
                  auditText += "pada $timeStr";
                }
              }
              // ---------------------------

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200), 
                ),
                elevation: 0, 
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.toNamed(
                      Routes.APPROVAL_DETAIL, 
                      arguments: {
                        'id': doc.id,
                        'data': data
                      }
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
                        // --- 1. ICON ---
                        Container(
                          width: 55, 
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD), 
                            borderRadius: BorderRadius.circular(14), 
                          ),
                          child: Icon(
                            iconData, 
                            color: Colors.blue, 
                            size: 28
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // --- 2. INFO ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? "User",
                                style: const TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              
                              Text(
                                "${data['type']} - ${data['reason']}",
                                style: TextStyle(
                                  fontSize: 14, 
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 6),
                              
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      dateStr,
                                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10), // Jarak ke Status

                              // --- TAMPILAN STATUS & AUDIT ---
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: Text(
                                  auditText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}