import 'package:flutter/material.dart';
import 'booking_details_page.dart';

class ServiceRequestScreen extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const ServiceRequestScreen({
    super.key,
    required this.requestData,
  });

  @override
  Widget build(BuildContext context) {
    final String title = requestData['title'] ?? 'Service Request';
    final String patientName = requestData['patientName'] ?? 'Ramesh Kumar';
    final String time = requestData['time'] ?? 'Today';
    final String location = requestData['location'] ?? '';
    final String amount = requestData['amount'] ?? '₹0';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B40F4),
        foregroundColor: Colors.white,
        title: Text('Service Request - $title', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Service Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('You have a new booking request', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Booking ID', style: TextStyle(color: Color.fromARGB(255, 8, 6, 6))), Text('#BK12456', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Service Type', style: TextStyle(color: Color.fromARGB(255, 8, 5, 5))), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Date & Time', style: TextStyle(color: Color.fromARGB(255, 9, 8, 8))), Text(time, style: const TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Duration', style: TextStyle(color: Color.fromARGB(255, 3, 3, 3))), Text('3 Hours', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Expected Earnings', style: TextStyle(color: Color.fromARGB(255, 7, 7, 7))), Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B40F4)))]),
                  const Divider(height: 24),
                  const Text('Customer Name', style: TextStyle(color: Color.fromARGB(255, 11, 11, 11), fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const Icon(Icons.phone, color: Color(0xFF5B40F4)),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Address', style: TextStyle(color: Color.fromARGB(255, 7, 7, 7), fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(location, style: const TextStyle(fontWeight: FontWeight.w500))),
                      const Icon(Icons.location_on, color: Color(0xFF5B40F4)),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Service Requirements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('• Specialized care for $title'),
                  const Text('• Assistance with daily activities'),
                  const Text('• Medicine reminder & monitoring'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Reject', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B40F4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => BookingDetailsScreen(bookingData: requestData)),
                    ),
                    child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('Request will expire in 01:25', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}