import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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

  // User Memory Profiles
  final Map<String, dynamic> _userMemory = {
    "name": "Traveler",
    "budget": "Moderate",
    "style": "Adventure & Culture",
    "interests": ["Monuments", "Local Food", "Nature"],
  };

  // Chat History Management List
  final List<List<AIMessage>> _chatHistorySessions = [
    [
      AIMessage(text: "Hi! I want to plan a 3-day trip to Agra.", isUser: true),
      AIMessage(
          text:
              "Hello! I'd love to help you plan your trip to Agra. Based on your preference for Monuments and Culture, I've outlined a great itinerary including the Taj Mahal and Agra Fort. Shall we finalize hotels?",
          isUser: false),
    ]
  ];

  int _currentSessionIndex = 0;
  bool _isListening = false; // Voice assistant state
  bool _isTyping = false;

  List<AIMessage> get _currentMessages =>
      _chatHistorySessions[_currentSessionIndex];

  void _sendMessage([String? overrideText]) {
    final text = overrideText ?? _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _currentMessages.add(AIMessage(text: text, isUser: true));
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI Agent processing user preference and generating step-by-step trip flow
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      String response = _generateAgentResponse(text);
      setState(() {
        _currentMessages.add(AIMessage(text: response, isUser: false));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  String _generateAgentResponse(String query) {
    query = query.toLowerCase();
    if (query.contains("budget") ||
        query.contains("luxury") ||
        query.contains("cheap")) {
      _userMemory["budget"] =
          query.contains("luxury") ? "Luxury" : "Budget-friendly";
      return "Got it! I've updated your preference profile to '${_userMemory["budget"]}'. What dates are you planning to travel?";
    } else if (query.contains("date") ||
        query.contains("day") ||
        query.contains("next week")) {
      return "Awesome. Dates recorded! Would you prefer a guided tour package or a self-explored itinerary with hotel recommendations?";
    } else {
      return "I've noted that down into your travel preference memory. To complete your full trip plan, would you like me to book accommodations or recommend nearby cafes?";
    }
  }

  void _startNewChat() {
    setState(() {
      _chatHistorySessions.insert(0, [
        AIMessage(
          text:
              "Hello ${_userMemory["name"]}! I am your AI Travel Agent. I remember your preference for ${_userMemory["style"]}. Where would you like to plan your next trip?",
          isUser: false,
        )
      ]);
      _currentSessionIndex = 0;
    });
    Navigator.pop(context); // Close drawer
  }

  void _toggleVoiceAssistant() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Simulate voice input collection
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isListening = false);
        _controller.text = "Plan a budget trip for next weekend";
        _sendMessage();
      });
    }
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
      // History Management Drawer Sidebar
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
                  final sessionTitle = _chatHistorySessions[index].first.text;
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
            // User Context Memory Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.primaryLight.withOpacity(0.15),
              child: Row(
                children: [
                  const Icon(Icons.psychology,
                      size: 18, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Memory Active: ${_userMemory["style"]} • Budget: ${_userMemory["budget"]}",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutral900),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Message Stream Area
            Expanded(
              child: ListView.builder(
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
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: msg.isUser ? AppTheme.primary : AppTheme.white,
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
                          color:
                              msg.isUser ? AppTheme.white : AppTheme.neutral900,
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
                    Text("AI is crafting your travel plan...",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),

            // Voice Assistant Listening State Banner
            if (_isListening)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.redAccent.withOpacity(0.1),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text("Listening to your voice command...",
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
                        hintText:
                            "Ask AI to plan a trip, pick hotels, or check spots...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.send_rounded, color: AppTheme.primary),
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
