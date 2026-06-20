/// API endpoint constants for future NestJS backend integration.
/// All endpoints are defined here for easy swapping.
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL — change this when connecting to NestJS
  static const String baseUrl = 'http://localhost:3000/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';

  // Rent & Payments
  static const String rentDetails = '/rent';
  static const String paymentHistory = '/payments';
  static const String markAsPaid = '/payments/mark-paid';

  // Room
  static const String roomDetails = '/room';

  // Menu
  static const String mealMenu = '/menu';

  // WiFi
  static const String wifiInfo = '/wifi';

  // Complaints
  static const String complaints = '/complaints';
  static const String raiseComplaint = '/complaints/create';

  // Notices
  static const String notices = '/notices';

  // Leave Notice
  static const String leaveNotice = '/leave-notice';
  static const String submitLeaveNotice = '/leave-notice/submit';
}
