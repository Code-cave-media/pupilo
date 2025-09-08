import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:speech_to_text/speech_to_text.dart';
import './reminder_screen.dart';
import './journal_screen.dart';
import './chat_screen.dart';
import './settings_screen.dart';
import '../widgets/header_section.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/quick_logs_section.dart';
import '../widgets/progress_section.dart';
import '../widgets/dog_mood_section.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // Speech-to-text instance
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';

  late AnimationController _animationController;
  late Animation<double> _animation;

  // List of widgets (pages) for each tab
  final List<Widget> _children = [
    // 0: Home Page Content
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const HeaderSection(),
          const SizedBox(height: 20),

          // Main Promotional Banner
          const PromotionalBanner(),
          const SizedBox(height: 24),

          // Quick Logs Section
          const QuickLogsSection(),
          const SizedBox(height: 24),

          // Progress Section
          const ProgressSection(),
          const SizedBox(height: 24),

          // Dog's Mood Section
          const DogMoodSection(),
          const SizedBox(height: 20),
        ],
      ),
    ),
    // 1: Reminders Page
    const RemindersScreen(),
    // 2: Placeholder
    const SizedBox.shrink(),
    // 3: Journal Page
    const JournalScreen(),
    // 4: Settings Page
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening(StateSetter setModalState) async {
    _recognizedText = '';
    await _speechToText.listen(
      onResult: (result) {
        setModalState(() {
          _recognizedText = result.recognizedWords;
        });
      },
      onSoundLevelChange: (level) {
        // You can use sound level to control animation or UI.
      },
    );
    setModalState(() {
      _isListening = true;
    });
  }

  void _stopListening(StateSetter setModalState) async {
    await _speechToText.stop();
    setModalState(() {
      _isListening = false;
    });
  }

  void onTabTapped(int index) {
    if (index == 2) {
      // The sparkle button's index is 2, but we will handle its tap and long press
      // separately. The onTabTapped will no longer be used for the sparkle button.
      return;
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _showVoiceRecognitionModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            if (!_isListening) {
              _startListening(setModalState);
            }

            return AlertDialog(
              backgroundColor: const Color(0xFFFDF6F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isListening ? 'Listening...' : 'Ready to record',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _recognizedText.isNotEmpty
                          ? _recognizedText
                          : 'Tap the microphone to start recording...',
                      key: ValueKey<String>(_recognizedText),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: _recognizedText.isNotEmpty
                            ? const Color(0xFF2D2D2D)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_isListening) {
                        _stopListening(setModalState);
                      } else {
                        _startListening(setModalState);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening
                          ? const Color(0xFFFF6B6B)
                          : const Color(0xFFFF6B35),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_recognizedText.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        _stopListening(setModalState);
                        Navigator.of(context).pop();
                        // TODO: Save the recorded text
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Voice log saved!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Save Voice Log'),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showManualLogModal(BuildContext context) {
    final TextEditingController _textEditingController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFDF6F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            'New Manual Log',
            style: TextStyle(
              color: Color(0xFF2D2D2D),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: _textEditingController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your log details here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFFF6B35)),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final logText = _textEditingController.text;
                Navigator.of(context).pop();
                // TODO: Save the manual log
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Manual log saved: $logText')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save Log'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFFFF6B35),
            unselectedItemColor: const Color(0xFFBAC5D4),
            selectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            showUnselectedLabels: true,
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 24),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, size: 24),
                label: 'Chat',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border, size: 24),
                label: 'Favorites',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt, size: 24),
                label: 'Camera',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.pets, size: 24),
                label: 'Pets',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
