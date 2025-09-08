import 'package:flutter/material.dart';

// Reminder data class to hold the reminder details.
class Reminder {
  final IconData icon;
  final String title;
  final DateTime dateTime;
  bool isActive;
  final List<bool> selectedDays;

  Reminder({
    required this.icon,
    required this.title,
    required this.dateTime,
    this.isActive = true,
    required this.selectedDays,
  });
}

class AppColors {
  static const Color primary = Color(0xFF5582AC);
  static const Color accent = Color(0xFFC0D2E1);
  static const Color background = Color.fromARGB(255, 255, 255, 255);
  static const Color card = Color.fromARGB(255, 251, 251, 251);
  static const Color text = Color(0xFF2E465C);
  static const Color subtext = Color(0xFF889BB0);
}

// RemindersScreen is now a StatefulWidget to manage a dynamic list of reminders.
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  // A dynamic list to store the reminders.
  final List<Reminder> _reminders = [
    Reminder(
      icon: Icons.access_alarm,
      title: 'Meal',
      dateTime: DateTime(2023, 10, 27, 9, 0),
      isActive: false,
      selectedDays: [
        false,
        true,
        true,
        false,
        true,
        false,
        false
      ], // Example for a reminder on T, W, F
    ),
    Reminder(
      icon: Icons.self_improvement,
      title: 'Poop',
      dateTime: DateTime(2023, 10, 27, 10, 0),
      isActive: true,
      selectedDays: [
        true,
        false,
        false,
        false,
        false,
        true,
        false
      ], // Example for a reminder on M, S
    ),
    Reminder(
      icon: Icons.medication,
      title: 'Meds',
      dateTime: DateTime(2023, 10, 27, 18, 0),
      isActive: false,
      selectedDays:
          List.generate(7, (index) => true), // Example for a daily reminder
    ),
    Reminder(
      icon: Icons.run_circle_outlined,
      title: 'Walk',
      dateTime: DateTime(2023, 10, 27, 19, 0),
      isActive: true,
      selectedDays:
          List.generate(7, (index) => false), // Example for a one-time reminder
    ),
  ];

  // Method to show the pop-up dialog for adding a new reminder.
  Future<void> _showAddReminderDialog() async {
    final newReminder = await showModalBottomSheet<Reminder>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddReminderSheet(),
    );

    if (newReminder != null) {
      setState(() {
        _reminders.add(newReminder);
      });
    }
  }

  // Method to handle reminder deletion.
  void _deleteReminder(Reminder reminderToDelete) {
    setState(() {
      _reminders.remove(reminderToDelete);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.history, color: AppColors.primary),
          onPressed: () {},
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: _reminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.subtext,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return _ReminderItem(
                  reminder: reminder,
                  onDelete: () => _deleteReminder(reminder),
                );
              },
            ),
    );
  }
}

// A new StatefulWidget to manage the dialog's state cleanly.
class _AddReminderSheet extends StatefulWidget {
  const _AddReminderSheet({Key? key}) : super(key: key);

  @override
  _AddReminderSheetState createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<bool> _selectedDays = List.generate(7, (index) => false);
  static const List<String> _dayNames = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Helper method to build a single day button.
  Widget _buildDayButton(String day, int index) {
    final bool isSelected = _selectedDays[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDays[index] = !isSelected;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.accent,
          shape: BoxShape.circle,
        ),
        child: Text(
          day,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Reminder',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: AppColors.subtext),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                ),
                TextButton(
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Repeat on:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _dayNames.asMap().entries.map((entry) {
                int index = entry.key;
                String day = entry.value;
                return _buildDayButton(day, index);
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final now = DateTime.now();
                  final newReminder = Reminder(
                    icon: Icons.check_circle_outline, // Changed default icon
                    title: _titleController.text,
                    dateTime: DateTime(
                      now.year,
                      now.month,
                      now.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    ),
                    selectedDays: _selectedDays,
                  );
                  Navigator.pop(context, newReminder);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Reminder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The new, improved _ReminderItem widget with a modern card design.
class _ReminderItem extends StatefulWidget {
  final Reminder reminder;
  final VoidCallback onDelete;

  const _ReminderItem({
    Key? key,
    required this.reminder,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ReminderItemState createState() => _ReminderItemState();
}

class _ReminderItemState extends State<_ReminderItem> {
  // Helper method to get the short day name for display.
  String _getShortDayName(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return 'M';
      case 1:
        return 'T';
      case 2:
        return 'W';
      case 3:
        return 'Th';
      case 4:
        return 'F';
      case 5:
        return 'S';
      case 6:
        return 'Su';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which days are active to display them.
    final List<Widget> dayWidgets = [];
    for (int i = 0; i < widget.reminder.selectedDays.length; i++) {
      if (widget.reminder.selectedDays[i]) {
        dayWidgets.add(
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 6),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: Text(
              _getShortDayName(i),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      }
    }

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.accent,
              radius: 24,
              child: Icon(widget.reminder.icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.reminder.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.reminder.dateTime.hour}:${widget.reminder.dateTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.subtext,
                    ),
                  ),
                  if (dayWidgets.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: dayWidgets,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: widget.reminder.isActive,
                  onChanged: (bool newValue) {
                    setState(() {
                      widget.reminder.isActive = newValue;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: AppColors.subtext),
                  onSelected: (value) {
                    if (value == 'edit') {
                      print('Edit tapped for ${widget.reminder.title}');
                      // The 'Edit' functionality would be implemented here.
                    } else if (value == 'delete') {
                      widget.onDelete();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
