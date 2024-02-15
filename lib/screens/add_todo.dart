// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, unused_field, override_on_non_overriding_member, annotate_overrides, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_list.dart';
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/util/snaakbar_helper.dart';

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
                   // showSuccessMessage(context, message: "updation success");
                  } else if (_formKey.currentState!.validate()) {
                    submitData();
                  }
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
    // final body = {
    //   "title": title,
    //   "description": description,
    //   "is_completed": false,
    // };
    final isSuccess = await TodoService.updateData(id, body);
    if (isSuccess) {
      showSuccessMessage(context, message: "updation success");
    } else {
      showErrorMessage(context, message: "updation failed");
    }
  }

  Future<void> submitData() async {
    final isSuccess = await TodoService.submitData(body);
    if (isSuccess) {
      titleEditingController.text = '';
      descriptionEditingController.text = '';

      showSuccessMessage(context, message: "creation success");
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>const LodoListPage()));
    } else {
      showErrorMessage(context, message: "creation failed");
    }
  }

  Map get body {
    final title = titleEditingController.text;
    final description = descriptionEditingController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
