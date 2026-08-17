import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        avatarUrl,
        phoneNumber,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() =>
      'ProfileEntity(id: $id, email: $email, name: $displayName, phone: $phoneNumber)';
}
