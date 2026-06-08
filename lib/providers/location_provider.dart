// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  String _currentSlug = 'ha-noi';
  List<String> _savedSlugs = [];

  String get currentSlug => _currentSlug;
  List<String> get savedSlugs => _savedSlugs;

  LocationProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _currentSlug = prefs.getString('current_location') ?? 'ha-noi';
    _savedSlugs = prefs.getStringList('saved_locations') ?? [];
    notifyListeners();
  }

  Future<void> changeLocation(String slug) async {
    if (_currentSlug == slug) return;
    _currentSlug = slug;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_location', slug);
    notifyListeners();
  }

  Future<void> toggleSave(String slug) async {
    if (_savedSlugs.contains(slug)) {
      _savedSlugs.remove(slug);
    } else {
      _savedSlugs.add(slug);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_locations', _savedSlugs);
    notifyListeners();
  }

  Future<String?> fetchCurrentDeviceLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await changeLocation('ha-noi');
      return 'Dịch vụ vị trí đang tắt. Hệ thống tự động chuyển về Hà Nội.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await changeLocation('ha-noi');
        return 'Quyền vị trí bị từ chối. Hệ thống tự động chuyển về Hà Nội.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await changeLocation('ha-noi');
      return 'Quyền vị trí bị chặn vĩnh viễn. Hệ thống tự động chuyển về Hà Nội.';
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String adminArea = placemarks.first.administrativeArea ?? '';
        String slug = _convertToSlug(adminArea);

        if (slug.isNotEmpty) {
          await changeLocation(slug);
          return null;
        }
      }
      await changeLocation('ha-noi');
      return 'Không xác định được thực thể tỉnh thành. Chuyển về Hà Nội.';
    } catch (e) {
      await changeLocation('ha-noi');
      return 'Không thể xác định vị trí. Đã chuyển về Hà Nội.';
    }
  }

  String _convertToSlug(String text) {
    var withDia =
        'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ';
    var withoutDia =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    String result = text.toLowerCase();
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    result = result.replaceAll('thanh pho ', '').replaceAll('tinh ', '').trim();
    return result.replaceAll(RegExp(r'\s+'), '-');
  }
}
