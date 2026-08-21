import 'package:flutter/material.dart';
import 'active_booking_page.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingDetailsScreen({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final String title = bookingData['title'] ?? 'Elder Care';
    final String patientName = bookingData['patientName'] ?? 'Ramesh Kumar';
    final String time = bookingData['time'] ?? '10 May 2025, 10:30 AM';
    final String location = bookingData['location'] ?? 'Koramangala, Bengaluru';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B40F4),
        foregroundColor: Colors.white,
        title: const Text('Booking Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.headset_mic), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF5B40F4), borderRadius: BorderRadius.circular(16)),
              child: const Row(
                children: [
                  Icon(Icons.task_alt, color: Colors.white),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Accepted', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('You have accepted this booking', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Booking ID', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), Text('#BK12456', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Service Type', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Date & Time', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), Text(time, style: const TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Duration', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), Text('3 Hours', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  const Text('Customer Name', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const Icon(Icons.phone, color: Color(0xFF5B40F4)),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Address', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(location, style: const TextStyle(fontWeight: FontWeight.w500))),
                      const Icon(Icons.navigation, color: Color(0xFF5B40F4)),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Service Requirements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text('• Companion for elderly (78 years)'),
                  const Text('• Assistance with walking'),
                  const Text('• Medicine reminder'),
                  const Text('• Light conversation'),
                  const Text('• Tea & meal assistance'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B40F4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.verified, color: Colors.white),
                label: const Text('Start Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActiveBookingScreen(bookingData: bookingData)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}