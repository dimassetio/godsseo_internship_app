import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/modules/Izin%20_admin/detail/controller/approval_detail_controller.dart';
import 'package:intl/intl.dart';

class ApprovalDetailView extends GetView<ApprovalDetailController> {
  const ApprovalDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final Map<String, dynamic> data = args['data'];
    final String docId = args['id'];

    return Scaffold(
      backgroundColor: Colors.white, // Background utama putih bersih
      appBar: AppBar(
        title: const Text("Detail Pengajuan", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Hilangkan shadow appbar biar menyatu
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER USER CARD (DESIGN BARU) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                // Shadow halus biar card-nya 'pop'
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(Icons.person, size: 30, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? "Nama Tidak Ada",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Mengajukan: ${data['type']}",
                          style: TextStyle(color: Colors.grey[500], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Badge Status di kanan
                  _buildStatusBadge(data['status']),
                ],
              ),
            ),

            // --- AUDIT TRAIL (SIAPA YANG ACC) ---
            if (data['status'] != 'Pending' && data['processedBy'] != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(data['status']).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(data['status']).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      data['status'] == 'Approved' ? Icons.check_circle : Icons.cancel,
                      color: _getStatusColor(data['status']),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['status'] == 'Approved' ? "Disetujui oleh:" : "Ditolak oleh:",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black87, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: data['processedBy'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (data['processedAt'] != null) ...[
                                  const TextSpan(text: " pada "),
                                  TextSpan(
                                    text: _formatTimestamp(data['processedAt']),
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 30),
            
            // --- DETAIL INFORMASI ---
            const Text("Informasi Izin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            
            _buildInfoRow(
              icon: Icons.calendar_today_outlined, 
              label: "Tanggal Mulai", 
              value: _formatDate(data['startDate'])
            ),
            _buildInfoRow(
              icon: Icons.event_available_outlined, 
              label: "Tanggal Selesai", 
              value: _formatDate(data['endDate'])
            ),
            _buildInfoRow(
              icon: Icons.description_outlined, 
              label: "Alasan", 
              value: data['reason'] ?? "-"
            ),

            const SizedBox(height: 30),

            // --- LAMPIRAN ---
            const Text("Lampiran Bukti", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: (data['attachmentUrl'] != null && data['attachmentUrl'] != "-" && data['attachmentUrl'] != "")
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: data['attachmentUrl'],
                        fit: BoxFit.cover, 
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Gagal memuat gambar", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tidak ada lampiran", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 100), 
          ],
        ),
      ),
      
      // --- BOTTOM ACTION BUTTONS ---
      bottomNavigationBar: data['status'] == "Pending"
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.05), offset: const Offset(0, -5))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _confirmDialog(context, docId, "Rejected", "Tolak"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Tolak", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _confirmDialog(context, docId, "Approved", "Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50), 
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("Approve", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  // --- HELPERS ---

  Widget _buildStatusBadge(String? status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Background transparan sesuai warna status
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)), // Border tipis
      ),
      child: Text(
        status ?? "Unknown",
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Approved": return const Color(0xFF4CAF50); // Hijau
      case "Rejected": return const Color(0xFFF44336); // Merah
      default: return const Color(0xFFFF9800); // Orange
    }
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      return DateFormat('dd MMMM yyyy').format(date.toDate());
    }
    return "-";
  }

  String _formatTimestamp(dynamic date) {
    if (date is Timestamp) {
      return DateFormat('dd MMM yyyy, HH:mm').format(date.toDate());
    }
    return "";
  }

  void _confirmDialog(BuildContext context, String docId, String status, String label) {
    Get.defaultDialog(
      title: "Konfirmasi",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Apakah Anda yakin ingin men-$label pengajuan ini?",
      textConfirm: "Ya, $label",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: status == "Approved" ? Colors.green : Colors.red,
      radius: 16,
      onConfirm: () {
        Get.back(); 
        controller.updateStatus(docId, status);
      },
    );
  }
}