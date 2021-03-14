import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:papership/services/persists.dart';

import 'package:provider/provider.dart';

import 'package:niku/niku.dart';

import '../../pages/memo.dart';

import '../atoms/atoms.dart'
    show Progress, showInputDialog, showDeleteDialog, showAlertDialog;

import '../../models/memo.dart' show MemoCollection;

import '../../stores/stores.dart' show MemoData;

class MemoCard extends StatelessWidget {
  const MemoCard({
    Key key,
    @required this.memoCollection,
    @required this.pageIndex,
  }) : super(key: key);

  final MemoCollection memoCollection;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final memoData = Provider.of<MemoData>(context, listen: false);

    final pushMemoPage = () async {
      final memoPage = await buildMemoPage(
          pageIndex: pageIndex, memoCollection: memoCollection);

      final route = MaterialPageRoute(builder: (context) => memoPage);

      Navigator.of(context).push(route);
    };

    final contextText = NikuText("")..fontSize(16);

    final renameCollection = () {
      Navigator.of(context).pop();

      showInputDialog(
        context,
        title: "Rename Collection",
        label: "New name",
        confirmation: "Rename",
        callback: (title) async {
          if (await isPersistCollectionExists(title))
            return showAlertDialog(
              context,
              title: "This collection already exists",
              content:
                  "$title is already exists. Please use another collection name",
            );

          if (title.trim().length < 1)
            return showAlertDialog(
              context,
              title: "Invalid name",
              content: "Collection name must have at least one character",
            );

          memoData.renameCollection(pageIndex, title);
        },
      );
    };

    final removeCollection = () {
      Navigator.of(context).pop();

      showDeleteDialog(
        context,
        title: "Delete Collection",
        content: "Are you sure you want to delete collection?",
        callback: () {
          memoData.removeCollection(pageIndex);
        },
      );
    };

    return CupertinoContextMenu(
      child: NikuStack([
        NikuText(memoCollection.title)
            .color(Colors.white)
            .fontSize(28)
            .bold()
            .niku()
            .center()
            .build(),
        NikuColumn([
          NikuText("${memoCollection.progress}/${memoCollection.total}")
              .color(Colors.white)
              .fontSize(14)
              .bold()
              .niku()
              .mb(8)
              .build(),
          Progress(progress: memoCollection.progress / memoCollection.total),
        ]).justifyEnd().itemsCenter().niku().p(20).build(),
      ])
          .niku()
          .inkwell(
            splash: Colors.transparent,
            highlight: Colors.transparent,
            onTap: pushMemoPage,
          )
          .material(color: Colors.transparent)
          .boxDecoration(
            BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  const Color(0xFF2f80ed),
                  const Color(0xFF56ccf2),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          )
          .aspectRatio(1)
          .rounded(16)
          .shadows(
        [
          BoxShadow(
            color: Color(0x6643bcef),
            offset: Offset(0, 25),
            blurRadius: 50,
          ),
        ],
      ).build(),
      actions: <Widget>[
        CupertinoContextMenuAction(
          child: NikuText("Rename").style(contextText),
          trailingIcon: CupertinoIcons.pencil,
          onPressed: renameCollection,
        ),
        CupertinoContextMenuAction(
          child: NikuText("Delete").style(contextText),
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
          onPressed: removeCollection,
        ),
      ],
    );
  }

  static Future<Widget> buildMemoPage({
    int pageIndex,
    MemoCollection memoCollection,
  }) =>
      Future.microtask(
        () => MemoPage(
          pageIndex: pageIndex,
        ),
      );
}
