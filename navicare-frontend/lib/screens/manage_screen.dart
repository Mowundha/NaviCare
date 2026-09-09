import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../services/supabase_service.dart';
import '../models/venue.dart';
import '../helpers.dart';

class ManageScreen extends StatefulWidget {
  final void Function(String) onVenueTap;

  const ManageScreen({super.key, required this.onVenueTap});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  List<Venue> _allVenues = [];
  List<Venue> _results = [];
  bool _loading = true;
  bool _searched = false;
  String _searchQuery = '';

  Venue? _editingVenue;
  bool _saving = false;
  bool _deleting = false;
  String? _saveError;
  bool _saved = false;
  bool _showDeleteConfirm = false;

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
  String _editType = 'restaurant';
  AccessibilityFeatures _editFeatures = AccessibilityFeatures.empty();

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    setState(() => _loading = true);
    try {
      final venues = await SupabaseService.fetchVenues(limit: 200);
      setState(() {
        _allVenues = venues;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _handleSearch() {
    setState(() {
      _searched = true;
      if (_searchQuery.isEmpty) {
        _results = _allVenues;
      } else {
        final q = _searchQuery.toLowerCase();
        _results = _allVenues.where((v) =>
            v.name.toLowerCase().contains(q) ||
            v.city.toLowerCase().contains(q) ||
            v.address.toLowerCase().contains(q) ||
            v.contactName.toLowerCase().contains(q) ||
            (v.email?.toLowerCase().contains(q) ?? false)).toList();
      }
    });
  }

  void _startEdit(Venue venue) {
    _editingVenue = venue;
    _nameController.text = venue.name;
    _contactController.text = venue.contactName;
    _addressController.text = venue.address;
    _cityController.text = venue.city;
    _stateController.text = venue.state;
    _zipController.text = venue.zip ?? '';
    _phoneController.text = venue.phone ?? '';
    _emailController.text = venue.email ?? '';
    _websiteController.text = venue.website ?? '';
    _imageController.text = venue.imageUrl ?? '';
    _descriptionController.text = venue.description ?? '';
    _notesController.text = venue.accessibilityNotes ?? '';
    _editType = venue.type;
    _editFeatures = venue.accessibility;
    _saveError = null;
    _saved = false;
    _showDeleteConfirm = false;
    setState(() {});
  }

  Future<void> _save() async {
    if (_editingVenue == null) return;
    setState(() {
      _saving = true;
      _saveError = null;
      _saved = false;
    });

    final updated = _editingVenue!.copyWith(
      name: _nameController.text.trim(),
      type: _editType,
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
      accessibility: _editFeatures,
      accessibilityNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    try {
      final result = await SupabaseService.updateVenue(updated);
      setState(() {
        _editingVenue = result;
        _editFeatures = result.accessibility;
        _saving = false;
        _saved = true;
      });
      Future.delayed(const Duration(seconds: 3), () => setState(() => _saved = false));
    } catch (e) {
      setState(() {
        _saving = false;
        _saveError = 'Failed to save changes. Please try again.';
      });
    }
  }

  Future<void> _delete() async {
    if (_editingVenue == null) return;
    setState(() => _deleting = true);
    try {
      await SupabaseService.deleteVenue(_editingVenue!.id);
      if (!mounted) return;
      _backToSearch();
    } catch (e) {
      setState(() {
        _deleting = false;
        _saveError = 'Failed to delete venue. Please try again.';
        _showDeleteConfirm = false;
      });
    }
  }

  void _backToSearch() {
    setState(() {
      _editingVenue = null;
      _searched = false;
      _searchQuery = '';
    });
    _loadVenues();
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
    if (_editingVenue != null) return _editView();
    return _searchView();
  }

  Widget _searchView() {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Your Venue')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: const Color(0xFFF0FDFA), borderRadius: BorderRadius.circular(20)),
              child: const Icon(LucideIcons.building2, size: 32, color: Color(0xFF0D9488)),
            ),
            const SizedBox(height: 16),
            const Text('Manage Your Venue', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text('Search for your restaurant or hotel to update details, edit accessibility info, or remove your listing.', style: TextStyle(fontSize: 14, color: Color(0xFF64748B)), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name, city, contact...',
                      prefixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF94A3B8)),
                    ),
                    onChanged: (value) => _searchQuery = value,
                    onSubmitted: (_) => _handleSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _handleSearch, child: const Text('Search')),
              ],
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Color(0xFF0D9488))))
            else if (_searched && _results.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const Icon(LucideIcons.search, size: 48, color: Color(0xFFCBD5E1)),
                      const SizedBox(height: 12),
                      const Text('No venues found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                      const SizedBox(height: 4),
                      const Text('Try a different search', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              )
            else if (_searched)
              ..._results.map((v) => _searchResultCard(v)),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFF0FDFA), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF5EEAD4))),
              child: Column(
                children: [
                  const Text("Don't see your venue?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F766E))),
                  const SizedBox(height: 4),
                  TextButton(onPressed: () => widget.onVenueTap(''), child: const Text('Register a new venue')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchResultCard(Venue venue) {
    final score = accessibilityScore(venue.accessibility);
    final label = getAccessibilityLabel(venue.accessibility);
    return GestureDetector(
      onTap: () => _startEdit(venue),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                getVenueImage(venue),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: const Color(0xFFE2E8F0), child: const Icon(Icons.image, size: 20, color: Color(0xFF94A3B8))),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(venue.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                      if (venue.verified) const Icon(LucideIcons.checkCircle2, size: 16, color: Color(0xFF0D9488)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text('${venue.city}, ${venue.state}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(venue.type == 'restaurant' ? Icons.restaurant : Icons.hotel, size: 12, color: const Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(venue.type, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                      const SizedBox(width: 12),
                      Text('${label.label} ($score%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(label.color))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(LucideIcons.edit3, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _editView() {
    final score = accessibilityScore(_editFeatures);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${_editingVenue!.name}'),
        leading: IconButton(icon: const Icon(LucideIcons.arrowLeft), onPressed: _backToSearch),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_saved)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFA7F3D0))),
                child: Row(children: const [Icon(LucideIcons.checkCircle2, size: 20, color: Color(0xFF059669)), SizedBox(width: 12), Text('Changes saved successfully!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF065F46)))]),
              ),
            if (_saveError != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECDD3))),
                child: Row(children: [const Icon(LucideIcons.alertCircle, size: 20, color: Color(0xFFE11D48)), const SizedBox(width: 12), Expanded(child: Text(_saveError!, style: const TextStyle(fontSize: 14, color: Color(0xFFBE123C))))]),
              ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Business Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 16),
                  _label('Business Name'),
                  TextField(controller: _nameController),
                  const SizedBox(height: 12),
                  _label('Contact Person'),
                  TextField(controller: _contactController),
                  const SizedBox(height: 12),
                  _label('Venue Type'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _typeButton('restaurant', 'Restaurant', Icons.restaurant)),
                      const SizedBox(width: 12),
                      Expanded(child: _typeButton('hotel', 'Hotel', Icons.hotel)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _label('Street Address'),
                  TextField(controller: _addressController),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('City'), const SizedBox(height: 6), TextField(controller: _cityController)])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('State'), const SizedBox(height: 6), TextField(controller: _stateController)])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('ZIP'), const SizedBox(height: 6), TextField(controller: _zipController)])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('Phone'), const SizedBox(height: 6), TextField(controller: _phoneController)])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('Email'), const SizedBox(height: 6), TextField(controller: _emailController)])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('Website'), const SizedBox(height: 6), TextField(controller: _websiteController)])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _label('Image URL'),
                  TextField(controller: _imageController),
                  const SizedBox(height: 12),
                  _label('Description'),
                  const SizedBox(height: 6),
                  TextField(controller: _descriptionController, maxLines: 3),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Accessibility Features', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Row(
                        children: [
                          SizedBox(width: 60, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: score / 100, backgroundColor: const Color(0xFFF1F5F9), color: const Color(0xFF14B8A6), minHeight: 6))),
                          const SizedBox(width: 8),
                          Text('$score%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final category in AccessibilityChecklist.categories) ...[
                    Text(category.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8), letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    ...AccessibilityChecklist.itemsForCategory(category).map((item) => _featureToggle(item)),
                    const SizedBox(height: 12),
                  ],
                  _label('Additional Accessibility Notes'),
                  const SizedBox(height: 6),
                  TextField(controller: _notesController, maxLines: 3),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFECDD3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Remove Listing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF9F1239))),
                  const SizedBox(height: 4),
                  const Text('Permanently remove this venue from the directory. This cannot be undone.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 12),
                  if (!_showDeleteConfirm)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _showDeleteConfirm = true),
                      icon: const Icon(LucideIcons.trash2, size: 16),
                      label: const Text('Remove venue'),
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFE11D48), side: const BorderSide(color: Color(0xFFFECDD3))),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECDD3))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Are you sure you want to permanently remove "${_editingVenue!.name}"?', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9F1239))),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _deleting ? null : _delete,
                                icon: _deleting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.trash2, size: 16),
                                label: Text(_deleting ? 'Deleting...' : 'Yes, remove'),
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
                              ),
                              const SizedBox(width: 12),
                              TextButton(onPressed: () => setState(() => _showDeleteConfirm = false), child: const Text('Cancel')),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                TextButton(onPressed: _backToSearch, child: const Text('Cancel')),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.save, size: 18),
                  label: Text(_saving ? 'Saving...' : 'Save Changes'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _typeButton(String value, String label, IconData icon) {
    final active = _editType == value;
    return GestureDetector(
      onTap: () => setState(() => _editType = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF0FDFA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: active ? const Color(0xFF0D9488) : const Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: active ? const Color(0xFF0F172A) : const Color(0xFF334155))),
          ],
        ),
      ),
    );
  }

  Widget _featureToggle(ChecklistItem item) {
    final checked = item.getValue(_editFeatures);
    return GestureDetector(
      onTap: () => setState(() => _editFeatures = item.setValue(_editFeatures, !checked)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: checked ? const Color(0xFFF0FDFA) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: checked ? const Color(0xFF5EEAD4) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: checked ? const Color(0xFF0D9488) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_getIcon(item.icon), size: 16, color: checked ? Colors.white : const Color(0xFF94A3B8)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(item.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: checked ? const Color(0xFF0F766E) : const Color(0xFF334155)))),
            if (checked) const Icon(LucideIcons.checkCircle2, size: 16, color: Color(0xFF0D9488)),
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

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)));
  }
}
