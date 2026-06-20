import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/rent_entity.dart';
import '../../domain/repositories/rent_repository.dart';

class RentMockDatasource implements RentRepository {
  @override
  Future<RentEntity> getCurrentRent() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return RentEntity(
      id: 'rent_001',
      amount: 8500,
      dueDate: DateTime(2026, 7, 5),
      status: RentStatus.pending,
      month: 'July 2026',
      breakdown: const RentBreakdown(
        roomRent: 6000,
        electricity: 1200,
        water: 300,
        maintenance: 1000,
      ),
    );
  }

  @override
  Future<List<RentEntity>> getPaymentHistory() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return [
      RentEntity(
        id: 'rent_001',
        amount: 8500,
        dueDate: DateTime(2026, 7, 5),
        status: RentStatus.pending,
        month: 'July 2026',
      ),
      RentEntity(
        id: 'rent_002',
        amount: 8200,
        dueDate: DateTime(2026, 6, 5),
        status: RentStatus.paid,
        paidDate: DateTime(2026, 6, 3),
        month: 'June 2026',
      ),
      RentEntity(
        id: 'rent_003',
        amount: 8400,
        dueDate: DateTime(2026, 5, 5),
        status: RentStatus.paid,
        paidDate: DateTime(2026, 5, 4),
        month: 'May 2026',
      ),
      RentEntity(
        id: 'rent_004',
        amount: 8000,
        dueDate: DateTime(2026, 4, 5),
        status: RentStatus.paid,
        paidDate: DateTime(2026, 4, 5),
        month: 'April 2026',
      ),
      RentEntity(
        id: 'rent_005',
        amount: 8100,
        dueDate: DateTime(2026, 3, 5),
        status: RentStatus.paid,
        paidDate: DateTime(2026, 3, 2),
        month: 'March 2026',
      ),
    ];
  }

  @override
  Future<bool> markAsPaid({required String rentId, String? screenshotPath}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return true;
  }
}
