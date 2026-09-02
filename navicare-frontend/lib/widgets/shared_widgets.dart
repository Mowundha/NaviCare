import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    BottomNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    BottomNavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Explore'),
    BottomNavItem(icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
    BottomNavItem(icon: Icons.bookmark_border_outlined, activeIcon: Icons.bookmark, label: 'Saved'),
    BottomNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(selected ? item.activeIcon : item.icon, size: 24,
                          color: selected ? AppTheme.primary : AppTheme.neutral400),
                      const SizedBox(height: 2),
                      Text(item.label, style: TextStyle(fontSize: 10,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? AppTheme.primary : AppTheme.neutral500,
                          fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const BottomNavItem({required this.icon, required this.activeIcon, required this.label});
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
            color: AppTheme.neutral900, fontFamily: 'Poppins')),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionText!, style: const TextStyle(fontSize: 13,
                fontWeight: FontWeight.w500, color: AppTheme.primary, fontFamily: 'Poppins')),
          ),
      ],
    );
  }
}

class FeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color background;

  const FeatureChip({super.key, required this.label, this.icon = Icons.check,
      this.color = AppTheme.primary, this.background = AppTheme.primarySurface});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
              color: color, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;

  const RatingStars({super.key, required this.rating, this.reviewCount, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: size, color: const Color(0xFFFFB400)),
        const SizedBox(width: 2),
        Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: size - 1,
            fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins')),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text('($reviewCount)', style: TextStyle(fontSize: size - 2,
              color: AppTheme.neutral500, fontFamily: 'Poppins')),
        ],
      ],
    );
  }
}

class PlaceCard extends StatelessWidget {
  final dynamic place;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final double width;

  const PlaceCard({super.key, required this.place, this.onTap, this.onSave, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
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
                    imageUrl: place.imageUrl as String, height: 120, width: double.infinity, fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppTheme.neutral200, height: 120),
                    errorWidget: (c, u, e) => Container(color: AppTheme.neutral200, height: 120,
                        child: const Icon(Icons.image, color: AppTheme.neutral400)),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: onSave,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.white.withValues(alpha: 0.95), shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                        ),
                        child: Icon(
                          (place.isSaved as bool) ? Icons.bookmark : Icons.bookmark_border_outlined,
                          size: 16,
                          color: (place.isSaved as bool) ? AppTheme.primary : AppTheme.neutral500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name as String, style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins'),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 11, color: AppTheme.neutral500),
                      const SizedBox(width: 2),
                      Expanded(child: Text(place.location as String, style: const TextStyle(fontSize: 11,
                          color: AppTheme.neutral500, fontFamily: 'Poppins'),
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RatingStars(rating: place.rating as double, reviewCount: place.reviewCount as int),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4, runSpacing: 4,
                    children: (place.accessibilityFeatures as List).take(2)
                        .map((f) => FeatureChip(label: f.toString())).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final dynamic event;
  final VoidCallback? onTap;
  final VoidCallback? onSave;

  const EventCard({super.key, required this.event, this.onTap, this.onSave});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    imageUrl: event.imageUrl as String, height: 140, width: double.infinity, fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppTheme.neutral200, height: 140),
                    errorWidget: (c, u, e) => Container(color: AppTheme.neutral200, height: 140,
                        child: const Icon(Icons.image, color: AppTheme.neutral400)),
                  ),
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.white, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 6)],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(event.dayNum.toString(), style: const TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w700, color: AppTheme.primary, fontFamily: 'Poppins', height: 1)),
                          Text(event.monthAbbr as String, style: const TextStyle(fontSize: 9,
                              fontWeight: FontWeight.w600, color: AppTheme.neutral600, fontFamily: 'Poppins', height: 1.2)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: GestureDetector(
                      onTap: onSave,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.white.withValues(alpha: 0.95), shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                        ),
                        child: Icon(
                          (event.isSaved as bool) ? Icons.bookmark : Icons.bookmark_border_outlined,
                          size: 16,
                          color: (event.isSaved as bool) ? AppTheme.primary : AppTheme.neutral500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title as String, style: const TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins'),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(event.organizer as String, style: const TextStyle(fontSize: 12,
                      color: AppTheme.neutral600, fontFamily: 'Poppins'),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: AppTheme.neutral500),
                      const SizedBox(width: 4),
                      Expanded(child: Text(event.dateDisplay as String, style: const TextStyle(fontSize: 11,
                          color: AppTheme.neutral600, fontFamily: 'Poppins'),
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppTheme.neutral500),
                      const SizedBox(width: 4),
                      Expanded(child: Text(event.location as String, style: const TextStyle(fontSize: 11,
                          color: AppTheme.neutral600, fontFamily: 'Poppins'),
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6, runSpacing: 4,
                    children: (event.tags as List).map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.accentSurface, borderRadius: BorderRadius.circular(6)),
                        child: Text(t.toString(), style: const TextStyle(fontSize: 10,
                            fontWeight: FontWeight.w500, color: AppTheme.accent, fontFamily: 'Poppins')),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({super.key, required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.neutral200),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
            color: selected ? AppTheme.white : AppTheme.neutral700, fontFamily: 'Poppins')),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppTheme.neutral300),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600,
                color: AppTheme.neutral700, fontFamily: 'Poppins'), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 13,
                color: AppTheme.neutral500, fontFamily: 'Poppins'), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
