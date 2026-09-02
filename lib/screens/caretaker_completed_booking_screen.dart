import 'package:flutter/material.dart';
import '../screens/caretaker_home_screen.dart';

class CaretakerCompletedBookingScreen extends StatefulWidget {
  const CaretakerCompletedBookingScreen({super.key});

  @override
  State<CaretakerCompletedBookingScreen> createState() => _CaretakerCompletedBookingScreenState();
}

class _CaretakerCompletedBookingScreenState extends State<CaretakerCompletedBookingScreen> {
  int _rating = 4;

  final Map<int, String> _ratingLabels = {
    1: 'Poor',
    2: 'Fair',
    3: 'Good',
    4: 'Very Good',
    5: 'Excellent',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B40F4),
        foregroundColor: Colors.white,
        title: const Text('Caretaker Completed Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.headset_mic), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 36, backgroundColor: Color(0xFF5B40F4), child: Icon(Icons.check, size: 40, color: Colors.white)),
            const SizedBox(height: 16),
            const Text('Booking Completed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Thank you for your service', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Booking ID', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), Text('#BK12456', style: TextStyle(fontWeight: FontWeight.bold))]),
                  Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total Earnings', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), Text('₹350', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B40F4)))]),
                  Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Duration', style: TextStyle(color: Color.fromARGB(255, 7, 6, 6))), Text('3 Hours', style: TextStyle(fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text('How was your experience?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _ratingLabels[_rating] ?? 'Good',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B40F4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const CaretakerHomeScreen()),
                  (route) => false,
                ),
                child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}