import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Providers/notes_provider.dart';
import 'package:notes_app/Providers/selected_notes_provider.dart';
import 'package:notes_app/Screens/notes_page.dart';

class NotesCard extends ConsumerWidget {
  final int index;
  const NotesCard({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final selectedNotes = ref.watch(selectedNotesProvider);

    return InkWell(
      onLongPress: () =>
          ref.read(selectedNotesProvider.notifier).selectNote(notes[index].id),
      onTap: () {
        if (selectedNotes.isEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotePage(note: notes[index]),
            ),
          );
        } else {
          ref.read(selectedNotesProvider.notifier).selectNote(notes[index].id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: (selectedNotes.contains(notes[index].id))
              ? BoxBorder.all(color: Colors.blue, width: 3)
              : null,
          color: Colors.primaries[index % Colors.primaries.length].shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notes[index].title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              MarkdownBody(data: notes[index].content),
            ],
          ),
        ),
      ),
    );
  }
}
