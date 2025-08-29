import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Providers/notes_provider.dart';
import 'package:notes_app/Providers/selected_notes_provider.dart';
import 'package:notes_app/Widgets/color_picker_widget.dart';

class SelectionBar extends ConsumerWidget {
  const SelectionBar({super.key, required this.selectedNotes});

  final List<String> selectedNotes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    ref.read(selectedNotesProvider.notifier).empty(),
                icon: const Icon(Icons.cancel),
              ),
              Text("${selectedNotes.length}"),
            ],
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {
                  for (String id in selectedNotes) {
                    ref.read(notesProvider.notifier).pinning(id);
                  }
                  ref.read(selectedNotesProvider.notifier).empty();
                },
                icon: const Icon(Icons.push_pin),
              ),
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const ColorPickerMenu(),
                ),
                icon: const Icon(Icons.color_lens),
              ),
              IconButton(
                onPressed: () {
                  for (String id in selectedNotes) {
                    ref.read(notesProvider.notifier).deleteNote(id);
                  }
                  ref.read(selectedNotesProvider.notifier).empty();
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
