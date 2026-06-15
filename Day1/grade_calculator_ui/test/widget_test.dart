import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grade_calculator_ui/main.dart';

void main() {
  testWidgets('calculates average and passing status', (tester) async {
    await tester.pumpWidget(const GradeCalculatorApp());

    await tester.enterText(find.byType(TextFormField).at(0), '8');
    await tester.enterText(find.byType(TextFormField).at(1), '9');
    await tester.enterText(find.byType(TextFormField).at(2), '9');
    await tester.tap(find.text('Llogarit mesataren'));
    await tester.pump();

    expect(find.text('8.67'), findsOneWidget);
    expect(find.text('Kalon'), findsOneWidget);
  });

  testWidgets('validates empty and invalid values', (tester) async {
    await tester.pumpWidget(const GradeCalculatorApp());

    await tester.enterText(find.byType(TextFormField).at(1), 'abc');
    await tester.tap(find.text('Llogarit mesataren'));
    await tester.pump();

    expect(find.text('Kjo fushe nuk mund te jete bosh'), findsNWidgets(2));
    expect(find.text('Vendos nje numer valid'), findsOneWidget);
  });
}
