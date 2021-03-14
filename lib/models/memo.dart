import 'package:flutter/material.dart' show required;

class MemoCollection {
  String title;
  String detail;
  int progress;
  int total;

  MemoCollection({
    @required this.title,
    @required this.detail,
    @required this.progress,
    @required this.total,
  });
}

class Memo {
  String title;
  String detail;
  bool done;

  Memo({@required this.title, @required this.detail, this.done = false});

  Map<String, dynamic> toMap(String reference) {
    return {
      'reference': reference,
      'title': title,
      'detail': detail,
      'done': done ? 1 : 0,
    };
  }
}

class DetailedMemoCollection extends MemoCollection {
  List<Memo> memo;

  DetailedMemoCollection({
    @required String title,
    @required String detail,
    @required this.memo,
  }) : super(
          title: title,
          detail: detail,
          progress: memo.where((element) => element.done == true).length,
          total: memo.length,
        );

  MemoCollection toCollection() {
    return MemoCollection(
      title: title,
      detail: detail,
      progress: progress,
      total: total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'detail': detail,
      'progress': progress,
      'total': total
    };
  }
}
