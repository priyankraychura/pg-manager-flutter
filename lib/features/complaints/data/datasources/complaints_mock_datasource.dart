import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';

class ComplaintsMockDatasource implements ComplaintsRepository {
  final List<ComplaintEntity> _complaints = [
    ComplaintEntity(
      id: 'c1',
      title: 'AC not cooling',
      description: 'The AC in room A-204 is not cooling properly. It makes a loud noise when turned on.',
      category: ComplaintCategory.maintenance,
      status: ComplaintStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      adminReply: 'Technician has been assigned. Will visit tomorrow.',
    ),
    ComplaintEntity(
      id: 'c2',
      title: 'WiFi speed very slow',
      description: 'Internet speed has been very slow for the past 3 days. Streaming is not possible.',
      category: ComplaintCategory.wifi,
      status: ComplaintStatus.open,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ComplaintEntity(
      id: 'c3',
      title: 'Bathroom tap leaking',
      description: 'Hot water tap in bathroom is constantly dripping.',
      category: ComplaintCategory.water,
      status: ComplaintStatus.resolved,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      resolvedAt: DateTime.now().subtract(const Duration(days: 8)),
      adminReply: 'Fixed. New washer installed.',
    ),
  ];

  @override
  Future<List<ComplaintEntity>> getComplaints() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return List.from(_complaints);
  }

  @override
  Future<ComplaintEntity> raiseComplaint({
    required String title,
    required String description,
    required ComplaintCategory category,
    String? imagePath,
  }) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final complaint = ComplaintEntity(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      category: category,
      status: ComplaintStatus.open,
      createdAt: DateTime.now(),
    );
    _complaints.insert(0, complaint);
    return complaint;
  }
}
