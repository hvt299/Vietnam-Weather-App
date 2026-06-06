import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import '../models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://thoitiet.vn';

  Future<WeatherModel?> fetchWeatherBySlug(String slug) async {
    try {
      final response = await _dio.get('$_baseUrl/$slug');

      if (response.statusCode == 200) {
        Document document = parser.parse(response.data);

        String locationName =
            document.querySelector('.location-name-main a')?.text.trim() ??
            'Không rõ';
        String currentTemp =
            document.querySelector('.current-temperature')?.text.trim() ?? '--';
        String weatherDesc =
            document
                .querySelector('.overview-caption-item-detail')
                ?.text
                .trim() ??
            '--';
        String feelsLike =
            document
                .querySelector('.overview-caption-summary-detail')
                ?.text
                .trim() ??
            '--';

        Map<String, String> details = {};
        var detailBlock = document.querySelector('.weather-detail');
        if (detailBlock != null) {
          var detailElements = detailBlock.querySelectorAll(
            '.d-flex.ml-2, .d-flex > .flex-1',
          );
          for (var element in detailElements) {
            var label = element.querySelector('.fw-bold.mb-1')?.text.trim();
            var value = element
                .querySelector('.text-white.op-8.fw-bold')
                ?.text
                .trim();
            if (label != null && value != null) details[label] = value;
          }
        }

        String rainVolume =
            document
                .querySelector('.rain-volume')
                ?.text
                .replaceAll('\n', '')
                .trim() ??
            '0 mm';
        var rainDescElements = document.querySelectorAll('.rain-desc p');
        String rainStatus = rainDescElements.isNotEmpty
            ? rainDescElements[0].text.trim()
            : 'Không mưa';

        String airQualityTitle =
            document.querySelector('.air-title')?.text.trim() ??
            'Đang cập nhật';
        Map<String, String> airComponents = {};
        var airComponentElements = document.querySelectorAll(
          '.air-components > div',
        );
        for (var element in airComponentElements) {
          var label = element.querySelector('.fw-bold.mb-1')?.text.trim();
          var value = element.querySelector('.text-white')?.text.trim();
          if (label != null && value != null) airComponents[label] = value;
        }

        return WeatherModel(
          locationName: locationName,
          currentTemp: currentTemp,
          weatherDesc: weatherDesc,
          feelsLike: feelsLike,
          details: details,
          rainVolume: rainVolume,
          rainStatus: rainStatus,
          airQualityTitle: airQualityTitle,
          airComponents: airComponents,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
