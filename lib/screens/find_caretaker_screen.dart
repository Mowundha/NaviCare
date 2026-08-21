import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'caretaker_details_screen.dart';

class FindCaretakerScreen extends StatelessWidget {
  const FindCaretakerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> caretakers = [
      {
        'name': 'Alice Johnson',
        'role': 'Elderly Care Specialist',
        'exp': '8 Years Experience',
        'rating': '4.8',
        'reviews': '8',
      },
      {
        'name': 'David Smith',
        'role': 'Babbility Care',
        'exp': '5 Years Experience',
        'rating': '4.7',
        'reviews': '7',
      },
      {
        'name': 'Priya Patel',
        'role': 'Child Care',
        'exp': '6 Years Experience',
        'rating': '4.6',
        'reviews': '6',
      },
      {
        'name': 'Rahul Sharma',
        'role': 'Physical Rehabilitation Support',
        'exp': '7 Years Experience',
        'rating': '4.9',
        'reviews': '14',
      },
      {
        'name': 'Emily Davis',
        'role': 'Mobility & Travel Assistant',
        'exp': '4 Years Experience',
        'rating': '4.5',
        'reviews': '5',
      },
      {
        'name': 'Michael Brown',
        'role': 'Elderly Companion',
        'exp': '9 Years Experience',
        'rating': '4.9',
        'reviews': '20',
      },
      {
        'name': 'Ananya Iyer',
        'role': 'Special Needs Care',
        'exp': '6 Years Experience',
        'rating': '4.8',
        'reviews': '12',
      },
      {
        'name': 'Carlos Gomez',
        'role': 'Medical Support Assistant',
        'exp': '5 Years Experience',
        'rating': '4.7',
        'reviews': '9',
      },
      {
        'name': 'Sneha Gupta',
        'role': 'Post-Surgery Care',
        'exp': '7 Years Experience',
        'rating': '4.9',
        'reviews': '15',
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: const Text('Find a Caretaker', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search caretakers...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.neutral400),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: caretakers.length,
                  itemBuilder: (context, index) {
                    final c = caretakers[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: AppTheme.neutral200,
                            child: Icon(Icons.person, size: 36, color: AppTheme.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['name']!,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c['role']!,
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                                Text(
                                  c['exp']!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${c['rating']} (${c['reviews']})',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CaretakerDetailsScreen(caretaker: c),
                                ),
                              );
                            },
                            child: const Text('Book'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}