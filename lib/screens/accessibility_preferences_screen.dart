import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class AccessibilityPreferencesScreen extends StatefulWidget {
  const AccessibilityPreferencesScreen({super.key});

  @override
  State<AccessibilityPreferencesScreen> createState() => _AccessibilityPreferencesScreenState();
}

class _AccessibilityPreferencesScreenState extends State<AccessibilityPreferencesScreen> {
  AccessibilityPrefs _prefs = const AccessibilityPrefs();

  final _allPrefs = [
    {'key': 'wheelchairAccess', 'icon': Icons.accessible, 'label': 'Wheelchair Access', 'desc': 'Ramps and wide doorways'},
    {'key': 'accessibleRestroom', 'icon': Icons.wc, 'label': 'Accessible Restroom', 'desc': 'Wider stalls with grab bars'},
    {'key': 'elevator', 'icon': Icons.elevator, 'label': 'Elevator Access', 'desc': 'Working elevators with Braille'},
    {'key': 'accessibleParking', 'icon': Icons.local_parking, 'label': 'Accessible Parking', 'desc': 'Designated close parking spots'},
    {'key': 'brailleMenu', 'icon': Icons.menu_book, 'label': 'Braille Menu', 'desc': 'Menus in Braille for visually impaired'},
    {'key': 'hearingAssistance', 'icon': Icons.hearing, 'label': 'Hearing Assistance', 'desc': 'Sign language or hearing loops'},
    {'key': 'stepFreeEntry', 'icon': Icons.stairs, 'label': 'Step-Free Entry', 'desc': 'No steps at the entrance'},
  ];

  bool _getValue(String key) {
    switch (key) {
      case 'wheelchairAccess': return _prefs.wheelchairAccess;
      case 'accessibleRestroom': return _prefs.accessibleRestroom;
      case 'elevator': return _prefs.elevator;
      case 'accessibleParking': return _prefs.accessibleParking;
      case 'brailleMenu': return _prefs.brailleMenu;
      case 'hearingAssistance': return _prefs.hearingAssistance;
      case 'stepFreeEntry': return _prefs.stepFreeEntry;
      default: return false;
    }
  }

  void _setValue(String key, bool value) {
    setState(() {
      _prefs = _prefs.copyWith(
        wheelchairAccess: key == 'wheelchairAccess' ? value : null,
        accessibleRestroom: key == 'accessibleRestroom' ? value : null,
        elevator: key == 'elevator' ? value : null,
        accessibleParking: key == 'accessibleParking' ? value : null,
        brailleMenu: key == 'brailleMenu' ? value : null,
        hearingAssistance: key == 'hearingAssistance' ? value : null,
        stepFreeEntry: key == 'stepFreeEntry' ? value : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _allPrefs.where((p) => _getValue(p['key'] as String)).length;
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildSummary(activeCount, _allPrefs.length),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: _allPrefs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final pref = _allPrefs[i];
                  final key = pref['key'] as String;
                  final value = _getValue(key);
                  return _PrefTile(
                    icon: pref['icon'] as IconData,
                    label: pref['label'] as String,
                    desc: pref['desc'] as String,
                    value: value,
                    onChanged: (v) => _setValue(key, v),
                  );
                },
              ),
            ),
            _buildSaveButton(context),
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
          const Text('Accessibility Preferences', style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w700, color: AppTheme.neutral900, fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _buildSummary(int active, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.primaryLight],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Accessibility Profile', style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w600, color: AppTheme.white, fontFamily: 'Poppins')),
                  const SizedBox(height: 4),
                  Text('$active of $total preferences enabled', style: TextStyle(fontSize: 12,
                      color: AppTheme.white.withValues(alpha: 0.85), fontFamily: 'Poppins')),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 48, height: 48,
                  child: CircularProgressIndicator(
                    value: active / total,
                    backgroundColor: AppTheme.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.white),
                    strokeWidth: 4,
                  ),
                ),
                Text('${((active / total) * 100).round()}%', style: const TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w700, color: AppTheme.white, fontFamily: 'Poppins')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Save Preferences'),
      ),
    );
  }
}

class _PrefTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrefTile({required this.icon, required this.label, required this.desc,
      required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: value ? AppTheme.primarySurface : AppTheme.neutral100,
              borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: value ? AppTheme.primary : AppTheme.neutral500, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w600, color: AppTheme.neutral900, fontFamily: 'Poppins')),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 11,
                    color: AppTheme.neutral500, fontFamily: 'Poppins')),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
