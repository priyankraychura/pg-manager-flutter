import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/auth_mock_datasource.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/dashboard/data/datasources/dashboard_mock_datasource.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/rent/data/datasources/rent_mock_datasource.dart';
import '../features/rent/domain/repositories/rent_repository.dart';
import '../features/menu/data/datasources/menu_mock_datasource.dart';
import '../features/menu/domain/repositories/menu_repository.dart';
import '../features/wifi/data/datasources/wifi_mock_datasource.dart';
import '../features/wifi/domain/repositories/wifi_repository.dart';
import '../features/complaints/data/datasources/complaints_mock_datasource.dart';
import '../features/complaints/domain/repositories/complaints_repository.dart';
import '../features/notices/data/datasources/notices_mock_datasource.dart';
import '../features/notices/domain/repositories/notices_repository.dart';
import '../features/room/data/datasources/room_mock_datasource.dart';
import '../features/room/domain/repositories/room_repository.dart';
import '../features/leave_notice/data/datasources/leave_notice_mock_datasource.dart';
import '../features/leave_notice/domain/repositories/leave_notice_repository.dart';

/// Service locator using get_it.
/// To switch from mock to real API, just change the datasource registration.
final getIt = GetIt.instance;

void setupServiceLocator() {
  // ─── Auth ──────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthMockDatasource(),
  );

  // ─── Dashboard ─────────────────────────────────────────────
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardMockDatasource(),
  );

  // ─── Rent ──────────────────────────────────────────────────
  getIt.registerLazySingleton<RentRepository>(
    () => RentMockDatasource(),
  );

  // ─── Menu ──────────────────────────────────────────────────
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuMockDatasource(),
  );

  // ─── WiFi ──────────────────────────────────────────────────
  getIt.registerLazySingleton<WifiRepository>(
    () => WifiMockDatasource(),
  );

  // ─── Complaints ────────────────────────────────────────────
  getIt.registerLazySingleton<ComplaintsRepository>(
    () => ComplaintsMockDatasource(),
  );

  // ─── Notices ───────────────────────────────────────────────
  getIt.registerLazySingleton<NoticesRepository>(
    () => NoticesMockDatasource(),
  );

  // ─── Room ──────────────────────────────────────────────────
  getIt.registerLazySingleton<RoomRepository>(
    () => RoomMockDatasource(),
  );

  // ─── Leave Notice ──────────────────────────────────────────
  getIt.registerLazySingleton<LeaveNoticeRepository>(
    () => LeaveNoticeMockDatasource(),
  );
}
