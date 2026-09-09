import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import 'edit_caretaker_profile_screen.dart';
import 'service_request_page.dart';
import 'earnings_screen.dart';
import 'role_entry_screen.dart';

class CaretakerHomeScreen extends StatefulWidget {
  const CaretakerHomeScreen({super.key});

  @override
  State<CaretakerHomeScreen> createState() => _CaretakerHomeScreenState();
}

class _CaretakerHomeScreenState extends State<CaretakerHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CaretakerDashboardTab(),
    const CaretakerBookingsTab(),
    const CaretakerEarningsScreen(),
    const CaretakerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF5B40F4),
        unselectedItemColor: const Color.fromARGB(255, 5, 5, 5),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Earnings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class CaretakerDashboardTab extends StatefulWidget {
  const CaretakerDashboardTab({super.key});

  @override
  State<CaretakerDashboardTab> createState() => _CaretakerDashboardTabState();
}

class CaretakerBookingsTab extends StatefulWidget {
  const CaretakerBookingsTab({super.key});

  @override
  State<CaretakerBookingsTab> createState() => _CaretakerBookingsTabState();
}

class _CaretakerBookingsTabState extends State<CaretakerBookingsTab> {
  final List<Map<String, String>> _bookings = [
    {
      'service': 'Elder Care',
      'customer': 'Ramesh Kumar',
      'date': 'Today, 10:30 AM',
      'location': 'Koramangala, Bengaluru',
      'amount': '₹350',
      'status': 'Pending',
    },
    {
      'service': 'Patient Care',
      'customer': 'Anita Sharma',
      'date': 'Today, 1:00 PM',
      'location': 'Indiranagar, Bengaluru',
      'amount': '₹500',
      'status': 'Pending',
    },
    {
      'service': 'Post-Surgery Care',
      'customer': 'Meera Iyer',
      'date': 'Tomorrow, 9:00 AM',
      'location': 'HSR Layout, Bengaluru',
      'amount': '₹600',
      'status': 'Pending',
    },
  ];

