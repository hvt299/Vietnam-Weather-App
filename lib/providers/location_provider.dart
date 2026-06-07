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
      return 'Vui lòng bật Dịch vụ vị trí (GPS) trên thiết bị của bạn.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Bạn đã từ chối quyền truy cập vị trí. Không thể lấy tọa độ.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Quyền vị trí bị từ chối vĩnh viễn. Vui lòng vào Cài đặt máy để mở lại.';
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
          changeLocation(slug);
          return null;
        }
      }
      return 'Không thể xác định được tỉnh/thành phố hiện tại.';
    } catch (e) {
      return 'Đã xảy ra lỗi khi lấy vị trí: $e';
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
