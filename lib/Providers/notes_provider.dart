import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/Model/note_model.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  late Box<Note> box;

  NotesNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }

    box = await Hive.openBox("notes");

    state = box.values.toList();
  }

  void addNote(Note newNote) {
    box.put(newNote.id, newNote);
    state = [newNote, ...state];
  }

  void updateNote(Note newNote) {
    box.put(newNote.id, newNote);
    state = [
      for (Note note in state)
        if (note.id == newNote.id) note.copyWith(newNote) else note,
    ];
  }

  void deleteNote(String id) {
    box.delete(id);
    state = [
      for (Note note in state)
        if (note.id != id) note,
    ];
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(),
);
