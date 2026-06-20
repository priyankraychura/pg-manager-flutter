import '../entities/wifi_entity.dart';

abstract class WifiRepository {
  Future<WifiEntity> getWifiInfo();
}
