import 'package:flutter/material.dart';
import 'caretaker_completed_booking_screen.dart';

class ActiveBookingScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const ActiveBookingScreen({
    super.key,
    required this.bookingData,
  });

  @override
  State<ActiveBookingScreen> createState() => _ActiveBookingScreenState();
}

class _ActiveBookingScreenState extends State<ActiveBookingScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.bookingData['title'] ?? 'Elder Care';
    final String patientName = widget.bookingData['patientName'] ?? 'Ramesh Kumar';
    final String time = widget.bookingData['time'] ?? '10:30 AM';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B40F4),
        foregroundColor: Colors.white,
        title: const Text('Active Booking', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.headset_mic), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('• In Progress', style: TextStyle(color: Color(0xFF5B40F4), fontWeight: FontWeight.bold)),
                      Text('02:15:30', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Customer', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(patientName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      CircleAvatar(backgroundColor: Colors.purple.shade50, child: const Icon(Icons.phone, color: Color(0xFF5B40F4))),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Service', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Start Time', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)), Text(time, style: const TextStyle(fontWeight: FontWeight.bold))]),
                      const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('End Time', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)), Text('01:30 PM', style: const TextStyle(fontWeight: FontWeight.bold))]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('OTP Verification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text('Ask customer to share OTP', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 65,
                  height: 65,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF5B40F4), width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B40F4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  final enteredOtp = _controllers.map((c) => c.text).join();

                  if (enteredOtp.length < 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter the full 4-digit OTP')),
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CaretakerCompletedBookingScreen()),
                  );
                },
                child: const Text('Verify & Complete', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}