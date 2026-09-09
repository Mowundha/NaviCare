import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../services/supabase_service.dart';
import '../models/venue.dart';
import '../helpers.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  final void Function(String) onRegistered;

  const RegisterScreen({super.key, required this.onRegistered});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 1;
  bool _submitting = false;
  String? _error;

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  String _type = 'restaurant';
  AccessibilityFeatures _features = AccessibilityFeatures.empty();

  bool get _canProceed =>
      _nameController.text.trim().isNotEmpty &&
      _addressController.text.trim().isNotEmpty &&
      _cityController.text.trim().isNotEmpty &&
      _stateController.text.trim().isNotEmpty &&
      _contactController.text.trim().isNotEmpty;

  void _continueToAccessibility() {
    if (!_canProceed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete the required business details first.')),
      );
      return;
    }
    setState(() => _step = 2);
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });

    final venue = Venue(
      id: '',
      name: _nameController.text.trim(),
      type: _type,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zip: _zipController.text.trim().isEmpty ? null : _zipController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
      imageUrl: _imageController.text.trim().isEmpty ? null : _imageController.text.trim(),
      contactName: _contactController.text.trim(),
      accessibility: _features,
      accessibilityNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      verified: false,
      rating: null,
      createdAt: DateTime.now(),
    );

    try {
      final created = await SupabaseService.insertVenue(venue);
      if (!mounted) return;
      _showSuccess(created.id);
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = 'Failed to register venue. Please try again.';
      });
    }
  }

  void _showSuccess(String venueId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: AppTheme.primarySurface, borderRadius: BorderRadius.circular(24)),
              child: const Icon(LucideIcons.checkCircle2, size: 40, color: AppTheme.primary),
            ),
            const SizedBox(height: 16),
            const Text('Venue Registered!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.neutral900)),
            const SizedBox(height: 8),
            const Text('Thank you for making your business more discoverable.', style: TextStyle(fontSize: 14, color: AppTheme.neutral600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onRegistered(venueId);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Your Venue')),
      bottomNavigationBar: _step == 1
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _continueToAccessibility,
                    icon: const Icon(LucideIcons.arrowRight, size: 18),
                    label: const Text('Continue'),
                  ),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _progressDot(1, 'Business Details'),
                Container(width: 40, height: 2, color: _step > 1 ? AppTheme.primary : AppTheme.neutral200),
                _progressDot(2, 'Accessibility'),
              ],
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECDD3))),
                child: Row(
                  children: [
                    const Icon(LucideIcons.alertCircle, size: 20, color: AppTheme.error),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_error!, style: const TextStyle(fontSize: 14, color: AppTheme.error))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_step == 1) ..._step1Fields(),
            if (_step == 2) ..._step2Fields(),
          ],
        ),
      ),
    );
  }

  List<Widget> _step1Fields() {
    return [
      const Text('Venue Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.neutral800)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(child: _typeCard('restaurant', 'Restaurant', 'Dining establishments', Icons.restaurant)),
          const SizedBox(width: 12),
          Expanded(child: _typeCard('hotel', 'Hotel', 'Accommodation providers', Icons.hotel)),
        ],
      ),
      const SizedBox(height: 20),
      _textField(_nameController, 'Business Name *', 'e.g. The Garden Bistro'),
      const SizedBox(height: 16),
      _textField(_contactController, 'Contact Person *', 'e.g. Jane Smith'),
      const SizedBox(height: 16),
      _textField(_addressController, 'Street Address *', 'e.g. 123 Main Street'),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(flex: 2, child: _textField(_cityController, 'City *', 'e.g. San Francisco')),
          const SizedBox(width: 12),
          Expanded(child: _textField(_stateController, 'State *', 'CA')),
          const SizedBox(width: 12),
          Expanded(child: _textField(_zipController, 'Pincode', 'e.g. 600001')),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: _textField(_phoneController, 'Phone', '(555) 123-4567')),
          const SizedBox(width: 12),
          Expanded(child: _textField(_emailController, 'Email', 'contact@venue.com')),
        ],
      ),
      const SizedBox(height: 16),
      _textField(_websiteController, 'Website (optional)', 'https://...'),
      const SizedBox(height: 16),
      _textField(_imageController, 'Image URL (optional)', 'https://example.com/photo.jpg'),
      const SizedBox(height: 16),
      const Text('Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.neutral800)),
      const SizedBox(height: 8),
      TextField(
        controller: _descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(hintText: 'Tell guests about your venue...'),
      ),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _step2Fields() {
    final score = accessibilityScore(_features);
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.primarySurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.primaryLight)),
        child: Row(
          children: [
            const Icon(LucideIcons.building2, size: 20, color: AppTheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Accessibility Checklist', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
                  Text('$score% complete', style: const TextStyle(fontSize: 12, color: AppTheme.primaryDark)),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      for (final category in AccessibilityChecklist.categories) ...[
        Text(category, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.neutral500, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        ...AccessibilityChecklist.itemsForCategory(category).map((item) => _featureToggle(item)),
        const SizedBox(height: 16),
      ],
      const Text('Additional Accessibility Notes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.neutral800)),
      const SizedBox(height: 8),
      TextField(
        controller: _notesController,
        maxLines: 3,
        decoration: const InputDecoration(hintText: 'Describe any other accessibility features...'),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          TextButton(
            onPressed: () => setState(() => _step = 1),
            child: const Text('Back'),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(LucideIcons.checkCircle2, size: 18),
            label: Text(_submitting ? 'Submitting...' : 'Submit Registration'),
          ),
        ],
      ),
    ];
  }

  Widget _typeCard(String value, String title, String subtitle, IconData icon) {
    final active = _type == value;
    return GestureDetector(
      onTap: () => setState(() => _type = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active ? AppTheme.primarySurface : AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? AppTheme.primary : AppTheme.neutral200, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: active ? AppTheme.primary : AppTheme.neutral400),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.neutral900)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.neutral500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureToggle(ChecklistItem item) {
    final checked = item.getValue(_features);
    return GestureDetector(
      onTap: () => setState(() => _features = item.setValue(_features, !checked)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: checked ? AppTheme.primarySurface : AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: checked ? AppTheme.primaryLight : AppTheme.neutral200),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: checked ? AppTheme.primary : AppTheme.neutral100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIcon(item.icon), size: 18, color: checked ? AppTheme.white : AppTheme.neutral400),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.neutral800))),
            if (checked) const Icon(LucideIcons.checkCircle2, size: 18, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    const map = {
      'Accessibility': LucideIcons.accessibility,
      'TrendingUp': LucideIcons.trendingUp,
      'Armchair': LucideIcons.armchair,
      'DoorOpen': LucideIcons.doorOpen,
      'ArrowUpDown': LucideIcons.arrowUpDown,
      'Car': LucideIcons.car,
      'MoveHorizontal': LucideIcons.moveHorizontal,
      'Minus': LucideIcons.minus,
      'Grip': LucideIcons.grip,
      'BedDouble': LucideIcons.bedDouble,
      'ShowerHead': LucideIcons.showerHead,
      'Type': LucideIcons.type,
      'ZoomIn': LucideIcons.zoomIn,
      'BellRing': LucideIcons.bellRing,
      'DoorClosed': LucideIcons.doorClosed,
      'Hand': LucideIcons.hand,
      'Ear': LucideIcons.ear,
      'Dog': LucideIcons.dog,
      'Moon': LucideIcons.moon,
      'Sparkles': LucideIcons.sparkles,
      'GraduationCap': LucideIcons.graduationCap,
    };
    return map[name] ?? Icons.accessibility;
  }

  Widget _progressDot(int step, String label) {
    final active = _step >= step;
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: active ? AppTheme.primary : AppTheme.neutral100,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('$step', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: active ? AppTheme.white : AppTheme.neutral400))),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: active ? AppTheme.neutral900 : AppTheme.neutral400)),
      ],
    );
  }

  Widget _textField(TextEditingController controller, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.neutral800)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}