import 'package:flutter/material.dart';

import '../models/models.dart' show DetailedMemoCollection, Memo;

import '../services/services.dart'
    show
        newPersistCollection,
        newPersistMemo,
        removePersistsMemo,
        savePersistMemoState,
        renamePersistCollection,
        removePersistCollection;

class MemoData with ChangeNotifier {
  List<DetailedMemoCollection> _detailedMemoCollection = [
    DetailedMemoCollection(
      title: "Work",
      detail: "Sleep",
      memo: [
        Memo(title: "Hello World", detail: "Hi", done: true),
        Memo(title: "Memo", detail: "", done: true),
      ],
    ),
    DetailedMemoCollection(
      title: "Work",
      detail: "Sleep",
      memo: [
        Memo(title: "Hello World", detail: "Hi", done: true),
        Memo(title: "Memo", detail: "", done: true),
      ],
    ),
    DetailedMemoCollection(title: "Niku", detail: "", memo: []),
    DetailedMemoCollection(title: "Expense", detail: "", memo: []),
  ];

  List<DetailedMemoCollection> get detailedMemoCollections =>
      _detailedMemoCollection;

  void toggleDone(int collectionIndex, int memoIndex) {
    final collection = _detailedMemoCollection[collectionIndex];
    final memo = collection.memo[memoIndex];

    final toggled = !memo.done;

    memo.done = toggled;

    savePersistMemoState(
      collection.title,
      Memo(
        title: memo.title,
        detail: memo.detail,
        done: toggled,
      ),
    );

    if (toggled)
      collection.progress++;
    else
      collection.progress--;

    notifyListeners();
  }

  void removeMemo(int collectionIndex, int memoIndex) {
    final collection = _detailedMemoCollection[collectionIndex];
    final memo = collection.memo[memoIndex];

    final isDone = memo.done;

    collection.memo.removeAt(memoIndex);

    removePersistsMemo(collection.title, memo);

    if (isDone) collection.progress--;

    collection.total--;

    notifyListeners();
  }

  set(List<DetailedMemoCollection> collection) {
    _detailedMemoCollection = collection;

    notifyListeners();
  }

  void newCollection(DetailedMemoCollection memoCollection) {
    _detailedMemoCollection.add(memoCollection);

    newPersistCollection(memoCollection);

    notifyListeners();
  }

  void newMemo(int collectionIndex, Memo memo) {
    final collection = _detailedMemoCollection[collectionIndex];

    collection.memo.add(memo);
    collection.total++;

    newPersistMemo(collection.title, memo);

    notifyListeners();
  }

  void renameCollection(int collectionIndex, String title) {
    final collection = _detailedMemoCollection[collectionIndex];

    renamePersistCollection(
      DetailedMemoCollection(
        title: collection.title,
        detail: collection.detail,
        memo: collection.memo,
      ),
      title,
    );

    collection.title = title;

    notifyListeners();
  }

  void removeCollection(int collectionIndex) {
    final collection = _detailedMemoCollection[collectionIndex];

    removePersistCollection(collection.title.toString());

    _detailedMemoCollection.removeAt(collectionIndex);

    notifyListeners();
  }
}
