import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project_task_manager/main.dart';

void main() {
  testWidgets('adds, views, completes, edits, and deletes a task', (
    tester,
  ) async {
    await tester.pumpWidget(const TaskManagerApp());

    expect(find.text('No tasks yet'), findsOneWidget);

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add task'));
    await tester.pump();
    expect(find.text('Please enter a task title'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title *'),
      'Prepare presentation',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Review final slides',
    );
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    expect(find.text('Task added'), findsOneWidget);
    expect(find.text('Prepare presentation'), findsOneWidget);

    await tester.tap(find.text('Prepare presentation'));
    await tester.pumpAndSettle();
    expect(find.text('Task details'), findsOneWidget);
    expect(find.text('Review final slides'), findsOneWidget);

    await tester.tap(find.text('Mark as completed'));
    await tester.pumpAndSettle();
    expect(find.text('Task completed'), findsOneWidget);

    await tester.tap(find.byTooltip('Task actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title *'),
      'Prepare final presentation',
    );
    await tester.tap(find.text('Update task'));
    await tester.pumpAndSettle();
    expect(find.text('Task updated'), findsOneWidget);

    await tester.tap(find.byTooltip('Task actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Task deleted'), findsOneWidget);
    expect(find.text('No tasks yet'), findsOneWidget);
  });
}
