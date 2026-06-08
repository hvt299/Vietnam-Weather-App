// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_weather_app/providers/settings_provider.dart';
import '../providers/location_provider.dart';
import '../data/islands_data.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../utils/weather_helper.dart';

class CentralCity {
  final String name;
  final String slug;
  final LatLng location;

  const CentralCity(this.name, this.slug, this.location);
}

const List<CentralCity> targetCities = [
  CentralCity('Hà Nội', 'ha-noi', LatLng(21.0285, 105.8542)),
  CentralCity('Hải Phòng', 'hai-phong', LatLng(20.8449, 106.6881)),
  CentralCity('Huế', 'thua-thien-hue', LatLng(16.4637, 107.5909)),
  CentralCity('Đà Nẵng', 'da-nang', LatLng(16.0471, 108.2062)),
  CentralCity('Đồng Nai', 'dong-nai', LatLng(10.9488, 106.8166)),
  CentralCity('Hồ Chí Minh', 'ho-chi-minh', LatLng(10.8231, 106.6297)),
  CentralCity('Cần Thơ', 'can-tho', LatLng(10.0452, 105.7469)),
];

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  double _currentZoom = 5.5;
  String? _lastTrackedSlug;
  int _citySwitcher = 0;
  Timer? _cityTimer;

  final LatLng _hanoiFallback = const LatLng(21.0285, 105.8542);

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final WeatherService _weatherService = WeatherService();
  final Map<String, WeatherModel> _cityWeathers = {};
  final Set<String> _animatedVisibleCities = {};

  final Map<String, String> _mapLayers = {
    'Bản đồ Sáng (Voyager)':
        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    'Bản đồ Tối (Dark Matter)':
        'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
    'Đơn giản (Positron)':
        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
    'Vệ tinh (Satellite)':
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  };
  String _selectedLayerName = 'Bản đồ Sáng (Voyager)';

  @override
  void initState() {
    super.initState();

    _cityTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;

      setState(() {
        _citySwitcher++;
      });
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadCitiesWeatherSequentially();
  }

  Future<void> _loadCitiesWeatherSequentially() async {
    for (int i = 0; i < targetCities.length; i++) {
      final city = targetCities[i];
      try {
        final weather = await _weatherService.fetchWeatherBySlug(city.slug);
        if (weather != null && mounted) {
          setState(() {
            _cityWeathers[city.slug] = weather;
          });

          await Future.delayed(const Duration(milliseconds: 250));
          if (mounted) {
            setState(() {
              _animatedVisibleCities.add(city.slug);
            });
          }
        }
      } catch (_) {}
    }
  }

  LatLng _getCoordinatesFromSlug(String slug) {
    for (var city in targetCities) {
      if (city.slug == slug) return city.location;
    }
    return _hanoiFallback;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    _cityTimer?.cancel();
    super.dispose();
  }

  void _zoomIn() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom + 1,
    );
  }

  void _zoomOut() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom - 1,
    );
  }

  bool shouldShowCity(CentralCity city) {
    final pairIndex = _citySwitcher % 2;
    final tripleIndex = _citySwitcher % 3;

    switch (city.slug) {
      case 'ha-noi':
        return pairIndex == 0;

      case 'hai-phong':
        return pairIndex == 1;

      case 'thua-thien-hue':
        return pairIndex == 0;

      case 'da-nang':
        return pairIndex == 1;

      case 'ho-chi-minh':
        return tripleIndex == 0;

      case 'dong-nai':
        return tripleIndex == 1;

      case 'can-tho':
        return tripleIndex == 2;

      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final settings = context.watch<SettingsProvider>();
    final activeSlug = locationProvider.currentSlug;
    final LatLng activeUserLocation = _getCoordinatesFromSlug(activeSlug);

    if (_lastTrackedSlug != activeSlug) {
      _lastTrackedSlug = activeSlug;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(activeUserLocation, 8.5);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: activeUserLocation,
              initialZoom: _currentZoom,
              minZoom: 4.0,
              maxZoom: 18.0,
              onPositionChanged: (position, hasGesture) {
                if (position.zoom != _currentZoom) {
                  setState(() {
                    _currentZoom = position.zoom;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _mapLayers[_selectedLayerName]!,
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.vn_weather_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: activeUserLocation,
                    width: 60,
                    height: 60,
                    child: _buildPulsingUserMarker(),
                  ),

                  ...targetCities.map((city) {
                    final weather = _cityWeathers[city.slug];
                    if (!shouldShowCity(city)) {
                      return Marker(
                        point: city.location,
                        width: 0,
                        height: 0,
                        child: const SizedBox(),
                      );
                    }

                    if (weather == null) {
                      return Marker(
                        point: city.location,
                        width: 0,
                        height: 0,
                        child: const SizedBox(),
                      );
                    }

                    bool isAnimatedIn = _animatedVisibleCities.contains(
                      city.slug,
                    );

                    return Marker(
                      point: city.location,
                      width: 100,
                      height: 70,
                      child: GestureDetector(
                        onTap: () {
                          _showWeatherDetail(context, city, weather);
                        },
                        child: AnimatedOpacity(
                          opacity: isAnimatedIn ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            margin: EdgeInsets.only(
                              bottom: isAnimatedIn ? 0 : 15,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  city.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF334155),
                                    shadows: [
                                      Shadow(
                                        color: Colors.white,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.95),
                                        Colors.blue.shade50.withOpacity(0.9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.blueAccent.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        WeatherHelper.getWeatherEmoji(
                                          weather.weatherDesc,
                                        ),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        settings
                                            .convertTemp(weather.currentTemp)
                                            .replaceAll(RegExp(r'[CF]'), ''),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  if (_currentZoom >= 5.0)
                    ...archipelagos.map(
                      (arch) => Marker(
                        point: arch.location,
                        width: 200,
                        height: 40,
                        child: Center(
                          child: Text(
                            arch.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (_currentZoom >= 7.0)
                    ...vnIslands.map(
                      (island) => Marker(
                        point: island.location,
                        width: 14,
                        height: 14,
                        child: GestureDetector(
                          onTap: () => _showIslandDetailDialog(context, island),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: GestureDetector(
              onTap: () => _showMapLayerOptions(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.layers,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedLayerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                _buildMapButton(icon: LucideIcons.plus, onTap: _zoomIn),
                const SizedBox(height: 8),
                _buildMapButton(icon: LucideIcons.minus, onTap: _zoomOut),
                const SizedBox(height: 8),
                _buildMapButton(
                  icon: LucideIcons.navigation,
                  color: Colors.blueAccent,
                  iconColor: Colors.white,
                  onTap: () async {
                    String? errorMessage = await locationProvider
                        .fetchCurrentDeviceLocation();

                    if (errorMessage != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xE62E3138),
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingUserMarker() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 24 * _pulseAnimation.value,
              height: 24 * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.3),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
    Color iconColor = Colors.black87,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

  void _showIslandDetailDialog(BuildContext context, Island island) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  island.nameVi,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${island.nameEn} — ${island.regionEn}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: island.occupied
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: island.occupied
                              ? Colors.redAccent.shade700
                              : Colors.green.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        island.occupied
                            ? 'Đang bị chiếm đóng'
                            : 'Việt Nam quản lý',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: island.occupied
                              ? Colors.redAccent.shade700
                              : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Các bên tranh chấp:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  island.claimants,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  island.desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Đóng'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWeatherDetail(
    BuildContext context,
    CentralCity city,
    WeatherModel weather,
  ) {
    final settings = context.read<SettingsProvider>();
    final details = weather.details;
    final uvIndex = details.entries
        .firstWhere(
          (e) => e.key.contains('UV'),
          orElse: () => const MapEntry('', '--'),
        )
        .value;
    final airQuality = weather.airQualityTitle.replaceAll(
      'Chất lượng không khí: ',
      '',
    );

    String cleanFeelsLike = settings
        .convertTemp(weather.feelsLike)
        .replaceAll('Cảm giác như ', '')
        .trim();
    if (cleanFeelsLike.endsWith('.')) {
      cleanFeelsLike = cleanFeelsLike.substring(0, cleanFeelsLike.length - 1);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.only(
            top: 12,
            left: 20,
            right: 20,
            bottom: 40,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E24),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                city.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings
                        .convertTemp(weather.currentTemp)
                        .replaceAll(RegExp(r'[°CF]'), ''),
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    settings.unit,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              Text(
                '${WeatherHelper.getWeatherEmoji(weather.weatherDesc)} ${weather.weatherDesc}',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    color: Colors.white70,
                    size: 16,
                  ),
                  Text(
                    settings.convertTemp(
                      details['Thấp/Cao']?.split('/').last ?? '--',
                    ),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.white70,
                    size: 16,
                  ),
                  Text(
                    settings.convertTemp(
                      details['Thấp/Cao']?.split('/').first ?? '--',
                    ),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Cảm giác như $cleanFeelsLike',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildMiniDetailBox(
                    'Độ ẩm',
                    details['Độ ẩm'] ?? '--',
                    Icons.water_drop,
                    context,
                  ),
                  _buildMiniDetailBox(
                    'Gió',
                    details['Gió'] ?? '--',
                    Icons.air,
                    context,
                  ),
                  _buildMiniDetailBox(
                    'Tầm nhìn',
                    details['Tầm nhìn'] ?? '--',
                    Icons.visibility,
                    context,
                  ),
                  _buildMiniDetailBox(
                    'Chỉ số UV',
                    uvIndex,
                    Icons.wb_sunny,
                    context,
                  ),
                  _buildMiniDetailBox(
                    'Lượng mưa',
                    weather.rainVolume,
                    Icons.umbrella,
                    context,
                  ),
                  _buildMiniDetailBox('KK', airQuality, Icons.eco, context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniDetailBox(
    String title,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    return Container(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white54, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMapLayerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 12, bottom: 30),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E24),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Lớp Bản Đồ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._mapLayers.keys.map((layerName) {
                bool isSelected = _selectedLayerName == layerName;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? Colors.blueAccent : Colors.white54,
                  ),
                  title: Text(
                    layerName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedLayerName = layerName;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
