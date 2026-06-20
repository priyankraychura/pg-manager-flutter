import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<RoomEntity> getRoomDetails();
}
