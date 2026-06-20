import '../entities/user_entity.dart';

/// Abstract auth repository — contract for data layer.
/// Mock and API implementations both implement this.
abstract class AuthRepository {
  /// Login with email and password.
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  /// Register a new user.
  Future<UserEntity> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  /// Send OTP to email/phone for verification.
  Future<bool> sendOtp({required String destination});

  /// Verify OTP code.
  Future<bool> verifyOtp({
    required String destination,
    required String otp,
  });

  /// Reset password with new password after OTP verification.
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  });

  /// Get current logged-in user.
  Future<UserEntity?> getCurrentUser();

  /// Logout.
  Future<void> logout();
}
