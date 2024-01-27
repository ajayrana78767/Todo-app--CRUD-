// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleEditingController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionEditingController,
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
                submitData();
              },
              child: const Text("Submit")),
        ],
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
      titleEditingController.text='';
      descriptionEditingController.text='';
      showSuccessMessage(
        "creation success",
      );
    } else {
      showErrorMessage("creation failed");
    }

    print(response.statusCode);
    print(response.body);
  }

  void showSuccessMessage(String message) {
    final snakbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: (Colors.green),
    );
    ScaffoldMessenger.of(context).showSnackBar(snakbar);
  }

  void showErrorMessage(String message) {
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
