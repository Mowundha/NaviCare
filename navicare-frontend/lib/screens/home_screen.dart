// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';

// // Data model for tourist places
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   // Sample data list for tourist places
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description:
//           "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Taj-Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description:
//           "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Jaipur%20City%20Palace%2C%20Rajasthan.jpg",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description:
//           "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Gateway%20of%20India%2C%20Mumbai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description:
//           "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Golden%20Temple%20%28Amritsar%29.jpg",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description:
//           "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Charminar%20of%20Hyderabad%20Telangana.jpg",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description:
//           "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Mysore%20Palace%2C%20Mysuru.jpg",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description:
//           "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/India%20gate%20new%20delhi.jpg",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description:
//           "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Meenakshi%20Temple%2C%20Shaivism%2C%20Madurai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description:
//           "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Hawa%20Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description:
//           "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/QutubMInar.jpg",
//     ),
//     _TouristPlace(
//       name: "Ajanta Caves",
//       location: "Maharashtra",
//       description:
//           "Ancient rock-cut Buddhist caves famous for their murals, sculptures and historical significance.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Ajanta%20Caves.jpg",
//     ),
//     _TouristPlace(
//       name: "Konark Sun Temple",
//       location: "Odisha",
//       description:
//           "A magnificent 13th-century temple designed as a colossal chariot dedicated to the Sun God.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/KONARK%20Sun%20Temple.jpg",
//     ),
//     _TouristPlace(
//       name: "Victoria Memorial",
//       location: "Kolkata, West Bengal",
//       description:
//           "A grand marble monument and museum located in the heart of Kolkata.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Victoria%20Memorial%2C%20Kolkata%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Lotus Temple",
//       location: "Delhi",
//       description:
//           "A famous Bahá'í House of Worship designed in the shape of a beautiful lotus flower.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Lotus%20Temple%2C%20Delhi.jpg",
//     ),
//   ];

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showCaretakerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker or not?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const FindCaretakerScreen(),
//                   ),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 80,
//         titleSpacing: 16,
//         title: const Text(
//           "Hello Aarav!!",
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showMessage(context, 'Emergency alert sent.');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 2, 23),
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               icon: const Icon(Icons.notifications_active, size: 18),
//               label: const Text(
//                 "SOS",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: _buildHomeBody(context),
//       ),
//     );
//   }

//   Widget _buildHomeBody(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // SEARCH BAR
//           TextField(
//             decoration: InputDecoration(
//               hintText: "Search accessible places...",
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: AppTheme.neutral200,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),

//           // CATEGORY ICONS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _CategoryIcon(
//                 icon: Icons.home,
//                 label: "My Home",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const HomeLocationMapScreen(),
//                     ),
//                   );
//                 },
//               ),
//               _CategoryIcon(
//                 icon: Icons.people,
//                 label: "Caretaker",
//                 onTap: () => _showCaretakerDialog(context),
//               ),
//               _CategoryIcon(
//                 icon: Icons.group,
//                 label: "Community",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const CommunityMainScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // ACCESSIBILITY PREFERENCES
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppTheme.primaryLight,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Accessibility Preferences",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppTheme.white,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Customize your experience based on accessibility needs",
//                   style: TextStyle(
//                     color: AppTheme.white,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.white,
//                     foregroundColor: AppTheme.primary,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => const AccessibilityPreferencesScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text("Set Preferences"),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),

//           // RECOMMENDED PLACES HEADER
//           const Text(
//             "Recommended Tourist Places in India",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // TOURIST PLACES LISTVIEW
//           ListView.builder(
//             itemCount: _touristPlaces.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final place = _touristPlaces[index];
//               return _PlaceCard(
//                 name: place.name,
//                 location: place.location,
//                 description: place.description,
//                 imageUrl: place.imageUrl,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // CATEGORY ICON WIDGET
// // ============================================================

// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   const _CategoryIcon({
//     required this.icon,
//     required this.label,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(
//             icon,
//             color: AppTheme.white,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );

//     if (onTap == null) {
//       return content;
//     }

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.all(6),
//         child: content,
//       ),
//     );
//   }
// }

// // ============================================================
// // PLACE CARD WIDGET
// // ============================================================

// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // PLACE IMAGE
//           SizedBox(
//             height: 180,
//             width: double.infinity,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(
//                     child: Icon(
//                       Icons.image_not_supported,
//                       size: 50,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // PLACE DETAILS
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       size: 16,
//                       color: AppTheme.primary,
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(
//                             placeName: name,
//                           ),
//                         ),
//                       );
//                     },
//                     icon: const Icon(
//                       Icons.arrow_forward,
//                     ),
//                     label: const Text(
//                       "Plan a Trip",
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';

// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';

//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Taj-Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Jaipur%20City%20Palace%2C%20Rajasthan.jpg",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Gateway%20of%20India%2C%20Mumbai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Golden%20Temple%20%28Amritsar%29.jpg",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Charminar%20of%20Hyderabad%20Telangana.jpg",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Mysore%20Palace%2C%20Mysuru.jpg",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/India%20gate%20new%20delhi.jpg",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Meenakshi%20Temple%2C%20Shaivism%2C%20Madurai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Hawa%20Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Marina_beach_1.jpg",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/QutubMInar.jpg",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Kerala_backwaters.jpg",
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }

//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showCaretakerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 80,
//         titleSpacing: 16,
//         title: Text(
//           "Hello $_userName!!",
//           style: const TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showMessage(context, 'Emergency alert sent.');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 2, 23),
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               icon: const Icon(Icons.notifications_active, size: 18),
//               label: const Text(
//                 "SOS",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),

//               // TOURIST PLACES LIST
//               ListView.builder(
//                 itemCount: _touristPlaces.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final place = _touristPlaces[index];
//                   return _PlaceCard(
//                     name: place.name,
//                     location: place.location,
//                     description: place.description,
//                     imageUrl: place.imageUrl,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   const _CategoryIcon({required this.icon, required this.label, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }

// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 180,
//             width: double.infinity,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return const Center(child: CircularProgressIndicator());
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(
//                     child: Icon(Icons.image_not_supported, size: 50),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(location, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(placeName: name),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.smart_toy_rounded),
//                     label: const Text("Plan with AI"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';

// // Data model for tourist places
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   // Sample data list for tourist places
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description:
//           "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Taj-Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description:
//           "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Jaipur%20City%20Palace%2C%20Rajasthan.jpg",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description:
//           "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Gateway%20of%20India%2C%20Mumbai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description:
//           "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Golden%20Temple%20%28Amritsar%29.jpg",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description:
//           "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Charminar%20of%20Hyderabad%20Telangana.jpg",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description:
//           "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Mysore%20Palace%2C%20Mysuru.jpg",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description:
//           "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/India%20gate%20new%20delhi.jpg",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description:
//           "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Meenakshi%20Temple%2C%20Shaivism%2C%20Madurai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description:
//           "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Hawa%20Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description:
//           "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/QutubMInar.jpg",
//     ),
//     _TouristPlace(
//       name: "Ajanta Caves",
//       location: "Maharashtra",
//       description:
//           "Ancient rock-cut Buddhist caves famous for their murals, sculptures and historical significance.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Ajanta%20Caves.jpg",
//     ),
//     _TouristPlace(
//       name: "Konark Sun Temple",
//       location: "Odisha",
//       description:
//           "A magnificent 13th-century temple designed as a colossal chariot dedicated to the Sun God.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/KONARK%20Sun%20Temple.jpg",
//     ),
//     _TouristPlace(
//       name: "Victoria Memorial",
//       location: "Kolkata, West Bengal",
//       description:
//           "A grand marble monument and museum located in the heart of Kolkata.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Victoria%20Memorial%2C%20Kolkata%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Lotus Temple",
//       location: "Delhi",
//       description:
//           "A famous Bahá'í House of Worship designed in the shape of a beautiful lotus flower.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Lotus%20Temple%2C%20Delhi.jpg",
//     ),
//   ];

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showCaretakerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker or not?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const FindCaretakerScreen(),
//                   ),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 80,
//         titleSpacing: 16,
//         title: const Text(
//           "Hello Aarav!!",
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showMessage(context, 'Emergency alert sent.');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 2, 23),
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               icon: const Icon(Icons.notifications_active, size: 18),
//               label: const Text(
//                 "SOS",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: _buildHomeBody(context),
//       ),
//     );
//   }

//   Widget _buildHomeBody(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // SEARCH BAR
//           TextField(
//             decoration: InputDecoration(
//               hintText: "Search accessible places...",
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: AppTheme.neutral200,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),

//           // CATEGORY ICONS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _CategoryIcon(
//                 icon: Icons.home,
//                 label: "My Home",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const HomeLocationMapScreen(),
//                     ),
//                   );
//                 },
//               ),
//               _CategoryIcon(
//                 icon: Icons.people,
//                 label: "Caretaker",
//                 onTap: () => _showCaretakerDialog(context),
//               ),
//               _CategoryIcon(
//                 icon: Icons.group,
//                 label: "Community",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const CommunityMainScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // ACCESSIBILITY PREFERENCES
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppTheme.primaryLight,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Accessibility Preferences",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppTheme.white,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Customize your experience based on accessibility needs",
//                   style: TextStyle(
//                     color: AppTheme.white,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.white,
//                     foregroundColor: AppTheme.primary,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => const AccessibilityPreferencesScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text("Set Preferences"),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),

//           // RECOMMENDED PLACES HEADER
//           const Text(
//             "Recommended Tourist Places in India",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // TOURIST PLACES LISTVIEW
//           ListView.builder(
//             itemCount: _touristPlaces.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final place = _touristPlaces[index];
//               return _PlaceCard(
//                 name: place.name,
//                 location: place.location,
//                 description: place.description,
//                 imageUrl: place.imageUrl,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // CATEGORY ICON WIDGET
// // ============================================================

// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   const _CategoryIcon({
//     required this.icon,
//     required this.label,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(
//             icon,
//             color: AppTheme.white,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );

//     if (onTap == null) {
//       return content;
//     }

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.all(6),
//         child: content,
//       ),
//     );
//   }
// }

// // ============================================================
// // PLACE CARD WIDGET
// // ============================================================

// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // PLACE IMAGE
//           SizedBox(
//             height: 180,
//             width: double.infinity,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(
//                     child: Icon(
//                       Icons.image_not_supported,
//                       size: 50,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // PLACE DETAILS
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       size: 16,
//                       color: AppTheme.primary,
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(
//                             placeName: name,
//                           ),
//                         ),
//                       );
//                     },
//                     icon: const Icon(
//                       Icons.arrow_forward,
//                     ),
//                     label: const Text(
//                       "Plan a Trip",
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';

// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';

//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Taj-Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Jaipur%20City%20Palace%2C%20Rajasthan.jpg",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Gateway%20of%20India%2C%20Mumbai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Golden%20Temple%20%28Amritsar%29.jpg",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Charminar%20of%20Hyderabad%20Telangana.jpg",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Mysore%20Palace%2C%20Mysuru.jpg",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/India%20gate%20new%20delhi.jpg",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Meenakshi%20Temple%2C%20Shaivism%2C%20Madurai%2C%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Hawa%20Mahal.jpg",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Marina_beach_1.jpg",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/QutubMInar.jpg",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://commons.wikimedia.org/wiki/Special:Redirect/file/Kerala_backwaters.jpg",
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }

//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showCaretakerDialog(BuildContext context) {
//     // Go directly to caretaker finder — no popup needed
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 80,
//         titleSpacing: 16,
//         title: Text(
//           "Hello $_userName!!",
//           style: const TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showMessage(context, 'Emergency alert sent.');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 2, 23),
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               icon: const Icon(Icons.notifications_active, size: 18),
//               label: const Text(
//                 "SOS",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),

//               // TOURIST PLACES LIST
//               ListView.builder(
//                 itemCount: _touristPlaces.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final place = _touristPlaces[index];
//                   return _PlaceCard(
//                     name: place.name,
//                     location: place.location,
//                     description: place.description,
//                     imageUrl: place.imageUrl,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   const _CategoryIcon({required this.icon, required this.label, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }

// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 180,
//             width: double.infinity,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return const Center(child: CircularProgressIndicator());
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(
//                     child: Icon(Icons.image_not_supported, size: 50),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(location, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(placeName: name),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.smart_toy_rounded),
//                     label: const Text("Plan with AI"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }























































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';

// // Data model for tourist places
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   // Sample data list for tourist places
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description:
//           "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl:
//           "https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description:
//           "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl:
//           "https://images.pexels.com/photos/3581368/pexels-photo-3581368.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description:
//           "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl:
//           "https://images.pexels.com/photos/2166553/pexels-photo-2166553.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description:
//           "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl:
//           "https://images.pexels.com/photos/3573382/pexels-photo-3573382.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description:
//           "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl:
//           "https://images.pexels.com/photos/3573351/pexels-photo-3573351.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description:
//           "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl:
//           "https://images.pexels.com/photos/4495813/pexels-photo-4495813.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description:
//           "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl:
//           "https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description:
//           "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl:
//           "https://images.pexels.com/photos/3581369/pexels-photo-3581369.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description:
//           "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl:
//           "https://images.pexels.com/photos/3581372/pexels-photo-3581372.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description:
//           "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl:
//           "https://images.pexels.com/photos/3587888/pexels-photo-3587888.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Ajanta Caves",
//       location: "Maharashtra",
//       description:
//           "Ancient rock-cut Buddhist caves famous for their murals, sculptures and historical significance.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Ajanta%20Caves.jpg",
//     ),
//     _TouristPlace(
//       name: "Konark Sun Temple",
//       location: "Odisha",
//       description:
//           "A magnificent 13th-century temple designed as a colossal chariot dedicated to the Sun God.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/KONARK%20Sun%20Temple.jpg",
//     ),
//     _TouristPlace(
//       name: "Victoria Memorial",
//       location: "Kolkata, West Bengal",
//       description:
//           "A grand marble monument and museum located in the heart of Kolkata.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Victoria%20Memorial%2C%20Kolkata%20India.jpg",
//     ),
//     _TouristPlace(
//       name: "Lotus Temple",
//       location: "Delhi",
//       description:
//           "A famous Bahá'í House of Worship designed in the shape of a beautiful lotus flower.",
//       imageUrl:
//           "https://commons.wikimedia.org/wiki/Special:Redirect/file/Lotus%20Temple%2C%20Delhi.jpg",
//     ),
//   ];

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showCaretakerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker or not?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const FindCaretakerScreen(),
//                   ),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 80,
//         titleSpacing: 16,
//         title: const Text(
//           "Hello Aarav!!",
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showMessage(context, 'Emergency alert sent.');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 2, 23),
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               icon: const Icon(Icons.notifications_active, size: 18),
//               label: const Text(
//                 "SOS",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: _buildHomeBody(context),
//       ),
//     );
//   }

