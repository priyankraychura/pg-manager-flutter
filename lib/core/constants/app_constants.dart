/// App-wide constant values.
class AppConstants {
  AppConstants._();

  static const String appName = 'PG Manager';
  static const String appVersion = '1.0.0';

  // Mock delay to simulate API calls (milliseconds)
  static const int mockApiDelay = 800;

  // Pagination
  static const int defaultPageSize = 20;

  // OTP
  static const int otpLength = 6;
  static const int otpResendSeconds = 30;

  // File upload
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];
}
