import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:niku/niku.dart';

Future<void> showInputDialog(
  BuildContext context, {
  @required String title,
  @required String label,
  String confirmation = 'Create',
  @required void Function(String text) callback,
}) async {
  final controller = TextEditingController(text: "");

  final void Function(BuildContext context) response = (context) {
    if (controller.text.length > 0) callback(controller.text);

    Navigator.of(context).pop();
  };

  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  if (isIOS)
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: CupertinoTextField(
            controller: controller,
            autofocus: true,
          ).niku().mt(12).build(),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(confirmation),
              isDefaultAction: true,
              onPressed: () {
                response(context);
              },
            )
          ],
        );
      },
    );

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: NikuTextField(label)
            .autofocus(true)
            .initialValue(null)
            .controller(controller)
            .build(),
        actions: <Widget>[
          TextButton(
            child: const Text('Canel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(confirmation),
            onPressed: () {
              response(context);
            },
          ),
        ],
      );
    },
  );
}
