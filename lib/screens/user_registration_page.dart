import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';
  final _disabilityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guardianController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _disabilityController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _guardianController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // TODO: Replace with API call to register user
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User registered successfully!")),
      );

      // Navigate to Home
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text("User Registration"),
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
                TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Name"), validator: (v) => v!.isEmpty ? "Enter your name" : null),
                const SizedBox(height: 14),
                TextFormField(controller: _ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Age"), validator: (v) => v!.isEmpty ? "Enter your age" : null),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (val) => setState(() => _gender = val!),
                  decoration: const InputDecoration(labelText: "Gender"),
                ),
                const SizedBox(height: 14),
                TextFormField(controller: _disabilityController, decoration: const InputDecoration(labelText: "Disability"), validator: (v) => v!.isEmpty ? "Enter disability info" : null),
                const SizedBox(height: 14),
                TextFormField(controller: _descriptionController, maxLines: 3, decoration: const InputDecoration(labelText: "Description")),
                const SizedBox(height: 14),
                TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Phone Number"), validator: (v) => v!.isEmpty ? "Enter phone number" : null),
                const SizedBox(height: 14),
                TextFormField(controller: _guardianController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Guardian Number"), validator: (v) => v!.isEmpty ? "Enter guardian number" : null),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: _loading ? null : _handleRegister, child: _loading ? const CircularProgressIndicator() : const Text("Register")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
