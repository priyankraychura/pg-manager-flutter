import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/rent/presentation/pages/rent_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/wifi/presentation/pages/wifi_page.dart';
import '../../features/complaints/presentation/pages/complaints_page.dart';
import '../../features/notices/presentation/pages/notices_page.dart';
import '../../features/room/presentation/pages/room_details_page.dart';
import '../../features/leave_notice/presentation/pages/leave_notice_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/help_support_page.dart';
import '../../features/settings/presentation/pages/privacy_policy_page.dart';
import '../../features/navigation/navigation_shell.dart';

/// App router configuration using GoRouter.
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // ─── Auth Routes ───────────────────────────────────────
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OtpVerificationPage(
          destination: extra['destination'] as String,
          flow: extra['flow'] as String,
          extra: extra.map((k, v) => MapEntry(k, v.toString())),
        );
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ResetPasswordPage(email: extra['email'] as String);
      },
    ),

    // ─── Main App (with bottom nav) ───────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/rent',
              builder: (context, state) => const RentPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/room',
              builder: (context, state) => const RoomDetailsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // ─── Feature Detail Routes ────────────────────────────
    GoRoute(
      path: '/wifi',
      builder: (context, state) => const WifiPage(),
    ),
    GoRoute(
      path: '/complaints',
      builder: (context, state) => const ComplaintsPage(),
    ),
    GoRoute(
      path: '/notices',
      builder: (context, state) => const NoticesPage(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuPage(),
    ),
    GoRoute(
      path: '/leave-notice',
      builder: (context, state) => const LeaveNoticePage(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/help-support',
      builder: (context, state) => const HelpAndSupportPage(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyPage(),
    ),
  ],
);
