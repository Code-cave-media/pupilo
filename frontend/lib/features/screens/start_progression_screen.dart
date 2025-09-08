import 'package:flutter/material.dart';
// Import the DashboardScreen from the separate file.
// This assumes you have a file named 'dashboard_screen.dart' in the same directory.
import './dashboard_screen.dart';

void main() {
  runApp(const ProgressiveScreen());
}

class ProgressiveScreen extends StatelessWidget {
  const ProgressiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duolingo-style Progression Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // A list of questions to display.
  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'input',
      'question': 'What is your favorite color?',
      'correctAnswer': 'Blue',
    },
    {
      'type': 'multiple_choice',
      'question': 'Which of these is a fruit?',
      'options': ['Potato', 'Carrot', 'Apple', 'Broccoli'],
      'correctAnswer': 'Apple',
    },
    {
      'type': 'multiple_choice',
      'question': 'Which country is known for the Eiffel Tower?',
      'options': ['Italy', 'Germany', 'Spain', 'France'],
      'correctAnswer': 'France',
    },
  ];

  int _currentQuestionIndex = 0;
  bool _showCorrectIndicator = false;
  bool _isAnswerSubmitted = false;
  final TextEditingController _inputController = TextEditingController();

  // Function to check the answer for multiple-choice questions.
  void _checkMultipleChoiceAnswer(String selectedAnswer) {
    setState(() {
      _isAnswerSubmitted = true;
      _showCorrectIndicator =
          selectedAnswer == _questions[_currentQuestionIndex]['correctAnswer'];
    });
  }

  // Function to check the answer for input questions.
  void _checkInputAnswer() {
    setState(() {
      _isAnswerSubmitted = true;
      _showCorrectIndicator = _inputController.text.trim().toLowerCase() ==
          _questions[_currentQuestionIndex]['correctAnswer'].toLowerCase();
    });
  }

  // Function to move to the next question or the dashboard.
  void _nextScreen() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _inputController.clear();
        _isAnswerSubmitted = false;
        _showCorrectIndicator = false;
      });
    } else {
      // Navigate to the dashboard screen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 15,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                currentQuestion['question'],
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              if (currentQuestion['type'] == 'input')
                TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    hintText: 'Type your answer here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              if (currentQuestion['type'] == 'multiple_choice')
                ...List.generate(
                  currentQuestion['options'].length,
                  (index) {
                    final option = currentQuestion['options'][index];
                    final isCorrect =
                        option == currentQuestion['correctAnswer'];
                    final isSubmitted = _isAnswerSubmitted;
                    Color color = Colors.grey[200]!;

                    if (isSubmitted) {
                      if (isCorrect) {
                        color = Colors.green[100]!;
                      } else {
                        color = Colors.red[100]!;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: _isAnswerSubmitted
                            ? null
                            : () => _checkMultipleChoiceAnswer(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: isSubmitted
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : Colors.grey[400]!,
                                width: 2),
                          ),
                          elevation: 0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            option,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const Spacer(),
              if (_isAnswerSubmitted)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _showCorrectIndicator
                        ? Colors.green[600]
                        : Colors.red[600],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _showCorrectIndicator ? 'Great job!' : 'Incorrect.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextScreen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _showCorrectIndicator
                                ? Colors.green[600]
                                : Colors.red[600],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isLastQuestion ? 'Continue' : 'Next',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
