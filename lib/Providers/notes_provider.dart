import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/Model/note_model.dart';
import 'package:notes_app/const/colors.dart';

// Manage Note
class NotesNotifier extends StateNotifier<List<Note>> {
  final Box<Note> box;
  // Listen to changes -> addition, updation or deletion of notes in memory
  late final ValueListenable<Box<Note>> _listner;

  // Constructor
  NotesNotifier(this.box) : super([]) {
    refreshList();
    _listner = box.listenable();
    // Call refreshList method, whenever there is any change
    _listner.addListener(refreshList);
  }

  void refreshList() {
    final notes = box.values.toList();

    // Pinned elements are at the top, followed by notes based on last update
    notes.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return b.isPinned ? 1 : -1;
      }

      return b.updatedAt.compareTo(a.updatedAt);
    });
    state = notes;
  }

  void addNote(Note newNote) {
    newNote = newNote.copyWith(updatedAt: DateTime.now());
    newNote.colorValue = getColor(box.length).toARGB32();
    box.put(newNote.id, newNote);
  }

  void setColor(String id, int newColor) {
    final Note? newNote = box.get(id);
    if (newNote == null) return;

    newNote.colorValue = newColor;
    box.put(id, newNote);
  }

  void updateNote(Note newNote) {
    final updatedNote = box
        .get(newNote.id)!
        .copyWith(
          title: newNote.title,
          content: newNote.content,
          updatedAt: DateTime.now(),
        );

    box.put(updatedNote.id, updatedNote);
  }

  void pinning(String id) {
    final bool isPinned = !box.get(id)!.isPinned;
    final updatedNote = box.get(id)!.copyWith(isPinned: isPinned);
    box.put(updatedNote.id, updatedNote);
  }

  void deleteNote(String id) {
    box.delete(id);
  }

  @override
  void dispose() {
    _listner.removeListener(refreshList);
    super.dispose();
  }
}

final notesProvider =
    StateNotifierProvider.autoDispose<NotesNotifier, List<Note>>((ref) {
      return NotesNotifier(Hive.box<Note>("notes"));
    });
