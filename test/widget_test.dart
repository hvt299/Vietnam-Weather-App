import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:vietnam_weather_app/main.dart';
import 'package:vietnam_weather_app/providers/location_provider.dart';
import 'package:vietnam_weather_app/providers/settings_provider.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('vi', null);
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('VNWeatherApp renders successfully', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: const MediaQuery(
            data: MediaQueryData(size: Size(375, 812)),
            child: VNWeatherApp(),
          ),
        ),
      );

      await tester.pump();

      await tester.pump(const Duration(seconds: 2));
    });

    expect(find.byType(VNWeatherApp), findsOneWidget);
  });
}
