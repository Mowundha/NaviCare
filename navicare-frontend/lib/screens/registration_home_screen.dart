import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../services/supabase_service.dart';
import '../models/venue.dart';
import '../helpers.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int) onNavigate;
  final void Function(String) onVenueTap;

  const HomeScreen({super.key, required this.onNavigate, required this.onVenueTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Venue> _venues = [];
  int _totalCount = 0;
  int _restaurantCount = 0;
  int _hotelCount = 0;
  bool _loading = true;

  void _openRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterScreen(
          onRegistered: (venueId) {
            Navigator.of(context).pop();
            widget.onNavigate(0);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DetailScreen(
                  venueId: venueId,
                  onNavigate: widget.onNavigate,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final venues = await SupabaseService.fetchVenues(limit: 6);
      final total = await SupabaseService.fetchCount();
      final restaurants = await SupabaseService.fetchCountByType('restaurant');
      final hotels = await SupabaseService.fetchCountByType('hotel');
      setState(() {
        _venues = venues;
        _totalCount = total;
        _restaurantCount = restaurants;
        _hotelCount = hotels;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryDark, AppTheme.primary, AppTheme.primaryLight],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(LucideIcons.accessibility, color: AppTheme.primary, size: 24),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NaviCare', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('Accessible care and travel', style: TextStyle(fontSize: 11, color: Color(0xFFE8E8F0))),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primarySurface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.shieldCheck, size: 16, color: AppTheme.primary),
                              SizedBox(width: 6),
                              Text('Care that includes everyone', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.primary)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Find places that\nwelcome everyone',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Discover restaurants and hotels with the accessibility features you need. Businesses share detailed info so you can plan with confidence.',
                          style: TextStyle(fontSize: 15, color: Color(0xFFE8E8F0), height: 1.5),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  _statCard(Icons.business, _totalCount, 'Total Venues', AppTheme.primarySurface, AppTheme.primary),
                  const SizedBox(width: 12),
                  _statCard(Icons.restaurant, _restaurantCount, 'Restaurants', AppTheme.secondarySurface, AppTheme.secondary),
                  const SizedBox(width: 12),
                  _statCard(Icons.hotel, _hotelCount, 'Hotels', AppTheme.accentSurface, AppTheme.accent),
                ],
              ),
            ),
          ),
          if (!_loading && _venues.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recently Added', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    TextButton(
                      onPressed: () => widget.onNavigate(1),
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _venueCard(_venues[index]),
                childCount: _venues.length,
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('How NaviCare Helps', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.neutral900)),
                  const SizedBox(height: 20),
                  _howItWorksStep('01', 'Create Your Listing', 'Sign up your restaurant or hotel in minutes by adding your photos, operating hours, and location details directly to the NaviCare directory.', LucideIcons.building2),
                  _howItWorksStep('02', 'Highlight Accessibility', 'Complete our straightforward accessibility checklist--detailing step-free entries, seating arrangements, and sensory accommodations.', LucideIcons.accessibility),
                  _howItWorksStep('03', 'Welcome New Guests', 'Gain a verified badge, build instant trust with differently-abled customers, and grow your reservations with confidence.', LucideIcons.checkCircle2),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('Are you a restaurant or hotel owner?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Register your business and help more guests plan with confidence.', style: TextStyle(fontSize: 14, color: AppTheme.primarySurface), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openRegisterScreen,
                    icon: const Icon(LucideIcons.building2, size: 18),
                    label: const Text('Register Your Venue'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.white, foregroundColor: AppTheme.primary),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, int value, String label, Color bg, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: 10),
              Text('$value', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.neutral900)),
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.neutral600)),
          ],
        ),
      ),
    );
  }

  Widget _venueCard(Venue venue) {
    final score = accessibilityScore(venue.accessibility);
    final label = getAccessibilityLabel(venue.accessibility);
    return GestureDetector(
      onTap: () => widget.onVenueTap(venue.id),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                getVenueImage(venue),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: const Color(0xFFE2E8F0),
                  child: const Icon(Icons.image, size: 40, color: Color(0xFF94A3B8)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(venue.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ),
                      if (venue.verified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF0D9488), borderRadius: BorderRadius.circular(12)),
                          child: const Text('Verified', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text('${venue.city}, ${venue.state}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF14B8A6), shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text(label.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(label.color))),
                        ],
                      ),
                      Text('$score% accessible', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: const Color(0xFFF1F5F9),
                      color: const Color(0xFF14B8A6),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _howItWorksStep(String step, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.neutral200),
            ),
            child: Icon(icon, size: 26, color: AppTheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary, letterSpacing: 2)),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.neutral900)),
                Text(desc, style: const TextStyle(fontSize: 13, color: AppTheme.neutral600, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
