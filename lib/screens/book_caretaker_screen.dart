import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'booking_summary_screen.dart';
import 'map_picker_screen.dart'; // Import the Map Picker Screen

class BookCaretakerScreen extends StatefulWidget {
  final Map<String, String>? caretaker;

  const BookCaretakerScreen({super.key, this.caretaker});

  @override
  State<BookCaretakerScreen> createState() => _BookCaretakerScreenState();
}

class _BookCaretakerScreenState extends State<BookCaretakerScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  final TextEditingController _durationController = TextEditingController(text: '4');
  final TextEditingController _requirementsController = TextEditingController();

  // Location Mode selection: 'detect' or 'manual'
  String _locationMode = 'detect';
  String _detectedLocation = '123 Maple St, City (Tap Open Map to change)';

  // Manual location text controllers
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _nationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime currentDateOnly = DateTime(today.year, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(currentDateOnly) ? currentDateOnly : _selectedDate,
      firstDate: currentDateOnly,
      lastDate: currentDateOnly.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _requirementsController.dispose();
    _flatController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _nationController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = "${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}";
    final String formattedTime = _selectedTime.format(context);

    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: const Text('Book Caretaker', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Date Picker Row
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: _buildFormRow('Select Date', formattedDate, Icons.calendar_today),
                    ),
                    const Divider(height: 24),
                    // Time Picker Row
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: _buildFormRow('Select Time', formattedTime, Icons.access_time),
                    ),
                    const Divider(height: 24),
                    // Duration Manual Entry Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Duration (Hours)', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // LOCATION SECTION WITH TWO OPTIONS
              const Text('Location Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Detect Map', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            value: 'detect',
                            groupValue: _locationMode,
                            onChanged: (value) {
                              setState(() {
                                _locationMode = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Enter Manual', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            value: 'manual',
                            groupValue: _locationMode,
                            onChanged: (value) {
                              setState(() {
                                _locationMode = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    if (_locationMode == 'detect') ...[
                      Row(
                        children: [
                          const Icon(Icons.my_location, color: AppTheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _detectedLocation,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () async {
                              // Navigate to MapPickerScreen and capture the returned location string
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const MapPickerScreen()),
                              );
                              if (result != null) {
                                setState(() {
                                  _detectedLocation = result;
                                });
                              }
                            },
                            child: const Text('Open Map'),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      _buildTextField('Flat / House No.', _flatController),
                      const SizedBox(height: 12),
                      _buildTextField('Street', _streetController),
                      const SizedBox(height: 12),
                      _buildTextField('Area', _areaController),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTextField('City', _cityController)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField('State', _stateController)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTextField('Nation', _nationController)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField('Mobile No.', _mobileController, keyboardType: TextInputType.phone),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text('Special Requirements', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _requirementsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter any special requests...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BookingSummaryScreen(),
                      ),
                    );
                  },
                  child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
        Row(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: AppTheme.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        filled: true,
        fillColor: AppTheme.neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}