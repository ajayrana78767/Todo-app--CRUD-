// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, unused_field, override_on_non_overriding_member, annotate_overrides, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/todo_list.dart';
//import 'package:todo_app/screens/todo_list.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  @override
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final Title = todo["title"];
      final Description = todo["description"];
      titleEditingController.text = Title;
      descriptionEditingController.text = Description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LodoListPage()));
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: titleEditingController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("please enter a some thing");
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionEditingController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("please enter a some thing");
                } else {
                  return null;
                }
                // return null;
              },
              minLines: 5,
              maxLines: 7,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[800],
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: () {
                  if (isEdit) {
                    updateData();
                  } else if (_formKey.currentState!.validate()) {
                    submitData();
                  }
                  // if (_formKey.currentState!.validate()) {
                  //   submitData();
                  // } else {
                  //   return;
                  // }
                },
                child: Text(isEdit ? "update" : "Submit")),
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("you can not call updated without todo data");
      return;
    }
    final id = todo["_id"];
    //final iscompleted = todo["is_completed"];
    final title = titleEditingController.text;
    final description = descriptionEditingController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    // submit updated data to the server
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      showSuccessMessage(
        "updation success",
      );
    } else {
      showErrorMessage("updation failed");
    }
  }

  Future<void> submitData() async {
    final title = titleEditingController.text;
    final description = descriptionEditingController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      titleEditingController.text = '';
      descriptionEditingController.text = '';
      showSuccessMessage(
        "creation success",
      );
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>const LodoListPage()));
    } else {
      showErrorMessage("creation failed");
    }

    //print(response.statusCode);
    //print(response.body);
  }

  void showSuccessMessage(String message) {
    if (mounted) {
      final snakbar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: (Colors.green),
      );
      ScaffoldMessenger.of(context).showSnackBar(snakbar);
    }
  }

  void showErrorMessage(String message) {
    if (mounted) {
      final snakbar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: (Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(snakbar);
    }
  }
  // void showSuccessMessage(String message) {
  //   final snakbar = SnackBar(
  //     content: Text(
  //       message,
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //     backgroundColor: (Colors.green),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snakbar);
  // }

  // void showErrorMessage(String message) {
  //   final snakbar = SnackBar(
  //     content: Text(
  //       message,
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //     backgroundColor: (Colors.red),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snakbar);
  // }
}
