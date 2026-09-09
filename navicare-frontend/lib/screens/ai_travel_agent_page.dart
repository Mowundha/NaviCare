





































































































































// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:audioplayers/audioplayers.dart';
// import '../services/token_storage.dart';
// import '../theme/app_theme.dart';
// import '../services/agent_service.dart';
// import 'find_caretaker_screen.dart';
// import 'caretaker_details_screen.dart';
 
// // ─── Message Model ────────────────────────────────────────────────────────────
// class AIMessage {
//   final String text;
//   final bool isUser;
//   final DateTime timestamp;
//   final String? audioUrl;
//   final MessageCard? card;
 
//   AIMessage({required this.text, required this.isUser, DateTime? timestamp, this.audioUrl, this.card})
//       : timestamp = timestamp ?? DateTime.now();
// }
 
// // ─── Rich Card Types ──────────────────────────────────────────────────────────
// enum CardType { caretaker, restaurant, hotel, place }
 
// class MessageCard {
//   final CardType type;
//   final List<Map<String, dynamic>> items;
//   const MessageCard({required this.type, required this.items});
// }
 
// // ─── Chat Session persistence ─────────────────────────────────────────────────
// class _ChatStore {
//   static final _ChatStore _i = _ChatStore._();
//   factory _ChatStore() => _i;
//   _ChatStore._();
 
//   final List<List<AIMessage>> sessions = [[]];
//   int currentIndex = 0;
 
//   void newSession() {
//     sessions.insert(0, []);
//     currentIndex = 0;
//   }
 
//   void selectSession(int i) => currentIndex = i;
 
//   List<AIMessage> get current => sessions[currentIndex];
// }
 
// // ─── Screen ───────────────────────────────────────────────────────────────────
// class AITravelAgentPage extends StatefulWidget {
//   const AITravelAgentPage({super.key});
 
//   @override
//   State<AITravelAgentPage> createState() => _AITravelAgentPageState();
// }
 
// class _AITravelAgentPageState extends State<AITravelAgentPage>
//     with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
 
//   final AudioRecorder _recorder = AudioRecorder();
//   bool _isListening = false;
 
//   final String _sessionId = 'session-${Random().nextInt(999999)}';
//   String _userName = 'User';
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlayingAudio = false;
//   bool _isTyping = false;
 
//   // ── Live Voice Conversation Mode ──
//   // When true the UI enters ChatGPT-style phone-call mode:
//   //   tap → listen → send (voice mode) → agent speaks → listen again
//   bool _isVoiceConversationMode = false;
//   bool _isAgentSpeaking = false;
 
//   // Pulse animation controller for the big mic button
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;
 
//   final _store = _ChatStore();
 
//   List<AIMessage> get _currentMessages => _store.current;
 
//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
 
//     // Set up pulse animation for voice mode button
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
 
//     // When audio finishes playing, auto-restart listening if still in voice mode
//     _audioPlayer.onPlayerComplete.listen((_) {
//       if (mounted) {
//         setState(() {
//           _isPlayingAudio = false;
//           _isAgentSpeaking = false;
//         });
//         if (_isVoiceConversationMode) {
//           _startListeningForNextTurn();
//         }
//       }
//     });
//   }
 
//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _audioPlayer.dispose();
//     _recorder.dispose();
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
 
//   Future<void> _loadUserName() async {
//     final name = await TokenStorage.instance.getUserName();
//     if (mounted && name != null && name.isNotEmpty) {
//       setState(() => _userName = name);
//     }
//   }
 
//   // No init needed — record package is ready immediately
 
//   // ── Voice Conversation Mode ────────────────────────────────────────────────
 
//   /// Toggle the whole voice conversation mode on/off.
//   void _toggleVoiceConversationMode() async {
//     if (_isVoiceConversationMode) {
//       // EXIT voice mode — stop recorder if running
//       if (await _recorder.isRecording()) {
//         await _recorder.stop();
//       }
//       await _audioPlayer.stop();
//       setState(() {
//         _isVoiceConversationMode = false;
//         _isListening = false;
//         _isAgentSpeaking = false;
//         _isPlayingAudio = false;
//       });
//     } else {
//       // ENTER voice mode
//       setState(() => _isVoiceConversationMode = true);
//       _startListeningForNextTurn();
//     }
//   }
 
//   /// Start recording user audio (called after entering mode or after agent finishes speaking).
//   void _startListeningForNextTurn() async {
//     if (!mounted || !_isVoiceConversationMode) return;

//     final hasPermission = await _recorder.hasPermission();
//     if (!hasPermission) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Microphone permission denied')),
//         );
//       }
//       return;
//     }

//     final dir = await getTemporaryDirectory();
//     final path = '${dir.path}/navicare_turn_${DateTime.now().millisecondsSinceEpoch}.m4a';

//     await _recorder.start(
//       const RecordConfig(
//         encoder: AudioEncoder.aacLc,   // .m4a — works on Android & iOS
//         bitRate: 64000,
//         sampleRate: 16000,             // 16kHz — optimal for Chirp 3 STT
//       ),
//       path: path,
//     );

//     if (mounted) setState(() => _isListening = true);
//   }
 
//   /// Stop recording, send audio bytes to Chirp 3 STT → Gemini → Cloud TTS, play reply.
//   Future<void> _stopAndSendVoiceTurn() async {
//     if (!await _recorder.isRecording()) return;

//     final path = await _recorder.stop();
//     if (mounted) setState(() => _isListening = false);

//     if (path == null) return;

//     final audioBytes = await File(path).readAsBytes();
//     if (audioBytes.isEmpty) return;

//     if (mounted) {
//       setState(() {
//         _store.current.add(AIMessage(text: '🎤 …', isUser: true));
//         _isTyping = true;
//       });
//       _scrollToBottom();
//     }

//     try {
//       // Send real audio bytes → server runs Chirp 3 STT + Gemini + Cloud TTS
//       final result = await AgentService.sendVoiceMessage(
//         sessionId: _sessionId,
//         audioBytes: audioBytes,
//       );

//       if (!mounted) return;

//       // Update the placeholder "🎤 …" with the real transcript if returned
//       final transcript = result['transcript'] as String?;
//       if (transcript != null && transcript.isNotEmpty && _store.current.isNotEmpty) {
//         final msgs = _store.current;
//         msgs[msgs.length - 1] = AIMessage(text: '🎤 $transcript', isUser: true);
//       }

//       final responseText = result['response_text'] ?? result['error'] ?? 'Something went wrong';
//       final audioUrl = result['audio_url'] as String?;
//       final card = _detectCard('', responseText);

//       setState(() {
//         _store.current.add(AIMessage(
//           text: responseText,
//           isUser: false,
//           card: card,
//           audioUrl: audioUrl,
//         ));
//         _isTyping = false;
//       });
//       _scrollToBottom();

