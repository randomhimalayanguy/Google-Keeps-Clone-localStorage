import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Build runner file
part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  // Store color as int
  @HiveField(3)
  int? colorValue;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  bool isPinned;

  Note({
    required this.id,
    this.title = "",
    this.content = "",
    Color color = Colors.white,
    this.isPinned = false,
    DateTime? updatedAt,
  }) : colorValue = color.toARGB32(),
       updatedAt = updatedAt ?? DateTime.now();

  // Helper to get the Color back
  Color get color => Color(colorValue ?? Colors.white.toARGB32());

  // To copy the note, (when note is updated)
  Note copyWith({
    String? id,
    String? title,
    String? content,
    Color? color,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
