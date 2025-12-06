import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String? status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status ?? "Unknown",
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
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
}