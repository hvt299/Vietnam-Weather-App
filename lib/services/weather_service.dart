import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://thoitiet.vn';

  WeatherModel? _parseWeather(String htmlString) {
    try {
      Document document = parser.parse(htmlString);

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
        var labels = detailBlock.querySelectorAll('.fw-bold.mb-1');
        for (var labelEl in labels) {
          String label = labelEl.text.trim();
          String value =
              labelEl.parent?.querySelector('.op-8')?.text.trim() ?? '--';
          details[label] = value;
        }
      }

      String rawRain = document.querySelector('.rain-volume')?.text ?? '0';
      String rainNumber = rawRain.replaceAll(RegExp(r'[^0-9.]'), '');
      if (rainNumber.isEmpty) rainNumber = '0';
      String rainVolume = '$rainNumber mm';

      var rainDescElements = document.querySelectorAll('.rain-desc p');
      String rainStatus = rainDescElements.isNotEmpty
          ? rainDescElements[0].text.trim()
          : 'Không mưa';

      String airQualityTitle =
          document.querySelector('.air-title')?.text.trim() ?? 'Đang cập nhật';
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
    } catch (e) {
      return null;
    }
  }

  Future<WeatherModel?> fetchWeatherBySlug(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cache_weather_$slug';

    try {
      final response = await _dio.get('$_baseUrl/$slug');
      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.data);
        return _parseWeather(response.data);
      }
    } catch (e) {
      String? cachedHtml = prefs.getString(cacheKey);
      if (cachedHtml != null) return _parseWeather(cachedHtml);
    }
    return null;
  }

  List<ForecastModel> _parseForecastList(String htmlString) {
    List<ForecastModel> list = [];
    Document document = parser.parse(htmlString);
    var elements = document.querySelectorAll('.weather-day');

    for (var element in elements) {
      String time =
          element.querySelector('.summary-day span')?.text.trim() ?? '';
      String minTemp =
          element
              .querySelector('.summary-temperature-min')
              ?.text
              .replaceAll('\n', '')
              .trim() ??
          '';
      String maxTemp =
          element
              .querySelector('.summary-temperature-max-value')
              ?.text
              .trim() ??
          '';
      String iconUrl =
          element.querySelector('.summary-img')?.attributes['src'] ?? '';
      String desc =
          element.querySelector('.summary-description-detail')?.text.trim() ??
          '';
      String humidity =
          element
              .querySelector('.summary-humidity span:last-child')
              ?.text
              .trim() ??
          '';
      String windSpeed =
          element
              .querySelector('.summary-speed span:last-child')
              ?.text
              .trim() ??
          '';

      if (time.isNotEmpty) {
        if (list.isNotEmpty && list.last.time == time) continue;
        list.add(
          ForecastModel(
            time: time,
            minTemp: minTemp,
            maxTemp: maxTemp,
            iconUrl: iconUrl,
            description: desc,
            humidity: humidity,
            windSpeed: windSpeed,
          ),
        );
      }
    }
    return list;
  }

  Future<List<ForecastModel>?> fetchHourlyForecast(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cache_hourly_$slug';

    try {
      final response = await _dio.get('$_baseUrl/$slug/theo-gio');
      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.data);
        return _parseForecastList(response.data);
      }
    } catch (e) {
      String? cachedHtml = prefs.getString(cacheKey);
      if (cachedHtml != null) return _parseForecastList(cachedHtml);
    }
    return null;
  }

  Future<List<ForecastModel>?> fetchDailyForecast(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cache_daily_$slug';

    try {
      final response = await _dio.get('$_baseUrl/$slug/30-ngay-toi');
      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.data);
        return _parseForecastList(response.data);
      }
    } catch (e) {
      String? cachedHtml = prefs.getString(cacheKey);
      if (cachedHtml != null) return _parseForecastList(cachedHtml);
    }
    return null;
  }
}
