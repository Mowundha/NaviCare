import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../models/models.dart';
import '../widgets/shared_widgets.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late List<Event> _events;
  late List<NGO> _ngos;
  String _selectedCategory = 'All';

  final _categories = [
    {'label': 'All', 'icon': Icons.grid_view},
    {'label': 'Workshops', 'icon': Icons.school_outlined},
    {'label': 'Awareness', 'icon': Icons.campaign_outlined},
    {'label': 'Volunteering', 'icon': Icons.volunteer_activism_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _events = MockData.events.map((e) => e.copyWith()).toList();
    _ngos = MockData.ngos.map((n) => n.copyWith()).toList();
  }

  void _toggleSaveEvent(int index) {
    setState(() => _events[index] = _events[index].copyWith(isSaved: !_events[index].isSaved));
  }

  void _toggleSaveNGO(int index) {
    setState(() => _ngos[index] = _ngos[index].copyWith(isSaved: !_ngos[index].isSaved));
  }

  List<Event> get _filteredEvents {
    if (_selectedCategory == 'All') return _events;
    final cat = _selectedCategory.toLowerCase();
    return _events.where((e) => e.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), child: _buildSectionTitle('Upcoming Events'))),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final event = _filteredEvents[i];
                    final originalIndex = _events.indexOf(event);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: EventCard(event: event, onSave: () => _toggleSaveEvent(originalIndex)),
                    );
                  },
                  childCount: _filteredEvents.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), child: _buildSectionTitle('NGO Communities'))),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _NGOCard(ngo: _ngos[i], onSave: () => _toggleSaveNGO(i)),
                  ),
                  childCount: _ngos.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: AppTheme.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
            child: const Icon(Icons.event, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          const Text('Events & Communities', style: TextStyle(fontSize: 19,
              fontWeight: FontWeight.w700, color: AppTheme.neutral900, fontFamily: 'Poppins')),
          const Spacer(),
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: AppTheme.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)]),
            child: const Icon(Icons.search, color: AppTheme.neutral700, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final selected = _selectedCategory == cat['label'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['label'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : AppTheme.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? AppTheme.primary : AppTheme.neutral200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cat['icon'] as IconData, size: 14,
                      color: selected ? AppTheme.white : AppTheme.neutral600),
                  const SizedBox(width: 6),
                  Text(cat['label'] as String, style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppTheme.white : AppTheme.neutral700, fontFamily: 'Poppins')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 17,
        fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins'));
  }
}

class _NGOCard extends StatelessWidget {
  final NGO ngo;
  final VoidCallback onSave;

  const _NGOCard({required this.ngo, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: ngo.imageUrl, width: 90, height: 110, fit: BoxFit.cover,
              placeholder: (c, u) => Container(color: AppTheme.neutral200, width: 90, height: 110),
              errorWidget: (c, u, e) => Container(color: AppTheme.neutral200, width: 90, height: 110,
                  child: const Icon(Icons.image, color: AppTheme.neutral400)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(ngo.name, style: const TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins'),
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                      GestureDetector(
                        onTap: onSave,
                        child: Icon(ngo.isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                            size: 20, color: ngo.isSaved ? AppTheme.primary : AppTheme.neutral400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppTheme.neutral500),
                      const SizedBox(width: 2),
                      Text(ngo.city, style: const TextStyle(fontSize: 11,
                          color: AppTheme.neutral500, fontFamily: 'Poppins')),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.accentSurface, borderRadius: BorderRadius.circular(6)),
                    child: Text(ngo.type, style: const TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w500, color: AppTheme.accent, fontFamily: 'Poppins')),
                  ),
                  const SizedBox(height: 6),
                  Text(ngo.description, style: const TextStyle(fontSize: 11,
                      color: AppTheme.neutral600, fontFamily: 'Poppins', height: 1.4),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
