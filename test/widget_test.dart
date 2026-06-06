import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_weather_app/main.dart';

void main() {
  testWidgets('App should render HomeScreen properly smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VNWeatherApp());

    await tester.pumpAndSettle();

    expect(find.text('Thời Tiết Việt Nam'), findsOneWidget);

    expect(find.text('Tìm kiếm tỉnh/thành...'), findsOneWidget);

    expect(find.text('0'), findsNothing);
  });
}
