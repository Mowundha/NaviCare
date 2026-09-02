import 'package:flutter/material.dart';

class CompletedBookingPage extends StatelessWidget {
  const CompletedBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Completed")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Thank you for your service"),
            Text("Total Earnings ₹350"),
            Text("Duration: 3 Hours"),
            Text("⭐⭐⭐⭐⭐ Good"),
          ],
        ),
      ),
    );
  }
}
