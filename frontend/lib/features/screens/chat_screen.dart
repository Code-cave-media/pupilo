import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// The main chat screen widget.
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text':
          'Hello there! I\'m FurMind AI. I\'m here to help you understand your dog, Luna, a bit better.'
    },
  ];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  final Map<String, dynamic> _dogProfile = {
    'name': 'Luna',
    'breed': 'Golden Retriever',
    'age': '2 years',
    'healthTags': ['sleeping more than usual'],
  };

  String _createAIPrompt(String userMessage) {
    final String healthTagsString = _dogProfile['healthTags'].join(', ');
    const String safetyDisclaimer =
        'You are not a veterinarian. Never diagnose. Always encourage the user to consult a licensed vet for health concerns. Your purpose is to provide informational and emotional support.';

    return '''
      $safetyDisclaimer
      
      You are an AI assistant for the FurMind app. Your persona is friendly and knowledgeable about dogs, and you reply as if you know the user's dog personally. Your name is FurMind.

      The user's dog is named ${_dogProfile['name']}, is a ${_dogProfile['breed']}, and is ${_dogProfile['age']} old. The user has noted the dog's health tags include: $healthTagsString.

      The user's question is: "$userMessage"
      
      Please respond in a friendly and supportive tone. If the user asks about health issues, gently remind them to consult a vet.
    ''';
  }

  Future<void> _handleSendMessage() async {
    if (_inputController.text.trim().isEmpty) return;

    final userMessage = _inputController.text;
    setState(() {
      _messages.add({'sender': 'user', 'text': userMessage});
      _inputController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final prompt = _createAIPrompt(userMessage);
      final chatHistory = [
        {
          'role': 'user',
          'parts': [
            {'text': prompt}
          ]
        }
      ];

      const apiKey = '';
      const apiUrl =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$apiKey';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contents': chatHistory}),
      );

      final result = jsonDecode(response.body);
      final aiResponse =
          result['candidates']?[0]?['content']?['parts']?[0]?['text'];

      if (aiResponse != null) {
        setState(() {
          _messages.add({'sender': 'ai', 'text': aiResponse});
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'ai',
            'text':
                'I apologize, I was unable to generate a response at this time. Please try again.'
          });
        });
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      setState(() {
        _messages.add({
          'sender': 'ai',
          'text':
              'Oops! Something went wrong. Please check your network connection and try again.'
        });
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
      _scrollToBottom();
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Chat History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Conversation with Luna (Today)'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Check-up with Dr. Smith'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Morning Walk Reminders'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FurMind AI',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          // Main chat area for displaying messages.
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  // Display typing indicator.
                  return const TypingIndicator();
                }
                final message = _messages[index];
                return _buildMessageBubble(
                  message['text']!,
                  message['sender'] == 'user',
                );
              },
            ),
          ),
          // Input area for sending messages.
          _buildInputArea(),
        ],
      ),
    );
  }

  // Builds a single chat message bubble.
  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24.0),
            topRight: const Radius.circular(24.0),
            bottomLeft: isUser
                ? const Radius.circular(24.0)
                : const Radius.circular(0.0),
            bottomRight: isUser
                ? const Radius.circular(0.0)
                : const Radius.circular(24.0),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
          minWidth: 50,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87, 
            fontSize: 16.0,
          ),
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  // Builds the input field and send button.
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                ),
                child: TextField(
                  controller: _inputController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Message FurMind AI...',
                    hintStyle: const TextStyle(fontSize: 16.0),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                  ),
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _isTyping ? null : _handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
        ),
        child: const Text('FurMind is typing...',
            style: TextStyle(color: Colors.black54, fontSize: 16.0)),
      ),
    );
  }
}
