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
  ChordDir chordDir = ChordDir.asc;
  Note? _note;

  void getNewNote() {
    Note newNote = Note.values[Random().nextInt(Note.values.length)];
    setState(() {
      _mustRevealAnswer = false;
      _note = newNote;
    });
  }

  void revealAnswer() {
    setState(() {
      _mustRevealAnswer = true;
    });
  }

  void onChangeDir(bool desc) {
    setState(() {
      chordDir = desc ? ChordDir.desc : ChordDir.asc;
      _mustRevealAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Chords"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ChordDir.asc.toString()),
                const SizedBox(width: 20),
                Switch(value: chordDir == ChordDir.desc, onChanged: onChangeDir),
                const SizedBox(width: 20),
                Text(ChordDir.desc.toString()),
              ],
            ),
            ElevatedButton(onPressed: getNewNote, child: const Text("New note")),
            if (_note != null) Text(_note!.label),
            ElevatedButton(
              onPressed: _mustRevealAnswer ? null : revealAnswer,
              child: const Text("Reveal chord"),
            ),
            if (_mustRevealAnswer && _note != null)
              Text(_note!.getChord(chordDir).join(" - ")),
          ],
        ),
      ),
    );
  }
}
