import 'package:flutter/material.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Earnings & Payouts")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Wallet Balance ₹1,250"),
            Text("This Week ₹3,450"),
            Text("This Month ₹12,650"),
          ],
        ),
      ),
    );
  }
}
