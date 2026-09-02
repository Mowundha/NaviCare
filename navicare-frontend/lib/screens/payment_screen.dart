
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'booking_confirmed_screen.dart';


// Razorpay import — keep commented for web; uncomment for Android/iOS
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String description;
  final Map<String, String>? caretaker;
  final String date;
  final String time;
  final String endTime;
  final String location;
  final double total;

  const PaymentScreen({
    super.key,
    this.amount = 1500.0,
    this.description = 'Caretaker Booking',
    this.caretaker,
    this.date = '25 Aug 2026',
    this.time = '09:00 AM',
    this.endTime = '01:00 PM',
    this.location = '123 Maple St, City',
    this.total = 1788,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPayment = 0;
  bool _isProcessing = false;

  double get _displayTotal => widget.total;

  void _handlePay() {
    if (_selectedPayment == 0 || _selectedPayment == 1) {
      // Show GPay-style UPI PIN sheet
      _showUpiPinSheet();
    } else {
      _processPayment();
    }
  }

  void _showUpiPinSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UpiPinSheet(
        amount: _displayTotal,
        onSuccess: () {
          Navigator.pop(context); // close sheet
          _navigateToConfirmed();
        },
        onFail: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment failed. Please try again.'), backgroundColor: Colors.red),
          );
        },
      ),
    );
  }

  void _processPayment() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      _navigateToConfirmed();
    });
  }

  void _navigateToConfirmed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmedScreen(
          caretaker: widget.caretaker,
          date: widget.date,
          time: widget.time,
          endTime: widget.endTime,
          location: widget.location,
          total: _displayTotal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4A30D8), Color(0xFF6B51FF)]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Text('Amount to Pay', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    '₹${_displayTotal.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Select Payment Method', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _buildPaymentOption(index: 0, icon: Icons.phone_android_rounded, iconColor: const Color(0xFF1A73E8), title: 'Google Pay / UPI', subtitle: 'GPay, PhonePe, Paytm, BHIM & more', recommended: true),
            const SizedBox(height: 10),
            _buildPaymentOption(index: 1, icon: Icons.qr_code_rounded, iconColor: const Color(0xFF7C3AED), title: 'UPI ID', subtitle: 'Enter your UPI ID directly'),
            const SizedBox(height: 10),
            _buildPaymentOption(index: 2, icon: Icons.credit_card_rounded, iconColor: const Color(0xFF0EA5E9), title: 'Credit / Debit Card', subtitle: 'Visa, Mastercard, RuPay'),
            const SizedBox(height: 10),
            _buildPaymentOption(index: 3, icon: Icons.account_balance_wallet_rounded, iconColor: const Color(0xFFF59E0B), title: 'Digital Wallet', subtitle: 'Amazon Pay, Freecharge & more'),

            const SizedBox(height: 24),

            // Security badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_rounded, color: Color(0xFF16A34A), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('100% Secure Payment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF16A34A))),
                        Text('Your payment info is encrypted and protected by SSL', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _handlePay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isProcessing
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text('Pay ₹${_displayTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Secured by', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFF072654), borderRadius: BorderRadius.circular(6)),
                  child: const Text('Razorpay', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({required int index, required IconData icon, required Color iconColor, required String title, required String subtitle, bool recommended = false}) {
    final selected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppTheme.primary : Colors.grey.withOpacity(0.2), width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    if (recommended) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF22C55E), borderRadius: BorderRadius.circular(20)),
                        child: const Text('Recommended', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ),
            Radio<int>(value: index, groupValue: _selectedPayment, onChanged: (v) => setState(() => _selectedPayment = v!), activeColor: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}

// ── GPay-style UPI PIN Sheet ────────────────────────────────────────────────
class _UpiPinSheet extends StatefulWidget {
  final double amount;
  final VoidCallback onSuccess;
  final VoidCallback onFail;
  const _UpiPinSheet({required this.amount, required this.onSuccess, required this.onFail});

  @override
  State<_UpiPinSheet> createState() => _UpiPinSheetState();
}

class _UpiPinSheetState extends State<_UpiPinSheet> {
  final List<String> _pin = [];
  bool _processing = false;

  void _onKey(String key) {
    if (_processing) return;
    if (key == '⌫') {
      if (_pin.isNotEmpty) setState(() => _pin.removeLast());
    } else if (_pin.length < 6) {
      setState(() => _pin.add(key));
      if (_pin.length == 6) _verifyPin();
    }
  }

  void _verifyPin() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    // Simulate success — any 6-digit PIN works
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),

          // GPay-style header
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: const Color(0xFF1A73E8).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.phone_android_rounded, color: Color(0xFF1A73E8), size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Google Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('UPI · navicare@okaxis', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${widget.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1A73E8))),
                  Text('NaviCare', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Enter UPI PIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('4 or 6 digit PIN', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 20),

          // PIN dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _pin.length ? const Color(0xFF1A73E8) : Colors.grey[300],
              ),
            )),
          ),
          const SizedBox(height: 24),

          // Processing indicator or keypad
          if (_processing)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Color(0xFF1A73E8)),
            )
          else
            _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = ['1','2','3','4','5','6','7','8','9','','0','⌫'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (_, i) {
        final key = keys[i];
        if (key.isEmpty) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => _onKey(key),
          child: Container(
            decoration: BoxDecoration(
              color: key == '⌫' ? Colors.red.withOpacity(0.08) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              key,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: key == '⌫' ? Colors.red : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}
