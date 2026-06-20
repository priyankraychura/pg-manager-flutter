import '../../rent/domain/entities/rent_entity.dart';
import '../../menu/domain/entities/meal_entity.dart';
import '../../notices/domain/entities/notice_entity.dart';
import '../../complaints/domain/entities/complaint_entity.dart';

/// Dashboard data aggregating summaries from multiple features.
class DashboardEntity {
  final String tenantName;
  final String roomNumber;
  final String pgName;
  final RentSummary rentSummary;
  final MealEntity? todayNextMeal;
  final List<NoticeEntity> recentNotices;
  final int activeComplaints;

  const DashboardEntity({
    required this.tenantName,
    required this.roomNumber,
    required this.pgName,
    required this.rentSummary,
    this.todayNextMeal,
    this.recentNotices = const [],
    this.activeComplaints = 0,
  });
}

class RentSummary {
  final double amountDue;
  final DateTime dueDate;
  final RentStatus status;

  const RentSummary({
    required this.amountDue,
    required this.dueDate,
    required this.status,
  });
}
