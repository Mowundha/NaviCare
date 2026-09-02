import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  final _services = const [
    {'icon': Icons.medical_services, 'label': 'Healthcare', 'desc': 'Accessible clinics & hospitals', 'color': AppTheme.heartRed, 'bg': Color(0xFFFFE8EC), 'count': '120+ providers'},
    {'icon': Icons.school, 'label': 'Education', 'desc': 'Inclusive schools & courses', 'color': AppTheme.primary, 'bg': AppTheme.primarySurface, 'count': '85+ institutions'},
    {'icon': Icons.work, 'label': 'Jobs', 'desc': 'Inclusive employers & roles', 'color': AppTheme.accent, 'bg': AppTheme.accentSurface, 'count': '340+ openings'},
    {'icon': Icons.local_taxi, 'label': 'Transport', 'desc': 'Wheelchair-friendly rides', 'color': AppTheme.info, 'bg': Color(0xFFE0F7FA), 'count': '60+ operators'},
    {'icon': Icons.home, 'label': 'Housing', 'desc': 'Accessible rental homes', 'color': AppTheme.secondary, 'bg': AppTheme.secondarySurface, 'count': '45+ listings'},
    {'icon': Icons.sports, 'label': 'Sports', 'desc': 'Adaptive sports facilities', 'color': AppTheme.accent, 'bg': AppTheme.accentSurface, 'count': '30+ venues'},
  ];

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
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.95, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: _services.length,
                itemBuilder: (context, i) {
                  final s = _services[i];
                  return _ServiceCard(
                    icon: s['icon'] as IconData,
                    label: s['label'] as String,
                    desc: s['desc'] as String,
                    color: s['color'] as Color,
                    bg: s['bg'] as Color,
                    count: s['count'] as String,
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
          const Text('Accessibility Services', style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w700, color: AppTheme.neutral900, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  final Color bg;
  final String count;

  const _ServiceCard({required this.icon, required this.label, required this.desc,
      required this.color, required this.bg, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const Spacer(),
          Text(label, style: const TextStyle(fontSize: 15,
              fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins')),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 11,
              color: AppTheme.neutral500, fontFamily: 'Poppins', height: 1.4)),
          const SizedBox(height: 8),
          Text(count, style: TextStyle(fontSize: 11,
              fontWeight: FontWeight.w600, color: color, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
