import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:melody/main.dart';
import 'package:melody/types.dart';

Note displayedNote() =>
    Note.values.singleWhere((n) => find.text(n.label).evaluate().isNotEmpty);

VoidCallback? revealOnPressed(WidgetTester tester) => tester
    .widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Reveal answer'))
    .onPressed;

void main() {
  group('Note.getChord', () {
    const expected = {
      Note.doNote: [Note.doNote, Note.mi, Note.sol],
      Note.re: [Note.re, Note.fa, Note.la],
      Note.mi: [Note.mi, Note.sol, Note.si],
      Note.fa: [Note.fa, Note.la, Note.doNote],
      Note.sol: [Note.sol, Note.si, Note.re],
      Note.la: [Note.la, Note.doNote, Note.mi],
      Note.si: [Note.si, Note.re, Note.fa],
    };

    for (final entry in expected.entries) {
      test('${entry.key.label} -> ${entry.value.join(' - ')}', () {
        expect(entry.key.getChord(), entry.value);
      });
    }
  });

  group('New chord flow', () {
    testWidgets('shows no note before tapping New chord', (tester) async {
      await tester.pumpWidget(const MyApp());

      for (final note in Note.values) {
        expect(find.text(note.label), findsNothing);
      }
    });

    testWidgets('New chord shows exactly one note', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('New chord'));
      await tester.pump();

      final shown = Note.values
          .where((n) => find.text(n.label).evaluate().isNotEmpty);
      expect(shown, hasLength(1));
    });

    testWidgets('Reveal answer shows the chord of the displayed note and '
        'gets disabled', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('New chord'));
      await tester.pump();
      final note = displayedNote();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);

      await tester.tap(find.text('Reveal answer'));
      await tester.pump();

      expect(find.text(note.getChord().join(' - ')), findsOneWidget);
      expect(revealOnPressed(tester), isNull);
    });

    testWidgets('New chord after a reveal hides the answer again',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('New chord'));
      await tester.pump();
      await tester.tap(find.text('Reveal answer'));
      await tester.pump();

      await tester.tap(find.text('New chord'));
      await tester.pump();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);
    });
  });
}
