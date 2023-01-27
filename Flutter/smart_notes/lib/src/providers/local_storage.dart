import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/note.dart';

class HiveService extends ChangeNotifier {
  List _notes = [];
  final _myBox = Hive.box('notes');

  // Create note
  Future<void> createItem(HiveNote note) async {
    await _myBox.add(note);
    _notes.add(note);
    notifyListeners();
  }

  // load data from database
  void loadData() {
    _notes = _myBox.values.toList();
  }

  void wipeData() {
    _myBox.clear();
    notifyListeners();
  }

  // Get notes
  Future<List<HiveNote>> getItems() async {
    return [..._notes];
  }

  // remove a note
  void removeItem(HiveNote note) {
    _notes.removeAt(0);
    updateDataBase();
    notifyListeners();
  }

  void updateDataBase() {
    _myBox.put('notes', _notes);
  }
}
