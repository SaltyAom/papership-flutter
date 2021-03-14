import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:niku/niku.dart';

import '../models/models.dart' show Memo;

import '../stores/stores.dart';

import '../components/components.dart'
    show MemoProgress, MemoList, showInputDialog;

class MemoPage extends StatelessWidget {
  const MemoPage({
    Key key,
    @required this.pageIndex,
  }) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final memoData = Provider.of<MemoData>(context, listen: false);
    final memoCollection = memoData.detailedMemoCollections[pageIndex];

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        actions: [
          NikuButton(
            NikuText(
              "Edit".toUpperCase(),
            ).build(),
          ).onPressed(() {}).fg(Colors.blue).build()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showInputDialog(
            context,
            title: "New Memo",
            label: "Memo",
            callback: (title) {
              memoData.newMemo(
                pageIndex,
                Memo(
                  title: title,
                  detail: '',
                ),
              );
            },
          );
        },
      ),
      body: NikuColumn([
        NikuText(memoCollection.title).fontSize(28).w600().build(),
        memoCollection.detail != ''
            ? NikuText(memoCollection.detail)
                .fontSize(16)
                .color(Colors.grey)
                .niku()
                .mt(4)
                .mb(8)
                .build()
            : SizedBox.shrink(),
        MemoProgress(pageIndex: pageIndex),
        MemoList(
          pageIndex: pageIndex,
        ),
      ])
          .justifyStart()
          .itemsStart()
          .niku()
          .px(32)
          .pt(32)
          .pb(64)
          .scrollable()
          .build(),
    );
  }
}
