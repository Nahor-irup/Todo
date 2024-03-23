import 'package:flutter/material.dart';
import 'package:todo/create_todo_screen.dart';
import 'package:todo/todo_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todoList = [];

  navigateToCreatePage({Todo? todo}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) =>
            CreateTodoScreen(todo: todo), // Pass the todo object here
      ),
    )
        .then((result) {
      if (result != null && result['isNew'] == true) {
        final Todo newTodo = result['todo'];
        _todoList.insert(0, newTodo); // Insert at the beginning of the list
      } else if (result != null && result['todo'] is Todo) {
        final updatedTodo = result['todo'];
        final index = _todoList.indexWhere((e) => e.title == updatedTodo.title);
        if (index != -1) {
          _todoList[index] = updatedTodo;
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToCreatePage();
        },
        child: Icon(Icons.add),
      ),
      body: Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_todoList[index].title),
              subtitle: Text(_todoList[index].description),
              leading: Icon(Icons.person),
              onTap: () {
                navigateToCreatePage(todo: _todoList[index]);
              },
              trailing: IconButton(
                onPressed: () {
                  _todoList
                      .removeWhere((e) => e.title == _todoList[index].title);
                  setState(() {});
                },
                icon: Icon(Icons.delete),
              ),
            );
          },
          itemCount: _todoList.length,
        ),
      ),
    );
  }
}
