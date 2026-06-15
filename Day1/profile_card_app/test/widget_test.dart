import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_card_app/main.dart';

void main() {
  testWidgets('shows profile details and thank you SnackBar', (tester) async {
    await tester.pumpWidget(const ProfileCardApp());

    expect(find.text('Drin Krasniqi'), findsOneWidget);
    expect(find.text('Flutter Student'), findsOneWidget);
    expect(
      find.text('I am learning Dart and Flutter during the Internal Internship.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.person), findsOneWidget);

    await tester.tap(find.text('View Profile'));
    await tester.pump();

    expect(
      find.text('Thank you for viewing my profile!'),
      findsOneWidget,
    );
  });
}
