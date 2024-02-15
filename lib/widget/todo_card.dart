import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteByID;
  const TodoCard({super.key,
  required this.index,
  required this.item,
  required this.navigateEdit, 
  required this.deleteByID,
  });

  @override
  Widget build(BuildContext context) {
    final id = item["_id"] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text("${index + 1}")),
        title: Text(item["title"]),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == 'Edit') {
            navigateEdit(item);
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
  }
}
