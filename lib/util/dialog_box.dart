import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),

            // buttons -> save + cancel
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // save button
                  MaterialButton(
                    onPressed: onSave,
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      "Save",
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  SizedBox(width: 8),
                  // cancel button
                  MaterialButton(
                    onPressed: onCancel,
                    color: Theme.of(context).colorScheme.error,
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Theme.of(context).colorScheme.onError),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
