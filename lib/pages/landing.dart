import 'package:flutter/material.dart';
import 'package:papership/models/memo.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:provider/provider.dart';

import 'package:niku/niku.dart';

import '../components/components.dart'
    show MemoCardPage, showInputDialog, showAlertDialog;

import '../stores/stores.dart' show MemoData;

import '../services/services.dart'
    show getPersistCollections, isPersistCollectionExists;

class Landing extends HookWidget {
  const Landing({Key key}) : super(key: key);

  @override
  build(context) {
    final memoData = Provider.of<MemoData>(context);

    final persistedCollection = getPersistCollections();

    final newCollection = (title) async {
      if (await isPersistCollectionExists(title))
        return showAlertDialog(
          context,
          title: "This collection already exists",
          content:
              "$title is already exists. Please use another collection name",
        );

      memoData.newCollection(
        DetailedMemoCollection(
          title: title,
          detail: '',
          memo: [],
        ),
      );
    };

    final promptNewCollection = () {
      showInputDialog(
        context,
        title: 'New Collection',
        label: "Collection",
        callback: newCollection,
      );
    };

    useEffect(() {
      final handle = () async {
        final memoCollection = await persistedCollection;

        memoData.set(memoCollection);
      };

      handle();

      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: NikuText("Papership").fontSize(18).w600().build(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: promptNewCollection,
      ),
      body: FutureBuilder(
        future: persistedCollection,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator().niku().center().build();

          if (memoData.detailedMemoCollections.length == 0)
            return NikuColumn([
              NikuButton(
                NikuText("New memo").fontSize(16).build(),
              ).onPressed(promptNewCollection).p(16).build(),
            ]).justifyCenter().niku().center().build();

          return NikuStack(
            [
              PageView.builder(
                controller: PageController(
                  initialPage: 0,
                  viewportFraction: .85,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: memoData.detailedMemoCollections.length,
                itemBuilder: (context, index) => MemoCardPage(
                  memoCollection: memoData.detailedMemoCollections[index],
                  pageIndex: index,
                ),
              )
            ],
          ).niku().fullSize().build();
        },
      ),
    );
  }
}