  void _updateBooking(int index, String status) {
    setState(() => _bookings[index]['status'] = status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking ${status.toLowerCase()}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Bookings',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Booking Requests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Review requests and manage your schedule',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 18),
          ..._bookings.asMap().entries.map((entry) {
            final index = entry.key;
            final booking = entry.value;
            final isPending = booking['status'] == 'Pending';
            final isAccepted = booking['status'] == 'Accepted';
            final statusColor = isPending
                ? Colors.orange
                : isAccepted
                    ? Colors.green
                    : Colors.red;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFE9E5FF),
                        child: Icon(Icons.person, color: Color(0xFF5B40F4)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking['service']!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3),
                            Text(booking['customer']!,
                                style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      Text(booking['amount']!,
                          style: const TextStyle(
                              color: Color(0xFF5B40F4),
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                  const Divider(height: 24),
                  _bookingInfo(Icons.schedule, booking['date']!),
                  const SizedBox(height: 8),
                  _bookingInfo(Icons.location_on_outlined, booking['location']!),
                  const SizedBox(height: 14),
                  if (isPending)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _updateBooking(index, 'Rejected'),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red)),
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateBooking(index, 'Accepted'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B40F4),
                                foregroundColor: Colors.white),
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(booking['status']!,
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _bookingInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class _CaretakerDashboardTabState extends State<CaretakerDashboardTab> {
  bool _isOnline = true;
  String _caretakerName = 'Caretaker';

  final List<Map<String, dynamic>> _serviceRequests = [
    {
      'title': 'Elder Care',
      'patientName': 'Ramesh Kumar',
      'time': 'Today, 10:30 AM',
      'location': 'Koramangala, Bengaluru',
      'amount': '₹350',
      'avatarColor': Colors.amber,
    },
    {
      'title': 'Patient Care',
      'patientName': 'Anita Sharma',
      'time': 'Today, 1:00 PM',
      'location': 'Indiranagar, Bengaluru',
      'amount': '₹500',
      'avatarColor': Colors.blueAccent,
    },
    {
      'title': 'Elderly Companion',
      'patientName': 'Vikram Singh',
      'time': 'Today, 3:30 PM',
      'location': 'Jayanagar, Bengaluru',
      'amount': '₹400',
      'avatarColor': Colors.orangeAccent,
    },
    {
      'title': 'Post-Surgery Care',
      'patientName': 'Meera Iyer',
      'time': 'Tomorrow, 9:00 AM',
      'location': 'HSR Layout, Bengaluru',
      'amount': '₹600',
      'avatarColor': Colors.purpleAccent,
    },
    {
      'title': 'Physiotherapy Assist',
      'patientName': 'Prakash Nair',
      'time': 'Tomorrow, 11:30 AM',
      'location': 'BTM Layout, Bengaluru',
      'amount': '₹450',
      'avatarColor': Colors.green,
    },
    {
      'title': 'Night Care Support',
      'patientName': 'Sonia Verma',
      'time': 'Tomorrow, 8:00 PM',
      'location': 'Whitefield, Bengaluru',
      'amount': '₹800',
      'avatarColor': Colors.redAccent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCaretakerName();
  }

  Future<void> _loadCaretakerName() async {
    final name = await TokenStorage.instance.getUserName();
    if (mounted && name != null && name.trim().isNotEmpty) {
      setState(() => _caretakerName = name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5141D8),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.accessibility_new_rounded,
              color: Color(0xFF5141D8), size: 22),
        ),
        title: Text('Hello $_caretakerName!',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18)),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: _isOnline
                          ? const Color.fromARGB(255, 76, 175, 80)
                          : const Color.fromARGB(255, 221, 27, 27),
                      shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(_isOnline ? 'You are Online' : 'You are Offline',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF6B51FF), Color(0xFF4A30D8)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's Earnings",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                      Icon(Icons.account_balance_wallet, color: Colors.white70),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('₹1,250',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jobs Completed',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                          Text('4',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hours Worked',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                          Text('5h 30m',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Available for Bookings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('You will receive new service requests',
                          style: TextStyle(
                              color: Color.fromARGB(255, 13, 13, 13),
                              fontSize: 11)),
                    ],
                  ),
                  Switch(
                    value: _isOnline,
                    activeColor: const Color(0xFF5B40F4),
                    onChanged: (val) => setState(() => _isOnline = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('New Service Requests',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {},
                    child: const Text('View all',
                        style: TextStyle(color: Color(0xFF5B40F4)))),
              ],
            ),
            // ListView builder rendering 6 Service Requests dynamically
            ListView.builder(
              itemCount: _serviceRequests.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final request = _serviceRequests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ServiceRequestScreen(requestData: request))),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 24,
                              backgroundColor: request['avatarColor'],
                              child: const Icon(Icons.person,
                                  color: Colors.white)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(request['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(request['time'],
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 11, 11, 11),
                                        fontSize: 12)),
                                Text(request['location'],
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 11, 11, 11),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(request['amount'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF5B40F4))),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Upcoming Bookings',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {},
                    child: const Text('View all',
                        style: TextStyle(color: Color(0xFF5B40F4)))),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, color: Colors.white)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Patient Care',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 4),
                        Text('12 May, 4:00 PM',
                            style: TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontSize: 12)),
                        Text('HSR Layout, Bengaluru',
                            style: TextStyle(
                                color: Color.fromARGB(255, 5, 4, 4),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('Confirmed',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaretakerProfilePage extends StatefulWidget {
  const CaretakerProfilePage({super.key});

  @override
  State<CaretakerProfilePage> createState() => _CaretakerProfilePageState();
}

class _CaretakerProfilePageState extends State<CaretakerProfilePage> {
  CaretakerDetails _details = const CaretakerDetails(
    name: 'Caretaker',
    email: '',
    phone: '',
    location: 'Not provided',
    experience: '0 Years',
    specialization: 'Not provided',
  );

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await TokenStorage.instance.getCaretakerProfile();
    if (!mounted || profile == null) return;

    setState(() {
      _details = CaretakerDetails(
        name: _profileText(profile, 'full_name', 'Caretaker'),
        email: _profileText(profile, 'Email'),
        phone: _profileText(profile, 'phone_number'),
        location: _profileText(profile, 'location', 'Not provided'),
        experience:
            '${profile['years_of_experience'] ?? 0} Years',
        specialization:
            _profileText(profile, 'specialization', 'Not provided'),
      );
    });
  }

  String _profileText(
    Map<String, dynamic> profile,
    String key, [
    String fallback = '',
  ]) {
    final value = profile[key];
    return value == null || value.toString().trim().isEmpty
        ? fallback
        : value.toString();
  }

  Future<void> _editProfile() async {
    final updatedDetails = await Navigator.push<CaretakerDetails>(
      context,
      MaterialPageRoute(
        builder: (_) => EditCaretakerProfileScreen(details: _details),
      ),
    );

    if (updatedDetails != null && mounted) {
      setState(() => _details = updatedDetails);
      await TokenStorage.instance.saveCaretakerProfile({
        'full_name': updatedDetails.name,
        'Email': updatedDetails.email,
        'phone_number': updatedDetails.phone,
        'location': updatedDetails.location,
        'years_of_experience': updatedDetails.experience,
        'specialization': updatedDetails.specialization,
      });
    }
  }

  Future<void> _logOut() async {
    await TokenStorage.instance.clearToken();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleEntryScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF6B51FF),
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(_details.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                    Text(_details.specialization,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star, color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        Text('4.8 (128 reviews)',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: const [
                      Text('5h 30m',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Hours Worked',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  Column(
                    children: const [
                      Text('4',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Jobs Completed',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  Column(
                    children: const [
                      Text('₹1,250',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Total Earnings',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Personal Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Personal Information',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow('Email', _details.email),
                  _buildInfoRow('Phone', _details.phone),
                  _buildInfoRow('Location', _details.location),
                  _buildInfoRow('Experience', _details.experience),
                  _buildInfoRow('Caretaker ID', 'CTK7890'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Services Offered
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Services Offered',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildServiceTag(_details.specialization),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B40F4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Edit Profile',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _logOut,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Color(0xFF5B40F4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Logout',
                    style: TextStyle(
                        color: Color(0xFF5B40F4), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildServiceTag(String service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF5B40F4).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        service,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5B40F4)),
      ),
    );
  }
}
























































