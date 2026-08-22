import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';
import 'find_caretaker_screen.dart';
import 'tourist_place_detail_page.dart';

class AIMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AIMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class AITravelAgentPage extends StatefulWidget {
  const AITravelAgentPage({super.key});

  @override
  State<AITravelAgentPage> createState() => _AITravelAgentPageState();
}

class _AITravelAgentPageState extends State<AITravelAgentPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechAvailable = false;

  // App & User Memory Profile
  final Map<String, dynamic> _userMemory = {
    "name": "Aarav",
    "budget": "Moderate",
    "style": "Adventure & Culture",
    "pendingPlace": null,
  };

  // Chat History Management List
  final List<List<AIMessage>> _chatHistorySessions = [
    []
  ];

  int _currentSessionIndex = 0;
  bool _isTyping = false;

  List<AIMessage> get _currentMessages =>
      _chatHistorySessions[_currentSessionIndex];

  @override
  void initState() {
    super.initState();
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          if (mounted) {
            setState(() => _isListening = false);
          }
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _isListening = false);
        }
      },
    );
    if (mounted) {
      setState(() {
        _speechAvailable = available;
      });
    }
  }

  void _toggleVoiceAssistant() async {
    if (!_speechAvailable) {
      _initSpeechRecognizer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Speech recognition is initializing or unavailable.")),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
            if (result.finalResult && _controller.text.trim().isNotEmpty) {
              _speech.stop();
              _isListening = false;
              _sendMessage();
            }
          });
        },
      );
    }
  }

  void _sendMessage([String? overrideText]) {
    final text = overrideText ?? _controller.text.trim();
    if (text.isEmpty) return;

    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }

    setState(() {
      _currentMessages.add(AIMessage(text: text, isUser: true));
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      
      final responseData = _generateAgentResponse(text);
      setState(() {
        _currentMessages.add(AIMessage(text: responseData["message"], isUser: false));
        _isTyping = false;
      });
      _scrollToBottom();

      if (responseData["navigate"] != null) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => responseData["navigate"]),
          );
        });
      }
    });
  }

  Map<String, dynamic> _generateAgentResponse(String query) {
    final lowerQuery = query.toLowerCase();

    // 1. Check if user is greeting
    if (lowerQuery.contains("hi") || lowerQuery.contains("hello") || lowerQuery.contains("hey")) {
      return {
        "message": "May I know where would you like to travel or you need a caretaker?",
        "navigate": null,
      };
    }

    // 2. Check if user explicitly asks for a caretaker
    if (lowerQuery.contains("caretaker") || lowerQuery.contains("nurse") || lowerQuery.contains("help me with caretaker")) {
      return {
        "message": "Opening the caretaker finder for you right away!",
        "navigate": const FindCaretakerScreen(),
      };
    }

    // 3. Check if we were waiting for confirmation to plan a trip to a pending place
    if (_userMemory["pendingPlace"] != null) {
      if (lowerQuery.contains("yes") || lowerQuery.contains("sure") || lowerQuery.contains("yeah") || lowerQuery.contains("ok")) {
        final placeName = _userMemory["pendingPlace"];
        _userMemory["pendingPlace"] = null;
        return {
          "message": "Awesome! Opening the trip planning details for $placeName.",
          "navigate": TouristPlaceDetailPage(placeName: placeName),
        };
      } else if (lowerQuery.contains("no") || lowerQuery.contains("nope")) {
        _userMemory["pendingPlace"] = null;
        return {
          "message": "No problem! Let me know if you need anything else.",
          "navigate": null,
        };
      }
    }

    // 4. Check for tourist destination mentions
    final List<String> availablePlaces = [
      "taj mahal", "jaipur city palace", "gateway of india", "golden temple", 
      "charminar", "mysore palace", "india gate", "meenakshi temple", 
      "hawa mahal", "qutub minar", "ajanta caves", "konark sun temple", 
      "victoria memorial", "lotus temple", "agra", "delhi", "mumbai", "jaipur"
    ];

    for (var place in availablePlaces) {
      if (lowerQuery.contains(place)) {
        final formattedPlaceName = place.split(' ').map((s) => s[0].toUpperCase() + s.substring(1)).join(' ');
        _userMemory["pendingPlace"] = formattedPlaceName;
        return {
          "message": "Do you want me to plan a trip?",
          "navigate": null,
        };
      }
    }

    // 5. Default Fallback
    return {
      "message": "May I know where would you like to travel or you need a caretaker?",
      "navigate": null,
    };
  }

  void _startNewChat() {
    setState(() {
      _chatHistorySessions.insert(0, []);
      _currentSessionIndex = 0;
      _userMemory["pendingPlace"] = null;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.white,
        title: const Text(
          "AI Travel Planner",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded),
            tooltip: "New Chat",
            onPressed: _startNewChat,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primary),
              accountName: Text(_userMemory["name"]),
              accountEmail: Text("Style: ${_userMemory["style"]}"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: AppTheme.white,
                child: Icon(Icons.person, color: AppTheme.primary, size: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Chat History",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
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
                itemCount: _chatHistorySessions.length,
                itemBuilder: (context, index) {
                  final session = _chatHistorySessions[index];
                  final sessionTitle = session.isNotEmpty
                      ? session.first.text
                      : "New Chat Session";
                  return ListTile(
                    selected: _currentSessionIndex == index,
                    selectedTileColor: AppTheme.primaryLight.withOpacity(0.2),
                    leading: const Icon(Icons.chat_bubble_outline, size: 18),
                    title: Text(
                      sessionTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      setState(() => _currentSessionIndex = index);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // User Memory Context Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.primaryLight.withOpacity(0.15),
              child: Row(
                children: [
                  const Icon(Icons.psychology,
                      size: 18, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "AI Travel Assistant & Caretaker Guide Active",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutral900),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Message Stream Area with Initial Centered Greeting if empty
            Expanded(
              child: _currentMessages.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: AppTheme.primaryLight.withOpacity(0.3),
                              child: const Icon(
                                Icons.smart_toy_rounded,
                                size: 36,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Hi Aarav, how can I help you?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.neutral900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Say 'Hi' or 'Hello' to begin, or ask about a destination or caretaker.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _currentMessages.length,
                      itemBuilder: (context, index) {
                        final msg = _currentMessages[index];
                        return Align(
                          alignment: msg.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? AppTheme.primary
                                  : AppTheme.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isUser
                                    ? AppTheme.white
                                    : AppTheme.neutral900,
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            if (_isTyping)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 8),
                    Text("AI is responding...",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),

            if (_isListening)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.redAccent.withOpacity(0.1),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text("Listening... Speak now, your text will type automatically",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            // Chat Input & Voice Toolbar
            Container(
              padding: const EdgeInsets.all(12),
              color: AppTheme.white,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic,
                        color: _isListening ? Colors.red : AppTheme.primary),
                    onPressed: _toggleVoiceAssistant,
                    tooltip: "Voice Assistant",
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: "Say 'Hi' or type a place name...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppTheme.primary),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}