import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Providers/notes_provider.dart';
import 'package:notes_app/Providers/selected_color.dart';
import 'package:notes_app/Providers/selected_notes_provider.dart';
import 'package:notes_app/const/colors.dart';

class ColorPickerMenu extends ConsumerWidget {
  const ColorPickerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curSelectedColor = ref.watch(selectedColor);
    final selectedNotes = ref.watch(selectedNotesProvider);
    final colors = getColorList();

    void clicked() {
      Navigator.of(context).pop();
      ref.read(selectedColor.notifier).state = null;
    }

    return AlertDialog(
      title: Text("Choose a color"),
      content: SizedBox(
        height: 120,
        child: GridView.builder(
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final isSelected = curSelectedColor == colors[index];
            return InkWell(
              onTap: () =>
                  ref.read(selectedColor.notifier).state = colors[index],
              child: CircleAvatar(
                radius: 10,
                backgroundColor: colors[index],
                child: (isSelected) ? Icon(Icons.check_circle) : null,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (curSelectedColor != null) {
              for (String id in selectedNotes) {
                ref
                    .read(notesProvider.notifier)
                    .setColor(id, curSelectedColor.toARGB32());
              }
            }
            clicked();
          },
          child: Text("Set Color"),
        ),
        TextButton(onPressed: clicked, child: Text("Cancel")),
      ],
    );
  }
}
