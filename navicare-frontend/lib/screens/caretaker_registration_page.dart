import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'caretaker_home_screen.dart';

class CaretakerRegistrationPage extends StatefulWidget {
  const CaretakerRegistrationPage({super.key});

  @override
  State<CaretakerRegistrationPage> createState() =>
      _CaretakerRegistrationPageState();
}

class _CaretakerRegistrationPageState
    extends State<CaretakerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _panController = TextEditingController();

  String _gender = 'Male';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  String? _certificateFileName; // only the name, no PlatformFile stored

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _panController.dispose();
    super.dispose();
  }

  // ── Validators ────────────────────────────────────────────────────────────

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Name must be at least 2 characters';
    if (!RegExp(r"^[a-zA-Z\s'.]+$").hasMatch(v.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 13) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include at least one uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include at least one number';
    return null;
  }

  String? _validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? _validateAge(String? v) {
    if (v == null || v.trim().isEmpty) return 'Age is required';
    final age = int.tryParse(v.trim());
    if (age == null) return 'Enter a valid number';
    if (age < 18 || age > 70) return 'Age must be between 18 and 70';
    return null;
  }

  String? _validateSpecialization(String? v) {
    if (v == null || v.trim().isEmpty) return 'Specialization is required';
    if (v.trim().length < 3) return 'Enter at least 3 characters';
    return null;
  }

  String? _validateExperience(String? v) {
    if (v == null || v.trim().isEmpty) return 'Years of experience is required';
    final years = int.tryParse(v.trim());
    if (years == null) return 'Enter a valid number';
    if (years < 0 || years > 50) return 'Enter a value between 0 and 50';
    return null;
  }

  String? _validatePan(String? v) {
    if (v == null || v.trim().isEmpty) return 'PAN Card number is required';
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
        .hasMatch(v.trim().toUpperCase())) {
      return 'Format: ABCDE1234F (5 letters, 4 digits, 1 letter)';
    }
    return null;
  }

  // ── Certificate picker ─────────────────────────────────────────────────────

  // Future<void> _pickCertificate() async {
  //   // final result = await FilePicker.pickFiles(
  //   //   type: FileType.custom,
  //   //   allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  //   final result = await FilePicker.platform.pickFiles(
  //   type: FileType.custom,
  //   allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  //   );
    
  //   if (result != null && result.files.isNotEmpty) {
  //     setState(() {
  //       _certificateFileName = result.files.first.name;
  //     });
  //   }
  // }






  Future<void> _pickCertificate() async {
    final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (!mounted || files.isEmpty) return;

    setState(() {
      _certificateFileName = files.first.name;
    });
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final result = await AuthService.registerCaretaker(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        gender: _gender,
        // age: int.parse(_ageController.text.trim()), // ← was missing before
        specialization: _specializationController.text.trim(),
        yearsOfExperience: int.parse(_experienceController.text.trim()),
        panCard: _panController.text.trim().toUpperCase(),
        certificateFileName: _certificateFileName,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Registered successfully!'),
            ]),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const CaretakerHomeScreen()),
          (route) => false,
        );
      } else {
        final error =
            result['error'] as String? ?? 'Registration failed. Try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(error)),
            ]),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        title: const Text('Caretaker Registration'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction, // ← validates as user types
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Personal ───────────────────────────────────────────
                _section('Personal Information'),
                const SizedBox(height: 12),
                _field(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'e.g. Ravi Kumar',
                  icon: Icons.person_outline,
                  validator: _validateName,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'e.g. ravi@email.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'e.g. 9876543210',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _ageController,
                  label: 'Age',
                  hint: 'e.g. 30',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  validator: _validateAge,
                ),
                const SizedBox(height: 14),
                _genderDropdown(),

                const SizedBox(height: 24),

                // ─── Password ────────────────────────────────────────────
                _section('Set Password'),
                const SizedBox(height: 12),
                _passwordField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Min 8 chars, 1 uppercase, 1 number',
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 14),
                _passwordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  obscure: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 24),

                // ─── Professional ────────────────────────────────────────
                _section('Professional Details'),
                const SizedBox(height: 12),
                _field(
                  controller: _specializationController,
                  label: 'Specialization',
                  hint: 'e.g. Elderly Care, Physiotherapy',
                  icon: Icons.medical_services_outlined,
                  validator: _validateSpecialization,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _experienceController,
                  label: 'Years of Experience',
                  hint: 'e.g. 5',
                  icon: Icons.work_outline,
                  keyboardType: TextInputType.number,
                  validator: _validateExperience,
                ),
                const SizedBox(height: 14),
                _field(
                  controller: _panController,
                  label: 'PAN Card Number',
                  hint: 'e.g. ABCDE1234F',
                  icon: Icons.credit_card_outlined,
                  validator: _validatePan,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 10,
                ),
                const SizedBox(height: 14),
                _certificatePicker(),
                const SizedBox(height: 6),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    'Accepted: PDF, JPG, PNG',
                    style: TextStyle(fontSize: 11, color: AppTheme.neutral500),
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Submit ──────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _handleRegister,
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: AppTheme.white),
                          )
                        : const Text('Register'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Reusable widgets ───────────────────────────────────────────────────────

  Widget _section(String label) => Text(
        label,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary),
      );

  InputDecoration _dec({
    required String label,
    required String hint,
    required IconData icon,
  }) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
        counterText: '',
        filled: true,
        fillColor: AppTheme.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.neutral200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.neutral200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.primary, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.error, width: 2)),
      );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int? maxLength,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        maxLength: maxLength,
        decoration: _dec(label: label, hint: hint, icon: icon),
        validator: validator,
      );

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: _dec(
          label: label,
          hint: hint,
          icon: Icons.lock_outline,
        ).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.neutral500,
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
        validator: validator,
      );

  Widget _genderDropdown() => DropdownButtonFormField<String>(
        value: _gender,
        decoration: _dec(
          label: 'Gender',
          hint: '',
          icon: Icons.wc_outlined,
        ),
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        onChanged: (val) => setState(() => _gender = val!),
      );

  Widget _certificatePicker() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.neutral200),
        ),
        child: Row(
          children: [
            Icon(
              _certificateFileName != null
                  ? Icons.check_circle
                  : Icons.upload_file_outlined,
              color: _certificateFileName != null
                  ? AppTheme.success
                  : AppTheme.neutral500,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _certificateFileName ?? 'No certificate selected',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: _certificateFileName != null
                      ? AppTheme.neutral800
                      : AppTheme.neutral500,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _pickCertificate,
              icon: const Icon(Icons.attach_file, size: 16),
              label: const Text('Attach'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primarySurface,
                foregroundColor: AppTheme.primary,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                textStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
}
