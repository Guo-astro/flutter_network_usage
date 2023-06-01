import 'package:flutter_test/flutter_test.dart';
import 'package:network_usage/network_usage.dart';
import 'package:network_usage/network_usage_platform_interface.dart';
import 'package:network_usage/network_usage_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNetworkUsagePlatform
    with MockPlatformInterfaceMixin
    implements NetworkUsagePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NetworkUsagePlatform initialPlatform = NetworkUsagePlatform.instance;

  test('$MethodChannelNetworkUsage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNetworkUsage>());
  });

  test('getPlatformVersion', () async {
    NetworkUsage networkUsagePlugin = NetworkUsage();
    MockNetworkUsagePlatform fakePlatform = MockNetworkUsagePlatform();
    NetworkUsagePlatform.instance = fakePlatform;

    expect(await networkUsagePlugin.getPlatformVersion(), '42');
  });
}
