import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  String displayName;
  final String email;
  String? gender; // 'Male','Female','Other' or null
  DateTime? dob;
  double? heightCm;
  Map<String, dynamic>? other;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.gender,
    this.dob,
    this.heightCm,
    this.other,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      displayName: (data['displayName'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      gender: data['gender'] as String?,
      dob: (data['dob'] is Timestamp)
          ? (data['dob'] as Timestamp).toDate()
          : (data['dob'] is String
          ? DateTime.tryParse(data['dob'])
          : null),
      heightCm: (data['heightCm'] != null)
          ? (data['heightCm'] as num).toDouble()
          : null,
      other: (data['other'] as Map?)?.cast<String, dynamic>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'gender': gender,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'heightCm': heightCm,
      'other': other,
      'updatedAt': Timestamp.now(),
    };
  }
}
