import 'package:flutter/material.dart';

import 'package:niku/niku.dart';

import '../molecules/memoCard.dart';

import 'package:papership/models/memo.dart' show MemoCollection;

class MemoCardPage extends StatelessWidget {
  const MemoCardPage(
      {Key key, @required this.memoCollection, @required this.pageIndex})
      : super(key: key);

  final MemoCollection memoCollection;
  final int pageIndex;

  @override
  build(context) {
    return NikuStack([
      MemoCard(
        memoCollection: memoCollection,
        pageIndex: pageIndex,
      ),
    ]).center().niku().p(8).pb(56).build();
  }
}
