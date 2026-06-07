class ForecastModel {
  final String time;
  final String minTemp;
  final String maxTemp;
  final String iconUrl;
  final String description;
  final String humidity;
  final String windSpeed;

  ForecastModel({
    required this.time,
    required this.minTemp,
    required this.maxTemp,
    required this.iconUrl,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  String toString() {
    return '🕒 $time | 🌡️ $minTemp - $maxTemp | ☁️ $description | 💧 $humidity | 💨 $windSpeed';
  }
}