//       // Play TTS audio — onPlayerComplete auto-restarts listening
//       if (audioUrl != null && audioUrl.isNotEmpty) {
//         setState(() {
//           _isAgentSpeaking = true;
//           _isPlayingAudio = true;
//         });
//         await _playAudioUrl(audioUrl);
//       } else {
//         if (_isVoiceConversationMode) _startListeningForNextTurn();
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _store.current.add(AIMessage(text: 'Error: ${e.toString()}', isUser: false));
//         _isTyping = false;
//         _isAgentSpeaking = false;
//       });
//       if (_isVoiceConversationMode) _startListeningForNextTurn();
//     }
//   }
 
//   // ── Small mic in input bar — tap to start, tap again to stop & send ────────

//   void _toggleVoiceAssistant() async {
//     if (_isListening) {
//       // STOP — send audio to Chirp 3, get text back, put in text field
//       final path = await _recorder.stop();
//       setState(() => _isListening = false);
//       if (path == null) return;
//       final audioBytes = await File(path).readAsBytes();
//       if (audioBytes.isEmpty) return;

//       // Show spinner while STT runs
//       setState(() => _isTyping = true);
//       try {
//         final result = await AgentService.sendVoiceMessage(
//           sessionId: _sessionId,
//           audioBytes: audioBytes,
//         );
//         setState(() => _isTyping = false);
//         final transcript = result['transcript'] as String? ??
//             result['response_text'] as String? ?? '';
//         if (transcript.isNotEmpty) {
//           _controller.text = transcript;
//         }
//       } catch (_) {
//         setState(() => _isTyping = false);
//       }
//     } else {
//       // START recording
//       final hasPermission = await _recorder.hasPermission();
//       if (!hasPermission) return;
//       final dir = await getTemporaryDirectory();
//       final path = '${dir.path}/navicare_bar_${DateTime.now().millisecondsSinceEpoch}.m4a';
//       await _recorder.start(
//         const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 16000),
//         path: path,
//       );
//       setState(() => _isListening = true);
//     }
//   }
 
//   // ── Audio Playback ─────────────────────────────────────────────────────────
 
//   Future<void> _playAudioUrl(String url) async {
//     try {
//       setState(() => _isPlayingAudio = true);
//       await _audioPlayer.play(UrlSource(url));
//       // completion handled by onPlayerComplete listener in initState
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isPlayingAudio = false;
//           _isAgentSpeaking = false;
//         });
//       }
//       debugPrint('Audio play error: $e');
//     }
//   }
 
//   // ── Text Message (typed / suggestion chips) ────────────────────────────────
 
//   void _sendMessage([String? overrideText]) async {
//     final text = overrideText ?? _controller.text.trim();
//     if (text.isEmpty) return;
 
//     if (_isListening) {
//       await _recorder.stop();
//       _isListening = false;
//     }
 
//     setState(() {
//       _store.current.add(AIMessage(text: text, isUser: true));
//       _controller.clear();
//       _isTyping = true;
//     });
//     _scrollToBottom();
 
//     try {
//       final result = await AgentService.sendMessage(
//         sessionId: _sessionId,
//         message: text,
//       );
 
//       if (!mounted) return;
 
//       final responseText = result['response_text'] ?? result['error'] ?? 'Something went wrong';
//       final card = _detectCard(text.toLowerCase(), responseText);
 
//       setState(() {
//         _store.current.add(AIMessage(text: responseText, isUser: false, card: card));
//         _isTyping = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _store.current.add(AIMessage(text: 'Error: ${e.toString()}', isUser: false));
//         _isTyping = false;
//       });
//     }
//     _scrollToBottom();
//   }
 
//   // ── Card Detection ─────────────────────────────────────────────────────────
 
//   MessageCard? _detectCard(String query, String response) {
//     final lower = query.toLowerCase();
//     final responseLower = response.toLowerCase();
 
//     if (lower.contains('caretaker') || lower.contains('nurse') ||
//         responseLower.contains('caretaker') || responseLower.contains('care specialist')) {
//       return MessageCard(type: CardType.caretaker, items: [
//         {'name': 'Alice Johnson', 'role': 'Elderly Care Specialist', 'exp': '8 Years', 'rating': '4.8'},
//         {'name': 'Priya Patel', 'role': 'Child Care', 'exp': '6 Years', 'rating': '4.6'},
//         {'name': 'Rahul Sharma', 'role': 'Physical Rehabilitation', 'exp': '7 Years', 'rating': '4.9'},
//       ]);
//     }
 
//     if (lower.contains('restaurant') || lower.contains('food') || lower.contains('eat') ||
//         lower.contains('dining') || responseLower.contains('restaurant')) {
//       return MessageCard(type: CardType.restaurant, items: [
//         {
//           'name': 'Sangeetha Restaurant',
//           'cuisine': 'South Indian',
//           'rating': '4.5',
//           'location': 'T. Nagar, Chennai',
//           'feature': 'Wheelchair Access',
//           'imageUrl': 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=400',
//         },
//         {
//           'name': 'Murugan Idli Shop',
//           'cuisine': 'South Indian',
//           'rating': '4.6',
//           'location': 'Vadapalani, Chennai',
//           'feature': 'Ground Floor Access',
//           'imageUrl': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?w=400',
//         },
//       ]);
//     }
 
//     if (lower.contains('hotel') || lower.contains('stay') || lower.contains('accommodation') ||
//         responseLower.contains('hotel')) {
//       return MessageCard(type: CardType.hotel, items: [
//         {
//           'name': 'Taj Coromandel',
//           'rating': '4.9',
//           'location': 'Nungambakkam, Chennai',
//           'price': '₹8,000/night',
//           'feature': 'Wheelchair + Elevator',
//           'imageUrl': 'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?w=400',
//         },
//         {
//           'name': 'ITC Grand Chola',
//           'rating': '4.8',
//           'location': 'Guindy, Chennai',
//           'price': '₹6,500/night',
//           'feature': 'Accessible Rooms + Spa',
//           'imageUrl': 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=400',
//         },
//       ]);
//     }
 
//     return null;
//   }
 
//   void _startNewChat() {
//     setState(() => _store.newSession());
//     Navigator.pop(context);
//   }
 
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
 
