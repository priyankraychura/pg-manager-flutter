import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';

class RoomMockDatasource implements RoomRepository {
  @override
  Future<RoomEntity> getRoomDetails() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return RoomEntity(
      roomNumber: 'A-204',
      floor: 2,
      bedType: 'Double Sharing',
      amenities: ['AC', 'Attached Bathroom', 'WiFi', 'Hot Water', 'Wardrobe', 'Study Table', 'Power Backup'],
      roommates: [
        RoommateEntity(name: 'Rahul Sharma', phone: '9876543222', joinDate: DateTime(2025, 11, 10)),
      ],
    );
  }
}
