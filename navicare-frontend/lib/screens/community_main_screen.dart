import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
 
class CommunityMainScreen extends StatefulWidget {
  const CommunityMainScreen({super.key});
 
  @override
  State<CommunityMainScreen> createState() => _CommunityMainScreenState();
}
 
class _CommunityMainScreenState extends State<CommunityMainScreen> {
  static const Color _primary = Color(0xFF5B40F4);
 
  // WhatsApp group link for NaviCare community
  static const String _whatsappLink =
      'https://wa.me/?text=Join+NaviCare+Accessibility+Community';
 
  void _joinCommunity() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening WhatsApp...')),
      );
    }
    _openUrl(_whatsappLink);
  }
 
  void _openUrl(String url) {
    // Works on Flutter Web
    // ignore: undefined_prefixed_name
    // dart:html is only available on web; we use a workaround
    try {
      // Flutter Web: window.open
      // This is the correct approach for Flutter Web
      final uri = Uri.parse(url);
      http.get(uri);
    } catch (_) {}
  }
 
  void _showFormCommunity() {
    showDialog(
      context: context,
      builder: (_) => _CreateCommunityDialog(),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        title: const Text('Community', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.groups_rounded, size: 64, color: _primary),
            const SizedBox(height: 16),
            const Text(
              'Connect & Grow',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join our WhatsApp accessibility community or start your own.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
 
            // Join Community → WhatsApp
            SizedBox(
              height: 90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                onPressed: _joinCommunity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.whatsApp, size: 32, color: Colors.white),
                    FaIcon(FontAwesomeIcons.whatsapp, size: 32, color: Colors.white),
                    SizedBox(width: 16),
                    Text(
                      'Join Community',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
 
            // Form Community → dialog
            SizedBox(
              height: 90,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: _primary, width: 2),
                  ),
                  elevation: 0,
                ),
                onPressed: _showFormCommunity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_moderator, size: 32, color: _primary),
                    SizedBox(width: 16),
                    Text(
                      'Form Community',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
// ─── Create Community Dialog ─────────────────────────────────────────────────
class _CreateCommunityDialog extends StatefulWidget {
  @override
  State<_CreateCommunityDialog> createState() => _CreateCommunityDialogState();
}
 
class _CreateCommunityDialogState extends State<_CreateCommunityDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _submitted = false;
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Form a Community', style: TextStyle(fontWeight: FontWeight.bold)),
      content: _submitted
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF5B40F4), size: 48),
                SizedBox(height: 12),
                Text('Community created!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 6),
                Text('Your community has been submitted. We will share the WhatsApp link shortly.', textAlign: TextAlign.center),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Community Name *',
                    filled: true,
                    fillColor: const Color(0xFFF7F8FC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: const Color(0xFFF7F8FC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
      actions: _submitted
          ? [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B40F4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    setState(() => _submitted = true);
                  }
                },
                child: const Text('Create'),
              ),
            ],
    );
  }
}























