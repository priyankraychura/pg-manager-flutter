import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/leave_notice_entity.dart';
import '../../domain/repositories/leave_notice_repository.dart';

class LeaveNoticeMockDatasource implements LeaveNoticeRepository {
  LeaveNoticeEntity? _currentNotice;

  @override
  Future<LeaveNoticeEntity?> getCurrentNotice() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _currentNotice;
  }

  @override
  Future<LeaveNoticeEntity> submitNotice({
    required DateTime intendedLeaveDate,
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _currentNotice = LeaveNoticeEntity(
      id: 'ln_${DateTime.now().millisecondsSinceEpoch}',
      submittedDate: DateTime.now(),
      intendedLeaveDate: intendedLeaveDate,
      reason: reason,
      status: LeaveNoticeStatus.pending,
    );
    return _currentNotice!;
  }
}
