// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'map_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    const HomeScreen(),
    SearchScreen(
      onNavigateHome: () {
        setState(() => _currentIndex = 0);
      },
    ),
    const MapScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isLightTab = _currentIndex == 2;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isLightTab
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isLightTab
                    ? Colors.white.withOpacity(0.85)
                    : Colors.white.withOpacity(0.08),
                border: Border(
                  top: BorderSide(
                    color: isLightTab
                        ? Colors.black.withOpacity(0.1)
                        : Colors.white.withOpacity(0.12),
                    width: 1,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },

                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,

                selectedItemColor: isLightTab
                    ? Colors.blueAccent.shade700
                    : Colors.white,
                unselectedItemColor: isLightTab
                    ? Colors.black45
                    : Colors.white54,

                selectedFontSize: 12,
                unselectedFontSize: 12,

                showSelectedLabels: true,
                showUnselectedLabels: false,

                selectedIconTheme: const IconThemeData(size: 28),
                unselectedIconTheme: const IconThemeData(size: 22),

                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.cloudSun),
                    label: 'Thời tiết',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.search),
                    label: 'Tìm kiếm',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.map),
                    label: 'Bản đồ',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.settings),
                    label: 'Cài đặt',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
