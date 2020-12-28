import 'package:Irrigation/models/provider.dart';
import 'package:Irrigation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/provider.dart';

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
        ),
      ],
      child: MaterialApp(
          title: 'Smart Control',
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
