import 'package:flutter/material.dart';

void main() {
  runApp(const GradeAverageCalculatorApp());
}

class GradeAverageCalculatorApp extends StatelessWidget {
  const GradeAverageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Average Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
      ),
      home: const GradeAverageCalculatorPage(),
    );
  }
}

class GradeAverageCalculatorPage extends StatefulWidget {
  const GradeAverageCalculatorPage({super.key});

  @override
  State<GradeAverageCalculatorPage> createState() =>
      _GradeAverageCalculatorPageState();
}

class _GradeAverageCalculatorPageState
    extends State<GradeAverageCalculatorPage> {
  final TextEditingController firstGradeController = TextEditingController();
  final TextEditingController secondGradeController = TextEditingController();
  final TextEditingController thirdGradeController = TextEditingController();

  String averageResult = '';
  String statusMessage = '';

  @override
  void dispose() {
    firstGradeController.dispose();
    secondGradeController.dispose();
    thirdGradeController.dispose();
    super.dispose();
  }

  // Shows validation errors with a SnackBar.
  void showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Validates input and calculates the average grade.
  void calculateAverage() {
    final String firstGradeText = firstGradeController.text.trim();
    final String secondGradeText = secondGradeController.text.trim();
    final String thirdGradeText = thirdGradeController.text.trim();

    if (firstGradeText.isEmpty ||
        secondGradeText.isEmpty ||
        thirdGradeText.isEmpty) {
      showValidationError('Please fill in all grade fields.');
      return;
    }

    final double? firstGrade = double.tryParse(firstGradeText);
    final double? secondGrade = double.tryParse(secondGradeText);
    final double? thirdGrade = double.tryParse(thirdGradeText);

    if (firstGrade == null || secondGrade == null || thirdGrade == null) {
      showValidationError('Please enter valid numbers only.');
      return;
    }

    final double average = (firstGrade + secondGrade + thirdGrade) / 3;

    setState(() {
      averageResult = average.toStringAsFixed(2);
      statusMessage = average >= 3.0 ? 'Kalon' : 'Duhet përmirësim';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Average Calculator'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter three grades',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GradeInputField(
                      controller: firstGradeController,
                      labelText: 'First grade',
                    ),
                    const SizedBox(height: 16),
                    GradeInputField(
                      controller: secondGradeController,
                      labelText: 'Second grade',
                    ),
                    const SizedBox(height: 16),
                    GradeInputField(
                      controller: thirdGradeController,
                      labelText: 'Third grade',
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: calculateAverage,
                      child: const Text('Calculate Average'),
                    ),
                    const SizedBox(height: 24),
                    if (averageResult.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Average: $averageResult',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              statusMessage,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradeInputField extends StatelessWidget {
  const GradeInputField({
    required this.controller,
    required this.labelText,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.grade_outlined),
      ),
    );
  }
}
