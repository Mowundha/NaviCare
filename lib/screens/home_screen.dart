import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'accessibility_preferences_screen.dart';
import 'find_caretaker_screen.dart';
import 'community_main_screen.dart';
import 'home_location_map_screen.dart';
import 'tourist_place_detail_page.dart';

// Data model for tourist places
class _TouristPlace {
  final String name;
  final String location;
  final String description;
  final String imageUrl;

  const _TouristPlace({
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample data list for tourist places
  static const List<_TouristPlace> _touristPlaces = [
    _TouristPlace(
      name: "Taj Mahal",
      location: "Agra, Uttar Pradesh",
      description:
          "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Taj-Mahal.jpg",
    ),
    _TouristPlace(
      name: "Jaipur City Palace",
      location: "Jaipur, Rajasthan",
      description:
          "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Jaipur%20City%20Palace%2C%20Rajasthan.jpg",
    ),
    _TouristPlace(
      name: "Gateway of India",
      location: "Mumbai, Maharashtra",
      description:
          "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Gateway%20of%20India%2C%20Mumbai%2C%20India.jpg",
    ),
    _TouristPlace(
      name: "Golden Temple",
      location: "Amritsar, Punjab",
      description:
          "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Golden%20Temple%20%28Amritsar%29.jpg",
    ),
    _TouristPlace(
      name: "Charminar",
      location: "Hyderabad, Telangana",
      description:
          "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Charminar%20of%20Hyderabad%20Telangana.jpg",
    ),
    _TouristPlace(
      name: "Mysore Palace",
      location: "Mysuru, Karnataka",
      description:
          "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Mysore%20Palace%2C%20Mysuru.jpg",
    ),
    _TouristPlace(
      name: "India Gate",
      location: "New Delhi",
      description:
          "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/India%20gate%20new%20delhi.jpg",
    ),
    _TouristPlace(
      name: "Meenakshi Temple",
      location: "Madurai, Tamil Nadu",
      description:
          "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Meenakshi%20Temple%2C%20Shaivism%2C%20Madurai%2C%20India.jpg",
    ),
    _TouristPlace(
      name: "Hawa Mahal",
      location: "Jaipur, Rajasthan",
      description:
          "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Hawa%20Mahal.jpg",
    ),
    _TouristPlace(
      name: "Qutub Minar",
      location: "Delhi",
      description:
          "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/QutubMInar.jpg",
    ),
    _TouristPlace(
      name: "Ajanta Caves",
      location: "Maharashtra",
      description:
          "Ancient rock-cut Buddhist caves famous for their murals, sculptures and historical significance.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Ajanta%20Caves.jpg",
    ),
    _TouristPlace(
      name: "Konark Sun Temple",
      location: "Odisha",
      description:
          "A magnificent 13th-century temple designed as a colossal chariot dedicated to the Sun God.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/KONARK%20Sun%20Temple.jpg",
    ),
    _TouristPlace(
      name: "Victoria Memorial",
      location: "Kolkata, West Bengal",
      description:
          "A grand marble monument and museum located in the heart of Kolkata.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Victoria%20Memorial%2C%20Kolkata%20India.jpg",
    ),
    _TouristPlace(
      name: "Lotus Temple",
      location: "Delhi",
      description:
          "A famous Bahá'í House of Worship designed in the shape of a beautiful lotus flower.",
      imageUrl:
          "https://commons.wikimedia.org/wiki/Special:Redirect/file/Lotus%20Temple%2C%20Delhi.jpg",
    ),
  ];

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showCaretakerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Caretaker Request"),
          content: const Text("Do you need a caretaker or not?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FindCaretakerScreen(),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showMessage(context, "No caretaker needed.");
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 80,
        titleSpacing: 16,
        title: const Text(
          "Hello Aarav!!",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                _showMessage(context, 'Emergency alert sent.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 2, 23),
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.notifications_active, size: 18),
              label: const Text(
                "SOS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _buildHomeBody(context),
      ),
    );
  }

  Widget _buildHomeBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SEARCH BAR
          TextField(
            decoration: InputDecoration(
              hintText: "Search accessible places...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppTheme.neutral200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // CATEGORY ICONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CategoryIcon(
                icon: Icons.home,
                label: "My Home",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeLocationMapScreen(),
                    ),
                  );
                },
              ),
              _CategoryIcon(
                icon: Icons.people,
                label: "Caretaker",
                onTap: () => _showCaretakerDialog(context),
              ),
              _CategoryIcon(
                icon: Icons.group,
                label: "Community",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CommunityMainScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ACCESSIBILITY PREFERENCES
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Accessibility Preferences",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Customize your experience based on accessibility needs",
                  style: TextStyle(
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    foregroundColor: AppTheme.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AccessibilityPreferencesScreen(),
                      ),
                    );
                  },
                  child: const Text("Set Preferences"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // RECOMMENDED PLACES HEADER
          const Text(
            "Recommended Tourist Places in India",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // TOURIST PLACES LISTVIEW
          ListView.builder(
            itemCount: _touristPlaces.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final place = _touristPlaces[index];
              return _PlaceCard(
                name: place.name,
                location: place.location,
                description: place.description,
                imageUrl: place.imageUrl,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY ICON WIDGET
// ============================================================

class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _CategoryIcon({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        CircleAvatar(
          backgroundColor: AppTheme.primaryLight,
          child: Icon(
            icon,
            color: AppTheme.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: content,
      ),
    );
  }
}

// ============================================================
// PLACE CARD WIDGET
// ============================================================

class _PlaceCard extends StatelessWidget {
  final String name;
  final String location;
  final String description;
  final String imageUrl;

  const _PlaceCard({
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PLACE IMAGE
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.neutral200,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ),

          // PLACE DETAILS
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TouristPlaceDetailPage(
                            placeName: name,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                    ),
                    label: const Text(
                      "Plan a Trip",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
