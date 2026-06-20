/// Leave notice entity for vacating the PG.
class LeaveNoticeEntity {
  final String id;
  final DateTime submittedDate;
  final DateTime intendedLeaveDate;
  final String reason;
  final LeaveNoticeStatus status;
  final String? adminRemarks;

  const LeaveNoticeEntity({
    required this.id,
    required this.submittedDate,
    required this.intendedLeaveDate,
    required this.reason,
    required this.status,
    this.adminRemarks,
  });
}

enum LeaveNoticeStatus { pending, approved, rejected }
