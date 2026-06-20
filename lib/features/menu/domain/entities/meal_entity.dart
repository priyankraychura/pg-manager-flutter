/// Meal entity for the 2-week rotating menu.
class MealEntity {
  final String id;
  final int dayNumber; // 1-14 (2-week cycle)
  final String dayName;
  final MealTime breakfast;
  final MealTime lunch;
  final MealTime dinner;

  const MealEntity({
    required this.id,
    required this.dayNumber,
    required this.dayName,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
}

class MealTime {
  final String type; // breakfast, lunch, dinner
  final String mainDish;
  final List<String> sideItems;
  final String? specialNote;
  final String timeSlot; // e.g., "7:30 - 9:00 AM"

  const MealTime({
    required this.type,
    required this.mainDish,
    this.sideItems = const [],
    this.specialNote,
    required this.timeSlot,
  });
}
