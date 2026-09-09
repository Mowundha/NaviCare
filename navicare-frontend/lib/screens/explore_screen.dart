import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../models/models.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late List<Place> _allPlaces;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final _categories = ['All', 'Hotels', 'Restaurants', 'Cafes', 'Attractions'];

  final _categoryIcons = {
    'All': Icons.apps_rounded,
    'Hotels': Icons.hotel_rounded,
    'Restaurants': Icons.restaurant_rounded,
    'Cafes': Icons.local_cafe_rounded,
    'Attractions': Icons.attractions_rounded,
  };

  @override
  void initState() {
    super.initState();
    _allPlaces = [
      ...MockData.hotels.map((h) => h.copyWith()),
      ...MockData.restaurants.map((r) => r.copyWith()),
      ...MockData.cafes.map((c) => c.copyWith()),
      ...MockData.attractions.map((a) => a.copyWith()),
      // Extra Chennai accessible places
      const Place(
        id: 'ch1', name: 'Marina Beach Cafe', type: 'restaurant', rating: 4.3, reviewCount: 89,
        priceDisplay: '', priceRange: '₹', cuisineType: 'South Indian',
        accessibilityFeatures: ['Wheelchair Ramp', 'Accessible Restroom'],
        imageUrl: 'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg?w=600',
        location: 'Marina Beach, Chennai', isSaved: false, distanceKm: 1.2,
      ),
      const Place(
        id: 'ch2', name: 'Taj Coromandel', type: 'hotel', rating: 4.9, reviewCount: 412,
        priceDisplay: '₹8,000 / night',
        accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Pool', 'Accessible Restroom'],
        imageUrl: 'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?w=600',
        location: 'Nungambakkam, Chennai', isSaved: false, distanceKm: 3.5,
      ),
      const Place(
        id: 'ch3', name: 'Government Museum', type: 'attraction', rating: 4.4, reviewCount: 198,
        priceDisplay: '₹15 per person',
        accessibilityFeatures: ['Wheelchair Access', 'Ramp', 'Accessible Restroom', 'Audio Guide'],
        imageUrl: 'https://images.pexels.com/photos/3683048/pexels-photo-3683048.jpeg?w=600',
        location: 'Egmore, Chennai', isSaved: false, distanceKm: 4.1,
      ),
      const Place(
        id: 'ch4', name: 'Sangeetha Restaurants', type: 'restaurant', rating: 4.5, reviewCount: 267,
        priceDisplay: '', priceRange: '₹', cuisineType: 'South Indian',
        accessibilityFeatures: ['Wheelchair Access', 'Accessible Seating'],
        imageUrl: 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=600',
        location: 'T. Nagar, Chennai', isSaved: false, distanceKm: 2.8,
      ),
      const Place(
        id: 'ch5', name: 'Amethyst Cafe', type: 'cafe', rating: 4.6, reviewCount: 143,
        priceDisplay: '', priceRange: '₹₹', cuisineType: 'Continental & Coffee',
        accessibilityFeatures: ['Wheelchair Access', 'Step-free Entry', 'Accessible Restroom'],
        imageUrl: 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?w=600',
        location: 'Gopalapuram, Chennai', isSaved: false, distanceKm: 5.2,
      ),
      const Place(
        id: 'ch6', name: 'Kapaleeshwarar Temple', type: 'attraction', rating: 4.7, reviewCount: 534,
        priceDisplay: 'Free Entry',
        accessibilityFeatures: ['Wheelchair Friendly', 'Ramp Available'],
        imageUrl: 'https://images.pexels.com/photos/1409140/pexels-photo-1409140.jpeg?w=600',
        location: 'Mylapore, Chennai', isSaved: false, distanceKm: 3.0,
      ),
      const Place(
        id: 'ch7', name: 'ITC Grand Chola', type: 'hotel', rating: 4.8, reviewCount: 389,
        priceDisplay: '₹6,500 / night',
        accessibilityFeatures: ['Wheelchair Access', 'Elevator', 'Accessible Spa', 'Accessible Rooms'],
        imageUrl: 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=600',
        location: 'Guindy, Chennai', isSaved: false, distanceKm: 6.0,
      ),
      const Place(
        id: 'ch8', name: 'Murugan Idli Shop', type: 'restaurant', rating: 4.6, reviewCount: 892,
        priceDisplay: '', priceRange: '₹', cuisineType: 'South Indian',
        accessibilityFeatures: ['Ground Floor Access', 'Accessible Seating'],
        imageUrl: 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?w=600',
        location: 'Vadapalani, Chennai', isSaved: false, distanceKm: 4.5,
      ),
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
        'Cafes': 'cafe',
        'Attractions': 'attraction',
      };
      final type = typeMap[_selectedCategory];
      if (type != null) {
        result = result.where((p) => p.type.toLowerCase() == type).toList();
      }
    }
    if (_searchQuery.isNotEmpty) {
      result = result.where((p) =>
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.location.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildLocationBanner(),
            const SizedBox(height: 12),
            _buildSearch(),
            const SizedBox(height: 14),
            _buildCategoryChips(),
            const SizedBox(height: 10),
            _buildResultsCount(),
            const SizedBox(height: 6),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.explore_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Explore Nearby',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                Text('Accessible places near you',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Color(0xFF8892A4))),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,2))],
            ),
            child: const Icon(Icons.map_outlined, color: Color(0xFF5B6478), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary.withOpacity(0.12), AppTheme.primary.withOpacity(0.06)],
          begin: Alignment.centerLeft, end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on_rounded, size: 14, color: AppTheme.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Showing accessible places near Chennai',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Live', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0,3))],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search accessible places...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  isDense: true,
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => _searchQuery = ''),
                child: Icon(Icons.close_rounded, color: Colors.grey[400], size: 18),
              ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final selected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: selected ? AppTheme.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                    blurRadius: selected ? 8 : 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(_categoryIcons[cat], size: 14,
                    color: selected ? Colors.white : Colors.grey[600]),
                  const SizedBox(width: 5),
                  Text(cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? Colors.white : Colors.grey[700],
                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsCount() {
    final count = _filteredPlaces.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count places',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary),
            ),
          ),
          const SizedBox(width: 8),
          Text('with accessibility features',
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final places = _filteredPlaces;
    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_off_rounded, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text('No places found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text('Try a different category or search term',
              style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 280,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: places.length,
      itemBuilder: (context, i) {
        final place = places[i];
        final originalIndex = _allPlaces.indexOf(place);
        return _PlaceCard(
          place: place,
          onSave: () => _toggleSave(originalIndex),
        );
      },
    );
  }
}