//   // ── Build ──────────────────────────────────────────────────────────────────
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: AppTheme.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Container(
//               width: 32, height: 32,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
//             ),
//             const SizedBox(width: 10),
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('NaviCare AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 Text('Travel & Accessibility Guide', style: TextStyle(fontSize: 10, color: Colors.white70)),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_comment_rounded),
//             tooltip: "New Chat",
//             onPressed: _startNewChat,
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(),
//       // Show the live voice conversation overlay when in voice mode
//       body: _isVoiceConversationMode
//           ? _buildVoiceConversationOverlay()
//           : _buildChatBody(),
//     );
//   }
 
//   // ── Chat body (normal mode) ────────────────────────────────────────────────
 
//   Widget _buildChatBody() {
//     return SafeArea(
//       child: Column(
//         children: [
//           // Banner
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             color: AppTheme.primary.withOpacity(0.08),
//             child: Row(
//               children: [
//                 Icon(Icons.psychology_rounded, size: 16, color: AppTheme.primary),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'AI Travel Assistant & Caretaker Guide Active',
//                     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   width: 6, height: 6,
//                   decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
//                 ),
//               ],
//             ),
//           ),
 
//           // Messages
//           Expanded(
//             child: _currentMessages.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     controller: _scrollController,
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _currentMessages.length,
//                     itemBuilder: (context, index) {
//                       return _buildMessageBubble(_currentMessages[index]);
//                     },
//                   ),
//           ),
 
//           if (_isTyping) _buildTypingIndicator(),
//           if (_isListening) _buildListeningBanner(),
 
//           _buildInputBar(),
//         ],
//       ),
//     );
//   }
 
//   // ── Live Voice Conversation Overlay ───────────────────────────────────────
//   // Full-screen overlay similar to ChatGPT voice mode.
//   // Shows recent messages dimmed, big animated mic circle in center.
 
//   Widget _buildVoiceConversationOverlay() {
//     String statusText;
//     if (_isTyping || _isAgentSpeaking) {
//       statusText = _isAgentSpeaking ? 'NaviCare is speaking…' : 'Thinking…';
//     } else if (_isListening) {
//       statusText = 'Listening… speak now';
//     } else {
//       statusText = 'Starting…';
//     }
 
//     return SafeArea(
//       child: Stack(
//         children: [
//           // Dimmed chat transcript behind the overlay
//           Opacity(
//             opacity: 0.18,
//             child: IgnorePointer(
//               child: _currentMessages.isEmpty
//                   ? const SizedBox.expand()
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _currentMessages.length,
//                       itemBuilder: (_, i) => _buildMessageBubble(_currentMessages[i]),
//                     ),
//             ),
//           ),
 
//           // Frosted overlay gradient
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   const Color(0xFFF5F7FA).withOpacity(0.92),
//                   const Color(0xFFF5F7FA).withOpacity(0.98),
//                 ],
//               ),
//             ),
//           ),
 
//           // Center content
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Status label
//               Text(
//                 statusText,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: _isListening
//                       ? const Color(0xFFEF4444)
//                       : _isAgentSpeaking
//                           ? AppTheme.primary
//                           : Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 48),
 
//               // Animated mic / speaker circle
//               // Tap while LISTENING → stop recording and send
//               // Tap while SPEAKING  → end call
//               GestureDetector(
//                 onTap: _isListening
//                     ? _stopAndSendVoiceTurn
//                     : _toggleVoiceConversationMode,
//                 child: AnimatedBuilder(
//                   animation: _pulseAnimation,
//                   builder: (_, child) {
//                     final shouldPulse = _isListening || _isAgentSpeaking;
//                     return Transform.scale(
//                       scale: shouldPulse ? _pulseAnimation.value : 1.0,
//                       child: child,
//                     );
//                   },
//                   child: Container(
//                     width: 110,
//                     height: 110,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _isListening
//                           ? const Color(0xFFEF4444)
//                           : _isAgentSpeaking
//                               ? AppTheme.primary
//                               : AppTheme.primary.withOpacity(0.75),
//                       boxShadow: [
//                         BoxShadow(
//                           color: (_isListening
//                               ? const Color(0xFFEF4444)
//                               : AppTheme.primary).withOpacity(0.35),
//                           blurRadius: 32,
//                           spreadRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       _isAgentSpeaking
//                           ? Icons.volume_up_rounded
//                           : Icons.mic_rounded,
//                       size: 48,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
 
//               // Hint text
//               Text(
//                 _isListening
//                     ? 'Tap mic to stop & send'
//                     : 'Tap to end conversation',
//                 style: TextStyle(fontSize: 13, color: Colors.grey[500]),
//               ),
//               const SizedBox(height: 16),
 
//               // Last agent message (small pill so user can read what was said)
//               if (_currentMessages.isNotEmpty) ...[
//                 const SizedBox(height: 8),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 32),
//                   child: () {
//                     // Find last AI message
//                     final lastAI = _currentMessages.lastWhere(
//                       (m) => !m.isUser,
//                       orElse: () => AIMessage(text: '', isUser: false),
//                     );
//                     if (lastAI.text.isEmpty) return const SizedBox.shrink();
//                     return Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
//                       ),
//                       child: Text(
//                         lastAI.text.length > 120
//                             ? '${lastAI.text.substring(0, 120)}…'
//                             : lastAI.text,
//                         style: const TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.4),
//                         textAlign: TextAlign.center,
//                       ),
//                     );
//                   }(),
//                 ),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }
 
//   // ── Drawer ─────────────────────────────────────────────────────────────────
 
//   Widget _buildDrawer() {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(color: AppTheme.primary),
//             accountName: Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold)),
//             accountEmail: const Text('NaviCare Accessible Travel', style: TextStyle(fontSize: 12)),
//             currentAccountPicture: const CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, color: AppTheme.primary, size: 32),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Chat History", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
//                 TextButton.icon(
//                   onPressed: _startNewChat,
//                   icon: const Icon(Icons.add, size: 16),
//                   label: const Text("New Chat"),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _store.sessions.length,
//               itemBuilder: (context, index) {
//                 final session = _store.sessions[index];
//                 final sessionTitle = session.isNotEmpty ? session.first.text : "New Chat";
//                 return ListTile(
//                   selected: _store.currentIndex == index,
//                   selectedTileColor: AppTheme.primary.withOpacity(0.1),
//                   leading: Icon(Icons.chat_bubble_outline_rounded, size: 18,
//                     color: _store.currentIndex == index ? AppTheme.primary : Colors.grey),
//                   title: Text(sessionTitle,
//                     maxLines: 1, overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontSize: 13)),
//                   onTap: () {
//                     setState(() => _store.selectSession(index));
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
 
//   // ── Empty State ────────────────────────────────────────────────────────────
 
//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 80, height: 80,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppTheme.primary.withOpacity(0.2), AppTheme.primary.withOpacity(0.05)],
//                   begin: Alignment.topLeft, end: Alignment.bottomRight,
//                 ),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Icons.smart_toy_rounded, size: 40, color: AppTheme.primary),
//             ),
//             const SizedBox(height: 20),
//             Text('Hi $_userName!',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
//             const SizedBox(height: 8),
//             Text('How can I help you today?',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600])),
//             const SizedBox(height: 24),
//             _buildSuggestionChips(),
//           ],
//         ),
//       ),
//     );
//   }
 
//   Widget _buildSuggestionChips() {
//     final suggestions = [
//       '♿ Find accessible hotels',
//       '👨‍⚕️ Book a caretaker',
//       '🍽 Accessible restaurants',
//       '🗺 Plan accessible trip',
//     ];
//     return Wrap(
//       spacing: 8, runSpacing: 8,
//       alignment: WrapAlignment.center,
//       children: suggestions.map((s) => GestureDetector(
//         onTap: () => _sendMessage(s),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
//           ),
//           child: Text(s, style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w500)),
//         ),
//       )).toList(),
//     );
//   }
 
//   // ── Message Bubble ─────────────────────────────────────────────────────────
 
//   Widget _buildMessageBubble(AIMessage msg) {
//     return Column(
//       crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         if (!msg.isUser) ...[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 28, height: 28,
//                 decoration: BoxDecoration(
//                   color: AppTheme.primary,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
//               ),
//               const SizedBox(width: 8),
//               Flexible(
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(4),
//                       topRight: Radius.circular(16),
//                       bottomLeft: Radius.circular(16),
//                       bottomRight: Radius.circular(16),
//                     ),
//                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
//                   ),
//                   child: _MarkdownText(text: msg.text, textColor: const Color(0xFF1A1A2E)),
//                 ),
//               ),
//             ],
//           ),
//           if (msg.card != null) ...[
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.only(left: 36),
//               child: _buildRichCard(msg.card!),
//             ),
//           ],
//           // Audio replay button if this message has TTS audio
//           if (msg.audioUrl != null && msg.audioUrl!.isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Padding(
//               padding: const EdgeInsets.only(left: 36),
//               child: GestureDetector(
//                 onTap: () => _playAudioUrl(msg.audioUrl!),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.volume_up_rounded, size: 14, color: AppTheme.primary.withOpacity(0.7)),
//                     const SizedBox(width: 4),
//                     Text('Play again', style: TextStyle(fontSize: 11, color: AppTheme.primary.withOpacity(0.7))),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
 
//         if (msg.isUser)
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.85)],
//               ),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(4),
//                 bottomLeft: Radius.circular(16),
//                 bottomRight: Radius.circular(16),
//               ),
//               boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
//             ),
//             child: Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
//           ),
 
