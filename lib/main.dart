import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uuid/uuid.dart';

void main() {
  return runApp(ProviderScope(child: MyApp()));
}

class Note {
  final String id;
  final String title;
  final String content;

  Note({required this.id, this.title = "", this.content = ""});

  Note copyWith(Note curNote) {
    return Note(id: curNote.id, title: curNote.title, content: curNote.content);
  }
}

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  void addNote(Note newNote) {
    state = [newNote, ...state];
  }

  void updateNote(Note newNote) {
    state = [
      for (Note note in state)
        if (note.id == newNote.id) note.copyWith(newNote) else note,
    ];
  }

  void deleteNote(String id) {
    state = [
      for (Note note in state)
        if (note.id != id) note,
    ];
  }
}

class SelectedNotesNotifier extends StateNotifier<List<String>> {
  SelectedNotesNotifier() : super([]);

  void selectNote(String id) {
    if (!state.contains(id)) {
      state = [...state, id];
    } else {
      state = [
        for (String nId in state)
          if (nId != id) nId,
      ];
    }
  }

  void empty() {
    state = [];
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(),
);

final selectedNotesProvider =
    StateNotifierProvider<SelectedNotesNotifier, List<String>>(
      (ref) => SelectedNotesNotifier(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainApp(), debugShowCheckedModeBanner: false);
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);
    final notes = ref.watch(notesProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              final List<String> titles = [
                "Grocery List",
                "Meeting Notes",
                "Travel Ideas",
                "Book Summary",
                "Workout Plan",
              ];

              List<String> texts = [
                "Eggs\nMilk\nBananas\nBread\nDon't forget to check for discounts on coffee.",
                "Discuss Q3 goals and upcoming project deadlines.\n- Prepare slides for next week\n- Email John about the report\nNotes from client meeting below.",
                "Explore Japan in spring for cherry blossoms.\nPossible destinations: Kyoto, Tokyo.\nBudget and itinerary to be planned.\nResearch visa requirements and local festivals.",
                "Atomic Habits by James Clear:\nMain idea: Small changes can lead to remarkable results.\nQuote: \"Habits are the compound interest of self-improvement.\"\nRemember to implement the '2-minute rule.'",
                "Monday: Chest & Triceps\nTuesday: Rest\nWednesday: Back & Biceps\nThursday: Cardio + Abs\nFriday: Legs\nStay hydrated and stretch before each workout.",
              ];
              for (int i = 0; i < 5; i++) {
                ref
                    .read(notesProvider.notifier)
                    .addNote(
                      Note(
                        id: Uuid().v4(),
                        title: titles[i],
                        content: texts[i],
                      ),
                    );
              }
            },
            heroTag: "ASDf",
            child: Icon(Icons.notes),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => NotePage())),
            heroTag: "asdf",
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverAppBar(
              centerTitle: true,
              floating: true,
              snap: true,
              title: (selectedNotes.isEmpty)
                  ? _SearchBar()
                  : SelectionBar(selectedNotes: selectedNotes),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                childCount: notes.length,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemBuilder: (context, index) => NotesCard(index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search your notes",
            hintStyle: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}

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
              Text(
                notes[index].content,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                hintStyle: TextStyle(fontSize: 28),
              ),
              style: TextStyle(fontSize: 28),
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: textController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Note",
                  hintStyle: TextStyle(fontSize: 22),
                ),
                expands: true,
                maxLines: null,
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
