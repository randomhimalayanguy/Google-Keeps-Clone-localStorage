import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/Providers/searched_notes_provider.dart';
import 'package:notes_app/Providers/selected_notes_provider.dart';
import 'package:notes_app/Screens/notes_page.dart';
import 'package:notes_app/Widgets/notes_card.dart';
import 'package:notes_app/Widgets/searchbar_widget.dart';
import 'package:notes_app/Widgets/selection_bar_widget.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);
    final notes = ref.watch(serachedNotesProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // FAB to add new note
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => NotePage())),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        // Using CustomScrollView, so that we can keep the search at the top
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverAppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              floating: true,
              snap: true,
              // If no note is selected -> show search bar,
              //otherwise show Selection bar
              title: (selectedNotes.isEmpty)
                  ? SearchBarWidget()
                  : SelectionBar(selectedNotes: selectedNotes),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              // MasonryGrid for uneven height of cards
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                childCount: notes.length,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemBuilder: (context, index) => NotesCard(note: notes[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
