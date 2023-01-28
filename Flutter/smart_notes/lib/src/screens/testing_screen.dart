import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/providers/local_storage.dart';

import '../models/hive_models/note.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  bool showWidget = false;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<HiveService>(context);

    database.loadData();

    void onPressed() => database.createItem(
          HiveNote(
            id: 3,
            userId: "",
            status: "",
            text: "this is a test",
            tags: "tag1, tag2, tag3",
            createdAt: "",
            updatedAt: "",
          ),
        );

    final items = database.getItems();

    return Scaffold(
        appBar: AppBar(
          actions: [
            MaterialButton(
              onPressed: onPressed,
              color: Colors.purpleAccent,
              child: const Text("Add Note"),
            ),
            MaterialButton(
              child: const Icon(Icons.playlist_remove_outlined),
              onPressed: () => database.wipeData(),
            )
          ],
        ),
        body: FutureBuilder(
          future: items,
          builder: (context, snapshot) => ListView.builder(
            itemCount: snapshot.hasData ? snapshot.data?.length : 1,
            itemBuilder: (context, index) => ListTile(
              title: Text(snapshot.data?[index].text ?? "null"),
              subtitle: Text(snapshot.data?[index].tags.toString() ?? "null"),
            ),
          ),
        ));
  }
}
