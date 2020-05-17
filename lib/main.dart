import 'package:flutter/material.dart';
import 'package:wallpaper_hub/views/home.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WallpaperHub',
      theme: ThemeData(primaryColor: Colors.white),
      home: Home(),
    );
  }
}
