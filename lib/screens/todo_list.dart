// ignore_for_file: unused_local_variable, avoid_web_libraries_in_flutter, unused_import

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';



class LodoListPage extends StatefulWidget {
  const LodoListPage({super.key});

  @override
  State<LodoListPage> createState() => _LodoListPageState();
}

class _LodoListPageState extends State<LodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddTodoPage(context);
        },
        label: const Text("Add Todo"),
      ),
    );
  }
}

void navigateToAddTodoPage( context){
  final route=MaterialPageRoute(builder: (context)=>  const AddTodoPage ());
  Navigator.push(context, route);
}