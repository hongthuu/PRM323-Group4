import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String id;
  final String name;
  final String description;
  final String leaderId; // References users collection (club leader)
  final String history;
  final String introduction;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClubModel({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderId,
    required this.history,
    required this.introduction,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Deserializes a Firestore document into a ClubModel instance.
  ///
  /// Converts Firestore Timestamp objects to DateTime objects.
  /// Provides default values for required fields to prevent null errors.
  factory ClubModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ClubModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      leaderId: data['leaderId'] ?? '',
      history: data['history'] ?? '',
      introduction: data['introduction'] ?? '',
      avatar: data['avatar'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Serializes the ClubModel to a Firestore-compatible map.
  ///
  /// Converts DateTime objects to Firestore Timestamp objects.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'leaderId': leaderId,
      'history': history,
      'introduction': introduction,
      'avatar': avatar,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
