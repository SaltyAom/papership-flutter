import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:niku/niku.dart';

import '../atoms/atoms.dart' show Progress;
import '../../models/models.dart' show DetailedMemoCollection, Memo;
import '../../stores/stores.dart' show MemoData;

final memoFallback = Memo(
  title: "All done",
  detail: "",
  done: true,
);

final getMemoFallback = () => memoFallback;

class MemoProgress extends StatelessWidget {
  const MemoProgress({
    Key key,
    this.pageIndex,
  }) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final memoData = Provider.of<MemoData>(context);
    final memoCollection = memoData.detailedMemoCollections[pageIndex];

    return NikuRow([
      Icon(
        Icons.playlist_add_check_rounded,
        color: Colors.blue,
      )
          .niku()
          .size(42, 42)
          .boxDecoration(
            BoxDecoration(
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(42),
              ),
            ),
          )
          .build(),
      NikuColumn([
        NikuRow([
          NikuText(getPendingTask(memoCollection))
              .fontSize(16)
              .color(Colors.blue)
              .w600()
              .niku()
              .mb(4)
              .build(),
          NikuText("${memoCollection.progress}/${memoCollection.total}")
              .fontSize(16)
              .color(Colors.blue)
              .w600()
              .niku()
              .mb(4)
              .build(),
        ]).spaceBetween().itemsStart().niku().build(),
        Progress(
          progress: memoCollection.progress / memoCollection.total,
          color: Colors.blue,
          background: Colors.blue.withOpacity(.1),
        )
      ])
          .justifyCenter()
          .itemsStart()
          .niku()
          .height(42)
          .pl(16)
          .expanded()
          .build(),
    ]).justifyStart().itemsStart().niku().fullWidth().height(42).my(20).build();
  }

  String getPendingTask(DetailedMemoCollection memoCollection) =>
      memoCollection.memo
          .firstWhere(
            (element) => element.done == false,
            orElse: getMemoFallback,
          )
          .title;
}
