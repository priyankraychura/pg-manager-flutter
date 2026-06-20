import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notices_repository.dart';

class NoticesMockDatasource implements NoticesRepository {
  @override
  Future<List<NoticeEntity>> getNotices() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return [
      NoticeEntity(
        id: 'n1',
        title: 'Water Tank Cleaning - 25th June',
        description: 'Water supply will be disrupted on 25th June from 10 AM to 2 PM due to tank cleaning. Please store water in advance.',
        postedDate: DateTime.now().subtract(const Duration(hours: 3)),
        priority: NoticePriority.high,
      ),
      NoticeEntity(
        id: 'n2',
        title: 'New WiFi Password',
        description: 'WiFi password has been updated for security reasons. Please check the WiFi section for the new credentials.',
        postedDate: DateTime.now().subtract(const Duration(days: 1)),
        priority: NoticePriority.medium,
      ),
      NoticeEntity(
        id: 'n3',
        title: 'Monthly Rent Due Reminder',
        description: 'Rent for July 2026 is due by 5th July. Please make the payment on time to avoid late fees.',
        postedDate: DateTime.now().subtract(const Duration(days: 2)),
        priority: NoticePriority.high,
      ),
      NoticeEntity(
        id: 'n4',
        title: 'Common Area Maintenance',
        description: 'Common areas (lobby, gym, laundry room) will undergo maintenance this weekend. Apologies for the inconvenience.',
        postedDate: DateTime.now().subtract(const Duration(days: 5)),
        priority: NoticePriority.low,
      ),
      NoticeEntity(
        id: 'n5',
        title: 'Independence Day Celebration',
        description: 'We are organizing a cultural program on 15th August. All tenants are welcome to participate. Contact admin to register.',
        postedDate: DateTime.now().subtract(const Duration(days: 7)),
        priority: NoticePriority.low,
      ),
    ];
  }
}
