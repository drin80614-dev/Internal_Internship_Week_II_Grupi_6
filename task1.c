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

  String? averageResult;
  String? statusMessage;

  @override
  void dispose() {
    firstGradeController.dispose();
    secondGradeController.dispose();
    thirdGradeController.dispose();
    super.dispose();
  }

  // Shows validation feedback with a SnackBar when input is missing or invalid.
  void showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Validates the three grades, calculates the average, and updates the UI.
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.35),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Enter Three Grades',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
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
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Calculate Average'),
                        ),
                        const SizedBox(height: 24),
                        if (averageResult != null && statusMessage != null)
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Average: $averageResult',
                                  style:
                                      Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  statusMessage!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
        prefixIcon: const Icon(Icons.school_outlined),
      ),
    );
  }
}
