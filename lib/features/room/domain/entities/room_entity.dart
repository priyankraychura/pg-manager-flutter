/// Room details entity.
class RoomEntity {
  final String roomNumber;
  final int floor;
  final String bedType;
  final List<String> amenities;
  final List<RoommateEntity> roommates;
  final String? roomImageUrl;

  const RoomEntity({
    required this.roomNumber,
    required this.floor,
    required this.bedType,
    this.amenities = const [],
    this.roommates = const [],
    this.roomImageUrl,
  });
}

class RoommateEntity {
  final String name;
  final String? phone;
  final String? profileImageUrl;
  final DateTime joinDate;

  const RoommateEntity({
    required this.name,
    this.phone,
    this.profileImageUrl,
    required this.joinDate,
  });
}
