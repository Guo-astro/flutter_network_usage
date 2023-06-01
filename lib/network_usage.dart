
import 'network_usage_platform_interface.dart';

class NetworkUsage {
  Future<String?> getPlatformVersion() {
    return NetworkUsagePlatform.instance.getPlatformVersion();
  }
}
