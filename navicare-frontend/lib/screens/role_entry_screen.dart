import 'package:flutter/material.dart';
import 'user_login_screen.dart';
import 'caretaker_login_screen.dart';
import 'restaurant_login_screen.dart';

class RoleEntryScreen extends StatefulWidget {
  const RoleEntryScreen({super.key});

  @override
  State<RoleEntryScreen> createState() => _RoleEntryScreenState();
}

class _RoleEntryScreenState extends State<RoleEntryScreen> {
  static const Color primaryPurple = Color(0xFF6554F6);
  static const Color backgroundLight = Color(0xFFF7F8FC);
  static const Color textDark = Color(0xFF2D3142);

  String selectedRole = 'user'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Role Selection',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to NaviCare',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select your portal access to customize your accessible travel experience.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                roleKey: 'user',
                title: 'I need care',
                subtitle: 'Find verified caretakers and dietary meal plans',
                icon: Icons.favorite,
                destination: const UserLoginScreen(),
              ),
              const SizedBox(height: 12),
              _buildRoleCard(
                roleKey: 'caretaker',
                title: "I'm a caretaker",
                subtitle: 'Provide care services, manage clients, and shifts',
                icon: Icons.medical_services_outlined,
                destination: const CaretakerLoginScreen(),
              ),
              const SizedBox(height: 12),
              _buildRoleCard(
                roleKey: 'restaurant',
                title: 'Restaurant Partner',
                subtitle: 'Manage dietary menus, meal subscriptions, and deliveries',
                icon: Icons.storefront_outlined,
                destination: const RestaurantLoginScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String roleKey,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget destination,
  }) {
    final isSelected = selectedRole == roleKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = roleKey;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryPurple : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                  ? primaryPurple.withValues(alpha: 0.1)
                  : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? primaryPurple : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryPurple : textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isSelected ? primaryPurple : Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}