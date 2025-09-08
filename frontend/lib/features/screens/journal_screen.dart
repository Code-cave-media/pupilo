import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A simple data model for a journal entry.
class JournalEntry {
  final DateTime date;
  final String type;
  final String title;
  final String content;

  JournalEntry({
    required this.date,
    required this.type,
    required this.title,
    required this.content,
  });
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // Mock data for the journal entries.
  final List<JournalEntry> _allEntries = [
    JournalEntry(
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'Vet Appointment',
      title: 'Annual Check-up',
      content:
          'Visited the vet for the annual check-up. Luna is in perfect health! We discussed her diet and exercise routine. The vet recommended adding more protein.',
    ),
    JournalEntry(
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: 'Medication',
      title: 'Flea & Tick Prevention',
      content:
          'Gave Luna her monthly flea and tick medication. No issues getting her to take it. She was a very good girl and got extra treats.',
    ),
    JournalEntry(
      date: DateTime.now().subtract(const Duration(days: 10)),
      type: 'Health',
      title: 'Tummy Troubles',
      content:
          'Luna had a mild stomach upset today. We switched her food back to the previous brand. She seems to be doing better now, and her appetite is back to normal.',
    ),
    JournalEntry(
      date: DateTime.now().subtract(const Duration(days: 15)),
      type: 'Vet Appointment',
      title: 'Vaccination',
      content:
          'Took Luna for her routine vaccinations. The vet said she handled it very well and was a very brave dog.',
    ),
    JournalEntry(
      date: DateTime.now().subtract(const Duration(days: 20)),
      type: 'Behavior',
      title: 'Separation Anxiety',
      content:
          'Noticed some signs of separation anxiety when I left her alone for a few hours. Barking and chewing on a shoe. Will try to train her with short intervals.',
    ),
  ];

  String _selectedFilter = 'All';

  List<String> get _filters {
    final types = _allEntries.map((e) => e.type).toSet().toList();
    types.insert(0, 'All');
    return types;
  }

  List<JournalEntry> get _filteredEntries {
    if (_selectedFilter == 'All') {
      return _allEntries;
    }
    return _allEntries.where((entry) => entry.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterChips(),
          Expanded(
            child: _filteredEntries.isEmpty
                ? const Center(
                    child: Text(
                      'No journal entries found.\nTry selecting a different filter.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF889BB0),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _filteredEntries[index];
                      return _JournalCard(entry: entry);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(filter),
                selected: isSelected,
                selectedColor: const Color(0xFFBAC5D4),
                backgroundColor: const Color(0xFFE9EEF4),
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xFF4C6A81)
                      : const Color(0xFF889BB0),
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF5582AC)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                onSelected: (bool selected) {
                  setState(() {
                    _selectedFilter = selected ? filter : 'All';
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final JournalEntry entry;

  const _JournalCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD3E0E9),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(entry.date),
                style: const TextStyle(
                  color: Color(0xFF4C6A81),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFBAC5D4),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  entry.type,
                  style: const TextStyle(
                    color: Color(0xFF2E465C),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E465C),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            entry.content,
            style: const TextStyle(
              color: Color(0xFF4C6A81),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
