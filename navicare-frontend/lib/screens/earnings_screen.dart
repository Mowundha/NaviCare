import 'package:flutter/material.dart';

class CaretakerEarningsScreen extends StatelessWidget {
  const CaretakerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B40F4),
        foregroundColor: Colors.white,
        title: const Text('Earnings & Payouts', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wallet Balance', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('₹1,250', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.account_balance_wallet, size: 36, color: Color(0xFF5B40F4)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Earnings Summary', style: TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(color: Color(0xFF5B40F4))))]),
                  const Divider(),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Today', style: TextStyle(color: Colors.grey)), Text('₹1,250', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 20),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('This Week', style: TextStyle(color: Colors.grey)), Text('₹3,450', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const Divider(height: 20),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('This Month', style: TextStyle(color: Colors.grey)), Text('₹12,650', style: TextStyle(fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Withdrawal History', style: TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(color: Color(0xFF5B40F4))))]),
                  const Divider(),
                  _withdrawalRow('08 May 2025', '₹1,000'),
                  const Divider(height: 16),
                  _withdrawalRow('01 May 2025', '₹1,200'),
                  const Divider(height: 16),
                  _withdrawalRow('24 Apr 2025', '₹900'),
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
                onPressed: () {},
                child: const Text('Withdraw Earnings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _withdrawalRow(String date, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Row(
          children: [
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
              child: const Text('Paid', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}