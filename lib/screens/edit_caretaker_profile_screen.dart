import 'package:flutter/material.dart';

class CaretakerDetails {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String experience;

  const CaretakerDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.experience,
  });
}

class EditCaretakerProfileScreen extends StatefulWidget {
  final CaretakerDetails details;

  const EditCaretakerProfileScreen({
    super.key,
    required this.details,
  });

  @override
  State<EditCaretakerProfileScreen> createState() =>
      _EditCaretakerProfileScreenState();
}

class _EditCaretakerProfileScreenState
    extends State<EditCaretakerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _experienceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.details.name);
    _emailController = TextEditingController(text: widget.details.email);
    _phoneController = TextEditingController(text: widget.details.phone);
    _locationController = TextEditingController(text: widget.details.location);
    _experienceController =
        TextEditingController(text: widget.details.experience);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Enter your $label';
    return null;
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      CaretakerDetails(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        experience: _experienceController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF5B40F4),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(_nameController, 'Full Name', Icons.person_outline),
              const SizedBox(height: 14),
              _buildField(
                _emailController,
                'Email Address',
                Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final requiredError = _required(value, 'email');
                  if (requiredError != null) return requiredError;
                  if (!value!.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildField(
                _phoneController,
                'Phone Number',
                Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              _buildField(
                _locationController,
                'Location',
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 14),
              _buildField(
                _experienceController,
                'Experience',
                Icons.work_outline,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B40F4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ?? (value) => _required(value, label.toLowerCase()),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
