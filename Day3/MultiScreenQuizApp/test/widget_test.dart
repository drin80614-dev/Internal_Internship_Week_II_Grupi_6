import 'package:flutter_test/flutter_test.dart';
import 'package:multi_screen_quiz_app/main.dart';

void main() {
  testWidgets('answers quiz, shows result, and restarts', (tester) async {
    await tester.pumpWidget(const MultiScreenQuizApp());

    expect(find.text('Question 1 of 5'), findsOneWidget);

    await tester.tap(find.text('MaterialApp'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scaffold'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Column'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Navigator'));
    await tester.pumpAndSettle();

    expect(find.text('Quiz Completed'), findsOneWidget);
    expect(find.text('5 / 5'), findsOneWidget);
    expect(find.text('Correct answers'), findsOneWidget);

    await tester.tap(find.text('Restart Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 5'), findsOneWidget);
  });
}
