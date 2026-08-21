import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
import 'caretaker_home_screen.dart';

class CaretakerRegistrationPage extends StatefulWidget {
  const CaretakerRegistrationPage({super.key});

  @override
  State<CaretakerRegistrationPage> createState() => _CaretakerRegistrationPageState();
}

class _CaretakerRegistrationPageState extends State<CaretakerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _panController = TextEditingController();

  String? _certificateFileName;
  PlatformFile? _certificateFile;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _panController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // TODO: Replace with API call to register caretaker
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Caretaker registered successfully!")),
      );

      // Navigating to the Caretaker Home Screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const CaretakerHomeScreen()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickCertificate() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result.isNotEmpty) {
      setState(() {
        _certificateFile = result.first;
        _certificateFileName = _certificateFile!.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text("Caretaker Registration"),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (v) => v!.isEmpty ? "Enter caretaker name" : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                  validator: (v) => v!.isEmpty ? "Enter age" : null,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (val) => setState(() => _gender = val!),
                  decoration: const InputDecoration(labelText: "Gender"),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(labelText: "Specialization"),
                  validator: (v) => v!.isEmpty ? "Enter specialization" : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _experienceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Years of Experience"),
                  validator: (v) => v!.isEmpty ? "Enter years of experience" : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _panController,
                  decoration: const InputDecoration(labelText: "PAN Card Number"),
                  validator: (v) => v!.isEmpty ? "Enter PAN card number" : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _certificateFileName ?? "No certificate selected",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton.icon(
                        onPressed: _pickCertificate,
                        icon: const Icon(Icons.attach_file),
                        label: const Text("Attach Certificate"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _handleRegister,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}