import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.phoneNumber,
    super.photoUrl,
    super.role = UserRole.customer,
    required super.createdAt,
    super.favoritePackageIds = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == (json['role'] as String? ?? 'customer'),
        orElse: () => UserRole.customer,
      ),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      favoritePackageIds: (json['favoritePackageIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'favoritePackageIds': favoritePackageIds,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      photoUrl: entity.photoUrl,
      role: entity.role,
      createdAt: entity.createdAt,
      favoritePackageIds: entity.favoritePackageIds,
    );
  }

  UserEntity toEntity() => this;
}
