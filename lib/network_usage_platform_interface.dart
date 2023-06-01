import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'network_usage_method_channel.dart';

abstract class NetworkUsagePlatform extends PlatformInterface {
  /// Constructs a NetworkUsagePlatform.
  NetworkUsagePlatform() : super(token: _token);

  static final Object _token = Object();

  static NetworkUsagePlatform _instance = MethodChannelNetworkUsage();

  /// The default instance of [NetworkUsagePlatform] to use.
  ///
  /// Defaults to [MethodChannelNetworkUsage].
  static NetworkUsagePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NetworkUsagePlatform] when
  /// they register themselves.
  static set instance(NetworkUsagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
