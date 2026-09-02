import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/completed_booking_page.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final Map<String, String>? caretaker;
  final String date;
  final String time;
  final String endTime;
  final String location;
  final double total;

  const BookingConfirmedScreen({
    super.key,
    this.caretaker,
    required this.date,
    required this.time,
    required this.endTime,
    required this.location,
    required this.total,
  });

  String get _bookingId {
    // Generate a short deterministic ID from the timestamp
    final ts = DateTime.now().millisecondsSinceEpoch % 1000000;
    return '#NC$ts';
  }

  @override
  Widget build(BuildContext context) {
    final name = caretaker?['name'] ?? 'Caretaker';
    final role = caretaker?['role'] ?? 'Care Specialist';
    final rating = caretaker?['rating'] ?? '4.8';

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        title: const Text('Booking Confirmed!', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Success animation circle
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade200, width: 3),
                ),
                child: const Icon(Icons.check_rounded, size: 52, color: Colors.green),
              ),
              const SizedBox(height: 16),
              const Text(
                'Caretaker Booked Successfully!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Your booking is confirmed. The caretaker will arrive on time.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Caretaker + booking card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Caretaker row
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: AppTheme.neutral200,
                          child: Icon(Icons.person, color: AppTheme.primary, size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(role, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                  const SizedBox(width: 3),
                                  Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                                    child: const Text('Verified', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1)),

                    // Booking details
                    _infoRow(Icons.calendar_today_rounded, AppTheme.primary, 'Date', date),
                    const SizedBox(height: 10),
                    _infoRow(Icons.access_time_rounded, const Color(0xFF8B5CF6), 'Time', '$time – $endTime'),
                    const SizedBox(height: 10),
                    _infoRow(Icons.location_on_rounded, const Color(0xFFEF4444), 'Location', location),

                    const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1)),

                    // Total + Booking ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Paid', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                        Text('₹${total.toStringAsFixed(0)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Booking ID: $_bookingId',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const CompletedBookingPage()),
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text('View My Bookings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, Color color, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}