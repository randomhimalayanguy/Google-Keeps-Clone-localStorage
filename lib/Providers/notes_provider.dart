import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Model/note_model.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  void addNote(Note newNote) {
    state = [newNote, ...state];
  }

  void updateNote(Note newNote) {
    state = [
      for (Note note in state)
        if (note.id == newNote.id) note.copyWith(newNote) else note,
    ];
  }

  void deleteNote(String id) {
    state = [
      for (Note note in state)
        if (note.id != id) note,
    ];
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(),
);
