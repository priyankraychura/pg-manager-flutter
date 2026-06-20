import '../entities/leave_notice_entity.dart';

abstract class LeaveNoticeRepository {
  Future<LeaveNoticeEntity?> getCurrentNotice();
  Future<LeaveNoticeEntity> submitNotice({
    required DateTime intendedLeaveDate,
    required String reason,
  });
}
