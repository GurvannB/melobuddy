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

  List<Note> getChord() {
    final noteLength = Note.values.length;
    final currentNodeIndex = Note.values.indexOf(this);

    return [
      this,
      Note.values[(currentNodeIndex + 2) % noteLength],
      Note.values[(currentNodeIndex + 4) % noteLength],
    ];
  }

  @override
  String toString() {
    return label;
  }
}
