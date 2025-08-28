import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Model/note_model.dart';
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
    if (widget.note != null) {
      titleController.text = widget.note?.title ?? "";
      textController.text = widget.note?.content ?? "";
      isNew = false;
    }
  }

  void save() {
    if (isNew) {
      if (titleController.text != "" || textController.text != "") {
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
        } else {
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
    } else {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: save, icon: Icon(Icons.save)),
          IconButton(
            onPressed: () {
              delete();
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
                hintStyle: TextStyle(fontSize: 26),
              ),
              style: TextStyle(fontSize: 26),
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Note",
                  hintStyle: TextStyle(fontSize: 15),
                ),
                expands: true,
                maxLines: null,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
