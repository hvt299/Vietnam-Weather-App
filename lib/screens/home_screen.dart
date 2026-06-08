// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../utils/weather_helper.dart';
import '../utils/constants.dart';
import '../widgets/glass_card.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String? _lastSlug;

  WeatherModel? _currentWeather;
  List<ForecastModel>? _hourlyForecast;
  List<ForecastModel>? _dailyForecast;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentSlug = Provider.of<LocationProvider>(context).currentSlug;

    if (_lastSlug != currentSlug) {
      _lastSlug = currentSlug;
      _loadAllData(currentSlug);
    }
  }

  Future<void> _loadAllData(String slug) async {
    if (_currentWeather == null) {}

    bool hasInternet = true;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) hasInternet = false;
    } on SocketException catch (_) {
      hasInternet = false;
    }

    final results = await Future.wait([
      _weatherService.fetchWeatherBySlug(slug),
      _weatherService.fetchHourlyForecast(slug),
      _weatherService.fetchDailyForecast(slug),
    ]);

    setState(() {
      _currentWeather = results[0] as WeatherModel?;
      _hourlyForecast = results[1] as List<ForecastModel>?;
      _dailyForecast = results[2] as List<ForecastModel>?;
    });

    if (!hasInternet && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Đang ngoại tuyến. Hiển thị dữ liệu lưu tạm.'),
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
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    return DateFormat('EEEE, dd/MM - HH:mm', 'vi').format(now);
  }

  String _getCleanLocationName(String rawName) {
    return rawName.replaceAll('Dự báo thời tiết ', '').trim();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentWeather == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    String bgImage = provinceBackgrounds[_lastSlug] ?? defaultBackground;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Image.network(bgImage, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.black45,
              onRefresh: () => _loadAllData(_lastSlug ?? 'ha-noi'),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildMainWeather(),
                    const SizedBox(height: 40),
                    _buildHourlyChartCard(),
                    const SizedBox(height: 20),
                    _build7DaysForecastCard(),
                    const SizedBox(height: 20),
                    _buildFullDetailsGrid(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  _getCleanLocationName(_currentWeather!.locationName),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              toBeginningOfSentenceCase(_getCurrentDateTime()) ??
                  _getCurrentDateTime(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(LucideIcons.menu, color: Colors.white, size: 28),
          onPressed: () => _showLocationMenu(context),
        ),
      ],
    );
  }

  Widget _buildMainWeather() {
    String cleanFeelsLike = _currentWeather!.feelsLike
        .replaceAll('Cảm giác như ', '')
        .trim();
    if (cleanFeelsLike.endsWith('.')) {
      cleanFeelsLike = cleanFeelsLike.substring(0, cleanFeelsLike.length - 1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentWeather!.currentTemp.replaceAll('°', ''),
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const Text(
              '°C',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                height: 1.6,
              ),
            ),
          ],
        ),
        Text(
          '${WeatherHelper.getWeatherEmoji(_currentWeather!.weatherDesc)} ${_currentWeather!.weatherDesc}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.arrow_upward, color: Colors.white70, size: 16),
            Text(
              _currentWeather!.details['Thấp/Cao']?.split('/').last ?? '--',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_downward, color: Colors.white70, size: 16),
            Text(
              _currentWeather!.details['Thấp/Cao']?.split('/').first ?? '--',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Cảm giác như $cleanFeelsLike',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildHourlyChartCard() {
    if (_hourlyForecast == null || _hourlyForecast!.isEmpty) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 16.0),
            child: Text(
              'Dự báo 24 giờ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _hourlyForecast!.take(24).length,
              itemBuilder: (context, index) {
                final forecast = _hourlyForecast![index];
                return SizedBox(
                  width: 65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        forecast.time,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        WeatherHelper.getWeatherEmoji(forecast.description),
                        style: const TextStyle(fontSize: 26),
                      ),
                      Text(
                        forecast.minTemp,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 2,
                            color: index == 0
                                ? Colors.transparent
                                : Colors.white24,
                          ),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 2,
                            color: index == 23
                                ? Colors.transparent
                                : Colors.white24,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: Colors.lightBlueAccent,
                            size: 12,
                          ),
                          Text(
                            forecast.humidity,
                            style: const TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _build7DaysForecastCard() {
    if (_dailyForecast == null || _dailyForecast!.isEmpty) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7 Ngày Tới',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _dailyForecast!.take(7).length,
            itemBuilder: (context, index) {
              final forecast = _dailyForecast![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        forecast.time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text(
                            WeatherHelper.getWeatherEmoji(forecast.description),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.water_drop,
                            color: Colors.lightBlueAccent,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            forecast.humidity,
                            style: const TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            forecast.minTemp.replaceAll('C', ''),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            forecast.maxTemp
                                .replaceAll('/', '')
                                .replaceAll('C', '')
                                .trim(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(color: Colors.white24, height: 24),
          Center(
            child: InkWell(
              onTap: () => _showDetailedForecast(context),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Xem tất cả 30 ngày',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.chevron_right, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullDetailsGrid() {
    final details = _currentWeather!.details;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _detailBox('Độ ẩm', details['Độ ẩm'] ?? '--', Icons.water_drop),
        _detailBox('Tầm nhìn', details['Tầm nhìn'] ?? '--', Icons.visibility),
        _detailBox('Gió', details['Gió'] ?? '--', Icons.air),

        _detailBox(
          'Chỉ số UV',
          details.entries
              .firstWhere(
                (e) => e.key.contains('UV'),
                orElse: () => const MapEntry('', '--'),
              )
              .value,
          Icons.wb_sunny,
        ),

        _detailBox(
          'Điểm ngưng',
          details['Điểm ngưng'] ?? '--',
          Icons.thermostat,
        ),
        _detailBox('Lượng mưa', _currentWeather!.rainVolume, Icons.umbrella),
        _detailBox(
          'KK',
          _currentWeather!.airQualityTitle.replaceAll(
            'Chất lượng không khí: ',
            '',
          ),
          Icons.eco,
        ),
      ],
    );
  }

  Widget _detailBox(String title, String value, IconData icon) {
    return Container(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
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

  void _showDetailedForecast(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E24),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
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
                'Dự Báo 30 Ngày',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: _dailyForecast?.length ?? 0,
                  itemBuilder: (context, index) {
                    final forecast = _dailyForecast![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              forecast.time,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              WeatherHelper.getWeatherEmoji(
                                forecast.description,
                              ),
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  forecast.minTemp,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  forecast.maxTemp.replaceAll('/', '').trim(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void _showLocationMenu(BuildContext context) {
  final provider = context.read<LocationProvider>();
  final savedSlugs = provider.savedSlugs;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
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

            ListTile(
              leading: const Icon(
                LucideIcons.navigation,
                color: Colors.blueAccent,
              ),
              title: const Text(
                'Vị trí hiện tại của tôi',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () async {
                Navigator.pop(context);

                String? errorMessage = await provider
                    .fetchCurrentDeviceLocation();

                if (errorMessage != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(child: Text(errorMessage)),
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

            const Divider(color: Colors.white24, indent: 20, endIndent: 20),

            if (savedSlugs.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Chưa có địa điểm nào được lưu.',
                  style: TextStyle(color: Colors.white54),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: savedSlugs.length,
                  itemBuilder: (context, index) {
                    String slug = savedSlugs[index];
                    String provinceName = provincesMap.entries
                        .firstWhere(
                          (entry) => entry.value == slug,
                          orElse: () => MapEntry(slug, slug),
                        )
                        .key;

                    bool isCurrent = provider.currentSlug == slug;

                    return ListTile(
                      leading: Icon(
                        Icons.favorite,
                        color: isCurrent ? Colors.blueAccent : Colors.redAccent,
                      ),
                      title: Text(
                        provinceName,
                        style: TextStyle(
                          color: isCurrent ? Colors.blueAccent : Colors.white,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isCurrent
                          ? const Icon(Icons.check, color: Colors.blueAccent)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        provider.changeLocation(slug);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      );
    },
  );
}
