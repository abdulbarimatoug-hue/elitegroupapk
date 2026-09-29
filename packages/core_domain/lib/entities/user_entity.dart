import 'package:equatable/equatable.dart';

/// User Role in LY-Elite Tourism Group
enum UserRole {
  customer,
  staff,
  admin,
}

/// User Entity representing an authenticated customer or staff member
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final List<String> favoritePackageIds;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.photoUrl,
    this.role = UserRole.customer,
    required this.createdAt,
    this.favoritePackageIds = const [],
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isStaff => role == UserRole.staff || role == UserRole.admin;

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        photoUrl,
        role,
        createdAt,
        favoritePackageIds,
      ];
}
