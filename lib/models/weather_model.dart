class WeatherModel {
  final String locationName;
  final String currentTemp;
  final String weatherDesc;
  final String feelsLike;
  final Map<String, String> details;
  final String rainVolume;
  final String rainStatus;
  final String airQualityTitle;
  final Map<String, String> airComponents;

  WeatherModel({
    required this.locationName,
    required this.currentTemp,
    required this.weatherDesc,
    required this.feelsLike,
    required this.details,
    required this.rainVolume,
    required this.rainStatus,
    required this.airQualityTitle,
    required this.airComponents,
  });

  @override
  String toString() {
    return 'Trạm: $locationName | Nhiệt độ: $currentTemp ($feelsLike) | Mưa: $rainVolume';
  }
}
