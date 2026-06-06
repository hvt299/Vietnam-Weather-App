import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const VNWeatherApp());
}

class VNWeatherApp extends StatelessWidget {
  const VNWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thời Tiết VN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Be Vietnam Pro',
      ),
      home: const HomeScreen(),
    );
  }
}
