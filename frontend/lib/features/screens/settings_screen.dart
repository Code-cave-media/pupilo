import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FurMindApp());
}

class FurMindApp extends StatelessWidget {
  const FurMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF5582AC),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5582AC),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
        cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          color: Colors.white,
          margin: EdgeInsets.zero,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF5582AC),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
       elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5582AC),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
        cardTheme: CardTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          color: Colors.grey[900],
          margin: EdgeInsets.zero,
        ),
      ),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  String _selectedTimezone = 'EST';
  String _selectedVoice = 'friendly';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey[900],
          title: Text(
            'Confirm Deletion',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Text(
            'Are you sure you want to delete all of your data? This action cannot be undone.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF5582AC),
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Delete',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              onPressed: () {
                print("Data deletion confirmed.");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingRow(String label, Widget child, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5582AC), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRowWithButton(
      String label, String buttonText, VoidCallback onPressed, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5582AC), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black87
                          : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRowWithButton(
                    'Edit Dog Profile',
                    'Edit',
                    () {},
                    Icons.pets,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'App Preferences',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black87
                          : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    'Timezone',
                    DropdownButton<String>(
                      value: _selectedTimezone,
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.grey[900],
                      items: <String>['EST', 'PST', 'CST', 'MST', 'GMT']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTimezone = newValue!;
                        });
                      },
                    ),
                    Icons.access_time,
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRow(
                    'Assistant Voice',
                    DropdownButton<String>(
                      value: _selectedVoice,
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.grey[900],
                      items: <String>['friendly', 'calm', 'playful']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedVoice = newValue!;
                        });
                      },
                    ),
                    Icons.mic,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Account',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black87
                          : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRowWithButton(
                    'Manage Subscription',
                    'View Plan',
                    () {},
                    Icons.subscriptions,
                  ),
                  const SizedBox(height: 12),
                  _buildSettingRowWithButton(
                    'Privacy & Terms',
                    'View',
                    () {},
                    Icons.privacy_tip,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showDeleteConfirmationModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                      ),
                      child: Text(
                        'Delete My Data',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
