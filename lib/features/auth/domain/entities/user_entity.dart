/// User entity — pure domain object with no serialization logic.
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String? roomNumber;
  final String? pgName;
  final DateTime? joinDate;
  final String? emergencyContact;
  final String? emergencyContactName;
  final String? address;
  final String? kycStatus;
  final String? policeVerificationStatus;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    this.roomNumber,
    this.pgName,
    this.joinDate,
    this.emergencyContact,
    this.emergencyContactName,
    this.address,
    this.kycStatus,
    this.policeVerificationStatus,
  });

  UserEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? roomNumber,
    String? pgName,
    DateTime? joinDate,
    String? emergencyContact,
    String? emergencyContactName,
    String? address,
    String? kycStatus,
    String? policeVerificationStatus,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      roomNumber: roomNumber ?? this.roomNumber,
      pgName: pgName ?? this.pgName,
      joinDate: joinDate ?? this.joinDate,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      address: address ?? this.address,
      kycStatus: kycStatus ?? this.kycStatus,
      policeVerificationStatus: policeVerificationStatus ?? this.policeVerificationStatus,
    );
  }
}
