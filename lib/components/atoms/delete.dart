import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:niku/niku.dart';

Future<void> showDeleteDialog(
  BuildContext context, {
  @required String title,
  @required String content,
  @required VoidCallback callback,
}) async {
  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  if (isIOS)
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Delete'),
              isDefaultAction: true,
              isDestructiveAction: true,
              onPressed: () {
                callback();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: NikuText('Delete').color(Colors.red).bold().build(),
            onPressed: () {
              callback();

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
