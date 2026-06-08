// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E3A5F), Color(0xFF0F172A)],
              ),
            ),
          ),
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cài đặt',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),

                  _buildSectionTitle('Cấu hình hệ thống'),
                  const SizedBox(height: 10),
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            LucideIcons.thermometer,
                            color: Colors.white70,
                          ),
                          title: const Text(
                            'Đơn vị nhiệt độ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          trailing: Text(
                            settingsProvider.isCelsius
                                ? 'Celsius (°C)'
                                : 'Fahrenheit (°F)',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () => settingsProvider.toggleTemperatureUnit(),
                        ),
                        const Divider(
                          color: Colors.white10,
                          height: 1,
                          indent: 56,
                        ),
                        ListTile(
                          leading: const Icon(
                            LucideIcons.languages,
                            color: Colors.white70,
                          ),
                          title: const Text(
                            'Ngôn ngữ hệ thống',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          trailing: const Text(
                            'Tiếng Việt',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  _buildSectionTitle('Thông tin ứng dụng'),
                  const SizedBox(height: 10),
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(
                            LucideIcons.info,
                            color: Colors.white70,
                          ),
                          title: Text(
                            'Phiên bản ứng dụng',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          trailing: Text(
                            'v1.0.0 (Release)',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white10,
                          height: 1,
                          indent: 56,
                        ),
                        const ListTile(
                          leading: Icon(
                            LucideIcons.heart,
                            color: Colors.white70,
                          ),
                          title: Text(
                            'Đội ngũ phát triển',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          trailing: Text(
                            'VN Weather Team',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
