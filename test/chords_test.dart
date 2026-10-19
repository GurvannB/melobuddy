import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:melody/main.dart';
import 'package:melody/types.dart';

Note displayedNote() =>
    Note.values.singleWhere((n) => find.text(n.label).evaluate().isNotEmpty);

VoidCallback? revealOnPressed(WidgetTester tester) => tester
    .widget<ElevatedButton>(find.widgetWithText(ElevatedButton, "Révéler l'accord"))
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

  group('Flux nouvelle note', () {
    testWidgets('n\'affiche aucune note avant de taper sur Nouvelle note', (tester) async {
      await tester.pumpWidget(const MyApp());

      for (final note in Note.values) {
        expect(find.text(note.label), findsNothing);
      }
    });

    testWidgets('le bouton Révéler l\'accord est désactivé sans note',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(revealOnPressed(tester), isNull);

      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();

      expect(revealOnPressed(tester), isNotNull);
    });

    testWidgets('Nouvelle note affiche exactement une note', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();

      final shown = Note.values
          .where((n) => find.text(n.label).evaluate().isNotEmpty);
      expect(shown, hasLength(1));
    });

    testWidgets('Révéler l\'accord affiche l\'accord de la note affichée et '
        'se désactive', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();
      final note = displayedNote();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);

      await tester.tap(find.text("Révéler l'accord"));
      await tester.pump();

      expect(find.text(note.getChord(ChordDir.asc).join(' - ')), findsOneWidget);
      expect(revealOnPressed(tester), isNull);
    });

    testWidgets('Nouvelle note après une révélation cache de nouveau la réponse',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();
      await tester.tap(find.text("Révéler l'accord"));
      await tester.pump();

      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);
    });
  });

  group('Switch de direction', () {
    testWidgets('affiche les deux libellés et démarre sur ascendant',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Ascendant'), findsOneWidget);
      expect(find.text('Descendant'), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    });

    testWidgets('descendant révèle l\'accord descendant', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();
      final note = displayedNote();
      await tester.tap(find.text("Révéler l'accord"));
      await tester.pump();

      expect(
        find.text(note.getChord(ChordDir.desc).join(' - ')),
        findsOneWidget,
      );
    });

    testWidgets('revenir sur ascendant révèle l\'accord ascendant',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();

      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();
      final note = displayedNote();
      await tester.tap(find.text("Révéler l'accord"));
      await tester.pump();

      expect(
        find.text(note.getChord(ChordDir.asc).join(' - ')),
        findsOneWidget,
      );
    });

    testWidgets('changer de direction après une révélation cache la réponse et garde la note',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Nouvelle note'));
      await tester.pump();
      final note = displayedNote();
      await tester.tap(find.text("Révéler l'accord"));
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(find.textContaining(' - '), findsNothing);
      expect(revealOnPressed(tester), isNotNull);
      expect(displayedNote(), note);

      await tester.tap(find.text("Révéler l'accord"));
      await tester.pump();

      expect(
        find.text(note.getChord(ChordDir.desc).join(' - ')),
        findsOneWidget,
      );
    });
  });
}
