import 'package:flutter/material.dart';

// Reminder data class to hold the reminder details.
class Reminder {
  final IconData icon;
  final String title;
  final DateTime dateTime;
  bool isActive;

  Reminder({
    required this.icon,
    required this.title,
    required this.dateTime,
    this.isActive = true,
  });
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
    ),
    Reminder(
      icon: Icons.access_alarm,
      title: 'Poop',
      dateTime: DateTime(2023, 10, 27, 10, 0),
      isActive: true,
    ),
    Reminder(
      icon: Icons.access_alarm,
      title: 'Meds',
      dateTime: DateTime(2023, 10, 27, 18, 0),
      isActive: false,
    ),
    Reminder(
      icon: Icons.access_alarm,
      title: 'Walk',
      dateTime: DateTime(2023, 10, 27, 19, 0),
      isActive: true,
    ),
  ];

  // Method to show the pop-up dialog for adding a new reminder.
  Future<void> _showAddReminderDialog() async {
    final TextEditingController titleController = TextEditingController();
    DateTime? selectedDate = DateTime.now();
    TimeOfDay? selectedTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text(selectedDate != null
                        ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                        : 'Select Date'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Text(selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Select Time'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    selectedDate != null &&
                    selectedTime != null) {
                  final newReminder = Reminder(
                    icon: Icons.access_alarm, // Default icon
                    title: titleController.text,
                    dateTime: DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    ),
                  );
                  setState(() {
                    _reminders.add(newReminder);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.filter_list, color: Color(0xFF5582AC)),
          onPressed: () {},
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add_circle_outline, color: Color(0xFF5582AC)),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: _reminders
              .map(
                (reminder) => _ReminderItem(
                  reminder: reminder,
                  onDelete: () => _deleteReminder(reminder),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// _ReminderItem is a StatefulWidget to manage its own internal state,
// like the toggle switch and a potential future dropdown menu.
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F9),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFDDE3EB),
            radius: 20,
            child: Icon(widget.reminder.icon, color: const Color(0xFF5582AC)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reminder.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2E465C),
                  ),
                ),
                Text(
                  // Format the DateTime object into a readable time string.
                  '${widget.reminder.dateTime.hour}:${widget.reminder.dateTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF889BB0),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.reminder.isActive,
            onChanged: (bool newValue) {
              setState(() {
                widget.reminder.isActive = newValue;
              });
            },
            activeColor: const Color(0xFF5582AC),
          ),
          const SizedBox(width: 8),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF889BB0)),
            onSelected: (value) {
              if (value == 'edit') {
                print('Edit tapped for ${widget.reminder.title}');
                // The 'Edit' functionality would be implemented here.
              } else if (value == 'delete') {
                // Call the onDelete callback passed from the parent widget.
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
    );
  }
}
