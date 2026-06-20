/// WiFi information entity.
class WifiEntity {
  final String networkName;
  final String password;
  final String speedInfo;
  final bool isActive;
  final List<TroubleshootTip> troubleshootTips;

  const WifiEntity({
    required this.networkName,
    required this.password,
    required this.speedInfo,
    this.isActive = true,
    this.troubleshootTips = const [],
  });
}

class TroubleshootTip {
  final String title;
  final String description;
  final IconType icon;

  const TroubleshootTip({
    required this.title,
    required this.description,
    this.icon = IconType.info,
  });
}

enum IconType { info, warning, router, signal }
