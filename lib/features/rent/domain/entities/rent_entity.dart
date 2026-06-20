/// Rent entity and related enums.
class RentEntity {
  final String id;
  final double amount;
  final DateTime dueDate;
  final RentStatus status;
  final DateTime? paidDate;
  final String? paymentScreenshotUrl;
  final String month;
  final RentBreakdown? breakdown;

  const RentEntity({
    required this.id,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.month,
    this.paidDate,
    this.paymentScreenshotUrl,
    this.breakdown,
  });
}

class RentBreakdown {
  final double roomRent;
  final double electricity;
  final double water;
  final double maintenance;
  final double? other;

  const RentBreakdown({
    required this.roomRent,
    required this.electricity,
    required this.water,
    required this.maintenance,
    this.other,
  });

  double get total => roomRent + electricity + water + maintenance + (other ?? 0);
}

enum RentStatus { paid, pending, overdue, processing }
