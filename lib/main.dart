import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'providers/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi', null);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LocationProvider())],
      child: const VNWeatherApp(),
    ),
  );
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
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}
