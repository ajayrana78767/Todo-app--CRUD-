// ignore_for_file: unused_local_variable, avoid_web_libraries_in_flutter, unused_import, avoid_print, deprecated_member_use, use_build_context_synchronously
import 'dart:convert';
//import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/util/snaakbar_helper.dart';
import 'package:todo_app/widget/todo_card.dart';

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
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No todo item",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return TodoCard(
                    index: index,
                    item: item,
                    navigateEdit: navigateToEditPage,
                    deleteByID: deleteByID);
              },
            ),
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
    final isSuccess = await TodoService.deleteByID(id);

    if (isSuccess) {
      // remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage(context, message: 'Deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true; // Set isLoading to true before fetching data
    });
    final response = await TodoService.fetchTodo();

    if (response != null) {
      setState(() {
        items = response;
      });
      // print(items);
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
