# network_usage
[Data Usage](https://github.com/Zfinix/data_usage/blob/main/README.md) is currently under maintained.
This a refactored lib for [Data Usage](https://github.com/Zfinix/data_usage/blob/main/README.md)

## Getting Started

### Usage for Android

- Initialize plugin and requests for permission
- Request Data usage stats

   ```dart
     NetworkUsageModel.init() // Only Required for Android
     List<NetworkUsageModel> networkUsage = await MethodChannelNetworkUsage.networkUsageAndroid(
          withAppIcon: true,
          dataUsageType: NetworkUsageType.wifi,
          oldVersion: false // will be true for Android versions lower than 23 (MARSHMELLOW)
        );
   ```

This would return:

   ```dart
      [   ...,
          NetworkUsageModel({
               String appName; //App's Name
               String packageName; // App's package name
               Uint8List appIconBytes; // Icon in bytes
               int received; // Amount of data Received
               int sent; // Amount of data sent/transferred
         })
      ]
   ```

[For more explanation](https://stackoverflow.com/questions/17674790/how-do-i-programmatically-show-data-usage-of-all-applications/29084035)



### Usage for iOS

Request for Total data usage on iOS devices

   ```dart
     IOSNetworkUsageModel  networkIOSUsage = await MethodChannelNetworkUsage.networkUsageIOS();

   ```

This would return:

   ```dart
     IOSNetworkUsageModel({
        int wifiCompelete, // Total Amount of wifi data (received + sent)
        int wifiReceived, // Amount of wifi data Received
        int wifiSent, // Amount of data sent/transferred
        int wwanCompelete, // Total Amount of mobile data (received + sent)
        int wwanReceived, // Amount of mobile data Received
        int wwanSent // Amount of data sent/transferred
     });
   ```