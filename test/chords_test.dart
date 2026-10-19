import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:melody/main.dart';
import 'package:melody/types.dart';

Note displayedNote() =>
    Note.values.singleWhere((n) => find.text(n.label).evaluate().isNotEmpty);

VoidCallback? revealOnPressed(WidgetTester tester) => tester
    .widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Reveal chord'))
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
        expect(entry.key.getChord(ChordDir.asc), entry.value);
      });
    }
  });

  group('Note.getChord descendant', () {
    const expected = {
      Note.doNote: [Note.doNote, Note.la, Note.fa],
      Note.re: [Note.re, Note.si, Note.sol],
      Note.mi: [Note.mi, Note.doNote, Note.la],
      Note.fa: [Note.fa, Note.re, Note.si],
      Note.sol: [Note.sol, Note.mi, Note.doNote],
      Note.la: [Note.la, Note.fa, Note.re],
      Note.si: [Note.si, Note.sol, Note.mi],
    };

    for (final entry in expected.entries) {
      test('${entry.key.label} -> ${entry.value.join(' - ')}', () {
        expect(entry.key.getChord(ChordDir.desc), entry.value);
      });
    }
  });

  group('New note flow', () {
    testWidgets('shows no note before tapping New note', (tester) async {
      await tester.pumpWidget(const MyApp());

      for (final note in Note.values) {
        expect(find.text(note.label), findsNothing);
      }
    });

    testWidgets('New note shows exactly one note', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('New note'));
      await tester.pump();

      final shown = Note.values
          .where((n) => find.text(n.label).evaluate().isNotEmpty);
      expect(shown, hasLength(1));
    });

    testWidgets('Reveal chord shows the chord of the displayed note and '
        'gets disabled', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('New note'));
      await tester.pump();
      final note = displayedNote();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);

      await tester.tap(find.text('Reveal chord'));
      await tester.pump();

      expect(find.text(note.getChord(ChordDir.asc).join(' - ')), findsOneWidget);
      expect(revealOnPressed(tester), isNull);
    });

    testWidgets('New note after a reveal hides the answer again',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('New note'));
      await tester.pump();
      await tester.tap(find.text('Reveal chord'));
      await tester.pump();

      await tester.tap(find.text('New note'));
      await tester.pump();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);
    });
  });

  group('Direction switch', () {
    testWidgets('shows both direction labels and starts on ascendant',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Ascendant'), findsOneWidget);
      expect(find.text('Descendant'), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    });

    testWidgets('descendant reveals the descending chord', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      await tester.tap(find.text('New note'));
      await tester.pump();
      final note = displayedNote();
      await tester.tap(find.text('Reveal chord'));
      await tester.pump();

      expect(
        find.text(note.getChord(ChordDir.desc).join(' - ')),
        findsOneWidget,
      );
    });

    testWidgets('switching back to ascendant reveals the ascending chord',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();

      await tester.tap(find.text('New note'));
      await tester.pump();
      final note = displayedNote();
      await tester.tap(find.text('Reveal chord'));
      await tester.pump();

      expect(
        find.text(note.getChord(ChordDir.asc).join(' - ')),
        findsOneWidget,
      );
    });

    testWidgets('toggling after a reveal hides the answer and keeps the note',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('New note'));
      await tester.pump();
      final note = displayedNote();
      await tester.tap(find.text('Reveal chord'));
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);
      expect(displayedNote(), note);

      await tester.tap(find.text('Reveal chord'));
      await tester.pump();

      expect(
        find.text(note.getChord(ChordDir.desc).join(' - ')),
        findsOneWidget,
      );
    });
  });
}
