import '../entities/meal_entity.dart';

abstract class MenuRepository {
  Future<List<MealEntity>> getTwoWeekMenu();
  Future<MealEntity?> getTodayMenu();
}
