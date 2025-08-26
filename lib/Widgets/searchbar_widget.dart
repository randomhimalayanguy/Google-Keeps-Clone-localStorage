import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/Providers/search_query_provider.dart';

class SearchBar extends ConsumerStatefulWidget {
  const SearchBar({super.key});

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(queryProvider);

    controller.text = query;

    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          controller: controller,
          autofocus: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search your notes",
            hintStyle: TextStyle(color: Colors.black),
          ),
          onChanged: (val) {
            print(val);
            ref.read(queryProvider.notifier).state = val;
            setState(() {});
          },
        ),
      ),
    );
  }
}
