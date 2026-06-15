import 'package:flutter/material.dart';

void main() {
  runApp(const GradeCalculatorApp());
}

class GradeCalculatorApp extends StatelessWidget {
  const GradeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Calculator UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GradeCalculatorScreen(),
    );
  }
}

class GradeCalculatorScreen extends StatefulWidget {
  const GradeCalculatorScreen({super.key});

  @override
  State<GradeCalculatorScreen> createState() => _GradeCalculatorScreenState();
}

class _GradeCalculatorScreenState extends State<GradeCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstGradeController = TextEditingController();
  final _secondGradeController = TextEditingController();
  final _thirdGradeController = TextEditingController();

  String _averageText = '0.00';
  String _statusText = 'Vendos notat';

  static const double passingAverage = 5.0;

  @override
  void dispose() {
    _firstGradeController.dispose();
    _secondGradeController.dispose();
    _thirdGradeController.dispose();
    super.dispose();
  }

  String? _validateGrade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kjo fushe nuk mund te jete bosh';
    }

    final parsedValue = double.tryParse(value.trim());
    if (parsedValue == null) {
      return 'Vendos nje numer valid';
    }

    return null;
  }

  void _calculateAverage() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final firstGrade = double.parse(_firstGradeController.text.trim());
    final secondGrade = double.parse(_secondGradeController.text.trim());
    final thirdGrade = double.parse(_thirdGradeController.text.trim());
    final average = (firstGrade + secondGrade + thirdGrade) / 3;

    // Update the result card after all fields pass validation.
    setState(() {
      _averageText = average.toStringAsFixed(2);
      _statusText = average >= passingAverage ? 'Kalon' : 'Duhet përmirësim';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Calculator UI'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 430),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.calculate,
                        color: Colors.indigo,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Llogarit mesataren',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Shkruaj tri nota ose pike numerike.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 24),
                      // Three numeric inputs used for the average calculation.
                      GradeInputField(
                        controller: _firstGradeController,
                        labelText: 'Nota 1',
                        validator: _validateGrade,
                      ),
                      const SizedBox(height: 14),
                      GradeInputField(
                        controller: _secondGradeController,
                        labelText: 'Nota 2',
                        validator: _validateGrade,
                      ),
                      const SizedBox(height: 14),
                      GradeInputField(
                        controller: _thirdGradeController,
                        labelText: 'Nota 3',
                        validator: _validateGrade,
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: _calculateAverage,
                        icon: const Icon(Icons.done),
                        label: const Text('Llogarit mesataren'),
                      ),
                      const SizedBox(height: 24),
                      // Result area displays the average and pass status.
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Mesatarja',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _averageText,
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _statusText,
                              style: TextStyle(
                                color: _statusText == 'Kalon'
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
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
    );
  }
}

class GradeInputField extends StatelessWidget {
  const GradeInputField({
    required this.controller,
    required this.labelText,
    required this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.grade),
      ),
    );
  }
}
