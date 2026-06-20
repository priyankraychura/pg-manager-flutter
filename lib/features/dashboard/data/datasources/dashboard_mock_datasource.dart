import '../../../../core/constants/app_constants.dart';
import '../../../rent/domain/entities/rent_entity.dart';
import '../../../menu/domain/entities/meal_entity.dart';
import '../../../notices/domain/entities/notice_entity.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardMockDatasource implements DashboardRepository {
  @override
  Future<DashboardEntity> getDashboardData() async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );

    return DashboardEntity(
      tenantName: 'Priyank',
      roomNumber: 'A-204',
      pgName: 'Sunshine PG Residency',
      rentSummary: RentSummary(
        amountDue: 8500,
        dueDate: DateTime(2026, 7, 5),
        status: RentStatus.pending,
      ),
      todayNextMeal: const MealEntity(
        id: 'm1',
        dayNumber: 1,
        dayName: 'Monday',
        breakfast: MealTime(
          type: 'breakfast',
          mainDish: 'Poha & Jalebi',
          sideItems: ['Chai', 'Banana'],
          timeSlot: '7:30 - 9:00 AM',
        ),
        lunch: MealTime(
          type: 'lunch',
          mainDish: 'Dal Rice & Roti',
          sideItems: ['Salad', 'Papad', 'Pickle'],
          timeSlot: '12:30 - 2:00 PM',
        ),
        dinner: MealTime(
          type: 'dinner',
          mainDish: 'Paneer Butter Masala',
          sideItems: ['Roti', 'Rice', 'Buttermilk'],
          timeSlot: '7:30 - 9:30 PM',
        ),
      ),
      recentNotices: [
        NoticeEntity(
          id: 'n1',
          title: 'Water Tank Cleaning',
          description: 'Water supply will be disrupted on 25th June from 10 AM to 2 PM.',
          postedDate: DateTime.now().subtract(const Duration(hours: 3)),
          priority: NoticePriority.high,
        ),
        NoticeEntity(
          id: 'n2',
          title: 'New WiFi Password',
          description: 'WiFi password has been changed. Check WiFi section for details.',
          postedDate: DateTime.now().subtract(const Duration(days: 1)),
          priority: NoticePriority.medium,
        ),
      ],
      activeComplaints: 2,
    );
  }
}
