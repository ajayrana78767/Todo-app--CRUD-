// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/todo_list.dart';
//import 'package:todo_app/screens/todo_list.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add Todo"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LodoListPage()));
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
                  if (_formKey.currentState!.validate()) {
                    submitData();
                  } else {
                    return;
                  }
                },
                child: const Text("Submit")),
          ],
        ),
      ),
    );
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