//         const SizedBox(height: 14),
//       ],
//     );
//   }
 
//   // ── Rich Cards ─────────────────────────────────────────────────────────────
 
//   Widget _buildRichCard(MessageCard card) {
//     if (card.type == CardType.caretaker) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Suggested Caretakers', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[600])),
//           const SizedBox(height: 6),
//           ...card.items.map((c) => GestureDetector(
//             onTap: () => Navigator.push(context, MaterialPageRoute(
//               builder: (_) => const FindCaretakerScreen())),
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 8),
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 22,
//                     backgroundColor: AppTheme.primary.withOpacity(0.12),
//                     child: Icon(Icons.person_rounded, color: AppTheme.primary, size: 24),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(c['name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
//                         Text(c['role'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
//                         Text(c['exp'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFF3E0),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFA500)),
//                         const SizedBox(width: 3),
//                         Text(c['rating'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFFFA500))),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )).toList(),
//         ],
//       );
//     }
 
//     // Restaurant / Hotel card (horizontal scroll)
//     final isHotel = card.type == CardType.hotel;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           isHotel ? 'Accessible Hotels' : 'Accessible Restaurants',
//           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[600]),
//         ),
//         const SizedBox(height: 6),
//         SizedBox(
//           height: 170,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: card.items.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 10),
//             itemBuilder: (_, i) {
//               final item = card.items[i];
//               return Container(
//                 width: 170,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
//                       child: Image.network(
//                         item['imageUrl'] ?? '',
//                         height: 90, width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           height: 90,
//                           color: AppTheme.primary.withOpacity(0.1),
//                           child: Icon(isHotel ? Icons.hotel : Icons.restaurant, color: AppTheme.primary),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(item['name'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
//                           Text(item['location'] ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
//                           const SizedBox(height: 4),
//                           Row(
//                             children: [
//                               const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFFA500)),
//                               const SizedBox(width: 2),
//                               Text(item['rating'] ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
//                               const Spacer(),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFD1FAE5),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Text('♿', style: const TextStyle(fontSize: 9)),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
 
//   // ── Typing / Listening indicators ──────────────────────────────────────────
 
//   Widget _buildTypingIndicator() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Row(
//         children: [
//           Container(
//             width: 28, height: 28,
//             decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
//             child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildDot(0),
//                 const SizedBox(width: 4),
//                 _buildDot(150),
//                 const SizedBox(width: 4),
//                 _buildDot(300),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
 
//   Widget _buildDot(int delay) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.3, end: 1.0),
//       duration: Duration(milliseconds: 600 + delay),
//       curve: Curves.easeInOut,
//       builder: (_, v, child) => Opacity(opacity: v, child: child),
//       child: Container(
//         width: 7, height: 7,
//         decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.7), shape: BoxShape.circle),
//       ),
//     );
//   }
 
//   Widget _buildListeningBanner() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       color: Colors.redAccent.withOpacity(0.08),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 8, height: 8,
//             decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 8),
//           const Text("Listening… Speak now",
//             style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
//         ],
//       ),
//     );
//   }
 
//   // ── Input Bar ──────────────────────────────────────────────────────────────
 
//   Widget _buildInputBar() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -2))],
//       ),
//       child: Row(
//         children: [
//           // Small mic button (one-shot STT → text field)
//           GestureDetector(
//             onTap: _toggleVoiceAssistant,
//             child: Container(
//               width: 40, height: 40,
//               decoration: BoxDecoration(
//                 color: _isListening ? Colors.redAccent.withOpacity(0.1) : AppTheme.primary.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
//                 color: _isListening ? Colors.redAccent : AppTheme.primary,
//                 size: 20,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
 
