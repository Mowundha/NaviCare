import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/token_storage.dart';
import 'accessibility_preferences_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileDetails _profileDetails = const ProfileDetails(
    name: 'Aarav',
    email: 'aarav@example.com',
    phone: '+91 9876543210',
  );

  Future<void> _editProfile() async {
    final updatedDetails = await Navigator.push<ProfileDetails>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(details: _profileDetails),
      ),
    );

    if (updatedDetails != null && mounted) {
      setState(() => _profileDetails = updatedDetails);
    }
  }

  Future<void> _logOut() async {
    await TokenStorage.instance.clearToken();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildProfileHeader(context),
              const SizedBox(height: 20),
              _buildStatsRow(),
              const SizedBox(height: 20),
              _buildAccessibilityCard(context),
              const SizedBox(height: 20),
              _buildMenuSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.person, color: AppTheme.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_profileDetails.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.neutral900,
                        fontFamily: 'Poppins')),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppTheme.primarySurface,
                      borderRadius: BorderRadius.circular(6)),
                  child: const Text('Premium Member',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                          fontFamily: 'Poppins')),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8)
                ]),
            child: IconButton(
              onPressed: _editProfile,
              tooltip: 'Edit profile',
              padding: EdgeInsets.zero,
              icon:
                  const Icon(Icons.edit, color: AppTheme.neutral700, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {
        'value': '24',
        'label': 'Saved Places',
        'icon': Icons.bookmark,
        'color': AppTheme.primary,
        'bg': AppTheme.primarySurface
      },
      {
        'value': '8',
        'label': 'Events Joined',
        'icon': Icons.event,
        'color': AppTheme.secondary,
        'bg': AppTheme.secondarySurface
      },
      {
        'value': '12',
        'label': 'Reviews',
        'icon': Icons.star,
        'color': AppTheme.accent,
        'bg': AppTheme.accentSurface
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8)
                  ]),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: s['bg'] as Color,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(s['icon'] as IconData,
                        color: s['color'] as Color, size: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(s['value'] as String,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.neutral900,
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 2),
                  Text(s['label'] as String,
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.neutral500,
                          fontFamily: 'Poppins'),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccessibilityCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AccessibilityPreferencesScreen())),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.accessible, color: AppTheme.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Accessibility Preferences',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.white,
                            fontFamily: 'Poppins')),
                    Text('2 of 7 preferences enabled',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.white.withValues(alpha: 0.85),
                            fontFamily: 'Poppins')),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: AppTheme.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'label': 'Personal Information',
        'color': AppTheme.primary
      },
      {
        'icon': Icons.notifications_outlined,
        'label': 'Notifications',
        'color': AppTheme.secondary
      },
      {
        'icon': Icons.lock_outline,
        'label': 'Privacy & Security',
        'color': AppTheme.accent
      },
      {
        'icon': Icons.help_outline,
        'label': 'Help & Support',
        'color': AppTheme.info
      },
      {
        'icon': Icons.info_outline,
        'label': 'About AccessEase',
        'color': AppTheme.neutral600
      },
      {'icon': Icons.logout, 'label': 'Log Out', 'color': AppTheme.error},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
            ]),
        child: Material(
          color: Colors.transparent,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuItems.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 14, endIndent: 14),
            itemBuilder: (context, i) {
              final item = menuItems[i];
              final isLogout = item['label'] == 'Log Out';
              final isPersonalInformation =
                  item['label'] == 'Personal Information';

              return ListTile(
                leading: Icon(item['icon'] as IconData,
                    color: item['color'] as Color, size: 22),
                title: Text(item['label'] as String,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.neutral800,
                        fontFamily: 'Poppins')),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 14, color: AppTheme.neutral400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                onTap: isLogout
                    ? _logOut
                    : isPersonalInformation
                        ? _editProfile
                        : () {},
              );
            },
          ),
        ),
      ),
    );
  }
}
