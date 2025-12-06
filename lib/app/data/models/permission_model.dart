import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionModel {
  String? id;
  String? uid;
  String? name;
  String? type;
  String? reason;
  DateTime? startDate;
  DateTime? endDate;
  String? attachmentUrl;
  String? status;
  DateTime? createdAt;

  // --- DATA TAMBAHAN AUDIT ---
  String? processedBy; // Nama Admin yang memproses
  DateTime? processedAt; // Waktu diproses

  PermissionModel({
    this.id,
    this.uid,
    this.name,
    this.type,
    this.reason,
    this.startDate,
    this.endDate,
    this.attachmentUrl,
    this.status,
    this.createdAt,
    this.processedBy,
    this.processedAt,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      type: json['type'],
      reason: json['reason'],
      startDate: (json['startDate'] as Timestamp?)?.toDate(),
      endDate: (json['endDate'] as Timestamp?)?.toDate(),
      attachmentUrl: json['attachmentUrl'],
      status: json['status'] ?? 'Pending',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      processedBy: json['processedBy'],
      processedAt: (json['processedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Helper dari Snapshot (Opsional, biar gampang dipanggil di controller)
  factory PermissionModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    data['id'] = snap.id;
    return PermissionModel.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'type': type,
      'reason': reason,
      'startDate': startDate,
      'endDate': endDate,
      'attachmentUrl': attachmentUrl,
      'status': status,
      'createdAt': createdAt,
      'processedBy': processedBy,
      'processedAt': processedAt,
    };
  }
}