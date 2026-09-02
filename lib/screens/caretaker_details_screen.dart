import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../screens/book_caretaker_screen.dart';

class CaretakerDetailsScreen extends StatelessWidget {
  final Map<String, String>? caretaker;

  const CaretakerDetailsScreen({super.key, this.caretaker});

  @override
  Widget build(BuildContext context) {
    final actualCaretaker = caretaker ?? {};
    final name = actualCaretaker['name'] ?? 'Caretaker';
    final role = actualCaretaker['role'] ?? 'Specialist';
    final exp = actualCaretaker['exp'] ?? 'Experience details unavailable';
    final rating = actualCaretaker['rating'] ?? '4.8';
    final reviewsCount = actualCaretaker['reviews'] ?? '8';

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: const Text('Caretaker Details', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 36, backgroundColor: AppTheme.neutral200, child: Icon(Icons.person, size: 40, color: AppTheme.primary)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(role, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                          const SizedBox(height: 2),
                          Text(exp, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('$rating ($reviewsCount reviews)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('About Me', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check, color: AppTheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Text('Certified in $role', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.check, color: AppTheme.primary, size: 18),
                        SizedBox(width: 8),
                        Text('Proper Professional Care Trained', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 20, backgroundColor: AppTheme.neutral200, child: Icon(Icons.person, color: AppTheme.primary)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Client Reviewer', style: TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const Icon(Icons.star_half, color: Colors.amber, size: 14),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('$name is an exceptional caretaker, very compassionate and professional!', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BookCaretakerScreen(caretaker: caretaker)));
                  },
                  child: const Text('Proceed to Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}