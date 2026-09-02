import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'find_caretaker_screen.dart';

class PlanTripPage extends StatefulWidget {
  const PlanTripPage({super.key});

  @override
  State<PlanTripPage> createState() => _PlanTripPageState();
}

class _PlanTripPageState extends State<PlanTripPage> {
  String _selectedOption = "Train"; // Default option

  // Train data list
  final List<Map<String, String>> trains = [
    {"name": "Shatabdi Express", "boarding": "06:00 AM", "duration": "4h", "arrival": "10:00 AM"},
    {"name": "Rajdhani Express", "boarding": "07:30 AM", "duration": "3.5h", "arrival": "11:00 AM"},
    {"name": "Duronto Express", "boarding": "08:15 AM", "duration": "5h", "arrival": "01:15 PM"},
    {"name": "Garib Rath", "boarding": "09:00 AM", "duration": "6h", "arrival": "03:00 PM"},
    {"name": "Jan Shatabdi", "boarding": "10:45 AM", "duration": "4.5h", "arrival": "03:15 PM"},
    {"name": "Intercity Express", "boarding": "11:30 AM", "duration": "3h", "arrival": "02:30 PM"},
    {"name": "Humsafar Express", "boarding": "12:15 PM", "duration": "7h", "arrival": "07:15 PM"},
    {"name": "Maharaja Express", "boarding": "01:00 PM", "duration": "8h", "arrival": "09:00 PM"},
    {"name": "Tejas Express", "boarding": "02:30 PM", "duration": "5h", "arrival": "07:30 PM"},
    {"name": "Vande Bharat Express", "boarding": "04:00 PM", "duration": "3h", "arrival": "07:00 PM"},
  ];

  // Bus data list
  final List<Map<String, String>> buses = [
    {"name": "Volvo AC Sleeper", "boarding": "06:30 AM", "duration": "5h", "arrival": "11:30 AM"},
    {"name": "KSRTC Super Deluxe", "boarding": "07:00 AM", "duration": "6h", "arrival": "01:00 PM"},
    {"name": "GreenLine Travels", "boarding": "08:15 AM", "duration": "7h", "arrival": "03:15 PM"},
    {"name": "Orange Tours", "boarding": "09:00 AM", "duration": "4h", "arrival": "01:00 PM"},
    {"name": "VRL Travels", "boarding": "10:30 AM", "duration": "8h", "arrival": "06:30 PM"},
    {"name": "SRS Travels", "boarding": "11:00 AM", "duration": "5h", "arrival": "04:00 PM"},
    {"name": "Parveen Travels", "boarding": "12:15 PM", "duration": "6h", "arrival": "06:15 PM"},
    {"name": "KPN Travels", "boarding": "01:00 PM", "duration": "7h", "arrival": "08:00 PM"},
    {"name": "National Travels", "boarding": "02:30 PM", "duration": "4.5h", "arrival": "07:00 PM"},
    {"name": "Rathimeena Travels", "boarding": "04:00 PM", "duration": "6h", "arrival": "10:00 PM"},
  ];

  // Travel agency list
  final List<Map<String, String>> agencies = [
    {"name": "MakeMyTrip Agency", "details": "Custom tour packages available"},
    {"name": "Yatra Travels", "details": "Affordable group trips"},
    {"name": "Thomas Cook India", "details": "Luxury and international tours"},
    {"name": "SOTC Holidays", "details": "Family vacation specialists"},
    {"name": "Cox & Kings", "details": "Heritage tours and premium packages"},
    {"name": "ClearTrip Agency", "details": "Quick bookings and discounts"},
    {"name": "TravelGuru", "details": "Hotel + travel combo deals"},
    {"name": "Goibibo Tours", "details": "Budget-friendly packages"},
    {"name": "Expedia India", "details": "International travel experts"},
    {"name": "HolidayIQ", "details": "Community-driven travel suggestions"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> currentList;

    if (_selectedOption == "Train") {
      currentList = trains.map((train) => Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryLight,
            child: const Icon(Icons.train, color: AppTheme.white),
          ),
          title: Text(
            train["name"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "Boarding: ${train["boarding"]} • Duration: ${train["duration"]} • Arrival: ${train["arrival"]}",
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ),
      )).toList();
    } else if (_selectedOption == "Bus") {
      currentList = buses.map((bus) => Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryLight,
            child: const Icon(Icons.directions_bus, color: AppTheme.white),
          ),
          title: Text(
            bus["name"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "Boarding: ${bus["boarding"]} • Duration: ${bus["duration"]} • Drop: ${bus["arrival"]}",
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ),
      )).toList();
    } else {
      currentList = agencies.map((agency) => Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryLight,
            child: const Icon(Icons.business, color: AppTheme.white),
          ),
          title: Text(
            agency["name"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              agency["details"]!,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ),
      )).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        centerTitle: false,
        toolbarHeight: 80,
        titleSpacing: 16,
        title: const Text(
          "Plan a Trip",
          style: TextStyle(
            fontSize: 25,
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
              // Option Selector Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildSegmentButton("Train"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSegmentButton("Bus"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSegmentButton("Agency"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dynamic List
              Expanded(
                child: ListView(
                  children: currentList,
                ),
              ),
              const SizedBox(height: 16),

              // Continue Journey Button
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text("Do you want a caretaker?"),
                        content: const Text(
                          "Would you like to assign a caretaker to assist you during your journey?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext); // Close dialog
                            },
                            child: const Text("No"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(dialogContext); // Close dialog
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FindCaretakerScreen(),
                                ),
                              );
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "Continue Journey",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for top selection tabs matching HomeScreen theme style
  Widget _buildSegmentButton(String title) {
    final bool isSelected = _selectedOption == title;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primaryLight : AppTheme.white,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => setState(() => _selectedOption = title),
    );
  }
}