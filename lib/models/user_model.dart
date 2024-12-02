import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? shortBio;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;

  UserModel({
    this.uid,
    this.displayName,
    this.email,
    this.gender,
    this.shortBio,
    this.dateOfBirth,
    this.createdAt,
  });

  // convert Supabase data map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String?,
      displayName: data['full_name'] as String?,
      email: data['email'] as String?,
      gender: data['gender'] as String?,
      shortBio: data['short_bio'] as String?,
      dateOfBirth: data['date_of_birth'] != null
          ? DateTime.tryParse(data['date_of_birth'] as String)
          : null,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
    );
  }

  // convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'full_name': displayName,
      'email': email,
      'gender': gender,
      'short_bio': shortBio,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // create a UserModel from Supabase User object
  factory UserModel.fromSupabaseUser(User user) {
    final metadata = user.userMetadata ?? {};
    return UserModel(
      uid: user.id,
      displayName: metadata['full_name'] as String?,
      email: user.email,
      gender: metadata['gender'] as String?,
      shortBio: metadata['short_bio'] as String?,
      dateOfBirth: metadata['date_of_birth'] != null
          ? DateTime.tryParse(metadata['date_of_birth'] as String)
          : null,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }
}
