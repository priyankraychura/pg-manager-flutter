
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

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



final updateProvider = FutureProvider<AppUpdateInfo>((ref) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final upgrader = Upgrader(
      // Can add debug settings here if needed
      // debugDisplayAlways: true, 
    );
    await upgrader.initialize();

    final storeVersion = upgrader.currentAppStoreVersion ?? '';
    final storeUrl = upgrader.currentAppStoreListingURL ?? '';
    final releaseNotes = upgrader.releaseNotes ?? '';

    if (storeVersion.isEmpty) {
      return const AppUpdateInfo(
        updateType: UpdateType.none,
        latestVersion: '',
        releaseNotes: '',
        storeUrl: '',
      );
    }

    // Compare versions
    List<String> cParts = currentVersion.split('.');
    List<String> sParts = storeVersion.split('.');

    int cMajor = cParts.isNotEmpty ? int.tryParse(cParts[0]) ?? 0 : 0;
    int cMinor = cParts.length > 1 ? int.tryParse(cParts[1]) ?? 0 : 0;
    int cPatch = cParts.length > 2 ? int.tryParse(cParts[2]) ?? 0 : 0;

    int sMajor = sParts.isNotEmpty ? int.tryParse(sParts[0]) ?? 0 : 0;
    int sMinor = sParts.length > 1 ? int.tryParse(sParts[1]) ?? 0 : 0;
    int sPatch = sParts.length > 2 ? int.tryParse(sParts[2]) ?? 0 : 0;

    UpdateType type = UpdateType.none;

    if (sMajor > cMajor) {
      type = UpdateType.major;
    } else if (sMajor == cMajor && sMinor > cMinor) {
      type = UpdateType.minor;
    } else if (sMajor == cMajor && sMinor == cMinor && sPatch > cPatch) {
      type = UpdateType.minor;
    }

    return AppUpdateInfo(
      updateType: type,
      latestVersion: storeVersion,
      releaseNotes: releaseNotes,
      storeUrl: storeUrl,
    );
  } catch (e) {
    // If any error occurs (e.g. no network, parsing error), return no update
    return const AppUpdateInfo(
      updateType: UpdateType.none,
      latestVersion: '',
      releaseNotes: '',
      storeUrl: '',
    );
  }
});
