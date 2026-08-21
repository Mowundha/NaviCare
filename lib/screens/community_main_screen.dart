import 'package:flutter/material.dart';

class CommunityMainScreen extends StatelessWidget {
  const CommunityMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B40F4),
        foregroundColor: Colors.white,
        title: const Text('Community', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Connect & Grow',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose an option below to get started with your community.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            
            // Join Community Large Button
            SizedBox(
              height: 90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B40F4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                onPressed: () {
                  // Handle Join Community Action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Join Community Selected')),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_add, size: 32, color: Colors.white),
                    SizedBox(width: 16),
                    Text(
                      'Join Community',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Form Community Large Button
            SizedBox(
              height: 90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF5B40F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFF5B40F4), width: 2),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Handle Form Community Action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form Community Selected')),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_moderator, size: 32, color: Color(0xFF5B40F4)),
                    SizedBox(width: 16),
                    Text(
                      'Form Community',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B40F4)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}