//           // Text input
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5F7FA),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: TextField(
//                 controller: _controller,
//                 onSubmitted: (_) => _sendMessage(),
//                 style: const TextStyle(fontSize: 14),
//                 decoration: const InputDecoration(
//                   hintText: "Ask me anything…",
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
//                   contentPadding: EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
 
//           // Send button
//           GestureDetector(
//             onTap: () => _sendMessage(),
//             child: Container(
//               width: 40, height: 40,
//               decoration: BoxDecoration(
//                 color: AppTheme.primary,
//                 shape: BoxShape.circle,
//                 boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
//               ),
//               child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
//             ),
//           ),
//           const SizedBox(width: 8),
 
//           // ★ BIG BLUE VOICE MODE BUTTON ★
//           GestureDetector(
//             onTap: _toggleVoiceConversationMode,
//             child: Container(
//               width: 44, height: 44,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.75)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppTheme.primary.withOpacity(0.45),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 22),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
 
// // ─── Lightweight Markdown renderer ────────────────────────────────────────────
// class _MarkdownText extends StatelessWidget {
//   final String text;
//   final Color textColor;
 
//   const _MarkdownText({required this.text, required this.textColor});
 
//   @override
//   Widget build(BuildContext context) {
//     final lines = text.split('\n');
//     final widgets = <Widget>[];
 
//     for (final raw in lines) {
//       final line = raw.trim();
//       if (line.isEmpty) {
//         widgets.add(const SizedBox(height: 4));
//         continue;
//       }
 
//       if (line.startsWith('### ')) {
//         widgets.add(Padding(
//           padding: const EdgeInsets.only(top: 8, bottom: 4),
//           child: Text(_stripInline(line.substring(4)),
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
//         ));
//         continue;
//       }
 
//       if (line.startsWith('## ')) {
//         widgets.add(Padding(
//           padding: const EdgeInsets.only(top: 8, bottom: 4),
//           child: Text(_stripInline(line.substring(3)),
//             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
//         ));
//         continue;
//       }
 
//       if (line.startsWith('* ') || line.startsWith('- ')) {
//         widgets.add(Padding(
//           padding: const EdgeInsets.only(left: 8, bottom: 3),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('• ', style: TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
//               Expanded(child: _buildInlineText(line.substring(2), textColor)),
//             ],
//           ),
//         ));
//         continue;
//       }
 
//       final numMatch = RegExp(r'^(\d+)\.\s+(.+)').firstMatch(line);
//       if (numMatch != null) {
//         widgets.add(Padding(
//           padding: const EdgeInsets.only(left: 8, bottom: 3),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('${numMatch.group(1)}. ',
//                 style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
//               Expanded(child: _buildInlineText(numMatch.group(2)!, textColor)),
//             ],
//           ),
//         ));
//         continue;
//       }
 
//       if (line == '---' || line == '—') {
//         widgets.add(Divider(height: 12, color: Colors.grey[300]));
//         continue;
//       }
 
//       widgets.add(Padding(
//         padding: const EdgeInsets.only(bottom: 2),
//         child: _buildInlineText(line, textColor),
//       ));
//     }
 
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
//   }
 
//   String _stripInline(String s) => s.replaceAll('**', '').replaceAll('*', '');
 
//   Widget _buildInlineText(String line, Color color) {
//     final spans = <TextSpan>[];
//     final parts = line.split('**');
//     for (int i = 0; i < parts.length; i++) {
//       if (parts[i].isEmpty) continue;
//       spans.add(TextSpan(
//         text: parts[i],
//         style: TextStyle(
//           fontWeight: i % 2 == 1 ? FontWeight.bold : FontWeight.normal,
//           color: color,
//           fontSize: 14,
//           height: 1.45,
//         ),
//       ));
//     }
//     return RichText(text: TextSpan(children: spans));
//   }
// }
 



 


















































































































































































import 'dart:math';
import 'dart:typed_data';
import '../services/browser_js_stub.dart'
  if (dart.library.js) '../services/browser_js_web.dart' as js;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/token_storage.dart';
import '../theme/app_theme.dart';
import '../services/agent_service.dart';
import 'find_caretaker_screen.dart';
 
// ─── Message Model ────────────────────────────────────────────────────────────
class AIMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? audioUrl;
  final MessageCard? card;
 
  AIMessage({required this.text, required this.isUser, DateTime? timestamp, this.audioUrl, this.card})
      : timestamp = timestamp ?? DateTime.now();
}
 
// ─── Rich Card Types ──────────────────────────────────────────────────────────
enum CardType { caretaker, restaurant, hotel, place }
 
class MessageCard {
  final CardType type;
  final List<Map<String, dynamic>> items;
  const MessageCard({required this.type, required this.items});
}
 
// ─── Chat Session persistence ─────────────────────────────────────────────────
class _ChatStore {
  static final _ChatStore _i = _ChatStore._();
  factory _ChatStore() => _i;
  _ChatStore._();
 
  final List<List<AIMessage>> sessions = [[]];
  int currentIndex = 0;
 
  void newSession() {
    sessions.insert(0, []);
    currentIndex = 0;
  }
 
  void selectSession(int i) => currentIndex = i;
 
  List<AIMessage> get current => sessions[currentIndex];
}
 
// ─── Screen ───────────────────────────────────────────────────────────────────
class AITravelAgentPage extends StatefulWidget {
  const AITravelAgentPage({super.key});
 
  @override
  State<AITravelAgentPage> createState() => _AITravelAgentPageState();
}
 
