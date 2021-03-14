import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> showAlertDialog(
  BuildContext context, {
  @required String title,
  @required String content,
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
              child: const Text('Ok'),
              onPressed: () {
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
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