//   Widget _buildHomeBody(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // SEARCH BAR
//           TextField(
//             decoration: InputDecoration(
//               hintText: "Search accessible places...",
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: AppTheme.neutral200,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),

//           // CATEGORY ICONS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _CategoryIcon(
//                 icon: Icons.home,
//                 label: "My Home",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const HomeLocationMapScreen(),
//                     ),
//                   );
//                 },
//               ),
//               _CategoryIcon(
//                 icon: Icons.people,
//                 label: "Caretaker",
//                 onTap: () => _showCaretakerDialog(context),
//               ),
//               _CategoryIcon(
//                 icon: Icons.group,
//                 label: "Community",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const CommunityMainScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),

//           // ACCESSIBILITY PREFERENCES
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppTheme.primaryLight,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Accessibility Preferences",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppTheme.white,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Customize your experience based on accessibility needs",
//                   style: TextStyle(
//                     color: AppTheme.white,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.white,
//                     foregroundColor: AppTheme.primary,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => const AccessibilityPreferencesScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text("Set Preferences"),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),

//           // RECOMMENDED PLACES HEADER
//           const Text(
//             "Recommended Tourist Places in India",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // TOURIST PLACES LISTVIEW
//           ListView.builder(
//             itemCount: _touristPlaces.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final place = _touristPlaces[index];
//               return _PlaceCard(
//                 name: place.name,
//                 location: place.location,
//                 description: place.description,
//                 imageUrl: place.imageUrl,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // CATEGORY ICON WIDGET
// // ============================================================

// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   const _CategoryIcon({
//     required this.icon,
//     required this.label,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(
//             icon,
//             color: AppTheme.white,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );

//     if (onTap == null) {
//       return content;
//     }

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(
//         padding: const EdgeInsets.all(6),
//         child: content,
//       ),
//     );
//   }
// }

// // ============================================================
// // PLACE CARD WIDGET
// // ============================================================

// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // PLACE IMAGE
//           SizedBox(
//             height: 180,
//             width: double.infinity,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(
//                     child: Icon(
//                       Icons.image_not_supported,
//                       size: 50,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // PLACE DETAILS
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       size: 16,
//                       color: AppTheme.primary,
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(
//                             placeName: name,
//                           ),
//                         ),
//                       );
//                     },
//                     icon: const Icon(
//                       Icons.arrow_forward,
//                     ),
//                     label: const Text(
//                       "Plan a Trip",
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';

// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';

//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://images.pexels.com/photos/3581368/pexels-photo-3581368.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://images.pexels.com/photos/2166553/pexels-photo-2166553.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://images.pexels.com/photos/3573382/pexels-photo-3573382.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://images.pexels.com/photos/4495813/pexels-photo-4495813.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://images.pexels.com/photos/3581369/pexels-photo-3581369.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://images.pexels.com/photos/3581372/pexels-photo-3581372.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://images.pexels.com/photos/3651820/pexels-photo-3651820.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://images.pexels.com/photos/3587888/pexels-photo-3587888.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://images.pexels.com/photos/3697742/pexels-photo-3697742.jpeg?w=400",
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }

//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showCaretakerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 80,
//         titleSpacing: 16,
//         title: Text(
//           "Hello $_userName!!",
//           style: const TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showMessage(context, 'Emergency alert sent.');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 2, 23),
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               icon: const Icon(Icons.notifications_active, size: 18),
//               label: const Text(
//                 "SOS",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),

//               // TOURIST PLACES - 2 per row horizontal grid
//               GridView.builder(
//                 itemCount: _touristPlaces.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.78,
//                 ),
//                 itemBuilder: (context, index) {
//                   final place = _touristPlaces[index];
//                   return _PlaceCard(
//                     name: place.name,
//                     location: place.location,
//                     description: place.description,
//                     imageUrl: place.imageUrl,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;

//   const _CategoryIcon({required this.icon, required this.label, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }

// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Image.network(
//               imageUrl,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Container(color: AppTheme.neutral200,
//                   child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(child: Icon(Icons.photo_camera, size: 36, color: Colors.grey)),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 3),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(location, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(placeName: name),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.smart_toy_rounded),
//                     label: const Text("Plan with AI"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


























































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';
 
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }
 
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
 
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
 
// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';
//   String _searchQuery = '';
 
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://images.pexels.com/photos/3581368/pexels-photo-3581368.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://images.pexels.com/photos/2166553/pexels-photo-2166553.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://images.pexels.com/photos/3573382/pexels-photo-3573382.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://images.pexels.com/photos/4495813/pexels-photo-4495813.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://images.pexels.com/photos/3581369/pexels-photo-3581369.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://images.pexels.com/photos/3581372/pexels-photo-3581372.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://images.pexels.com/photos/3651820/pexels-photo-3651820.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://images.pexels.com/photos/3587888/pexels-photo-3587888.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://images.pexels.com/photos/3697742/pexels-photo-3697742.jpeg?w=400",
//     ),
//   ];
 
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }
 
//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }
 
//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
 
//   void _showCaretakerDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }
//   void _showCaretakerDialogOLD(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 80,
//         titleSpacing: 16,
//         title: Text(
//           "Hello $_userName!!",
//           style: const TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 _showMessage(context, 'Emergency alert sent.');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 255, 2, 23),
//                 foregroundColor: AppTheme.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               icon: const Icon(Icons.notifications_active, size: 18),
//               label: const Text(
//                 "SOS",
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
 
//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
 
