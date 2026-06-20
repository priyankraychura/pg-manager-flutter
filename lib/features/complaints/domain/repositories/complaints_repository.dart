import '../entities/complaint_entity.dart';

abstract class ComplaintsRepository {
  Future<List<ComplaintEntity>> getComplaints();
  Future<ComplaintEntity> raiseComplaint({
    required String title,
    required String description,
    required ComplaintCategory category,
    String? imagePath,
  });
}
