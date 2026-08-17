import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, displayName, avatarUrl];

  @override
  String toString() => 'UserEntity(id: $id, email: $email, name: $displayName)';
}
