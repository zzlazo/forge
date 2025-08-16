import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/model/shared_model.dart';

class SharedAlertDialog extends StatelessWidget {
  const SharedAlertDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(DialogAction.cancel);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            context.pop(DialogAction.ok);
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
