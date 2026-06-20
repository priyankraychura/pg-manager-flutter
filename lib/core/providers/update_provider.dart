import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UpdateType { none, minor, major }

class AppUpdateInfo {
  final UpdateType updateType;
  final String latestVersion;
  final String releaseNotes;
  final String storeUrl;

  const AppUpdateInfo({
    required this.updateType,
    required this.latestVersion,
    required this.releaseNotes,
    required this.storeUrl,
  });
}

// In a real application, this would fetch from a backend API or use package_info_plus/upgrader
// For now, we simulate an update check. Change UpdateType.none to .minor or .major to test.
final updateProvider = FutureProvider<AppUpdateInfo>((ref) async {
  await Future.delayed(const Duration(seconds: 1));

  return const AppUpdateInfo(
    updateType: UpdateType.minor, // Set to .major to test blocking modal
    latestVersion: '1.2.0',
    releaseNotes:
        '• Bug fixes and performance improvements\n• New features added',
    storeUrl: 'https://play.google.com/store/apps',
  );
});
