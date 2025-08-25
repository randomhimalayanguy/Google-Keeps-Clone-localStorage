import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final selectedNotesProvider =
    StateNotifierProvider<SelectedNotesNotifier, List<String>>(
      (ref) => SelectedNotesNotifier(),
    );
