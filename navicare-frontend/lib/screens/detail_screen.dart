import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../services/supabase_service.dart';
import '../models/venue.dart';
import '../helpers.dart';

class DetailScreen extends StatefulWidget {
  final String venueId;
  final void Function(int) onNavigate;

  const DetailScreen({super.key, required this.venueId, required this.onNavigate});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Venue? _venue;
  bool _loading = true;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _loadVenue();
  }

  Future<void> _loadVenue() async {
    try {
      final venue = await SupabaseService.fetchVenue(widget.venueId);
      setState(() {
        _venue = venue;
        _loading = false;
        _notFound = venue == null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _notFound = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488))),
      );
    }

    if (_notFound || _venue == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.alertCircle, size: 48, color: Color(0xFFFECDD3)),
              const SizedBox(height: 12),
              const Text('Venue Not Found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              const Text('This venue may have been removed.', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
              const SizedBox(height: 16),
              TextButton(onPressed: () => widget.onNavigate(1), child: const Text('Back to directory')),
            ],
          ),
        ),
      );
    }

    final venue = _venue!;
    final score = accessibilityScore(venue.accessibility);
    final label = getAccessibilityLabel(venue.accessibility);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    getVenueImage(venue),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE2E8F0)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(venue.type == 'restaurant' ? Icons.restaurant : Icons.hotel, size: 14, color: const Color(0xFF334155)),
                                  const SizedBox(width: 4),
                                  Text(venue.type, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                ],
                              ),
                            ),
                            if (venue.verified) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: const Color(0xFF0D9488), borderRadius: BorderRadius.circular(20)),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text('Verified', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(venue.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 16, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
              '${venue.address}, ${venue.city}, ${venue.state}${venue.zip != null ? ' ${venue.zip}' : ''}',
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (venue.description != null && venue.description!.isNotEmpty) ...[
                    const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 8),
                    Text(venue.description!, style: const TextStyle(fontSize: 15, color: Color(0xFF475569), height: 1.5)),
                    const SizedBox(height: 24),
                  ],
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: score / 100,
                                strokeWidth: 8,
                                backgroundColor: const Color(0xFFE2E8F0),
                                color: const Color(0xFF0D9488),
                              ),
                            ),
                            Text('$score%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Accessibility Score', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                              const SizedBox(height: 4),
                              Text(label.label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(label.color))),
                              Text('${venue.accessibility.countTrue} of 22 features', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Accessibility Features', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 16),
                  for (final category in AccessibilityChecklist.categories) ...[
                    Text(category.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    ...AccessibilityChecklist.itemsForCategory(category).map((item) => _featureRow(item, venue.accessibility)),
                    const SizedBox(height: 16),
                  ],
                  if (venue.accessibilityNotes != null && venue.accessibilityNotes!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFDE68A))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Additional Notes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF92400E))),
                          const SizedBox(height: 4),
                          Text(venue.accessibilityNotes!, style: const TextStyle(fontSize: 14, color: Color(0xFFB45309), height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _contactRow(LucideIcons.mapPin, '${venue.address}, ${venue.city}, ${venue.state}${venue.zip != null ? ' ${venue.zip}' : ''}'),
                  if (venue.phone != null) _contactRow(LucideIcons.phone, venue.phone!),
                  if (venue.email != null) _contactRow(LucideIcons.mail, venue.email!),
                  if (venue.website != null) _contactRow(LucideIcons.globe, venue.website!),
                  _contactRow(LucideIcons.user, 'Registered by ${venue.contactName}'),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFFF0FDFA), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF5EEAD4))),
                    child: Column(
                      children: [
                        const Text('Want to list your business too?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F766E))),
                        const SizedBox(height: 4),
                        const Text('Register your venue for free', style: TextStyle(fontSize: 13, color: Color(0xFF0D9488))),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: () => widget.onNavigate(2), child: const Text('Register Your Venue')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(ChecklistItem item, AccessibilityFeatures features) {
    final has = item.getValue(features);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: has ? const Color(0xFFF0FDFA) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: has ? const Color(0xFF5EEAD4) : const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: has ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_getIcon(item.icon), size: 16, color: has ? Colors.white : const Color(0xFF94A3B8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: has ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)),
            ),
          ),
          Icon(has ? LucideIcons.checkCircle2 : LucideIcons.xCircle, size: 18, color: has ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1)),
        ],
      ),
    );
  }

  IconData _getIcon(String name) {
    const map = {
      'Accessibility': LucideIcons.accessibility,
      'TrendingUp': LucideIcons.trendingUp,
      'Armchair': LucideIcons.armchair,
      'DoorOpen': LucideIcons.doorOpen,
      'ArrowUpDown': LucideIcons.arrowUpDown,
      'Car': LucideIcons.car,
      'MoveHorizontal': LucideIcons.moveHorizontal,
      'Minus': LucideIcons.minus,
      'Grip': LucideIcons.grip,
      'BedDouble': LucideIcons.bedDouble,
      'ShowerHead': LucideIcons.showerHead,
      'Type': LucideIcons.type,
      'ZoomIn': LucideIcons.zoomIn,
      'BellRing': LucideIcons.bellRing,
      'DoorClosed': LucideIcons.doorClosed,
      'Hand': LucideIcons.hand,
      'Ear': LucideIcons.ear,
      'Dog': LucideIcons.dog,
      'Moon': LucideIcons.moon,
      'Sparkles': LucideIcons.sparkles,
      'GraduationCap': LucideIcons.graduationCap,
    };
    return map[name] ?? Icons.accessibility;
  }

  Widget _contactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF475569)))),
        ],
      ),
    );
  }
}