class _AITravelAgentPageState extends State<AITravelAgentPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
 
  final List<js.JsObject> _audioChunks = [];
  bool _isListening = false;
 
  final String _sessionId = 'session-${Random().nextInt(999999)}';
  String _userName = 'User';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isTyping = false;
 
  // ── Live Voice Conversation Mode ──
  // When true the UI enters ChatGPT-style phone-call mode:
  //   tap → listen → send (voice mode) → agent speaks → listen again
  bool _isVoiceConversationMode = false;
  bool _isAgentSpeaking = false;
 
  // Pulse animation controller for the big mic button
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
 
  final _store = _ChatStore();
 
  List<AIMessage> get _currentMessages => _store.current;
 
  @override
  void initState() {
    super.initState();
    _loadUserName();
 
    // Set up pulse animation for voice mode button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
 
    // When audio finishes playing, auto-restart listening if still in voice mode
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isAgentSpeaking = false;
        });
        if (_isVoiceConversationMode) {
          _startListeningForNextTurn();
        }
      }
    });
  }
 
  @override
  void dispose() {
    _pulseController.dispose();
    _audioPlayer.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
 
  Future<void> _loadUserName() async {
    final name = await TokenStorage.instance.getUserName();
    if (mounted && name != null && name.isNotEmpty) {
      setState(() => _userName = name);
    }
  }
 
  // No init needed — record package is ready immediately
 
  // ── Voice Conversation Mode ────────────────────────────────────────────────
 
  /// Toggle the whole voice conversation mode on/off.
  void _toggleVoiceConversationMode() async {
    if (_isVoiceConversationMode) {
      // EXIT — stop MediaRecorder if running
      js.context.callMethod('eval', ["""
        if (window._navicareRecorder && window._navicareRecorder.state === 'recording') {
          window._navicareRecorder.stop();
        }
      """]);
      await _audioPlayer.stop();
      setState(() {
        _isVoiceConversationMode = false;
        _isListening = false;
        _isAgentSpeaking = false;
      });
    } else {
      // ENTER voice mode
      setState(() => _isVoiceConversationMode = true);
      _startListeningForNextTurn();
    }
  }
 
  /// Start recording via browser MediaRecorder API (dart:js).
  /// Works on Flutter Web / mobile Chrome — sends real audio to Chirp 3.
  /// Start recording via browser MediaRecorder API.
  /// Pure dart:js, all async in JS — no js_util needed.
  void _startListeningForNextTurn() {
    if (!mounted || !_isVoiceConversationMode) return;
    _audioChunks.clear();

    // Register Dart callbacks that JS will call when done
    js.context['_navicareOnAudioReady'] = (js.JsObject uint8) {
      _handleAudioReady(uint8);
    };
    js.context['_navicareOnMicError'] = (dynamic err) {
      debugPrint('Mic error: $err');
      if (mounted) {
        setState(() { _isListening = false; _isVoiceConversationMode = false; });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Microphone access denied. Allow mic in browser settings.'),
          backgroundColor: Colors.red,
        ));
      }
    };

    // All promise/async work in JS — calls Dart back via registered functions
    js.context.callMethod('eval', ["""
      (function() {
        navigator.mediaDevices.getUserMedia({ audio: true, video: false })
          .then(function(stream) {
            var chunks = [];
            var recorder;
            try { recorder = new MediaRecorder(stream, { mimeType: 'audio/webm;codecs=opus' }); }
            catch(e) { recorder = new MediaRecorder(stream); }
            window._navicareRecorder = recorder;
            recorder.ondataavailable = function(e) {
              if (e.data && e.data.size > 0) chunks.push(e.data);
            };
            recorder.onstop = function() {
              var blob = new Blob(chunks, { type: 'audio/webm' });
              chunks = [];
              var reader = new FileReader();
              reader.onloadend = function() {
                window._navicareOnAudioReady(new Uint8Array(reader.result));
              };
              reader.readAsArrayBuffer(blob);
            };
            recorder.start(250);
            console.log('NaviCare mic started');
          })
          .catch(function(err) {
            console.error('NaviCare mic error:', err);
            window._navicareOnMicError(err.toString());
          });
      })();
    """]);

    if (mounted) setState(() => _isListening = true);
  }

  /// Called from JS when audio bytes are ready — converts to Dart Uint8List and sends.
  void _handleAudioReady(js.JsObject jsUint8Array) async {
    final length = jsUint8Array['length'] as int;
    final audioBytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      audioBytes[i] = jsUint8Array[i] as int;
    }
    if (audioBytes.isNotEmpty) await _sendAudioToServer(audioBytes);
  }

  /// Tap mic to stop — JS recorder.stop() fires onstop → _handleAudioReady.
  Future<void> _stopAndSendVoiceTurn() async {
    js.context.callMethod('eval', ["""
      if (window._navicareRecorder && window._navicareRecorder.state === 'recording') {
        window._navicareRecorder.stop();
      }
    """]);
    if (mounted) setState(() => _isListening = false);
  }

  /// Called from onstop — sends audio bytes to Chirp 3 → Gemini → TTS.
  Future<void> _sendAudioToServer(Uint8List audioBytes) async {
    if (!mounted) return;

    setState(() {
      _store.current.add(AIMessage(text: '🎤 …', isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final result = await AgentService.sendVoiceMessage(
        sessionId: _sessionId,
        audioBytes: audioBytes,
      );

      if (!mounted) return;

      final responseText = result['response_text'] ?? result['error'] ?? 'Something went wrong';
      final audioUrl = result['audio_url'] as String?;
      final card = _detectCard('', responseText);

      setState(() {
        _store.current.add(AIMessage(
          text: responseText,
          isUser: false,
          card: card,
          audioUrl: audioUrl,
        ));
        _isTyping = false;
      });
      _scrollToBottom();

      // Play TTS — onPlayerComplete auto-restarts listening
      if (audioUrl != null && audioUrl.isNotEmpty) {
        setState(() {
          _isAgentSpeaking = true;
        });
        await _playAudioUrl(audioUrl);
      } else {
        if (_isVoiceConversationMode) _startListeningForNextTurn();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _store.current.add(AIMessage(text: 'Error: $e', isUser: false));
        _isTyping = false;
        _isAgentSpeaking = false;
      });
      if (_isVoiceConversationMode) _startListeningForNextTurn();
    }
  }

  Future<void> _playAudioUrl(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (error) {
      if (mounted) {
        setState(() => _isAgentSpeaking = false);
      }
      debugPrint('Audio play error: $error');
    }
  }
 
  // ── Small mic in input bar — tap to start, tap again to stop & transcribe ──

  // ── Small mic in input bar — tap to start, tap again to stop ──
  void _toggleVoiceAssistant() {
    if (_isListening) {
      // STOP — JS recorder stops, onstop fires, we get transcript via sendVoiceMessage
      js.context['_navicareOnAudioReady'] = (js.JsObject uint8) async {
        final length = uint8['length'] as int;
        final audioBytes = Uint8List(length);
        for (int i = 0; i < length; i++) audioBytes[i] = uint8[i] as int;
        if (audioBytes.isEmpty) return;
        setState(() => _isTyping = true);
        try {
          final result = await AgentService.sendVoiceMessage(
            sessionId: _sessionId,
            audioBytes: audioBytes,
          );
          setState(() => _isTyping = false);
          final transcript = result['transcript'] as String? ??
              result['response_text'] as String? ?? '';
          if (transcript.isNotEmpty) _controller.text = transcript;
        } catch (_) { setState(() => _isTyping = false); }
      };
      js.context.callMethod('eval', ["""
        if (window._navicareRecorder && window._navicareRecorder.state === 'recording') {
          window._navicareRecorder.stop();
        }
      """]);
      setState(() => _isListening = false);
    } else {
      // START — same JS flow as voice conversation mode
      js.context['_navicareOnMicError'] = (dynamic err) {
        if (mounted) setState(() => _isListening = false);
      };
      js.context.callMethod('eval', ["""
        (function() {
          navigator.mediaDevices.getUserMedia({ audio: true, video: false })
            .then(function(stream) {
              var chunks = [];
              var recorder;
              try { recorder = new MediaRecorder(stream, { mimeType: 'audio/webm;codecs=opus' }); }
              catch(e) { recorder = new MediaRecorder(stream); }
              window._navicareRecorder = recorder;
              recorder.ondataavailable = function(e) {
                if (e.data && e.data.size > 0) chunks.push(e.data);
              };
              recorder.onstop = function() {
                var blob = new Blob(chunks, { type: 'audio/webm' });
                chunks = [];
                var reader = new FileReader();
                reader.onloadend = function() {
                  window._navicareOnAudioReady(new Uint8Array(reader.result));
                };
                reader.readAsArrayBuffer(blob);
              };
              recorder.start(250);
            })
            .catch(function(err) { window._navicareOnMicError(err.toString()); });
        })();
      """]);
      setState(() => _isListening = true);
    }
  }

  void _sendMessage([String? overrideText]) async {
    final text = overrideText ?? _controller.text.trim();
    if (text.isEmpty) return;
 
    if (_isListening) {
      js.context.callMethod('eval', ["""
        if (window._navicareRecorder && window._navicareRecorder.state === 'recording') {
          window._navicareRecorder.stop();
        }
      """]);
      _isListening = false;
    }
 
    setState(() {
      _store.current.add(AIMessage(text: text, isUser: true));
      _controller.clear();
      _isTyping = true;
    });
    _scrollToBottom();
 
    try {
      final result = await AgentService.sendMessage(
        sessionId: _sessionId,
        message: text,
      );
 
      if (!mounted) return;
 
      final responseText = result['response_text'] ?? result['error'] ?? 'Something went wrong';
      final card = _detectCard(text.toLowerCase(), responseText);
 
      setState(() {
        _store.current.add(AIMessage(text: responseText, isUser: false, card: card));
        _isTyping = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _store.current.add(AIMessage(text: 'Error: ${e.toString()}', isUser: false));
        _isTyping = false;
      });
    }
    _scrollToBottom();
  }
 
  // ── Card Detection ─────────────────────────────────────────────────────────
 
  MessageCard? _detectCard(String query, String response) {
    final lower = query.toLowerCase();
    final responseLower = response.toLowerCase();
 
    if (lower.contains('caretaker') || lower.contains('nurse') ||
        responseLower.contains('caretaker') || responseLower.contains('care specialist')) {
      return MessageCard(type: CardType.caretaker, items: [
        {'name': 'Alice Johnson', 'role': 'Elderly Care Specialist', 'exp': '8 Years', 'rating': '4.8'},
        {'name': 'Priya Patel', 'role': 'Child Care', 'exp': '6 Years', 'rating': '4.6'},
        {'name': 'Rahul Sharma', 'role': 'Physical Rehabilitation', 'exp': '7 Years', 'rating': '4.9'},
      ]);
    }
 
    if (lower.contains('restaurant') || lower.contains('food') || lower.contains('eat') ||
        lower.contains('dining') || responseLower.contains('restaurant')) {
      return MessageCard(type: CardType.restaurant, items: [
        {
          'name': 'Sangeetha Restaurant',
          'cuisine': 'South Indian',
          'rating': '4.5',
          'location': 'T. Nagar, Chennai',
          'feature': 'Wheelchair Access',
          'imageUrl': 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?w=400',
        },
        {
          'name': 'Murugan Idli Shop',
          'cuisine': 'South Indian',
          'rating': '4.6',
          'location': 'Vadapalani, Chennai',
          'feature': 'Ground Floor Access',
          'imageUrl': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?w=400',
        },
      ]);
    }
 
    if (lower.contains('hotel') || lower.contains('stay') || lower.contains('accommodation') ||
        responseLower.contains('hotel')) {
      return MessageCard(type: CardType.hotel, items: [
        {
          'name': 'Taj Coromandel',
          'rating': '4.9',
          'location': 'Nungambakkam, Chennai',
          'price': '₹8,000/night',
          'feature': 'Wheelchair + Elevator',
          'imageUrl': 'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?w=400',
        },
        {
          'name': 'ITC Grand Chola',
          'rating': '4.8',
          'location': 'Guindy, Chennai',
          'price': '₹6,500/night',
          'feature': 'Accessible Rooms + Spa',
          'imageUrl': 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?w=400',
        },
      ]);
    }
 
    return null;
  }
 
  void _startNewChat() {
    setState(() => _store.newSession());
    Navigator.pop(context);
  }
 
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
 
  // ── Build ──────────────────────────────────────────────────────────────────
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NaviCare AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Travel & Accessibility Guide', style: TextStyle(fontSize: 10, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded),
            tooltip: "New Chat",
            onPressed: _startNewChat,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      // Show the live voice conversation overlay when in voice mode
      body: _isVoiceConversationMode
          ? _buildVoiceConversationOverlay()
          : _buildChatBody(),
    );
  }
 
  // ── Chat body (normal mode) ────────────────────────────────────────────────
 
  Widget _buildChatBody() {
    return SafeArea(
      child: Column(
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.primary.withOpacity(0.08),
            child: Row(
              children: [
                Icon(Icons.psychology_rounded, size: 16, color: AppTheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI Travel Assistant & Caretaker Guide Active',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
                ),
              ],
            ),
          ),
 
          // Messages
          Expanded(
            child: _currentMessages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _currentMessages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_currentMessages[index]);
                    },
                  ),
          ),
 
          if (_isTyping) _buildTypingIndicator(),
          if (_isListening) _buildListeningBanner(),
 
          _buildInputBar(),
        ],
      ),
    );
  }
 
  // ── Live Voice Conversation Overlay ───────────────────────────────────────
  // Full-screen overlay similar to ChatGPT voice mode.
  // Shows recent messages dimmed, big animated mic circle in center.
 
  Widget _buildVoiceConversationOverlay() {
    String statusText;
    if (_isTyping) {
      statusText = 'Thinking…';
    } else if (_isAgentSpeaking) {
      statusText = 'NaviCare is speaking…';
    } else if (_isListening) {
      statusText = 'Listening… tap mic to send';
    } else {
      statusText = 'Tap mic to speak';
    }
 
    return SafeArea(
      child: Stack(
        children: [
          // Solid background — clean voice UI, no chat bleed-through
          Container(color: const Color(0xFFF5F7FA)),
 
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status label
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isListening
                      ? const Color(0xFFEF4444)
                      : _isAgentSpeaking
                          ? AppTheme.primary
                          : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),
 
              // Animated mic / speaker circle
              // Tap while LISTENING → stop recording and send
              // Tap while SPEAKING  → end call
              GestureDetector(
                onTap: _isListening
                    ? _stopAndSendVoiceTurn
                    : _toggleVoiceConversationMode,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (_, child) {
                    final shouldPulse = _isListening || _isAgentSpeaking;
                    return Transform.scale(
                      scale: shouldPulse ? _pulseAnimation.value : 1.0,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? const Color(0xFFEF4444)
                          : _isAgentSpeaking
                              ? AppTheme.primary
                              : AppTheme.primary.withOpacity(0.75),
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening
                              ? const Color(0xFFEF4444)
                              : AppTheme.primary).withOpacity(0.35),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isAgentSpeaking
                          ? Icons.volume_up_rounded
                          : Icons.mic_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
 
              // Hint text
              Text(
                _isListening
                    ? 'Tap mic to stop & send'
                    : 'Tap to end conversation',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const SizedBox(height: 16),
 
              // Last agent message (small pill so user can read what was said)
              if (_currentMessages.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: () {
                    // Find last AI message
                    final lastAI = _currentMessages.lastWhere(
                      (m) => !m.isUser,
                      orElse: () => AIMessage(text: '', isUser: false),
                    );
                    if (lastAI.text.isEmpty) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
                      ),
                      child: Text(
                        lastAI.text.length > 120
                            ? '${lastAI.text.substring(0, 120)}…'
                            : lastAI.text,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
 
  // ── Drawer ─────────────────────────────────────────────────────────────────
 
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primary),
            accountName: Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text('NaviCare Accessible Travel', style: TextStyle(fontSize: 12)),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppTheme.primary, size: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Chat History", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
                TextButton.icon(
                  onPressed: _startNewChat,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("New Chat"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _store.sessions.length,
              itemBuilder: (context, index) {
                final session = _store.sessions[index];
                final sessionTitle = session.isNotEmpty ? session.first.text : "New Chat";
                return ListTile(
                  selected: _store.currentIndex == index,
                  selectedTileColor: AppTheme.primary.withOpacity(0.1),
                  leading: Icon(Icons.chat_bubble_outline_rounded, size: 18,
                    color: _store.currentIndex == index ? AppTheme.primary : Colors.grey),
                  title: Text(sessionTitle,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13)),
                  onTap: () {
                    setState(() => _store.selectSession(index));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
 
  // ── Empty State ────────────────────────────────────────────────────────────
 
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary.withOpacity(0.2), AppTheme.primary.withOpacity(0.05)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy_rounded, size: 40, color: AppTheme.primary),
            ),
            const SizedBox(height: 20),
            Text('Hi $_userName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 8),
            Text('How can I help you today?',
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 24),
            _buildSuggestionChips(),
          ],
        ),
      ),
    );
  }
 
  Widget _buildSuggestionChips() {
    final suggestions = [
      '♿ Find accessible hotels',
      '👨‍⚕️ Book a caretaker',
      '🍽 Accessible restaurants',
      '🗺 Plan accessible trip',
    ];
    return Wrap(
      spacing: 8, runSpacing: 8,
      alignment: WrapAlignment.center,
      children: suggestions.map((s) => GestureDetector(
        onTap: () => _sendMessage(s),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
          ),
          child: Text(s, style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w500)),
        ),
      )).toList(),
    );
  }
 
  // ── Message Bubble ─────────────────────────────────────────────────────────
 
  Widget _buildMessageBubble(AIMessage msg) {
    return Column(
      crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!msg.isUser) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: _MarkdownText(text: msg.text, textColor: const Color(0xFF1A1A2E)),
                ),
              ),
            ],
          ),
          if (msg.card != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: _buildRichCard(msg.card!),
            ),
          ],
          // Audio replay button if this message has TTS audio
          if (msg.audioUrl != null && msg.audioUrl!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: GestureDetector(
                onTap: () => _playAudioUrl(msg.audioUrl!),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.volume_up_rounded, size: 14, color: AppTheme.primary.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text('Play again', style: TextStyle(fontSize: 11, color: AppTheme.primary.withOpacity(0.7))),
                  ],
                ),
              ),
            ),
          ],
        ],
 
        if (msg.isUser)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.85)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
          ),
 
        const SizedBox(height: 14),
      ],
    );
  }
 
  // ── Rich Cards ─────────────────────────────────────────────────────────────
 
  Widget _buildRichCard(MessageCard card) {
    if (card.type == CardType.caretaker) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggested Caretakers', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[600])),
          const SizedBox(height: 6),
          ...card.items.map((c) => GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const FindCaretakerScreen())),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.primary.withOpacity(0.12),
                    child: Icon(Icons.person_rounded, color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c['name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        Text(c['role'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        Text(c['exp'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFA500)),
                        const SizedBox(width: 3),
                        Text(c['rating'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFFFA500))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      );
    }
 
    // Restaurant / Hotel card (horizontal scroll)
    final isHotel = card.type == CardType.hotel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isHotel ? 'Accessible Hotels' : 'Accessible Restaurants',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[600]),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: card.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final item = card.items[i];
              return Container(
                width: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: Image.network(
                        item['imageUrl'] ?? '',
                        height: 90, width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 90,
                          color: AppTheme.primary.withOpacity(0.1),
                          child: Icon(isHotel ? Icons.hotel : Icons.restaurant, color: AppTheme.primary),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(item['location'] ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFFA500)),
                              const SizedBox(width: 2),
                              Text(item['rating'] ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('♿', style: const TextStyle(fontSize: 9)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
 
  // ── Typing / Listening indicators ──────────────────────────────────────────
 
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(150),
                const SizedBox(width: 4),
                _buildDot(300),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeInOut,
      builder: (_, v, child) => Opacity(opacity: v, child: child),
      child: Container(
        width: 7, height: 7,
        decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.7), shape: BoxShape.circle),
      ),
    );
  }
 
  Widget _buildListeningBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.redAccent.withOpacity(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          const Text("Listening… Speak now",
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
 
  // ── Input Bar ──────────────────────────────────────────────────────────────
 
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          // Small mic button (one-shot STT → text field)
          GestureDetector(
            onTap: _toggleVoiceAssistant,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _isListening ? Colors.redAccent.withOpacity(0.1) : AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                color: _isListening ? Colors.redAccent : AppTheme.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
 
          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Ask me anything…",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
 
          // Send button
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 8),
 
          // ★ BIG BLUE VOICE MODE BUTTON ★
          GestureDetector(
            onTap: _toggleVoiceConversationMode,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.45),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
 
// ─── Lightweight Markdown renderer ────────────────────────────────────────────
class _MarkdownText extends StatelessWidget {
  final String text;
  final Color textColor;
 
  const _MarkdownText({required this.text, required this.textColor});
 
  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    final widgets = <Widget>[];
 
    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 4));
        continue;
      }
 
      if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(_stripInline(line.substring(4)),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
        ));
        continue;
      }
 
      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(_stripInline(line.substring(3)),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
        ));
        continue;
      }
 
      if (line.startsWith('* ') || line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(child: _buildInlineText(line.substring(2), textColor)),
            ],
          ),
        ));
        continue;
      }
 
      final numMatch = RegExp(r'^(\d+)\.\s+(.+)').firstMatch(line);
      if (numMatch != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${numMatch.group(1)}. ',
                style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(child: _buildInlineText(numMatch.group(2)!, textColor)),
            ],
          ),
        ));
        continue;
      }
 
      if (line == '---' || line == '—') {
        widgets.add(Divider(height: 12, color: Colors.grey[300]));
        continue;
      }
 
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: _buildInlineText(line, textColor),
      ));
    }
 
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }
 
  String _stripInline(String s) => s.replaceAll('**', '').replaceAll('*', '');
 
  Widget _buildInlineText(String line, Color color) {
    final spans = <TextSpan>[];
    final parts = line.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: i % 2 == 1 ? FontWeight.bold : FontWeight.normal,
          color: color,
          fontSize: 14,
          height: 1.45,
        ),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }
}