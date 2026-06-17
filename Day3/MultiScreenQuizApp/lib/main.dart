import 'package:flutter/material.dart';

void main() {
  runApp(const MultiScreenQuizApp());
}

class MultiScreenQuizApp extends StatelessWidget {
  const MultiScreenQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-screen Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.questionText,
    required this.answerOptions,
    required this.correctAnswerIndex,
  });

  final String questionText;
  final List<String> answerOptions;
  final int correctAnswerIndex;
}

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    questionText: 'Which widget is commonly used as the root of a Flutter app?',
    answerOptions: ['MaterialApp', 'TextField', 'Icon', 'SnackBar'],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    questionText: 'Which widget provides the basic visual page structure?',
    answerOptions: ['Column', 'Scaffold', 'Container', 'Padding'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    questionText: 'Which language is mainly used to build Flutter apps?',
    answerOptions: ['Python', 'Java', 'Dart', 'Swift'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    questionText: 'Which widget arranges children vertically?',
    answerOptions: ['Row', 'Stack', 'ListTile', 'Column'],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    questionText: 'Which tool is used to move between screens in Flutter?',
    answerOptions: ['Navigator', 'ThemeData', 'Form', 'Center'],
    correctAnswerIndex: 0,
  ),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;
  int _correctAnswers = 0;

  QuizQuestion get _currentQuestion => quizQuestions[_currentQuestionIndex];

  void _selectAnswer(int selectedIndex) {
    setState(() {
      _selectedAnswerIndex = selectedIndex;
    });

    final isCorrect = selectedIndex == _currentQuestion.correctAnswerIndex;
    if (isCorrect) {
      _score += 1;
      _correctAnswers += 1;
    }

    final isLastQuestion = _currentQuestionIndex == quizQuestions.length - 1;
    if (isLastQuestion) {
      _openResultScreen();
      return;
    }

    // Move to the next question after the user selects an option.
    setState(() {
      _currentQuestionIndex += 1;
      _selectedAnswerIndex = null;
    });
  }

  void _openResultScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          totalScore: _score,
          correctAnswers: _correctAnswers,
          totalQuestions: quizQuestions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressText =
        'Question ${_currentQuestionIndex + 1} of ${quizQuestions.length}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-screen Quiz'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          progressText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.deepPurple.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentQuestion.questionText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // The option buttons update state and advance the quiz.
                        for (var index = 0;
                            index < _currentQuestion.answerOptions.length;
                            index++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AnswerOptionButton(
                              optionText: _currentQuestion.answerOptions[index],
                              isSelected: _selectedAnswerIndex == index,
                              onPressed: () => _selectAnswer(index),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnswerOptionButton extends StatelessWidget {
  const AnswerOptionButton({
    required this.optionText,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final String optionText;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        side: BorderSide(
          color: isSelected ? Colors.deepPurple : Colors.grey.shade400,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(
        optionText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.totalScore,
    required this.correctAnswers,
    required this.totalQuestions,
    super.key,
  });

  final int totalScore;
  final int correctAnswers;
  final int totalQuestions;

  void _restartQuiz(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.deepPurple,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Quiz Completed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ResultInfoRow(
                        label: 'Total score',
                        value: '$totalScore / $totalQuestions',
                      ),
                      const SizedBox(height: 12),
                      ResultInfoRow(
                        label: 'Correct answers',
                        value: '$correctAnswers',
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: () => _restartQuiz(context),
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Restart Quiz'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultInfoRow extends StatelessWidget {
  const ResultInfoRow({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
