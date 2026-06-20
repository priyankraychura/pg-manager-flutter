import '../entities/notice_entity.dart';

abstract class NoticesRepository {
  Future<List<NoticeEntity>> getNotices();
}
