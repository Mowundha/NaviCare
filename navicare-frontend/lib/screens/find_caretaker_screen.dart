import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'caretaker_details_screen.dart';

class FindCaretakerScreen extends StatefulWidget {
  const FindCaretakerScreen({super.key});

  @override
  State<FindCaretakerScreen> createState() => _FindCaretakerScreenState();
}

class _FindCaretakerScreenState extends State<FindCaretakerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allCaretakers = [
    {
      'name': 'Kavitha Sundaram',
      'role': 'Elderly Care Specialist',
      'type': 'general',
      'exp': '8 Years Experience',
      'rating': '4.8',
      'reviews': '42',
      'price': '₹700 / session',
      'priceRange': '₹600–₹800',
      'image': 'https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg?w=200',
      'location': 'Tambaram, Chennai',
    },
    {
      'name': 'Murugan Rajan',
      'role': 'Physical Therapy & Care',
      'type': 'physio',
      'exp': '10 Years Experience',
      'rating': '4.9',
      'reviews': '67',
      'price': '₹2,000 / session',
      'priceRange': '₹1,800–₹2,200',
      'image': 'https://images.pexels.com/photos/6749778/pexels-photo-6749778.jpeg?w=200',
      'location': 'Anna Nagar, Chennai',
    },
    {
      'name': 'Priya Natarajan',
      'role': 'Child & Special Needs Care',
      'type': 'general',
      'exp': '6 Years Experience',
      'rating': '4.6',
      'reviews': '29',
      'price': '₹650 / session',
      'priceRange': '₹600–₹800',
      'image': 'https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg?w=200',
      'location': 'T. Nagar, Chennai',
    },
    {
      'name': 'Senthil Kumar',
      'role': 'Mobility & Travel Assistant',
      'type': 'specialized',
      'exp': '7 Years Experience',
      'rating': '4.9',
      'reviews': '53',
      'price': '₹1,400 / session',
      'priceRange': '₹1,200–₹1,600',
      'image': 'https://images.pexels.com/photos/6749777/pexels-photo-6749777.jpeg?w=200',
      'location': 'Velachery, Chennai',
    },
    {
      'name': 'Deepa Krishnamurthy',
      'role': 'Post-Surgery Recovery Care',
      'type': 'physio',
      'exp': '9 Years Experience',
      'rating': '4.8',
      'reviews': '38',
      'price': '₹1,900 / session',
      'priceRange': '₹1,800–₹2,200',
      'image': 'https://images.pexels.com/photos/5327656/pexels-photo-5327656.jpeg?w=200',
      'location': 'Adyar, Chennai',
    },
    {
      'name': 'Arjun Balakrishnan',
      'role': 'Specialized Disability Care',
      'type': 'specialized',
      'exp': '5 Years Experience',
      'rating': '4.7',
      'reviews': '21',
      'price': '₹1,300 / session',
      'priceRange': '₹1,200–₹1,600',
      'image': 'https://images.pexels.com/photos/6749773/pexels-photo-6749773.jpeg?w=200',
      'location': 'Porur, Chennai',
    },
    {
      'name': 'Meenakshi Annamalai',
      'role': 'Elderly Companion & Care',
      'type': 'general',
      'exp': '11 Years Experience',
      'rating': '4.9',
      'reviews': '74',
      'price': '₹750 / session',
      'priceRange': '₹600–₹800',
      'image': 'https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg?w=200',
      'location': 'Mylapore, Chennai',
    },
    {
      'name': 'Karthikeyan Pillai',
      'role': 'Medical Support Assistant',
      'type': 'specialized',
      'exp': '6 Years Experience',
      'rating': '4.7',
      'reviews': '31',
      'price': '₹1,350 / session',
      'priceRange': '₹1,200–₹1,600',
      'image': 'https://images.pexels.com/photos/6749779/pexels-photo-6749779.jpeg?w=200',
      'location': 'Guindy, Chennai',
    },
    {
      'name': 'Lakshmi Venkatesh',
      'role': 'Neurological Rehab Care',
      'type': 'physio',
      'exp': '8 Years Experience',
      'rating': '4.8',
      'reviews': '44',
      'price': '₹2,100 / session',
      'priceRange': '₹1,800–₹2,200',
      'image': 'https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg?w=200',
      'location': 'Nungambakkam, Chennai',
    },
  ];

  List<Map<String, String>> get _filtered {
    if (_searchQuery.isEmpty) return _allCaretakers;
    return _allCaretakers
        .where((c) =>
            c['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c['role']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c['location']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'physio':
        return const Color(0xFF0EA5E9);
      case 'specialized':
        return const Color(0xFF8B5CF6);
      default:
        return AppTheme.accent;
    }
  }

  String _typeLabel(String? type) {
    switch (type) {
      case 'physio':
        return 'Physio Care';
      case 'specialized':
        return 'Specialized';
      default:
        return 'General';
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        elevation: 0,
        title: const Text('Find a Caretaker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search_rounded,
                        color: AppTheme.neutral400, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search by name, role, location...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyle(
                              fontSize: 14, color: AppTheme.neutral400),
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: Icon(Icons.close_rounded,
                            color: AppTheme.neutral400, size: 18),
                      ),
                    const SizedBox(width: 14),
                  ],
                ),
              ),
            ),

            // Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                children: [
                  Text(
                    '${list.length} caretakers available near Chennai',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.neutral500,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_rounded,
                              size: 56, color: AppTheme.neutral300),
                          const SizedBox(height: 12),
                          Text('No caretakers found',
                              style: TextStyle(
                                  color: AppTheme.neutral500,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final c = list[index];
                        return _CaretakerCard(
                          caretaker: c,
                          typeColor: _typeColor(c['type']),
                          typeLabel: _typeLabel(c['type']),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CaretakerDetailsScreen(caretaker: c),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaretakerCard extends StatelessWidget {
  final Map<String, String> caretaker;
  final Color typeColor;
  final String typeLabel;
  final VoidCallback onTap;

  const _CaretakerCard({
    required this.caretaker,
    required this.typeColor,
    required this.typeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = caretaker['image'] ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with online dot
            Stack(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppTheme.neutral200,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person,
                          size: 36, color: AppTheme.primary)
                      : null,
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          caretaker['name']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.neutral900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            color: typeColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  Text(caretaker['role']!,
                      style:
                          TextStyle(fontSize: 12, color: AppTheme.neutral600)),

                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 11, color: AppTheme.neutral400),
                      const SizedBox(width: 2),
                      Text(caretaker['location']!,
                          style: TextStyle(
                              fontSize: 11, color: AppTheme.neutral500)),
                      const SizedBox(width: 8),
                      Icon(Icons.work_history_rounded,
                          size: 11, color: AppTheme.neutral400),
                      const SizedBox(width: 2),
                      Text(caretaker['exp']!,
                          style: TextStyle(
                              fontSize: 11, color: AppTheme.neutral500)),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Rating + price
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        '${caretaker['rating']} (${caretaker['reviews']})',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.neutral900),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          caretaker['price']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onTap,
                      child: const Text('View & Book',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700)),
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
}