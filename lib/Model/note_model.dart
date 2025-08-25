class Note {
  final String id;
  final String title;
  final String content;

  Note({required this.id, this.title = "", this.content = ""});

  Note copyWith(Note curNote) {
    return Note(id: curNote.id, title: curNote.title, content: curNote.content);
  }
}