// ─── Beautiful Place Card ───────────────────────────────────────────────────
class _PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onSave;

  const _PlaceCard({required this.place, required this.onSave});

  Color get _typeColor {
    switch (place.type) {
      case 'hotel': return const Color(0xFF4361EE);
      case 'restaurant': return const Color(0xFFE63946);
      case 'cafe': return const Color(0xFF8B5CF6);
      case 'attraction': return const Color(0xFF06B6D4);
      default: return AppTheme.primary;
    }
  }

  IconData get _typeIcon {
    switch (place.type) {
      case 'hotel': return Icons.hotel_rounded;
      case 'restaurant': return Icons.restaurant_rounded;
      case 'cafe': return Icons.local_cafe_rounded;
      case 'attraction': return Icons.attractions_rounded;
      default: return Icons.place_rounded;
    }
  }

  String get _typeLabel {
    switch (place.type) {
      case 'hotel': return 'Hotel';
      case 'restaurant': return 'Restaurant';
      case 'cafe': return 'Cafe';
      case 'attraction': return 'Attraction';
      default: return place.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  place.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: Icon(_typeIcon, size: 40, color: Colors.grey[400]),
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                // Type badge top-left
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: _typeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_typeIcon, size: 10, color: Colors.white),
                        const SizedBox(width: 3),
                        Text(_typeLabel,
                          style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                // Save button top-right
                Positioned(
                  top: 6, right: 6,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: place.isSaved ? AppTheme.primary : Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        place.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                        size: 15,
                        color: place.isSaved ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                // Distance badge bottom-left
                Positioned(
                  bottom: 7, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.near_me_rounded, size: 9, color: Colors.white),
                        const SizedBox(width: 3),
                        Text('${place.distanceKm.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 10, color: Colors.grey[400]),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          place.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFA500)),
                      const SizedBox(width: 3),
                      Text('${place.rating}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                      Text(' (${place.reviewCount})',
                        style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ],
                  ),
                  const Spacer(),
                  // Accessibility feature tag
                  if (place.accessibilityFeatures.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.accessibility_new_rounded, size: 10, color: Color(0xFF16A34A)),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              place.accessibilityFeatures.first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 9, color: Color(0xFF16A34A), fontWeight: FontWeight.w600),
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
}
