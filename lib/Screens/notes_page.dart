import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Model/note_model.dart';
import 'package:notes_app/Providers/edit_mode_provider.dart';
import 'package:notes_app/Providers/notes_provider.dart';
import 'package:uuid/uuid.dart';

class NotePage extends ConsumerStatefulWidget {
  final Note? note;
  const NotePage({super.key, this.note});

  @override
  ConsumerState<NotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends ConsumerState<NotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  bool isNew = true;
  String newId = "";

  @override
  void initState() {
    super.initState();
    // Updating old note
    if (widget.note != null) {
      titleController.text = widget.note?.title ?? "";
      textController.text = widget.note?.content ?? "";
      isNew = false;
    }

    // Waiting for UI to build, then setting editMode,
    // If new note -> enter editing mode
    // otherwise -> enter reading mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editModeProvider.notifier).state = isNew;
    });
  }

  void save() {
    if (isNew) {
      if (titleController.text != "" || textController.text != "") {
        // If new and not saved already, then save the note
        if (newId == "") {
          newId = Uuid().v4();
          ref
              .read(notesProvider.notifier)
              .addNote(
                Note(
                  id: newId,
                  title: titleController.text,
                  content: textController.text,
                ),
              );
        }
        // if new note, but already saved, then update the note
        else {
          ref
              .read(notesProvider.notifier)
              .updateNote(
                Note(
                  id: newId,
                  title: titleController.text,
                  content: textController.text,
                ),
              );
        }
      }
    }
    // Old note -> update it
    else {
      if (titleController.text != "" || textController.text != "") {
        ref
            .read(notesProvider.notifier)
            .updateNote(
              Note(
                id: widget.note!.id,
                title: titleController.text,
                content: textController.text,
              ),
            );
      }
    }
  }

  void delete() {
    if (isNew) {
      if (newId != "") {
        ref.read(notesProvider.notifier).deleteNote(newId);
      }
    } else {
      ref.read(notesProvider.notifier).deleteNote(widget.note!.id);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = ref.watch(editModeProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: save, icon: const Icon(Icons.save)),
          IconButton(
            onPressed: () {
              delete();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle for reading and editing mode
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: (!isEditing) ? Colors.blueAccent : Colors.grey,
                  ),
                  height: 35,
                  child: TextButton(
                    onPressed: () =>
                        ref.read(editModeProvider.notifier).state = false,
                    child: const Text(
                      "Read",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: (isEditing) ? Colors.blueAccent : Colors.grey,
                  ),
                  height: 35,
                  child: TextButton(
                    onPressed: () =>
                        ref.read(editModeProvider.notifier).state = true,
                    child: const Text(
                      "Write",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            // Editing Mode -> TextField
            // Reading Mode -> MarkDown/Text
            (isEditing)
                ? TextField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Title",
                      hintStyle: const TextStyle(fontSize: 26),
                    ),
                    style: const TextStyle(fontSize: 26),
                  )
                : Text(
                    titleController.text,
                    style: const TextStyle(fontSize: 26),
                  ),

            const SizedBox(height: 10),
            Expanded(
              child: (isEditing)
                  ? TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Note",
                        hintStyle: const TextStyle(fontSize: 15),
                      ),
                      expands: true,
                      maxLines: null,
                      style: const TextStyle(fontSize: 15),
                    )
                  : Markdown(
                      data: textController.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 16),
                        h1: const TextStyle(fontSize: 26),
                        h2: const TextStyle(fontSize: 22),
                        h3: const TextStyle(fontSize: 20),
                      ),
                      softLineBreak: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
