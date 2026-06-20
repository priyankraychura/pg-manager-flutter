import '../entities/rent_entity.dart';

abstract class RentRepository {
  Future<RentEntity> getCurrentRent();
  Future<List<RentEntity>> getPaymentHistory();
  Future<bool> markAsPaid({required String rentId, String? screenshotPath});
}
