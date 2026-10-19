import 'dart:math';

import 'package:flutter/material.dart';
import 'package:melody/types.dart';

class ChordsPage extends StatefulWidget {
  const ChordsPage({super.key});

  @override
  State<ChordsPage> createState() => _ChordsPageState();
}

class _ChordsPageState extends State<ChordsPage> {
  bool _mustRevealAnswer = false;
  ChordDir _chordDir = ChordDir.asc;
  Note? _note;
  final _random = Random();

  void _getNewNote() {
    Note newNote = Note.values[_random.nextInt(Note.values.length)];
    setState(() {
      _mustRevealAnswer = false;
      _note = newNote;
    });
  }

  void _revealAnswer() {
    setState(() {
      _mustRevealAnswer = true;
    });
  }

  void _onChangeDir(bool desc) {
    setState(() {
      _chordDir = desc ? ChordDir.desc : ChordDir.asc;
      _mustRevealAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = colors.onSurface.withValues(alpha: 0.5);
    final isDesc = _chordDir == ChordDir.desc;
    final activeDir = textTheme.titleMedium!.copyWith(color: colors.primary);
    final inactiveDir = textTheme.titleMedium!.copyWith(
      color: colors.onSurface.withValues(alpha: 0.5),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accords",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        toolbarHeight: 72,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ChordDir.asc.toString(),
                          style: isDesc ? inactiveDir : activeDir,
                        ),
                        const SizedBox(width: 16),
                        Switch(value: isDesc, onChanged: _onChangeDir),
                        const SizedBox(width: 16),
                        Text(
                          ChordDir.desc.toString(),
                          style: isDesc ? activeDir : inactiveDir,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text("NOTE", style: textTheme.labelMedium),
                        const SizedBox(height: 4),
                        Text(
                          _note?.label ?? "?",
                          style: textTheme.displayMedium!.copyWith(
                            color: _note == null ? muted : colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text("ACCORD", style: textTheme.labelMedium),
                        const SizedBox(height: 4),
                        if (_mustRevealAnswer && _note != null)
                          Text(
                            _note!.getChord(_chordDir).join(" - "),
                            style: textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          Text(
                            "···",
                            style: textTheme.headlineMedium!.copyWith(
                              color: muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _getNewNote,
                  child: const Text("Nouvelle note"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _mustRevealAnswer || _note == null
                      ? null
                      : _revealAnswer,
                  child: const Text("Révéler l'accord"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
