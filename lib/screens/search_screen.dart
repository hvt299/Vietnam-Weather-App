// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/constants.dart';
import '../widgets/glass_card.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onNavigateHome;
  const SearchScreen({super.key, required this.onNavigateHome});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _regionNames = regionsMap.keys.toList();
  String _selectedRegion = 'Đông Bắc Bộ';

  String _searchQuery = '';
  List<String> _searchResults = [];

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = provincesMap.keys
            .where(
              (province) =>
                  province.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quản lý địa điểm',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_searchQuery.isNotEmpty)
                  Expanded(child: _buildSearchResults())
                else
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRegionTabBar(),
                        const SizedBox(height: 16),
                        Expanded(child: _buildProvinceGrid()),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Tìm kiếm tỉnh/thành phố...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            LucideIcons.search,
            color: Colors.white.withOpacity(0.7),
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildRegionTabBar() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _regionNames.length,
        itemBuilder: (context, index) {
          final region = _regionNames[index];
          final isSelected = _selectedRegion == region;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedRegion = region;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  region,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProvinceGrid() {
    final provincesInRegion = regionsMap[_selectedRegion] ?? [];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: provincesInRegion.length,
      itemBuilder: (context, index) {
        final provinceName = provincesInRegion[index];
        final slug = provincesMap[provinceName] ?? '';
        final bgImage = provinceBackgrounds[slug] ?? defaultBackground;

        return _buildCityCard(provinceName, bgImage, slug);
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'Không tìm thấy "$_searchQuery"',
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final provinceName = _searchResults[index];
        final slug = provincesMap[provinceName] ?? '';
        final bgImage = provinceBackgrounds[slug] ?? defaultBackground;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            height: 100,
            child: _buildCityCard(provinceName, bgImage, slug),
          ),
        );
      },
    );
  }

  Widget _buildCityCard(String name, String imageUrl, String slug) {
    final savedSlugs = context.watch<LocationProvider>().savedSlugs;
    final isSaved = savedSlugs.contains(slug);

    return GestureDetector(
      onTap: () {
        context.read<LocationProvider>().changeLocation(slug);
        widget.onNavigateHome();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => context.read<LocationProvider>().toggleSave(slug),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? Colors.redAccent : Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
