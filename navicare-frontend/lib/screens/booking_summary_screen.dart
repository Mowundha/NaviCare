import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Map<String, String>? caretaker;
  final String date;
  final String time;
  final int duration;
  final String location;
  final String requirements;
  final double serviceCharge;
  final double convenienceFee;
  final double gst;
  final double total;

  const BookingSummaryScreen({
    super.key,
    this.caretaker,
    this.date = '25 Aug 2026',
    this.time = '09:00 AM',
    this.duration = 4,
    this.location = '123 Maple St, City',
    this.requirements = '',
    this.serviceCharge = 1500,
    this.convenienceFee = 18,
    this.gst = 270,
    this.total = 1788,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _navigating = false;

  String get _name => widget.caretaker?['name'] ?? 'Alice Johnson';
  String get _role => widget.caretaker?['role'] ?? 'Elderly Care Specialist';
  String get _rating => widget.caretaker?['rating'] ?? '4.8';
  String get _image => widget.caretaker?['image'] ?? '';
  String get _endTime {
    // Simple end time: parse start time add duration hours
    try {
      final parts = widget.time.split(':');
      int hour = int.parse(parts[0]);
      final minPart = parts[1].split(' ');
      int min = int.parse(minPart[0]);
      bool isPm = minPart[1] == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      hour += widget.duration;
      final suffix = hour >= 12 ? 'PM' : 'AM';
      final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '${h.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $suffix';
    } catch (_) {
      return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Caretaker card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.neutral200,
                    backgroundImage: _image.isNotEmpty ? NetworkImage(_image) : null,
                    child: _image.isEmpty ? const Icon(Icons.person, size: 38, color: AppTheme.primary) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.neutral900)),
                        const SizedBox(height: 3),
                        Text(_role, style: const TextStyle(fontSize: 13, color: AppTheme.neutral600)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(_rating, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                              child: const Text('Verified', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Booking Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.neutral900)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _detailRow(icon: Icons.calendar_today_rounded, iconColor: AppTheme.primary, label: 'Date', value: widget.date),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                  _detailRow(icon: Icons.access_time_rounded, iconColor: const Color(0xFF8B5CF6), label: 'Time', value: '${widget.time} – $_endTime'),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                  _detailRow(icon: Icons.location_on_rounded, iconColor: const Color(0xFFEF4444), label: 'Location', value: widget.location),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                  _detailRow(icon: Icons.medical_services_rounded, iconColor: const Color(0xFF0EA5E9), label: 'Service', value: _role),
                  if (widget.requirements.isNotEmpty) ...[
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                    _detailRow(icon: Icons.notes_rounded, iconColor: Colors.grey, label: 'Notes', value: widget.requirements),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Price Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.neutral900)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _priceRow('Service Charge (${widget.duration} hrs)', '₹${widget.serviceCharge.toStringAsFixed(0)}'),
                  const SizedBox(height: 10),
                  _priceRow('Convenience Fee', '₹${widget.convenienceFee.toStringAsFixed(0)}'),
                  const SizedBox(height: 10),
                  _priceRow('GST (18%)', '₹${widget.gst.toStringAsFixed(0)}'),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.neutral900)),
                      Text('₹${widget.total.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cancellation note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Free cancellation up to 2 hours before the booking start time.', style: TextStyle(fontSize: 12, color: Colors.amber[900], height: 1.4))),
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _navigating ? null : () async {
                  setState(() => _navigating = true);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        amount: widget.serviceCharge,
                        description: 'Caretaker Booking - $_name',
                        caretaker: widget.caretaker,
                        date: widget.date,
                        time: widget.time,
                        endTime: _endTime,
                        location: widget.location,
                        total: widget.total,
                      ),
                    ),
                  );
                  if (mounted) setState(() => _navigating = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _navigating
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Proceed to Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_rounded, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Text('100% Secure & Encrypted Payment', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({required IconData icon, required Color iconColor, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.neutral500, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.neutral900)),
          ],
        ),
      ],
    );
  }

  Widget _priceRow(String label, String amount) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.neutral600)),
      Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.neutral900)),
    ],
  );
}
