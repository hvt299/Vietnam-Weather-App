import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isCelsius = true;

  bool get isCelsius => _isCelsius;
  String get unit => _isCelsius ? '°C' : '°F';

  SettingsProvider() {
    _loadSettingsFromPrefs();
  }

  Future<void> _loadSettingsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isCelsius = prefs.getBool('is_celsius') ?? true;
    notifyListeners();
  }

  Future<void> toggleTemperatureUnit() async {
    _isCelsius = !_isCelsius;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_celsius', _isCelsius);
    notifyListeners();
  }

  String convertTemp(String temp) {
    if (_isCelsius) return temp;

    final regex = RegExp(r'-?\d+');
    return temp
        .replaceAllMapped(regex, (match) {
          final c = int.tryParse(match.group(0) ?? '') ?? 0;
          final f = (c * 9 / 5).round() + 32;
          return f.toString();
        })
        .replaceAll('C', 'F')
        .replaceAll('c', 'f');
  }
}
