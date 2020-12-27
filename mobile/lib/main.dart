import 'package:Irrigation/device_card.dart';
import 'package:Irrigation/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DevicesManager(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
          title: 'Irrigation',
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: Home()),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DevicesManager>(
      builder: (_, devicesManager, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Irrigation"),
            centerTitle: true,
          ),
          body: Container(
            child: RefreshIndicator(
              onRefresh: () async {
                Future.delayed(Duration(seconds: 2));
                devicesManager.getDevices();
              },
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: devicesManager.devices
                    .map((e) => DeviceCard(
                          device: e,
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
