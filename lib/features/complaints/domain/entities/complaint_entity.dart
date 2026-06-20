/// Complaint/ticket entity.
class ComplaintEntity {
  final String id;
  final String title;
  final String description;
  final ComplaintCategory category;
  final ComplaintStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? imageUrl;
  final String? adminReply;

  const ComplaintEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.imageUrl,
    this.adminReply,
  });
}

enum ComplaintCategory {
  maintenance,
  cleanliness,
  wifi,
  water,
  electricity,
  food,
  noise,
  security,
  other,
}

enum ComplaintStatus { open, inProgress, resolved, closed }
