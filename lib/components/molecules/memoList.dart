import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../stores/stores.dart' show MemoData;

class MemoList extends StatelessWidget {
  const MemoList({
    Key key,
    @required this.pageIndex,
  }) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final memoData = Provider.of<MemoData>(context);
    final memoCollection = memoData.detailedMemoCollections[pageIndex];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: memoCollection.memo.length,
      itemBuilder: (context, index) {
        final memo = memoCollection.memo[index];

        return Dismissible(
          key: ObjectKey(memo.title),
          onDismissed: (direction) {
            memoData.removeMemo(pageIndex, index);
          },
          child: CheckboxListTile(
            title: Text(memo.title),
            value: memo.done,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (checked) {
              memoData.toggleDone(pageIndex, index);
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
        );
      },
    );
  }
}
