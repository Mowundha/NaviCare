import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late List<Place> _allPlaces;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final _categories = ['All', 'Hotels', 'Restaurants'];

  @override
  void initState() {
    super.initState();
    // Combined mock data spanning all categories to ensure every filter option has items
    _allPlaces = [
      ...MockData.hotels.map((h) => h.copyWith()),
      ...MockData.restaurants.map((r) => r.copyWith()),
    ];
  }

  void _toggleSave(int index) {
    setState(() {
      _allPlaces[index] = _allPlaces[index].copyWith(isSaved: !_allPlaces[index].isSaved);
    });
  }

  List<Place> get _filteredPlaces {
    var result = _allPlaces;
    if (_selectedCategory != 'All') {
      final typeMap = {
        'Hotels': 'hotel',
        'Restaurants': 'restaurant',
      };
      final type = typeMap[_selectedCategory];
      if (type != null) {
        result = result.where((p) => p.type.toLowerCase() == type).toList();
      }
    }
    if (_searchQuery.isNotEmpty) {
      result = result.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildSearch(context),
            const SizedBox(height: 14),
            _buildCategories(),
            const SizedBox(height: 14),
            Expanded(
              child: _filteredPlaces.isEmpty
                  ? const EmptyState(
                      icon: Icons.explore_outlined,
                      title: 'No places found',
                      subtitle: 'Try a different category or search term',
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58, // Adjusted height ratio to prevent overflow
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, i) {
                        final place = _filteredPlaces[i];
                        final originalIndex = _allPlaces.indexOf(place);
                        return PlaceCard(
                          place: place,
                          width: double.infinity,
                          onSave: () => _toggleSave(originalIndex),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: const Icon(Icons.explore, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          const Text(
            'Explore Nearby',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppTheme.neutral900,
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: const Icon(Icons.map_outlined, color: AppTheme.neutral700, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppTheme.neutral400, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: const InputDecoration(
                  hintText: 'Search places near you...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppTheme.neutral400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const Icon(Icons.tune, color: AppTheme.neutral400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => CategoryChip(
          label: _categories[i],
          selected: _selectedCategory == _categories[i],
          onTap: () => setState(() => _selectedCategory = _categories[i]),
        ),
      ),
    );
  }
}