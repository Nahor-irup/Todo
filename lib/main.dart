import 'package:flutter/material.dart';
import 'package:todo/create_todo_screen.dart';
import 'package:todo/todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: TodoListScreen(),
    );
  }
}
