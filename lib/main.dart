import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/Screens/main_page.dart';
import 'Model/note_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk(
  //   "notes",
  // ); //use it when ever notes model is changed
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>("notes");
  return runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainApp(), debugShowCheckedModeBanner: false);
  }
}
