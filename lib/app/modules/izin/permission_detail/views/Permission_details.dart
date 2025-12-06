import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/widgets/status_badge.dart';
import 'package:godsseo/app/modules/izin/permission_detail/controllers/permission_details_controllers.dart';
import 'package:intl/intl.dart';
// Import StatusBadge dari modul Approval (sesuaikan path jika perlu)


class PermissionDetailView extends GetView<PermissionDetailController> {
  const PermissionDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Terima data dari list
    final Map<String, dynamic> args = Get.arguments ?? {};
    final Map<String, dynamic> data = args['data'] ?? {};
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Izin Saya", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER STATUS ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getStatusColor(data['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getStatusColor(data['status']).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    _getStatusIcon(data['status']), 
                    size: 48, 
                    color: _getStatusColor(data['status'])
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['type'] ?? "Pengajuan Izin",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Ganti Container manual dengan StatusBadge
                  StatusBadge(status: data['status']),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- AUDIT TRAIL (SIAPA YANG ACC) ---
            // Hanya muncul jika sudah diproses (Approved/Rejected)
            if (data['status'] != 'Pending' && data['processedBy'] != null) 
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey[100],
                      child: const Icon(Icons.admin_panel_settings, size: 20, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['status'] == 'Approved' ? "Disetujui oleh" : "Ditolak oleh",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            data['processedBy'] ?? "Admin",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          if (data['processedAt'] != null)
                            Text(
                              _formatTimestamp(data['processedAt']),
                              style: TextStyle(fontSize: 12, color: Colors.grey[500], fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // --- DETAIL INFORMASI ---
            const Text("Detail Informasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            
            _buildDetailItem(Icons.calendar_today, "Tanggal Mulai", _formatDate(data['startDate'])),
            _buildDetailItem(Icons.event_available, "Tanggal Selesai", _formatDate(data['endDate'])),
            _buildDetailItem(Icons.description_outlined, "Alasan", data['reason'] ?? "-"),

            const SizedBox(height: 25),

            // --- LAMPIRAN ---
            const Text("Lampiran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: (data['attachmentUrl'] != null && data['attachmentUrl'] != "")
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: CachedNetworkImage(
                        imageUrl: data['attachmentUrl'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tidak ada lampiran", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Approved": return const Color(0xFF4CAF50);
      case "Rejected": return const Color(0xFFF44336);
      default: return const Color(0xFFFF9800);
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case "Approved": return Icons.check_circle_outline;
      case "Rejected": return Icons.highlight_off;
      default: return Icons.access_time;
    }
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
}