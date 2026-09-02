import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'plan_trip_page.dart'; // Ensure this points to your plan trip page

class TouristPlaceDetailPage extends StatefulWidget {
  final String placeName; // Passed from the previous screen

  const TouristPlaceDetailPage({
    super.key,
    required this.placeName,
  });

  @override
  State<TouristPlaceDetailPage> createState() => _TouristPlaceDetailPageState();
}

class _TouristPlaceDetailPageState extends State<TouristPlaceDetailPage> {
  String _selectedCategory = "All"; // Default filter option

  // Comprehensive database mapping every home screen tourist place to its specific nearby spots
  static const Map<String, List<Map<String, String>>> _nearbySpotsDatabase = {
    "Taj Mahal": [
      {"name": "Agra Fort", "desc": "A UNESCO World Heritage Site, massive red sandstone fort built by the Mughals.", "category": "Monument"},
      {"name": "Mehtab Bagh", "desc": "Beautiful garden across the Yamuna River offering stunning views of the Taj Mahal.", "category": "Nature"},
      {"name": "Fatehpur Sikri", "desc": "Historic Mughal city with palaces, mosques, and the famous Buland Darwaza.", "category": "Culture"},
      {"name": "Itimad-ud-Daulah's Tomb", "desc": "Often called the 'Baby Taj', an exquisite jewel of early Mughal architecture.", "category": "Monument"},
      {"name": "Akbar’s Tomb, Sikandra", "desc": "Magnificent mausoleum of Emperor Akbar, blending diverse architectural styles.", "category": "Monument"},
    ],
    "Jaipur City Palace": [
      {"name": "Hawa Mahal", "desc": "The iconic Palace of Winds featuring a unique five-story honeycomb exterior.", "category": "Monument"},
      {"name": "Jantar Mantar", "desc": "An astronomical observation site built in the early 18th century.", "category": "Culture"},
      {"name": "Amber Palace", "desc": "Majestic hilltop fort overlooking Maota Lake with grand artistic elements.", "category": "Monument"},
      {"name": "Jal Mahal", "desc": "A striking palace situated right in the middle of the Man Sagar Lake.", "category": "Nature"},
      {"name": "Albert Hall Museum", "desc": "The oldest museum in Rajasthan showcasing extensive local artifacts.", "category": "Culture"},
    ],
    "Gateway of India": [
      {"name": "Taj Mahal Palace Hotel", "desc": "An iconic luxury landmark hotel facing the Arabian Sea.", "category": "Monument"},
      {"name": "Elephanta Caves", "desc": "A network of sculpted cave temples located on an island near Mumbai.", "category": "Monument"},
      {"name": "Colaba Causeway", "desc": "A vibrant street shopping market and foodie hub close to the monument.", "category": "Culture"},
      {"name": "Chhatrapati Shivaji Museum", "desc": "Premier art and history museum featuring rich Indian exhibits.", "category": "Culture"},
      {"name": "Marine Drive", "desc": "A coastal boulevard known as the Queen's Necklace.", "category": "Nature"},
    ],
    "Golden Temple": [
      {"name": "Jallianwala Bagh", "desc": "Historic public garden and national memorial of a tragic historical event.", "category": "Monument"},
      {"name": "Partition Museum", "desc": "A poignant museum capturing the stories and history of the 1947 partition.", "category": "Culture"},
      {"name": "Gobindgarh Fort", "desc": "Historic military fort now turned into a cultural theme park.", "category": "Monument"},
      {"name": "Durgiana Temple", "desc": "A premier Hindu temple resembling the architectural style of the Golden Temple.", "category": "Culture"},
      {"name": "Maharaja Ranjit Singh Museum", "desc": "Museum dedicated to honoring the brave soldiers and military history.", "category": "Culture"},
    ],
    "Charminar": [
      {"name": "Mecca Chowk Market", "desc": "One of the oldest and busiest markets buzzing with local culture and crafts.", "category": "Culture"},
      {"name": "Golconda Fort", "desc": "A majestic fortress complex known for its acoustic architecture and history.", "category": "Monument"},
      {"name": "Qutb Shahi Tombs", "desc": "Magnificent domed mausoleums surrounded by peaceful landscaped gardens.", "category": "Monument"},
      {"name": "Chowmahalla Palace", "desc": "The opulent seat of the Asaf Jahi dynasty showcasing grand courtyards.", "category": "Monument"},
      {"name": "Salar Jung Museum", "desc": "Home to one of the world's largest one-man collections of antiques and art.", "category": "Culture"},
    ],
    "Mysore Palace": [
      {"name": "Chamundeshwari Temple", "desc": "Prominent shrine located atop the Chamundi Hills overlooking Mysuru.", "category": "Culture"},
      {"name": "Mysore Zoo", "desc": "One of the oldest and most well-maintained zoological gardens in India.", "category": "Nature"},
      {"name": "Brindavan Gardens", "desc": "Terraced garden layout featuring a famous musical fountain show.", "category": "Nature"},
      {"name": "St. Philomena's Cathedral", "desc": "A breathtaking neo-Gothic style church inspired by Cologne Cathedral.", "category": "Monument"},
      {"name": "Jaganmohan Palace", "desc": "Royal art gallery exhibiting unique historical paintings and artifacts.", "category": "Culture"},
    ],
    "India Gate": [
      {"name": "Rashtrapati Bhavan", "desc": "The official majestic residence of the President of India.", "category": "Monument"},
      {"name": "National Museum", "desc": "Houses a massive variety of articles ranging from pre-historic eras to modern art.", "category": "Culture"},
      {"name": "Humayun's Tomb", "desc": "Stunning precursor to the Taj Mahal featuring immaculate garden tomb architecture.", "category": "Monument"},
      {"name": "Lodhi Gardens", "desc": "A historic park containing architectural monuments of the Lodhi dynasty.", "category": "Nature"},
      {"name": "National Gallery of Modern Art", "desc": "Prime repository of India's modern art masterpieces.", "category": "Culture"},
    ],
    "Meenakshi Temple": [
      {"name": "Thirumalai Nayakkar Palace", "desc": "17th-century royal palace famed for its grand Indo-Saracenic pillars and courtyard.", "category": "Monument"},
      {"name": "Vandiyur Mariamman Teppakulam", "desc": "A massive temple tank hosting colorful floating festivals.", "category": "Culture"},
      {"name": "Gandhi Memorial Museum", "desc": "Exhibits detailing the life of Mahatma Gandhi alongside historical fragments.", "category": "Culture"},
      {"name": "Koodal Azhagar Temple", "desc": "Ancient shrine dedicated to Lord Vishnu with stunning sculptural work.", "category": "Culture"},
      {"name": "Pazhamudhir Solai", "desc": "Revered sacred hill temple surrounded by dense green forests.", "category": "Nature"},
    ],
    "Hawa Mahal": [
      {"name": "City Palace Jaipur", "desc": "The historical royal hub blending Rajasthani and Mughal planning.", "category": "Monument"},
      {"name": "Jantar Mantar", "desc": "UNESCO site filled with monumental masonry astronomical instruments.", "category": "Culture"},
      {"name": "Tripolia Bazaar", "desc": "A bustling market lane ideal for traditional bangles and brassware.", "category": "Culture"},
      {"name": "Ishwar Lat", "desc": "Historic minaret tower providing a panoramic look over the old pink city.", "category": "Monument"},
      {"name": "Govind Dev Ji Temple", "desc": "Sacred shrine located within the palace gardens visited by devotees daily.", "category": "Culture"},
    ],
    "Qutub Minar": [
      {"name": "Mehrauli Archaeological Park", "desc": "Forest area peppered with historic ruins, stepwells, and tombs.", "category": "Nature"},
      {"name": "Iron Pillar of Delhi", "desc": "An ancient 4th-century architectural marvel renowned for its rust-resistant composition.", "category": "Monument"},
      {"name": "Zafar Mahal", "desc": "The final summer palace built by the last Mughal emperors.", "category": "Monument"},
      {"name": "Ahinsa Sthal", "desc": "Serene Jain temple complex featuring a massive statue of Lord Mahavira.", "category": "Culture"},
      {"name": "Dargah of Qutbuddin Bakhtiyar Kaki", "desc": "A revered and peaceful Sufi shrine located close by.", "category": "Culture"},
    ],
    "Ajanta Caves": [
      {"name": "Ellora Caves", "desc": "Magnificent rock-cut multi-religious temple cave complex nearby.", "category": "Monument"},
      {"name": "Bibi Ka Maqbara", "desc": "A historic mausoleum resembling the Taj Mahal, situated in Aurangabad.", "category": "Monument"},
      {"name": "Daulatabad Fort", "desc": "An extraordinary 14th-century hill fortress with complex defense layouts.", "category": "Monument"},
      {"name": "Siddharth Garden and Zoo", "desc": "A popular local leisure park featuring a green landscape and zoo area.", "category": "Nature"},
      {"name": "Panchakki", "desc": "An old water mill complex operated by underground stream systems.", "category": "Culture"},
    ],
    "Konark Sun Temple": [
      {"name": "Chandrabhaga Beach", "desc": "A scenic, peaceful beach situated close to the temple mouth.", "category": "Nature"},
      {"name": "Kuruba Beach", "desc": "An untouched coastline popular for calm morning strolls.", "category": "Nature"},
      {"name": "Pipli Village", "desc": "Renowned center for traditional appliqué handicraft items and artwork.", "category": "Culture"},
      {"name": "Ramachandi Temple", "desc": "Coastal shrine located by the confluence of the river and sea.", "category": "Culture"},
      {"name": "Udayagiri and Khandagiri Caves", "desc": "Partially natural and artificial caves with historical Jain inscriptions.", "category": "Monument"},
    ],
    "Victoria Memorial": [
      {"name": "St. Paul's Cathedral", "desc": "An Anglican cathedral recognized for its striking Gothic architecture and quiet grounds.", "category": "Monument"},
      {"name": "Maidan Kolkata", "desc": "The largest urban park in Kolkata encompassing vast open green expanses.", "category": "Nature"},
      {"name": "Indian Museum", "desc": "The oldest museum in India carrying rare collections and fossils.", "category": "Culture"},
      {"name": "Eden Gardens", "desc": "Historic and legendary international cricket stadium.", "category": "Culture"},
      {"name": "Princep Ghat", "desc": "Palladian porch monument along the Hooghly River bank offering sunset views.", "category": "Nature"},
    ],
    "Lotus Temple": [
      {"name": "ISKCON Temple Delhi", "desc": "A grand spiritual cultural center dedicated to Lord Krishna.", "category": "Culture"},
      {"name": "Kalkaji Mandir", "desc": "Ancient and highly revered Hindu temple dedicated to Goddess Kali.", "category": "Culture"},
      {"name": "Okhla Bird Sanctuary", "desc": "Wetland habitat hosting hundreds of species of native and migratory birds.", "category": "Nature"},
      {"name": "Humayun's Tomb", "desc": "A stunning garden-tomb complex located a short drive away.", "category": "Monument"},
      {"name": "Hazrat Nizamuddin Dargah", "desc": "Famous spiritual shrine of the Sufi saint Nizamuddin Auliya.", "category": "Culture"},
    ],
  };

