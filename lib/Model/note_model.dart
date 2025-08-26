import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;

  Note({required this.id, this.title = "", this.content = ""});

  Note copyWith(Note curNote) {
    return Note(id: curNote.id, title: curNote.title, content: curNote.content);
  }
}
