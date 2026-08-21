import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  late List<Place> _hotels;
  String _selectedFilter = 'All';
  bool _showAccessibleOnly = false;

  final _filters = ['All', 'Budget', 'Premium', 'Luxury'];

  @override
  void initState() {
    super.initState();
    _hotels = MockData.hotels.map((h) => h.copyWith()).toList();
  }

  void _toggleSave(int index) {
    setState(() => _hotels[index] = _hotels[index].copyWith(isSaved: !_hotels[index].isSaved));
  }

  List<Place> get _filteredHotels {
    var result = _hotels;
    if (_showAccessibleOnly) {
      result = result.where((h) => h.accessibilityFeatures.contains('Wheelchair Access')).toList();
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
            _buildAppBar(context),
            const SizedBox(height: 12),
            _buildSearchAndFilter(context),
            const SizedBox(height: 14),
            _buildAccessibilityToggle(context),
            const SizedBox(height: 14),
            Expanded(
              child: _filteredHotels.isEmpty
                  ? const EmptyState(icon: Icons.hotel_outlined,
                      title: 'No hotels found', subtitle: 'Try changing your filters or search query')
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _filteredHotels.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, i) {
                        final hotel = _filteredHotels[i];
                        final originalIndex = _hotels.indexOf(hotel);
                        return _HotelDetailCard(hotel: hotel, onSave: () => _toggleSave(originalIndex));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppTheme.white, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
              child: const Icon(Icons.arrow_back, color: AppTheme.neutral900, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          const Text('Accessible Hotels', style: TextStyle(fontSize: 19,
              fontWeight: FontWeight.w700, color: AppTheme.neutral900, fontFamily: 'Poppins')),
          const Spacer(),
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: AppTheme.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
            child: const Icon(Icons.sort, color: AppTheme.neutral700, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppTheme.white, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppTheme.neutral400, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search hotels...', border: InputBorder.none,
                      enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, filled: false,
                      hintStyle: TextStyle(fontSize: 13, color: AppTheme.neutral400, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => CategoryChip(
              label: _filters[i],
              selected: _selectedFilter == _filters[i],
              onTap: () => setState(() => _selectedFilter = _filters[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: AppTheme.primarySurface, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            const Icon(Icons.accessible, color: AppTheme.primary, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wheelchair Accessible Only', style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins')),
                  Text('Show only hotels with wheelchair access', style: TextStyle(fontSize: 11,
                      color: AppTheme.neutral600, fontFamily: 'Poppins')),
                ],
              ),
            ),
            Switch(value: _showAccessibleOnly, onChanged: (v) => setState(() => _showAccessibleOnly = v)),
          ],
        ),
      ),
    );
  }
}

class _HotelDetailCard extends StatelessWidget {
  final Place hotel;
  final VoidCallback onSave;

  const _HotelDetailCard({required this.hotel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: hotel.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover,
                  placeholder: (c, u) => Container(color: AppTheme.neutral200, height: 160),
                  errorWidget: (c, u, e) => Container(color: AppTheme.neutral200, height: 160,
                      child: const Icon(Icons.image, color: AppTheme.neutral400)),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withValues(alpha: 0.95), shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]),
                      child: Icon(hotel.isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                          size: 18, color: hotel.isSaved ? AppTheme.primary : AppTheme.neutral500),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(8)),
                    child: RatingStars(rating: hotel.rating, reviewCount: hotel.reviewCount, size: 14),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(hotel.name, style: const TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins'))),
                    Text(hotel.priceDisplay, style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700, color: AppTheme.primary, fontFamily: 'Poppins')),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 13, color: AppTheme.neutral500),
                    const SizedBox(width: 2),
                    Expanded(child: Text(hotel.location, style: const TextStyle(fontSize: 12,
                        color: AppTheme.neutral500, fontFamily: 'Poppins'))),
                    const Icon(Icons.directions_walk, size: 13, color: AppTheme.neutral500),
                    const SizedBox(width: 2),
                    Text('${hotel.distanceKm} km away', style: const TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w500, color: AppTheme.neutral600, fontFamily: 'Poppins')),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Accessibility Features', style: TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w600, color: AppTheme.neutral700, fontFamily: 'Poppins')),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: hotel.accessibilityFeatures.map((f) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primarySurface, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, size: 13, color: AppTheme.primary),
                          const SizedBox(width: 4),
                          Text(f, style: const TextStyle(fontSize: 11,
                              fontWeight: FontWeight.w500, color: AppTheme.primary, fontFamily: 'Poppins')),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Contact', style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary, foregroundColor: AppTheme.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12), elevation: 0),
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text('Directions', style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
