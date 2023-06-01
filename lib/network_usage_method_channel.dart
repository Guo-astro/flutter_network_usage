import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:network_usage/src/model/ios_network_usage_model.dart';
import 'package:network_usage/src/model/network_usage_model.dart';
import 'dart:async';
import 'dart:io';
import 'network_usage_platform_interface.dart';

/// An implementation of [NetworkUsagePlatform] that uses method channels.
enum NetworkUsageType { mobile, wifi }

class MethodChannelNetworkUsage extends NetworkUsagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const _channel = const MethodChannel('network_usage');

  static Future<bool?> init() async => await _channel.invokeMethod('init');

  static Future<List<NetworkUsageModel>> networkUsageAndroid({
    bool withAppIcon = false,
    bool oldVersion = false,
    NetworkUsageType dataUsageType = NetworkUsageType.mobile,
  }) async {
    if (Platform.isAndroid) {
      final List<dynamic> dataUsage = await _channel.invokeMethod(
        oldVersion ? 'getNetworkUsageOld' : 'getNetworkUsage',
        <String, dynamic>{
          "withAppIcon": withAppIcon,
          "isWifi": dataUsageType == NetworkUsageType.wifi,
        },
      );
      return dataUsage
          .map((e) => NetworkUsageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      //Limit API to Android Platform
      print(
        PlatformException(
          code: 'NETWORK_USAGE',
          message:
              'This method can only be called on an android device use .dataUsageIOS() instead',
        ),
      );
      return [];
    }
  }

  /// Gets Data Usage From iOS Device as `Future<IOSDataUsageModel>`

  /// [WARNING]
  ///
  /// - This method will only get the total amounts of data transfered and received
  ///
  /// - Data resets after every reboot
  static Future<IOSNetworkUsageModel> networkUsageIOS() async {
    if (Platform.isIOS) {
      final data = await _channel.invokeMethod(
        'getNetworkUsage',
      );
      return IOSNetworkUsageModel.fromJson(Map<String, dynamic>.from(data));
    } else {
      //Limit API to iOS Platform
      throw PlatformException(
          code: 'NETWORK_USAGE',
          message:
              'This method can only be called on an ios device use .networkUsageAndroid() instead');
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await _channel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
