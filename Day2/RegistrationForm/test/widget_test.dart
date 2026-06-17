import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_form/main.dart';

void main() {
  testWidgets('validates registration form and shows summary dialog',
      (tester) async {
    await tester.pumpWidget(const RegistrationFormApp());

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Role or Status is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Drin Krasniqi');
    await tester.enterText(find.byType(TextFormField).at(1), 'drin@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret1');
    await tester.enterText(find.byType(TextFormField).at(3), 'Flutter Student');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Registration Summary'), findsOneWidget);
    expect(find.text('Name: Drin Krasniqi'), findsOneWidget);
    expect(find.text('Email: drin@example.com'), findsOneWidget);
    expect(find.text('Role or Status: Flutter Student'), findsOneWidget);
  });

  testWidgets('shows email and password validation errors', (tester) async {
    await tester.pumpWidget(const RegistrationFormApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Drin Krasniqi');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong-email');
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.enterText(find.byType(TextFormField).at(3), 'Student');
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(
      find.text('Password must be at least 6 characters'),
      findsOneWidget,
    );
  });
}
