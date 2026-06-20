import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/wifi_entity.dart';
import '../../domain/repositories/wifi_repository.dart';

class WifiMockDatasource implements WifiRepository {
  @override
  Future<WifiEntity> getWifiInfo() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return const WifiEntity(
      networkName: 'SunshinePG_5G',
      password: 'Sunsh!ne@2026#PG',
      speedInfo: '100 Mbps (Fiber)',
      isActive: true,
      troubleshootTips: [
        TroubleshootTip(
          title: 'Restart your device WiFi',
          description: 'Turn off WiFi on your phone, wait 10 seconds, then turn it back on.',
          icon: IconType.signal,
        ),
        TroubleshootTip(
          title: 'Forget & reconnect',
          description: 'Go to WiFi settings, forget this network, and reconnect with the password.',
          icon: IconType.router,
        ),
        TroubleshootTip(
          title: 'Check router proximity',
          description: 'Make sure you are within range of the WiFi router. Signal may be weak in some rooms.',
          icon: IconType.signal,
        ),
        TroubleshootTip(
          title: 'Contact Admin',
          description: 'If nothing works, raise a complaint in the Complaints section or contact the admin.',
          icon: IconType.info,
        ),
      ],
    );
  }
}
