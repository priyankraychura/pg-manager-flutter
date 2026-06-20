import '../../domain/entities/user_entity.dart';

/// User model — data transfer object with JSON serialization.
/// Extends UserEntity with fromJson/toJson for API communication.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.profileImageUrl,
    super.roomNumber,
    super.pgName,
    super.joinDate,
    super.emergencyContact,
    super.emergencyContactName,
    super.address,
    super.kycStatus,
    super.policeVerificationStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      roomNumber: json['roomNumber'] as String?,
      pgName: json['pgName'] as String?,
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'] as String)
          : null,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyContactName: json['emergencyContactName'] as String?,
      address: json['address'] as String?,
      kycStatus: json['kycStatus'] as String?,
      policeVerificationStatus: json['policeVerificationStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'roomNumber': roomNumber,
      'pgName': pgName,
      'joinDate': joinDate?.toIso8601String(),
      'emergencyContact': emergencyContact,
      'emergencyContactName': emergencyContactName,
      'address': address,
      'kycStatus': kycStatus,
      'policeVerificationStatus': policeVerificationStatus,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      profileImageUrl: entity.profileImageUrl,
      roomNumber: entity.roomNumber,
      pgName: entity.pgName,
      joinDate: entity.joinDate,
      emergencyContact: entity.emergencyContact,
      emergencyContactName: entity.emergencyContactName,
      address: entity.address,
      kycStatus: entity.kycStatus,
      policeVerificationStatus: entity.policeVerificationStatus,
    );
  }
}
