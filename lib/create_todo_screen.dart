import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo/components/urls.dart';
import 'package:todo/todo_model.dart';

class CreateTodoScreen extends StatefulWidget {
  final Todo? todo;

  const CreateTodoScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  DateTime? date;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _title = widget.todo?.title ?? '';
    _description = widget.todo?.description ?? '';
  }

  saveTodo() async {
    try {
      context.loaderOverlay.show();
      final dio = Dio();
      final _ = await dio.post(
        Urls.notes,
        data: {
          'title': _title,
          'description': _description,
        },
      );
      Navigator.of(context).pop(true);
      Fluttertoast.showToast(msg: "Note saved successfully");
    } on DioException catch (e) {
      Fluttertoast.showToast(
          msg: e.response?.data["message"] ?? "Unable to create todo");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      context.loaderOverlay.hide();
    }
  }

  updateTodo() async {
    try {
      context.loaderOverlay.show();
      final dio = Dio();
      final _ = await dio.put(
        "${Urls.notes}/${widget.todo?.id}",
        data: {
          'title': _title,
          'description': _description,
        },
      );
      Navigator.of(context).pop(true);
      Fluttertoast.showToast(msg: "Note updated successfully");
    } on DioException catch (e) {
      Fluttertoast.showToast(
          msg: e.response?.data["message"] ?? "Unable to updated todo");
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: Text(
          "Create Todo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _description,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.todo != null) {
                      updateTodo();
                    } else {
                      saveTodo();
                    }
                  }
                },
                child: Text(
                  widget.todo != null ? "Update" : "Save",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
