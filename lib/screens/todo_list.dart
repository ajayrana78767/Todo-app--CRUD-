// ignore_for_file: unused_local_variable, avoid_web_libraries_in_flutter, unused_import, avoid_print

import 'dart:convert';
//import 'dart:js';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class LodoListPage extends StatefulWidget {
  const LodoListPage({Key? key}) : super(key: key);

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
    // isLoading=true;
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              final id = item['_id'] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(item["title"]),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'Edit') {
                      navigateToEditPage(item);
                      // open edit page
                    } else if (value == 'Delete') {
                      //remove and refresh the page
                      deleteByID(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Text("Edit"),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text("Delete"),
                      ),
                    ];
                  }),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddTodoPage();
        },
        label: const Text("Add Todo"),
      ),
    );
  }

  void navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    // Refresh data after returning from the edit page
    //setState(() {});
  }

  Future<void> navigateToAddTodoPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route); // Remove 'as BuildContext' here
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteByID(String id) async {
    // delete the item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      // remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage('Deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true; // Set isLoading to true before fetching data
    });
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