//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
 
//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
 
//               // TOURIST PLACES - 2 per row horizontal grid
//               GridView.builder(
//                 itemCount: _touristPlaces.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.78,
//                 ),
//                 itemBuilder: (context, index) {
//                   final place = _touristPlaces[index];
//                   return _PlaceCard(
//                     name: place.name,
//                     location: place.location,
//                     description: place.description,
//                     imageUrl: place.imageUrl,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
 
// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
 
//   const _CategoryIcon({required this.icon, required this.label, this.onTap});
 
//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }
 
// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Image.network(
//               imageUrl,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Container(color: AppTheme.neutral200,
//                   child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(child: Icon(Icons.photo_camera, size: 36, color: Colors.grey)),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 3),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(location, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(placeName: name),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.smart_toy_rounded),
//                     label: const Text("Plan a Trip"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


























































































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';
 
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }
 
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
 
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
 
// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';
//   String _searchQuery = '';
 
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://images.pexels.com/photos/3581368/pexels-photo-3581368.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://images.pexels.com/photos/2166553/pexels-photo-2166553.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://images.pexels.com/photos/3573382/pexels-photo-3573382.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://images.pexels.com/photos/4495813/pexels-photo-4495813.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://images.pexels.com/photos/3581369/pexels-photo-3581369.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://images.pexels.com/photos/3581372/pexels-photo-3581372.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://images.pexels.com/photos/3651820/pexels-photo-3651820.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://images.pexels.com/photos/3587888/pexels-photo-3587888.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://images.pexels.com/photos/3697742/pexels-photo-3697742.jpeg?w=400",
//     ),
//   ];
 
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }
 
//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }
 
//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
 
//   void _showCaretakerDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }
//   void _showCaretakerDialogOLD(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 64,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.accessible, color: AppTheme.primary, size: 22),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               "Hello $_userName!",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         actions: const [],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
 
//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
 
//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
 
//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
 
//               // TOURIST PLACES - 2 per row horizontal grid
//               GridView.builder(
//                 itemCount: _touristPlaces.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.78,
//                 ),
//                 itemBuilder: (context, index) {
//                   final place = _touristPlaces[index];
//                   return _PlaceCard(
//                     name: place.name,
//                     location: place.location,
//                     description: place.description,
//                     imageUrl: place.imageUrl,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
 
// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
 
//   const _CategoryIcon({required this.icon, required this.label, this.onTap});
 
//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }
 
// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Image.network(
//               imageUrl,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Container(color: AppTheme.neutral200,
//                   child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: AppTheme.neutral200,
//                   child: const Center(child: Icon(Icons.photo_camera, size: 36, color: Colors.grey)),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 3),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(location, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => TouristPlaceDetailPage(placeName: name),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.smart_toy_rounded),
//                     label: const Text("Plan a Trip"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: AppTheme.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




































































































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';
 
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }
 
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
 
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
 
// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';
//   String _searchQuery = '';
 
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://images.pexels.com/photos/3581368/pexels-photo-3581368.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://images.pexels.com/photos/2166553/pexels-photo-2166553.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://images.pexels.com/photos/3573382/pexels-photo-3573382.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://images.pexels.com/photos/4495813/pexels-photo-4495813.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://images.pexels.com/photos/3581369/pexels-photo-3581369.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://images.pexels.com/photos/3581372/pexels-photo-3581372.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://images.pexels.com/photos/3651820/pexels-photo-3651820.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://images.pexels.com/photos/3587888/pexels-photo-3587888.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://images.pexels.com/photos/3697742/pexels-photo-3697742.jpeg?w=400",
//     ),
//   ];
 
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }
 
//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }
 
//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
 
//   void _showCaretakerDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }
//   void _showCaretakerDialogOLD(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 64,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.accessible, color: AppTheme.primary, size: 22),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               "Hello $_userName!",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         actions: const [],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
 
//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
 
//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
 
//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
 
//               // TOURIST PLACES - 2 per row grid
//               GridView.builder(
//                 itemCount: _touristPlaces.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.72,
//                 ),
//                 itemBuilder: (context, index) {
//                   final place = _touristPlaces[index];
//                   return _PlaceCard(
//                     name: place.name,
//                     location: place.location,
//                     description: place.description,
//                     imageUrl: place.imageUrl,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
 
// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
 
//   const _CategoryIcon({required this.icon, required this.label, this.onTap});
 
//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }
 
// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => TouristPlaceDetailPage(placeName: name),
//             ),
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image: fixed height so it never overflows
//             SizedBox(
//               height: 120,
//               width: double.infinity,
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 headers: const {'User-Agent': 'Mozilla/5.0'},
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.landscape_rounded, size: 36, color: Colors.grey[400]),
//                         const SizedBox(height: 4),
//                         Text(name.split(' ').first, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Content area
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 3),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 11, color: AppTheme.primary),
//                         const SizedBox(width: 2),
//                         Expanded(
//                           child: Text(
//                             location,
//                             style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => TouristPlaceDetailPage(placeName: name),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primary,
//                           foregroundColor: AppTheme.white,
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.smart_toy_rounded, size: 13),
//                             SizedBox(width: 4),
//                             Text('Plan a Trip', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
































































































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import '../services/sos_service.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';

// // ─── Data model ──────────────────────────────────────────────────────────────

// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }

// // ─── HomeScreen ──────────────────────────────────────────────────────────────

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';
//   String _searchQuery = '';

//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://images.pexels.com/photos/3581368/pexels-photo-3581368.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://images.pexels.com/photos/2166553/pexels-photo-2166553.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://images.pexels.com/photos/3573382/pexels-photo-3573382.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://images.pexels.com/photos/4495813/pexels-photo-4495813.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://images.pexels.com/photos/3581369/pexels-photo-3581369.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://images.pexels.com/photos/3581372/pexels-photo-3581372.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://images.pexels.com/photos/3651820/pexels-photo-3651820.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://images.pexels.com/photos/3587888/pexels-photo-3587888.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://images.pexels.com/photos/3697742/pexels-photo-3697742.jpeg?w=400",
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }

//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }

//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _showCaretakerDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }

//   // ── SOS confirmation dialog ────────────────────────────────────────────────

//   Future<void> _showSosConfirmDialog(BuildContext context) async {
//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Pulsing SOS icon
//               Container(
//                 width: 72,
//                 height: 72,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.red.shade300, width: 2),
//                 ),
//                 child: const Icon(Icons.sos_rounded, color: Colors.red, size: 40),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Send SOS Alert?',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Your current GPS location, name, booking details, and timestamp will be sent immediately to your emergency contacts and government services.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   // NO
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(false),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: BorderSide(color: Colors.grey.shade400),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'No, Cancel',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // YES
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Yes, SOS!',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (confirmed == true && context.mounted) {
//       _triggerSos(context);
//     }
//   }

