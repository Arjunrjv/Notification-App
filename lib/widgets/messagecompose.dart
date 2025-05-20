import 'package:flutter/material.dart';

class MessageComposeDialog extends StatefulWidget {
  const MessageComposeDialog({super.key});

  @override
  _MessageComposeDialogState createState() => _MessageComposeDialogState();
}

class _MessageComposeDialogState extends State<MessageComposeDialog> {
  bool sendToAll = true;
  bool sendToTeachers = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Recipients'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Send to All'),
            leading: Radio(
              value: true,
              groupValue: sendToAll,
              onChanged: (value) {
                setState(() {
                  sendToAll = value!;
                  sendToTeachers = false;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Send to Teachers Only'),
            leading: Radio(
              value: true,
              groupValue: sendToTeachers,
              onChanged: (value) {
                setState(() {
                  sendToAll = false;
                  sendToTeachers = value!;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // TODO: Implement logic based on selected options
            print('Send to All: $sendToAll');
            print('Send to Teachers Only: $sendToTeachers');
            Navigator.pop(context);
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}
