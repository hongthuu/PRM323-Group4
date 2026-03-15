import 'package:cloud_firestore/cloud_firestore.dart';


class ClubMemberModel {
  final String id;
  final String clubId;
  final String userId;
  final String role; // 'staff' or 'admin'
  final DateTime addedAt;

  ClubMemberModel({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.role,
    required this.addedAt,
  });

  factory ClubMemberModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ClubMemberModel(
      id: id,
      clubId: data['clubId'] ?? '',
      userId: data['userId'] ?? '',
      role: data['role'] ?? 'staff',
      addedAt: data['addedAt'] != null
          ? (data['addedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clubId': clubId,
      'userId': userId,
      'role': role,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
