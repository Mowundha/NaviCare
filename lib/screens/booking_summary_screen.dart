import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 32, backgroundColor: AppTheme.neutral200, child: Icon(Icons.person, size: 36, color: AppTheme.primary)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Alice Johnson', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Elderly Care Specialist', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            SizedBox(width: 4),
                            Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Booking Details', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Row(children: [Icon(Icons.check, size: 16, color: AppTheme.primary), SizedBox(width: 8), Text('Date: 25 August 2023')]),
                    SizedBox(height: 8),
                    Row(children: [Icon(Icons.check, size: 16, color: AppTheme.primary), SizedBox(width: 8), Text('Time: 09:00 AM - 01:00 PM')]),
                    SizedBox(height: 8),
                    Row(children: [Icon(Icons.check, size: 16, color: AppTheme.primary), SizedBox(width: 8), Text('Location: 123 Maple St, City')]),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen()));
                  },
                  child: const Text('Proceed to Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}