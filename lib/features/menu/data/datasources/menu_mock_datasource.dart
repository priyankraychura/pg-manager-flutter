import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuMockDatasource implements MenuRepository {
  static const _menu = [
    // Week 1
    MealEntity(id: 'm1', dayNumber: 1, dayName: 'Monday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Poha & Jalebi', sideItems: ['Chai', 'Banana'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Dal Rice', sideItems: ['Roti', 'Salad', 'Papad'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Paneer Butter Masala', sideItems: ['Roti', 'Rice', 'Buttermilk'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm2', dayNumber: 2, dayName: 'Tuesday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Upma & Chutney', sideItems: ['Coffee', 'Boiled Egg'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Rajma Chawal', sideItems: ['Onion Rings', 'Pickle'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Mix Veg Curry', sideItems: ['Roti', 'Rice', 'Raita'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm3', dayNumber: 3, dayName: 'Wednesday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Paratha & Curd', sideItems: ['Chai', 'Pickle'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Chole Bhature', sideItems: ['Onion', 'Green Chutney'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Dal Fry & Jeera Rice', sideItems: ['Roti', 'Salad'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm4', dayNumber: 4, dayName: 'Thursday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Idli & Sambhar', sideItems: ['Coconut Chutney', 'Coffee'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Kadhi Chawal', sideItems: ['Roti', 'Papad'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Aloo Gobi & Roti', sideItems: ['Rice', 'Dal', 'Buttermilk'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm5', dayNumber: 5, dayName: 'Friday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Bread Toast & Omelette', sideItems: ['Juice', 'Butter'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Pav Bhaji', sideItems: ['Onion', 'Lemon'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Palak Paneer', sideItems: ['Roti', 'Rice', 'Raita'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm6', dayNumber: 6, dayName: 'Saturday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Dosa & Sambhar', sideItems: ['Chutney', 'Chai'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Biryani', sideItems: ['Raita', 'Salan'], specialNote: '🎉 Weekend Special', timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Chana Masala', sideItems: ['Puri', 'Rice'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm7', dayNumber: 7, dayName: 'Sunday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Chole Bhature', sideItems: ['Lassi', 'Pickle'], specialNote: '🎉 Sunday Special', timeSlot: '8:00 - 10:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Paneer Biryani', sideItems: ['Raita', 'Papad', 'Sweet'], specialNote: '🎉 Sunday Special', timeSlot: '12:30 - 2:30 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Butter Dal & Roti', sideItems: ['Rice', 'Salad', 'Ice Cream'], timeSlot: '7:30 - 9:30 PM'),
    ),
    // Week 2
    MealEntity(id: 'm8', dayNumber: 8, dayName: 'Monday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Aloo Paratha', sideItems: ['Curd', 'Chai', 'Pickle'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Sambar Rice', sideItems: ['Papad', 'Pickle'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Malai Kofta', sideItems: ['Roti', 'Naan', 'Rice'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm9', dayNumber: 9, dayName: 'Tuesday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Sabudana Khichdi', sideItems: ['Peanuts', 'Curd', 'Chai'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Matar Paneer & Rice', sideItems: ['Roti', 'Salad'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Bhindi Masala', sideItems: ['Roti', 'Dal', 'Rice'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm10', dayNumber: 10, dayName: 'Wednesday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Moong Dal Cheela', sideItems: ['Green Chutney', 'Coffee'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Aloo Matar & Rice', sideItems: ['Roti', 'Raita'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Egg Curry', sideItems: ['Roti', 'Rice', 'Salad'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm11', dayNumber: 11, dayName: 'Thursday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Methi Thepla', sideItems: ['Chai', 'Curd', 'Pickle'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Dal Tadka & Rice', sideItems: ['Roti', 'Papad'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Mushroom Masala', sideItems: ['Naan', 'Rice', 'Raita'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm12', dayNumber: 12, dayName: 'Friday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Vada Pav', sideItems: ['Chai', 'Green Chutney'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Pulao & Kadhi', sideItems: ['Papad', 'Salad'], timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Sev Tamatar', sideItems: ['Roti', 'Rice', 'Buttermilk'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm13', dayNumber: 13, dayName: 'Saturday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Sandwich & Juice', sideItems: ['Chips', 'Ketchup'], timeSlot: '7:30 - 9:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Veg Pulao', sideItems: ['Raita', 'Pickle'], specialNote: '🎉 Weekend Special', timeSlot: '12:30 - 2:00 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Shahi Paneer', sideItems: ['Butter Naan', 'Rice'], timeSlot: '7:30 - 9:30 PM'),
    ),
    MealEntity(id: 'm14', dayNumber: 14, dayName: 'Sunday',
      breakfast: MealTime(type: 'breakfast', mainDish: 'Puri Bhaji', sideItems: ['Halwa', 'Chai'], specialNote: '🎉 Sunday Special', timeSlot: '8:00 - 10:00 AM'),
      lunch: MealTime(type: 'lunch', mainDish: 'Special Thali', sideItems: ['4 items', 'Sweet', 'Drink'], specialNote: '🎉 Sunday Special', timeSlot: '12:30 - 2:30 PM'),
      dinner: MealTime(type: 'dinner', mainDish: 'Matar Mushroom', sideItems: ['Roti', 'Rice', 'Gulab Jamun'], timeSlot: '7:30 - 9:30 PM'),
    ),
  ];

  @override
  Future<List<MealEntity>> getTwoWeekMenu() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _menu;
  }

  @override
  Future<MealEntity?> getTodayMenu() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final dayOfCycle = (DateTime.now().day % 14) + 1;
    return _menu.firstWhere(
      (m) => m.dayNumber == dayOfCycle,
      orElse: () => _menu.first,
    );
  }
}
