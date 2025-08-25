import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/Model/note_model.dart';
import 'package:notes_app/Providers/notes_provider.dart';
import 'package:notes_app/Providers/selected_notes_provider.dart';
import 'package:notes_app/Screens/notes_page.dart';
import 'package:notes_app/Widgets/notes_card.dart';
import 'package:notes_app/Widgets/selection_bar_widget.dart';
import 'package:uuid/uuid.dart';

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
                  ? SearchBar()
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
