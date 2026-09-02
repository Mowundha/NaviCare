import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'booking_summary_screen.dart';
import 'map_picker_screen.dart';

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
  String _locationMode = 'detect';
  String _detectedLocation = '123 Maple St, City';
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String get _formattedDate {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  String get _formattedTime => _selectedTime.format(context);

  String get _resolvedLocation {
    if (_locationMode == 'detect') return _detectedLocation;
    final parts = [_flatController.text, _streetController.text, _areaController.text, _cityController.text]
        .where((s) => s.trim().isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(', ') : 'Enter location above';
  }

  int get _durationHours => int.tryParse(_durationController.text) ?? 4;
  double get _serviceCharge => _durationHours * 375.0;
  double get _convenienceFee => 18.0;
  double get _gst => _serviceCharge * 0.18;
  double get _total => _serviceCharge + _convenienceFee + _gst;

  void _proceed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSummaryScreen(
          caretaker: widget.caretaker,
          date: _formattedDate,
          time: _formattedTime,
          duration: _durationHours,
          location: _resolvedLocation,
          requirements: _requirementsController.text,
          serviceCharge: _serviceCharge,
          convenienceFee: _convenienceFee,
          gst: _gst,
          total: _total,
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
        title: const Text('Book Caretaker', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date / Time / Duration
            _sectionCard(children: [
              _tappableRow('Select Date', _formattedDate, Icons.calendar_today_rounded, () => _selectDate(context)),
              const Divider(height: 1),
              _tappableRow('Select Time', _formattedTime, Icons.access_time_rounded, () => _selectTime(context)),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Expanded(child: Text('Duration (Hours)', style: TextStyle(fontSize: 14, color: Colors.grey))),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 16),

            const Text('Location Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _sectionCard(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _radioOption('detect', 'Detect Map'),
                        const SizedBox(width: 24),
                        _radioOption('manual', 'Enter Manual'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_locationMode == 'detect')
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded, color: AppTheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_detectedLocation, style: const TextStyle(fontSize: 13))),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const MapPickerScreen()),
                              );
                              if (result != null && mounted) setState(() => _detectedLocation = result.toString());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Open Map', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _textField(_flatController, 'Flat / House No.'),
                          const SizedBox(height: 8),
                          _textField(_streetController, 'Street'),
                          const SizedBox(height: 8),
                          _textField(_areaController, 'Area / Landmark'),
                          const SizedBox(height: 8),
                          _textField(_cityController, 'City'),
                        ],
                      ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 16),

            const Text('Special Requirements', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: _requirementsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter any special requests...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Price preview
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estimated Total ($_durationHours hrs)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('₹${_total.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _proceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required List<Widget> children}) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
    child: Column(children: children),
  );

  Widget _tappableRow(String label, String value, IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey))),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Icon(icon, size: 18, color: AppTheme.primary),
        ],
      ),
    ),
  );

  Widget _radioOption(String value, String label) => Row(
    children: [
      Radio<String>(
        value: value,
        groupValue: _locationMode,
        onChanged: (v) => setState(() => _locationMode = v!),
        activeColor: AppTheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    ],
  );

  Widget _textField(TextEditingController controller, String hint) => TextField(
    controller: controller,
    onChanged: (_) => setState(() {}),
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      isDense: true,
    ),
  );
}