import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vietnam_weather_app/main.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('vi', null);
  });

  testWidgets('VNWeatherApp renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const VNWeatherApp());

    expect(find.byType(VNWeatherApp), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