//   Future<void> _triggerSos(BuildContext context) async {
//     // Show loading indicator
//     if (!context.mounted) return;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(color: Colors.red),
//                 SizedBox(height: 16),
//                 Text('Sending SOS...', style: TextStyle(fontWeight: FontWeight.w600)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     final result = await SosService.triggerSOS();

//     if (context.mounted) {
//       Navigator.of(context).pop(); // dismiss loading
//       _showSosResultDialog(context, result);
//     }
//   }

//   void _showSosResultDialog(BuildContext context, String message) {
//     final bool success = message.contains('successfully');
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(
//               success ? Icons.check_circle_rounded : Icons.error_rounded,
//               color: success ? Colors.green : Colors.red,
//             ),
//             const SizedBox(width: 8),
//             Text(success ? 'SOS Sent' : 'SOS Failed'),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 64,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.accessible, color: AppTheme.primary, size: 22),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               "Hello $_userName!",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         // ── SOS button top-right ────────────────────────────────────────────
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: GestureDetector(
//               onTap: () => _showSosConfirmDialog(context),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.withOpacity(0.4),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.sos_rounded, color: Colors.white, size: 18),
//                     SizedBox(width: 5),
//                     Text(
//                       'SOS',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Accessibility Preferences",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const AccessibilityPreferencesScreen(),
//                               ),
//                             );
//                           },
//                           child: const Text("Edit"),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: const [
//                         _PrefChip(label: "♿ Wheelchair"),
//                         _PrefChip(label: "🚻 Restroom"),
//                         _PrefChip(label: "🛗 Elevator"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // PLACES GRID
//               const Text(
//                 "Accessible Destinations",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               _buildPlacesGrid(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlacesGrid() {
//     final filtered = _searchQuery.isEmpty
//         ? _touristPlaces
//         : _touristPlaces
//             .where((p) =>
//                 p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//                 p.location.toLowerCase().contains(_searchQuery.toLowerCase()))
//             .toList();

//     if (filtered.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(32),
//           child: Text('No places found.', style: TextStyle(color: Colors.grey)),
//         ),
//       );
//     }

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.75,
//       ),
//       itemCount: filtered.length,
//       itemBuilder: (_, i) => _PlaceCard(
//         name: filtered[i].name,
//         location: filtered[i].location,
//         description: filtered[i].description,
//         imageUrl: filtered[i].imageUrl,
//       ),
//     );
//   }
// }

// // ─── Helper widgets ───────────────────────────────────────────────────────────

// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _CategoryIcon({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 28,
//             backgroundColor: AppTheme.primaryLight,
//             child: Icon(icon, color: AppTheme.primary, size: 28),
//           ),
//           const SizedBox(height: 6),
//           Text(label, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }

// class _PrefChip extends StatelessWidget {
//   final String label;
//   const _PrefChip({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: AppTheme.primary.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(label, style: const TextStyle(fontSize: 12)),
//     );
//   }
// }

// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;

//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => TouristPlaceDetailPage(placeName: name),
//             ),
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 120,
//               width: double.infinity,
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 headers: const {'User-Agent': 'Mozilla/5.0'},
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.landscape_rounded, size: 36, color: Colors.grey[400]),
//                         const SizedBox(height: 4),
//                         Text(
//                           name.split(' ').first,
//                           style: TextStyle(fontSize: 10, color: Colors.grey[500]),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 3),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 11, color: AppTheme.primary),
//                         const SizedBox(width: 2),
//                         Expanded(
//                           child: Text(
//                             location,
//                             style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => TouristPlaceDetailPage(placeName: name),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primary,
//                           foregroundColor: AppTheme.white,
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.smart_toy_rounded, size: 13),
//                             SizedBox(width: 4),
//                             Text(
//                               'Plan a Trip',
//                               style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





































































































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import '../services/sos_service.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';
 
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }
 
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
 
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
 
// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';
//   String _searchQuery = '';
 
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://images.pexels.com/photos/1603650/pexels-photo-1603650.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://images.pexels.com/photos/3581368/pexels-photo-3581368.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://images.pexels.com/photos/2166553/pexels-photo-2166553.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://images.pexels.com/photos/3573382/pexels-photo-3573382.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://images.pexels.com/photos/4495813/pexels-photo-4495813.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://images.pexels.com/photos/789750/pexels-photo-789750.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://images.pexels.com/photos/3581369/pexels-photo-3581369.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://images.pexels.com/photos/3581372/pexels-photo-3581372.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://images.pexels.com/photos/3651820/pexels-photo-3651820.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://images.pexels.com/photos/3587888/pexels-photo-3587888.jpeg?w=400",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://images.pexels.com/photos/3697742/pexels-photo-3697742.jpeg?w=400",
//     ),
//   ];
 
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }
 
//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }
 
//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
 
//   void _showCaretakerDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }

//   void _showCaretakerDialogOLD(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ── SOS: confirm → loading → result ───────────────────────────────────────

//   Future<void> _showSosConfirmDialog(BuildContext context) async {
//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 72,
//                 height: 72,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.red.shade300, width: 2),
//                 ),
//                 child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Are you sure about SOS?',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Your GPS location, name, booking details, and timestamp will be sent to your emergency contacts and government services immediately.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(false),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: BorderSide(color: Colors.grey.shade400),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'No',
//                         style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Yes',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (confirmed == true && context.mounted) {
//       await _triggerSos(context);
//     }
//   }

//   Future<void> _triggerSos(BuildContext context) async {
//     if (!context.mounted) return;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(color: Colors.red),
//                 SizedBox(height: 16),
//                 Text('Sending SOS...', style: TextStyle(fontWeight: FontWeight.w600)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     final result = await SosService.triggerSOS();

//     if (context.mounted) {
//       Navigator.of(context).pop(); // close loading
//       final bool success = result.contains('successfully');
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Row(
//             children: [
//               Icon(
//                 success ? Icons.check_circle_rounded : Icons.error_rounded,
//                 color: success ? Colors.green : Colors.red,
//               ),
//               const SizedBox(width: 8),
//               Text(success ? 'SOS Sent' : 'SOS Failed'),
//             ],
//           ),
//           content: Text(result),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 64,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.accessible, color: AppTheme.primary, size: 22),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               "Hello $_userName!",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         // ── Only change from original: SOS button replacing empty actions ──
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: GestureDetector(
//               onTap: () => _showSosConfirmDialog(context),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.withOpacity(0.4),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 // Icon only — no Text widget, so no duplicate word
//                 child: const Icon(Icons.sos_rounded, color: Colors.white, size: 32),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
 
//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
 
//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
 
//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
 
//               // TOURIST PLACES - 2 per row grid
//               GridView.builder(
//                 itemCount: _touristPlaces.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.72,
//                 ),
//                 itemBuilder: (context, index) {
//                   final place = _touristPlaces[index];
//                   return _PlaceCard(
//                     name: place.name,
//                     location: place.location,
//                     description: place.description,
//                     imageUrl: place.imageUrl,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
 
// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
 
//   const _CategoryIcon({required this.icon, required this.label, this.onTap});
 
//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }
 
// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => TouristPlaceDetailPage(placeName: name),
//             ),
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image: fixed height so it never overflows
//             SizedBox(
//               height: 120,
//               width: double.infinity,
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 headers: const {'User-Agent': 'Mozilla/5.0'},
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.landscape_rounded, size: 36, color: Colors.grey[400]),
//                         const SizedBox(height: 4),
//                         Text(name.split(' ').first, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Content area
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 3),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 11, color: AppTheme.primary),
//                         const SizedBox(width: 2),
//                         Expanded(
//                           child: Text(
//                             location,
//                             style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => TouristPlaceDetailPage(placeName: name),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primary,
//                           foregroundColor: AppTheme.white,
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.smart_toy_rounded, size: 13),
//                             SizedBox(width: 4),
//                             Text('Plan a Trip', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }























































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import '../services/sos_service.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';
 
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }
 
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
 
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
 
// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';
//   String _searchQuery = '';
 
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Taj_Mahal_%28Edited%29.jpeg/320px-Taj_Mahal_%28Edited%29.jpeg",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Jaipur_03-2016_15_City_Palace.jpg/320px-Jaipur_03-2016_15_City_Palace.jpg",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Gateway_of_India_2651527.jpg/320px-Gateway_of_India_2651527.jpg",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Golden_Temple%2C_Amritsar%2C_India_-_Aug_2012.jpg/320px-Golden_Temple%2C_Amritsar%2C_India_-_Aug_2012.jpg",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Charminar-Hyderabad.jpg/240px-Charminar-Hyderabad.jpg",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/East_facade_of_Mysore_Palace.jpg/320px-East_facade_of_Mysore_Palace.jpg",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/India_Gate_immediate_02-2016.jpg/240px-India_Gate_immediate_02-2016.jpg",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Meenakshi_Amman_Temple_Madurai.jpg/240px-Meenakshi_Amman_Temple_Madurai.jpg",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Hawa_Mahal_Jaipur_Rajasthan_India.jpg/180px-Hawa_Mahal_Jaipur_Rajasthan_India.jpg",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Chennai_Marina_beach_morning.jpg/320px-Chennai_Marina_beach_morning.jpg",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Qutab_Minar_2011.jpg/180px-Qutab_Minar_2011.jpg",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Kerala_backwaters_boat.jpg/320px-Kerala_backwaters_boat.jpg",
//     ),
//   ];
 
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }
 
//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }
 
//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
 
//   void _showCaretakerDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }

//   void _showCaretakerDialogOLD(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ── SOS: confirm → loading → result ───────────────────────────────────────

//   Future<void> _showSosConfirmDialog(BuildContext context) async {
//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 72,
//                 height: 72,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.red.shade300, width: 2),
//                 ),
//                 child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Are you sure about SOS?',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Your GPS location, name, booking details, and timestamp will be sent to your emergency contacts and government services immediately.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(false),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: BorderSide(color: Colors.grey.shade400),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'No',
//                         style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Yes',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (confirmed == true && context.mounted) {
//       await _triggerSos(context);
//     }
//   }

//   Future<void> _triggerSos(BuildContext context) async {
//     if (!context.mounted) return;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(color: Colors.red),
//                 SizedBox(height: 16),
//                 Text('Sending SOS...', style: TextStyle(fontWeight: FontWeight.w600)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     final result = await SosService.triggerSOS();

//     if (context.mounted) {
//       Navigator.of(context).pop(); // close loading
//       final bool success = result.contains('successfully');
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Row(
//             children: [
//               Icon(
//                 success ? Icons.check_circle_rounded : Icons.error_rounded,
//                 color: success ? Colors.green : Colors.red,
//               ),
//               const SizedBox(width: 8),
//               Text(success ? 'SOS Sent' : 'SOS Failed'),
//             ],
//           ),
//           content: Text(result),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 64,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.accessible, color: AppTheme.primary, size: 22),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               "Hello $_userName!",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         // ── Only change from original: SOS button replacing empty actions ──
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: GestureDetector(
//               onTap: () => _showSosConfirmDialog(context),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.withOpacity(0.4),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 // Icon only — no Text widget, so no duplicate word
//                 child: const Icon(Icons.sos_rounded, color: Colors.white, size: 32),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
 
//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
 
//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
 
//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
 
//               // TOURIST PLACES - responsive grid
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   // On wide screens (web/tablet) use more columns
//                   final width = constraints.maxWidth;
//                   final crossAxisCount = width > 900 ? 4 : width > 600 ? 3 : 2;
//                   final ratio = width > 600 ? 0.85 : 0.72;
//                   return GridView.builder(
//                     itemCount: _touristPlaces.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: crossAxisCount,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 12,
//                       childAspectRatio: ratio,
//                     ),
//                     itemBuilder: (context, index) {
//                       final place = _touristPlaces[index];
//                       return _PlaceCard(
//                         name: place.name,
//                         location: place.location,
//                         description: place.description,
//                         imageUrl: place.imageUrl,
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
 
// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
 
//   const _CategoryIcon({required this.icon, required this.label, this.onTap});
 
//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }
 
// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => TouristPlaceDetailPage(placeName: name),
//             ),
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image: fixed height so it never overflows
//             SizedBox(
//               height: 120,
//               width: double.infinity,
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.landscape_rounded, size: 36, color: Colors.grey[400]),
//                         const SizedBox(height: 4),
//                         Text(name.split(' ').first, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Content area
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 3),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 11, color: AppTheme.primary),
//                         const SizedBox(width: 2),
//                         Expanded(
//                           child: Text(
//                             location,
//                             style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => TouristPlaceDetailPage(placeName: name),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primary,
//                           foregroundColor: AppTheme.white,
//                           padding: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.smart_toy_rounded, size: 13),
//                             SizedBox(width: 4),
//                             Text('Plan a Trip', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





























































































































// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../services/token_storage.dart';
// import '../services/sos_service.dart';
// import 'accessibility_preferences_screen.dart';
// import 'find_caretaker_screen.dart';
// import 'community_main_screen.dart';
// import 'home_location_map_screen.dart';
// import 'tourist_place_detail_page.dart';
 
// class _TouristPlace {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _TouristPlace({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
// }
 
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
 
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
 
// class _HomeScreenState extends State<HomeScreen> {
//   String _userName = 'User';
//   String _searchQuery = '';
 
