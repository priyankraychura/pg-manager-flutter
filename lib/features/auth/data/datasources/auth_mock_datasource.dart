import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock implementation of AuthRepository.
/// Returns hardcoded data with simulated delays.
/// Swap this with ApiAuthDatasource when NestJS is ready.
class AuthMockDatasource implements AuthRepository {
  UserEntity? _currentUser;

  // Mock user data
  static final _mockUser = UserModel(
    id: 'usr_001',
    name: 'Priyank Raychura',
    email: 'priyank@example.com',
    phone: '9876543210',
    profileImageUrl: null,
    roomNumber: 'A-204',
    pgName: 'Sunshine PG Residency',
    joinDate: DateTime(2026, 1, 15),
    emergencyContact: '9876543211',
    emergencyContactName: 'Rajesh Raychura',
    address: '123, MG Road, Ahmedabad, Gujarat - 380001',
  );

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );

    if (email == 'priyank@example.com' && password == 'Password1') {
      _currentUser = _mockUser;
      return _mockUser;
    }

    _currentUser = UserModel(
      id: _mockUser.id,
      name: _mockUser.name,
      email: email,
      phone: _mockUser.phone,
      roomNumber: _mockUser.roomNumber,
      pgName: _mockUser.pgName,
      joinDate: _mockUser.joinDate,
      emergencyContact: _mockUser.emergencyContact,
      emergencyContactName: _mockUser.emergencyContactName,
      address: _mockUser.address,
    );
    return _currentUser!;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );

    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      roomNumber: 'A-204',
      pgName: 'Sunshine PG Residency',
      joinDate: DateTime.now(),
    );

    return _currentUser!;
  }

  @override
  Future<bool> sendOtp({required String destination}) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    return true;
  }

  @override
  Future<bool> verifyOtp({
    required String destination,
    required String otp,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    return otp == '123456';
  }

  @override
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    return true;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
