import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Model/note_model.dart';
import 'package:notes_app/Providers/selected_notes_provider.dart';
import 'package:notes_app/Screens/notes_page.dart';

class NotesCard extends ConsumerWidget {
  final Note note;
  const NotesCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);

    return InkWell(
      // Long press on note -> select it
      onLongPress: () =>
          ref.read(selectedNotesProvider.notifier).selectNote(note.id),
      onTap: () {
        // If no note is selected -> open the note
        if (selectedNotes.isEmpty) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => NotePage(note: note)));
        }
        // Add the note to selectedNote
        else {
          ref.read(selectedNotesProvider.notifier).selectNote(note.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          // Show border around selected notes
          border: (selectedNotes.contains(note.id))
              ? BoxBorder.all(color: Colors.blue, width: 3)
              : null,
          color: note.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: Markdown(
                      data: note.content,
                      softLineBreak: true,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 14),
                        h3: const TextStyle(fontSize: 15),
                        h2: const TextStyle(fontSize: 16),
                        h1: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (note.isPinned)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 4,
                ),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.push_pin),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
