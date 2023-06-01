import 'dart:io';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_usage/network_usage_method_channel.dart';
import 'dart:async';
import 'package:network_usage/src/model/ios_network_usage_model.dart';
import 'package:network_usage/src/model/network_usage_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<NetworkUsageModel> _dataUsage = [];
  IOSNetworkUsageModel _dataiOSUsage = IOSNetworkUsageModel();

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      List<NetworkUsageModel> networkUsage;
      try {
        print('''AndroidNetworkUsage''');

        print(await MethodChannelNetworkUsage.init());

        networkUsage = await MethodChannelNetworkUsage.networkUsageAndroid(
          withAppIcon: true,
          dataUsageType: NetworkUsageType.wifi,
        );

        print(networkUsage);
        setState(() {
          _dataUsage = networkUsage;
        });
      } catch (e) {
        print(e.toString());
      }
    } else if (Platform.isIOS) {
      IOSNetworkUsageModel networkIOSUsage;
      try {
        print('''IOSNetworkUsage''');



        networkIOSUsage = await MethodChannelNetworkUsage.networkUsageIOS();

        print(networkIOSUsage);
        setState(() {
          _dataiOSUsage = networkIOSUsage;
        });
      } catch (e) {
        print(e.toString());
      }
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Usage Plugin Example'),
      ),
      body: Center(
        child: Platform.isAndroid
            ? Android(
                dataUsage: _dataUsage,
                size: size,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _dataiOSUsage
                        ?.toJson()
                        ?.entries
                        ?.map((e) => Text(
                              '${e.key}: ${e.value}',
                              overflow: TextOverflow.ellipsis,
                            ))
                        ?.toList() ??
                    []),
      ),
    );
  }
}

class Android extends StatelessWidget {
  const Android({
    super.key,
    required this.size,
    required this.dataUsage,
  });

  final List<NetworkUsageModel> dataUsage;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (dataUsage != null)
          for (var item in dataUsage) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  if (item.appIconBytes != null)
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(item.appIconBytes!),
                        ),
                      ),
                    ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.7,
                        child: Text(
                          '${item.appName}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: size.width * 0.7,
                        child: Text(
                          '${item.packageName}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Received: ${(item.received! / 1048576).toStringAsFixed(4)}MB  ',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13),
                          ),
                          Text(
                            'Sent: ${(item.sent! / 1048576).toStringAsFixed(4)}MB',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider()
          ]
      ],
    );
  }
}
