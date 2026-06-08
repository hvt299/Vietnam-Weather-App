class WeatherHelper {
  static String getWeatherEmoji(String description) {
    final desc = description.toLowerCase().trim();

    if (desc.contains('dông') ||
        desc.contains('sấm') ||
        desc.contains('chớp')) {
      return '⛈️';
    }

    if (desc.contains('mưa rào') || desc.contains('mưa to')) {
      return '🌧️';
    }

    if (desc.contains('mưa')) {
      return '🌦️';
    }

    if (desc.contains('nắng') ||
        desc.contains('quang mây') ||
        desc.contains('trời trong')) {
      return '☀️';
    }

    if (desc.contains('mây rải rác') || desc.contains('mây thưa')) {
      return '⛅';
    }

    if (desc.contains('nhiều mây') || desc.contains('âm u')) {
      return '☁️';
    }

    if (desc.contains('sương')) {
      return '🌫️';
    }

    return '🌤️';
  }
}
