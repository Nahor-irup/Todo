import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo/create_todo_screen.dart';
import 'package:todo/todo_model.dart';

import 'components/urls.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todoList = [];

  navigateToCreatePage({Todo? todo}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CreateTodoScreen(todo: todo), // Pass the todo object here
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  Future<List<Todo>> fetchTodo() async {
    final dio = Dio();
    final response = await dio.get(Urls.notes);
    final convertedList = List.from(response.data["data"]);
    return convertedList.map((e) => Todo.fomrMap(e)).toList();
  }

  void deleteTod(String todoId) async {
    try {
      context.loaderOverlay.show();
      final dio = Dio();
      final _ = await dio.delete(
        "${Urls.notes}/${todoId}",
      );
      Fluttertoast.showToast(msg: "Note deleted successfully");
      setState(() {});
    } on DioException catch (e) {
      Fluttertoast.showToast(
          msg: e.response?.data["message"] ?? "Unable to delete todo");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      context.loaderOverlay.hide();
    }
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
      body: FutureBuilder<List<Todo>>(
          future: fetchTodo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final todo = snapshot
                          .data![index]; // Get the todo from snapshot.data
                      return ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        leading: Icon(Icons.person),
                        onTap: () {
                          navigateToCreatePage(todo: todo);
                        },
                        trailing: IconButton(
                          onPressed: () {
                            deleteTod(snapshot.data![index].id);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      );
                    },
                    itemCount: snapshot
                        .data!.length, // Use snapshot.data for itemCount
                  );
                } else {
                  return Center(
                    child: Text("No data found"),
                  );
                }
              } else {
                return Center(
                  child: Text("No data found"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
