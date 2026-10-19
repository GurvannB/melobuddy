enum Note {
  doNote('Do'),
  re('Ré'),
  mi('Mi'),
  fa('Fa'),
  sol('Sol'),
  la('La'),
  si('Si');

  const Note(this.label);

  final String label;

  List<Note> getChord(ChordDir chordDir) {
    final noteLength = Note.values.length;
    final currentNodeIndex = Note.values.indexOf(this);

    final int factor = chordDir == ChordDir.desc ? -1 : 1;

    return [
      this,
      Note.values[(currentNodeIndex + 2 * factor) % noteLength],
      Note.values[(currentNodeIndex + 4 * factor) % noteLength],
    ];
  }

  @override
  String toString() {
    return label;
  }
}

enum ChordDir {
  asc('Ascendant'), desc('Descendant');

  const ChordDir(this.label);
  final String label;

  @override
  String toString() {
    return label;
  }
}