//   static const List<_TouristPlace> _touristPlaces = [
//     _TouristPlace(
//       name: "Taj Mahal",
//       location: "Agra, Uttar Pradesh",
//       description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
//       imageUrl: "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Jaipur City Palace",
//       location: "Jaipur, Rajasthan",
//       description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
//       imageUrl: "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Gateway of India",
//       location: "Mumbai, Maharashtra",
//       description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
//       imageUrl: "https://images.unsplash.com/photo-1529253355930-ddbe423a2ac7?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Golden Temple",
//       location: "Amritsar, Punjab",
//       description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
//       imageUrl: "https://images.unsplash.com/photo-1514222134-b57cbb8ce073?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Charminar",
//       location: "Hyderabad, Telangana",
//       description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
//       imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Mysore Palace",
//       location: "Mysuru, Karnataka",
//       description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
//       imageUrl: "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "India Gate",
//       location: "New Delhi",
//       description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
//       imageUrl: "https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Meenakshi Temple",
//       location: "Madurai, Tamil Nadu",
//       description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
//       imageUrl: "https://images.unsplash.com/photo-1621996659490-3275b4d0d951?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Hawa Mahal",
//       location: "Jaipur, Rajasthan",
//       description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
//       imageUrl: "https://images.unsplash.com/photo-1548013146-72479768bada?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Marina Beach",
//       location: "Chennai, Tamil Nadu",
//       description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
//       imageUrl: "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Qutub Minar",
//       location: "Delhi",
//       description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
//       imageUrl: "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=400&h=250&fit=crop",
//     ),
//     _TouristPlace(
//       name: "Kerala Backwaters",
//       location: "Alleppey, Kerala",
//       description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
//       imageUrl: "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400&h=250&fit=crop",
//     ),
//   ];
 
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }
 
//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }
 
//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
 
//   void _showCaretakerDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//     );
//   }

//   void _showCaretakerDialogOLD(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Caretaker Request"),
//           content: const Text("Do you need a caretaker?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
//                 );
//               },
//               child: const Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _showMessage(context, "No caretaker needed.");
//               },
//               child: const Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ── SOS: confirm → loading → result ───────────────────────────────────────

//   Future<void> _showSosConfirmDialog(BuildContext context) async {
//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 72,
//                 height: 72,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.red.shade300, width: 2),
//                 ),
//                 child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Are you sure about SOS?',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Your GPS location, name, booking details, and timestamp will be sent to your emergency contacts and government services immediately.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(false),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: BorderSide(color: Colors.grey.shade400),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'No',
//                         style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Yes',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (confirmed == true && context.mounted) {
//       await _triggerSos(context);
//     }
//   }

//   Future<void> _triggerSos(BuildContext context) async {
//     if (!context.mounted) return;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(color: Colors.red),
//                 SizedBox(height: 16),
//                 Text('Sending SOS...', style: TextStyle(fontWeight: FontWeight.w600)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     final result = await SosService.triggerSOS();

//     if (context.mounted) {
//       Navigator.of(context).pop(); // close loading
//       final bool success = result.contains('successfully');
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Row(
//             children: [
//               Icon(
//                 success ? Icons.check_circle_rounded : Icons.error_rounded,
//                 color: success ? Colors.green : Colors.red,
//               ),
//               const SizedBox(width: 8),
//               Text(success ? 'SOS Sent' : 'SOS Failed'),
//             ],
//           ),
//           content: Text(result),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(ctx).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.neutral100,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: AppTheme.white,
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         toolbarHeight: 64,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.accessible, color: AppTheme.primary, size: 22),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               "Hello $_userName!",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         // ── Only change from original: SOS button replacing empty actions ──
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: GestureDetector(
//               onTap: () => _showSosConfirmDialog(context),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.withOpacity(0.4),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 // Icon only — no Text widget, so no duplicate word
//                 child: const Icon(Icons.sos_rounded, color: Colors.white, size: 32),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // SEARCH BAR
//               TextField(
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: "Search accessible places...",
//                   prefixIcon: const Icon(Icons.search),
//                   filled: true,
//                   fillColor: AppTheme.neutral200,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
 
//               // CATEGORY ICONS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _CategoryIcon(
//                     icon: Icons.home,
//                     label: "My Home",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
//                       );
//                     },
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.people,
//                     label: "Caretaker",
//                     onTap: () => _showCaretakerDialog(context),
//                   ),
//                   _CategoryIcon(
//                     icon: Icons.group,
//                     label: "Community",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
 
//               // ACCESSIBILITY PREFERENCES
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppTheme.primaryLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Accessibility Preferences",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Customize your experience based on accessibility needs",
//                       style: TextStyle(color: AppTheme.white),
//                     ),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.white,
//                         foregroundColor: AppTheme.primary,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
//                         );
//                       },
//                       child: const Text("Set Preferences"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
 
//               // RECOMMENDED PLACES HEADER
//               const Text(
//                 "Recommended Accessible Places in India",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
 
//               // TOURIST PLACES - responsive grid
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   // On wide screens (web/tablet) use more columns
//                   final width = constraints.maxWidth;
//                   final crossAxisCount = width > 900 ? 4 : width > 600 ? 3 : 2;
//                   final ratio = width > 900 ? 0.70 : width > 600 ? 0.68 : 0.72;
//                   return GridView.builder(
//                     itemCount: _touristPlaces.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: crossAxisCount,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 12,
//                       childAspectRatio: ratio,
//                     ),
//                     itemBuilder: (context, index) {
//                       final place = _touristPlaces[index];
//                       return _PlaceCard(
//                         name: place.name,
//                         location: place.location,
//                         description: place.description,
//                         imageUrl: place.imageUrl,
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
 
// class _CategoryIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
 
//   const _CategoryIcon({required this.icon, required this.label, this.onTap});
 
//   @override
//   Widget build(BuildContext context) {
//     final content = Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: AppTheme.primaryLight,
//           child: Icon(icon, color: AppTheme.white),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//     if (onTap == null) return content;
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Padding(padding: const EdgeInsets.all(6), child: content),
//     );
//   }
// }
 
// class _PlaceCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String description;
//   final String imageUrl;
 
//   const _PlaceCard({
//     required this.name,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//   });
 
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => TouristPlaceDetailPage(placeName: name),
//             ),
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image with increased height
//             SizedBox(
//               height: 180,
//               width: double.infinity,
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 cacheWidth: 400,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: AppTheme.neutral200,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.landscape_rounded, size: 36, color: Colors.grey[400]),
//                         const SizedBox(height: 4),
//                         Text(name.split(' ').first, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Content area
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 3),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, size: 11, color: AppTheme.primary),
//                       const SizedBox(width: 2),
//                       Expanded(
//                         child: Text(
//                           location,
//                           style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: TextStyle(fontSize: 10, color: Colors.grey[600], height: 1.4),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => TouristPlaceDetailPage(placeName: name),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.primary,
//                         foregroundColor: AppTheme.white,
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.smart_toy_rounded, size: 13),
//                           SizedBox(width: 4),
//                           Text('Plan a Trip', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




































































































