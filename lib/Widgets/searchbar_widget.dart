import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

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
