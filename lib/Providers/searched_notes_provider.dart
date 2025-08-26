import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Model/note_model.dart';
import 'package:notes_app/Providers/notes_provider.dart';
import 'package:notes_app/Providers/search_query_provider.dart';

final serachedNotesProvider = StateProvider<List<Note>>((ref) {
  final String query = ref.watch(queryProvider).toLowerCase();
  final List<Note> allNotes = ref.watch(notesProvider);
  if (query.isEmpty) {
    return allNotes;
  }

  return allNotes.where((note) {
    final title = note.title.toLowerCase();
    final content = note.content.toLowerCase();
    if (title.contains(query) || content.contains(query)) {
      print(note.title);
    }
    return title.contains(query) || content.contains(query);
  }).toList();
});
