import 'dart:ui';

import 'package:file_storage_mini_project/home/homePage.dart';
import 'package:flutter/material.dart';

import 'home/appTheme/appTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
        },
      ),
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.dartTheme(),
      home: Homepage(),
    );
  }
}
