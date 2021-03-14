import 'package:flutter/widgets.dart';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

import '../models/memo.dart' show DetailedMemoCollection, Memo;

Future<Database> Function() databaseInstance = () async {
  WidgetsFlutterBinding.ensureInitialized();

  return openDatabase(
    join(await getDatabasesPath(), 'memo.db'),
    version: 1,
    onConfigure: (database) async {
      await database.execute('PRAGMA foreign_keys = ON');
    },
    onCreate: (db, version) async {
      await db.execute(
        """
        CREATE TABLE memo_collection (
          title     TEXT      PRIMARY KEY,
          detail    TEXT      DEFAULT '',
          progress  INTEGER   NOT NULL,
          total     INTEGER   NOT NULL
        );
      """,
      );

      await db.execute(
        """
        CREATE TABLE memo (
          reference TEXT      NOT NULL,
          title     TEXT      NOT NULL,
          detail    TEXT      DEFAULT '',
          done      INTEGER   DEFAULT 0,
          FOREIGN KEY(reference) REFERENCES memo_collection(title)
        );
        """,
      );
    },
  );
};

Future<List<DetailedMemoCollection>> getPersistCollections() async {
  final database = await databaseInstance();

  final List<Map<String, dynamic>> memoCollections =
      await database.query('memo_collection');

  final List<Map<String, dynamic>> memos = await database.query('memo');

  List<DetailedMemoCollection> detailedMemoCollection =
      List.generate(memoCollections.length, (index) {
    final collection = memoCollections[index];

    final memo = memos
        .where(
          (memo) => memo['reference'] == collection['title'],
        )
        .map(
          (memo) => Memo(
            title: memo['title'],
            detail: memo['detail'],
            done: memo['done'] == 1 ? true : false,
          ),
        )
        .toList();

    return DetailedMemoCollection(
      title: collection['title'],
      detail: collection['detail'],
      memo: memo,
    );
  });

  return detailedMemoCollection;
}

Future<void> newPersistCollection(DetailedMemoCollection collection) async {
  final database = await databaseInstance();

  await database.insert(
    'memo_collection',
    collection.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> newPersistMemo(String reference, Memo memo) async {
  final database = await databaseInstance();

  await database.insert(
    'memo',
    memo.toMap(reference),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> removePersistsMemo(String reference, Memo memo) async {
  final database = await databaseInstance();

  await database.delete(
    'memo',
    where: 'title = ? AND reference = ?',
    whereArgs: [memo.title, reference],
  );
}

Future<void> savePersistMemoState(String reference, Memo memo) async {
  final database = await databaseInstance();

  await database.update(
    'memo',
    memo.toMap(reference),
    where: 'title = ? AND reference = ?',
    whereArgs: [memo.title, reference],
  ).catchError((error) {
    print(error);
  });
}

Future<bool> isPersistCollectionExists(String memoTitle) async {
  final database = await databaseInstance();

  final List<Map<String, dynamic>> table = await database.rawQuery(
    """
    SELECT
      count(*)
    FROM
      memo_collection
    WHERE
      title = ?
  """,
    [memoTitle],
  );

  final count = Sqflite.firstIntValue(table);

  return count > 0;
}

Future<void> renamePersistCollection(
  DetailedMemoCollection collection,
  String newTitle,
) async {
  final database = await databaseInstance();

  await database.execute("PRAGMA foreign_keys=OFF");

  database.transaction((transaction) async {
    await transaction.rawUpdate(
      """
        UPDATE 
          memo 
        SET 
          reference = ?
        WHERE
          reference = ?
      """,
      [newTitle, collection.title],
    );

    await transaction.update(
      'memo_collection',
      DetailedMemoCollection(
        title: newTitle,
        detail: collection.detail,
        memo: collection.memo,
      ).toMap(),
      where: 'title = ?',
      whereArgs: [collection.title],
    );

    await transaction.execute("PRAGMA foreign_keys=ON");
  });
}

Future<void> removePersistCollection(String title) async {
  final database = await databaseInstance();

  await database.execute("PRAGMA foreign_keys=OFF");

  database.transaction((transaction) async {
    await transaction.delete(
      'memo_collection',
      where: 'title = ?',
      whereArgs: [title],
    );

    await transaction.delete(
      'memo',
      where: 'reference = ?',
      whereArgs: [title],
    );

    await transaction.execute("PRAGMA foreign_keys=ON");
  });
}
