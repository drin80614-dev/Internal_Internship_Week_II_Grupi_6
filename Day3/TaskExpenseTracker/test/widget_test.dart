import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_expense_tracker/main.dart';

void main() {
  testWidgets('adds, toggles, and deletes a tracker item', (tester) async {
    await tester.pumpWidget(const TaskExpenseTrackerApp());

    expect(find.text('Tracker overview'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Create new task'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Finish homework');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Complete the state management task.',
    );
    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();

    expect(find.text('Finish homework'), findsOneWidget);
    expect(find.text('Item added'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();

    expect(find.text('Done'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.delete_outline).last);
    await tester.pump();

    expect(find.text('Finish homework'), findsNothing);
  });
}
