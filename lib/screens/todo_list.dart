// ignore_for_file: unused_local_variable, avoid_web_libraries_in_flutter, unused_import, avoid_print

import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class LodoListPage extends StatefulWidget {
  const LodoListPage({super.key});

  @override
  State<LodoListPage> createState() => _LodoListPageState();
}

class _LodoListPageState extends State<LodoListPage> {
  List items = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo List"),
      ),
      body: Visibility(
        visible: isLoading,
        // ignore: sort_child_properties_last
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index] as Map;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(item["title"]),
                  subtitle: Text(item['description']),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddTodoPage(context);
        },
        label: const Text("Add Todo"),
      ),
    );
  }

  void navigateToAddTodoPage(context) {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    Navigator.push(context, route);
  }

  Future<void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;

      setState(() {
        items = result;
      });
     // print(items);
    }
    setState(() {
      isLoading = false;
    });
  }
}
