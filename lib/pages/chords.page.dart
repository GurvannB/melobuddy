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
            ElevatedButton(onPressed: getNewNote, child: const Text("New chord")),
            if (_note != null) Text(_note!.label),
            ElevatedButton(
              onPressed: _mustRevealAnswer ? null : revealAnswer,
              child: const Text("Reveal answer"),
            ),
            if (_mustRevealAnswer && _note != null)
              Text(_note!.getChord().join(" - ")),
          ],
        ),
      ),
    );
  }
}