  // Filter spots dynamically based on the selected category tab
  List<Map<String, String>> _getFilteredSpots() {
    final rawSpots = _nearbySpotsDatabase[widget.placeName] ?? _nearbySpotsDatabase["Taj Mahal"]!;
    if (_selectedCategory == "All") {
      return rawSpots;
    }
    return rawSpots.where((spot) => spot["category"] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spots = _getFilteredSpots();

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        centerTitle: false,
        toolbarHeight: 80,
        titleSpacing: 16,
        title: Text(
          "Near ${widget.placeName}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Segment Selector Buttons (Matching PlanTripPage layout)
              Row(
                children: [
                  Expanded(child: _buildSegmentButton("All")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSegmentButton("Monument")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSegmentButton("Nature")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSegmentButton("Culture")),
                ],
              ),
              const SizedBox(height: 16),

              // Dynamic List of Nearby Spots
              Expanded(
                child: spots.isEmpty
                    ? Center(
                        child: Text(
                          "No spots found for '$_selectedCategory'",
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        itemCount: spots.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primaryLight,
                              child: const Icon(
                                Icons.place,
                                color: AppTheme.white,
                              ),
                            ),
                            title: Text(
                              spots[index]["name"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                spots[index]["desc"]!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Plan a Trip Button (Matching PlanTripPage button structure)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Plan a Trip",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PlanTripPage(),
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

  // Helper widget for top selection tabs matching PlanTripPage design
  Widget _buildSegmentButton(String title) {
    final bool isSelected = _selectedCategory == title;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primaryLight : AppTheme.white,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: () => setState(() => _selectedCategory = title),
    );
  }
}