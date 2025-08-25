import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Providers/notes_provider.dart';
import 'package:notes_app/Providers/selected_notes_provider.dart';

class SelectionBar extends ConsumerWidget {
  SelectionBar({super.key, required this.selectedNotes});

  final List<String> selectedNotes;
  final List<Color> colors = [
    for (int i = 0; i < 8; i++) Colors.primaries[i].shade200,
  ];

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
                icon: Icon(Icons.cancel),
              ),
              Text("${selectedNotes.length}"),
            ],
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Choose a color"),
                    content: SizedBox(
                      height: 150,
                      child: GridView.builder(
                        itemCount: 8,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) => InkWell(
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: colors[index],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                ),
                icon: Icon(Icons.color_lens),
              ),
              IconButton(
                onPressed: () {
                  for (String id in selectedNotes) {
                    ref.read(notesProvider.notifier).deleteNote(id);
                  }
                  ref.read(selectedNotesProvider.notifier).empty();
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
