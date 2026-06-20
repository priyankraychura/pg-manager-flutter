/// Notice/Announcement entity.
class NoticeEntity {
  final String id;
  final String title;
  final String description;
  final DateTime postedDate;
  final NoticePriority priority;
  final String postedBy;
  final bool isRead;

  const NoticeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.postedDate,
    required this.priority,
    this.postedBy = 'Admin',
    this.isRead = false,
  });
}

enum NoticePriority { low, medium, high, urgent }