import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/token_storage.dart';
import '../services/sos_service.dart';
import 'accessibility_preferences_screen.dart';
import 'find_caretaker_screen.dart';
import 'community_main_screen.dart';
import 'home_location_map_screen.dart';
import 'tourist_place_detail_page.dart';
 
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
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'User';
  String _searchQuery = '';
 
  static const List<_TouristPlace> _touristPlaces = [
    _TouristPlace(
      name: "Taj Mahal",
      location: "Agra, Uttar Pradesh",
      description: "A UNESCO World Heritage Site, the Taj Mahal is a white marble mausoleum built by Emperor Shah Jahan in memory of his wife Mumtaz Mahal.",
      imageUrl: "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Jaipur City Palace",
      location: "Jaipur, Rajasthan",
      description: "A stunning blend of Mughal and Rajput architecture, the City Palace is a historic royal complex in Jaipur.",
      imageUrl: "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Gateway of India",
      location: "Mumbai, Maharashtra",
      description: "An iconic arch monument overlooking the Arabian Sea and one of Mumbai's most famous landmarks.",
      imageUrl: "https://images.unsplash.com/photo-1529253355930-ddbe423a2ac7?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Golden Temple",
      location: "Amritsar, Punjab",
      description: "The Golden Temple, also known as Harmandir Sahib, is a famous Sikh shrine surrounded by a peaceful sacred pool.",
      imageUrl: "https://images.unsplash.com/photo-1514222134-b57cbb8ce073?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Charminar",
      location: "Hyderabad, Telangana",
      description: "Built in 1591, Charminar is an iconic monument of Hyderabad featuring four impressive minarets.",
      imageUrl: "https://images.unsplash.com/photo-1569163139599-0f4517e36f51?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Mysore Palace",
      location: "Mysuru, Karnataka",
      description: "A magnificent palace famous for its Indo-Saracenic architecture and spectacular illumination.",
      imageUrl: "https://images.unsplash.com/photo-1602301604413-98b3210b4939?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "India Gate",
      location: "New Delhi",
      description: "A famous war memorial in New Delhi dedicated to Indian soldiers who died during the First World War.",
      imageUrl: "https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Meenakshi Temple",
      location: "Madurai, Tamil Nadu",
      description: "A historic temple famous for its colorful Dravidian architecture and magnificent gopurams.",
      imageUrl: "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Hawa Mahal",
      location: "Jaipur, Rajasthan",
      description: "Known as the Palace of Winds, Hawa Mahal is famous for its distinctive facade and numerous windows.",
      imageUrl: "https://images.unsplash.com/photo-1548013146-72479768bada?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Marina Beach",
      location: "Chennai, Tamil Nadu",
      description: "One of the longest urban beaches in the world, Marina Beach is a popular destination in Chennai with accessible pathways.",
      imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Qutub Minar",
      location: "Delhi",
      description: "A UNESCO World Heritage Site and one of India's most famous historical monuments.",
      imageUrl: "https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=400&h=250&fit=crop",
    ),
    _TouristPlace(
      name: "Kerala Backwaters",
      location: "Alleppey, Kerala",
      description: "A network of interconnected canals, rivers, and lakes offering scenic houseboat experiences.",
      imageUrl: "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400&h=250&fit=crop",
    ),
  ];
 
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }
 
  Future<void> _loadUserName() async {
    final name = await TokenStorage.instance.getUserName();
    if (mounted && name != null && name.isNotEmpty) {
      setState(() => _userName = name);
    }
  }
 
  void _showCaretakerDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FindCaretakerScreen()),
    );
  }

  // ── SOS: confirm → loading → result ───────────────────────────────────────

  Future<void> _showSosConfirmDialog(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade300, width: 2),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure about SOS?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Your GPS location, name, booking details, and timestamp will be sent to your emergency contacts and government services immediately.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      await _triggerSos(context);
    }
  }

  Future<void> _triggerSos(BuildContext context) async {
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.red),
                SizedBox(height: 16),
                Text('Sending SOS...', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );

    final result = await SosService.triggerSOS();

    if (context.mounted) {
      Navigator.of(context).pop(); // close loading
      final bool success = result.contains('successfully');
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                success ? Icons.check_circle_rounded : Icons.error_rounded,
                color: success ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(success ? 'SOS Sent' : 'SOS Failed'),
            ],
          ),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 64,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.accessible, color: AppTheme.primary, size: 22),
            ),
            const SizedBox(width: 10),
            Text(
              "Hello $_userName!",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // ── Only change from original: SOS button replacing empty actions ──
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showSosConfirmDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                // Icon only — no Text widget, so no duplicate word
                child: const Icon(Icons.sos_rounded, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEARCH BAR
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
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
                        MaterialPageRoute(builder: (_) => const HomeLocationMapScreen()),
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
                        MaterialPageRoute(builder: (_) => const CommunityMainScreen()),
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
                      style: TextStyle(color: AppTheme.white),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.white,
                        foregroundColor: AppTheme.primary,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AccessibilityPreferencesScreen()),
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
                "Recommended Accessible Places in India",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
 
              // TOURIST PLACES - responsive grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final query = _searchQuery.trim().toLowerCase();
                  final filteredPlaces = query.isEmpty
                      ? _touristPlaces
                      : _touristPlaces.where((place) {
                          return place.name.toLowerCase().contains(query) ||
                              place.location.toLowerCase().contains(query) ||
                              place.description.toLowerCase().contains(query);
                        }).toList();
                  final width = constraints.maxWidth;
                  // mobile=1 col, tablet=2 col, desktop=4 col
                  final crossAxisCount = width > 900 ? 4 : width > 600 ? 2 : 1;
                  // fixed card height — tall enough for image + text + button
                  final cardHeight = width < 600 ? 460.0 : 380.0;
                  return GridView.builder(
                    itemCount: filteredPlaces.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: cardHeight,
                    ),
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];
                      return _PlaceCard(
                        name: place.name,
                        location: place.location,
                        description: place.description,
                        imageUrl: place.imageUrl,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
 
  const _CategoryIcon({required this.icon, required this.label, this.onTap});
 
  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        CircleAvatar(
          backgroundColor: AppTheme.primaryLight,
          child: Icon(icon, color: AppTheme.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(padding: const EdgeInsets.all(6), child: content),
    );
  }
}
 
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
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TouristPlaceDetailPage(placeName: name),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with increased height
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                cacheWidth: 400,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.neutral200,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.neutral200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.landscape_rounded, size: 36, color: Colors.grey[400]),
                        const SizedBox(height: 4),
                        Text(name.split(' ').first, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Content area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 11, color: AppTheme.primary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.4),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TouristPlaceDetailPage(placeName: name),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.white,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.smart_toy_rounded, size: 13),
                          SizedBox(width: 4),
                          Text('Plan a Trip', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
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