import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import './reminder_screen.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // State variable to track the current index
  int _currentIndex = 0;

  // List of widgets (pages) for each tab
  final List<Widget> _children = [
    // 0: Home Page Content
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your existing dashboard content
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFD3E0E9),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Check your dog\'s paws!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4C6A81),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4C6A81),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                          child: const Text('Join now'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Image.asset("assets/images/onboarding1.png"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Quick Logs',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E465C)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _LogButton(icon: Icons.directions_run, label: 'Walk'),
              _LogButton(icon: Icons.restaurant, label: 'Meal'),
              _LogButton(icon: Icons.delete, label: 'Poop'),
              _LogButton(icon: Icons.local_hospital, label: 'Meds'),
            ],
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Progress',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E465C)),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFD3E0E9),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Training Completed',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4C6A81))),
                        SizedBox(height: 4),
                        Text(
                          'Keep going! You\'re almost there.',
                          style: TextStyle(color: Color(0xFF889BB0)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 70,
                    height: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.7,
                          strokeWidth: 4,
                          backgroundColor: Color(0xFFADC6D8),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF4C6A81)),
                        ),
                        Text(
                          '70%',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4C6A81)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'What\'s the Dog\'s Mood?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E465C)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _MoodButton(emoji: '😊'),
              _MoodButton(emoji: '😔'),
              _MoodButton(emoji: '😠'),
              _MoodButton(emoji: '😭'),
            ],
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Reminders',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E465C)),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFD3E0E9),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Color(0xFFF99D4D), size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Uh oh you have missed Something',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4C6A81)),
                      ),
                      SizedBox(height: 4),
                      Text('Track your reminders',
                          style: TextStyle(color: Color(0xFF889BB0))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
    // 1: Reminders Page
    const RemindersScreen(),
    // 2: Center Button placeholder
    const Center(child: Text('Special Action Page Content')),
    // 3: Journal Page
    const Center(child: Text('Journal Page Content')),
    // 4: Settings Page
    const Center(child: Text('Settings Page Content')),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hi Luna',
              style: TextStyle(
                color: Color(0xFF2E465C),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Good Morning!',
              style: TextStyle(
                color: Color(0xFF889BB0),
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE9EEF4),
              child: Image.asset("assets/images/onboarding1.png"),
            ),
          ),
        ],
      ),
      body: _children[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5582AC),
        unselectedItemColor: const Color(0xFFBAC5D4),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        currentIndex: _currentIndex, // Link currentIndex to the state variable
        onTap: onTabTapped, // Handle tab taps
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFF5582AC),
              child: Icon(LucideIcons.sparkle, color: Colors.white, size: 32),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _LogButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LogButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFDDE3EB),
          radius: 30,
          child: Icon(icon, color: const Color(0xFF4C6A81)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
              color: Color(0xFF4C6A81), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;

  const _MoodButton({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFDDE3EB),
      radius: 30,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
