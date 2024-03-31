import 'package:admin/controllers/LocationProvider.dart';
import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/controllers/SerialController.dart';
import 'package:admin/controllers/SettingsProvider.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delta',
      theme: ThemeData.light(),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
          ChangeNotifierProvider(
            create: (context) => LocationProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => SettingsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => SerialController(),
          ),
        ],
        child: MainScreen(),
      ),
    );
  }
}
