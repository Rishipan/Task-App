// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final titleController;
  final contentController;
  final dateController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.titleController,
    required this.contentController,
    this.dateController,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.orange.shade200,
      title: const Text('Add New Task'),
      content: Expanded(
        child: SizedBox(
          height: 300,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // get user input
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task Title',
                  ),
                ),
                TextField(
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Task Content'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Time(optional)',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        MaterialButton(
          onPressed: onSave,
          color: Colors.amber,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
