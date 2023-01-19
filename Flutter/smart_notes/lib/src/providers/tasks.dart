import 'dart:core';

import 'package:flutter/foundation.dart';

import '../models/task_model.dart';

// final Note myNote1 = Note(
//   id: 2,
//   userId: "Testing",
//   status: "Testing",
//   text: "Every year try something new",
//   tags: "goal, idea, recurring",
//   createdAt: "test",
//   updatedAt: "test",
// );
//
// final Note myNote2 = Note(
//   id: 2,
//   userId: "Testing",
//   status: "Testing",
//   text: "Bake a cake tomorrow",
//   tags: "baking, reminder, goal",
//   createdAt: "test",
//   updatedAt: "test",
// );
//
// final Note myNote3 = Note(
//   id: 2,
//   userId: "Testing",
//   status: "Testing",
//   text: "Build a robot",
//   tags: "goal, building",
//   createdAt: "test",
//   updatedAt: "test",
// );
//
// final Task task1 = Task(message: myNote1.text, note: myNote1);
// final Task task2 = Task(message: myNote2.text, note: myNote2);
// final Task task3 = Task(message: myNote3.text, note: myNote3);

class Tasks with ChangeNotifier {
  final List<Task> _notes = [];

  final List<String> _tags = [];

  final List<String> _enabledTags = [];
  final Map<String, List<Task>> _filteredNotes = {};
  List<Task> _filteredNotesList = [];

  void filterNotes() {
    for (int i = 0; i < _enabledTags.length; i++) {
      _filteredNotes[_enabledTags[i]] = _notes
          .where((element) => element.note.tags.contains(_enabledTags[i]))
          .toList();
    }
    print(_filteredNotes);
    print(enabledTags);
    addFiltersToList();
    notifyListeners();
  }

  void addFiltersToList() {
    List<Task> sortedNotes = [];

    for (List<Task> value in filteredNotes.values) {
      for (int i = 0; i < value.length; i++) {
        sortedNotes.add(value[i]);
      }
    }
    _filteredNotesList = sortedNotes.toSet().toList();
    notifyListeners();
  }

  List<Task> get filteredNotesList {
    return [..._filteredNotesList];
  }

  Map get filteredNotes {
    return _filteredNotes;
  }

  List<String> get enabledTags {
    return [..._enabledTags];
  }

  void removeFilter(String tag) {
    filteredNotes.removeWhere((key, value) => tag == key);
    filterNotes();
    notifyListeners();
  }

  void enableTag(String value) {
    _enabledTags.add(value);
    notifyListeners();
  }

  void disableTag(int index) {
    _enabledTags.removeWhere((title) {
      return title == tags[index];
    });
    notifyListeners();
  }

  List<Task> get tasks {
    return [..._notes];
  }

  void addTask(Task value) {
    _notes.add(value);
    notifyListeners();
  }

  List<String> get tags {
    return [..._tags.toSet().toList()];
  }

  void assignTags() {
    for (var element in _notes) {
      var tagsList = element.note.tags.split(",");
      _tags.addAll(tagsList);
    }
  }

  int compareTags(List<String> elementTags) {
    final allTags = [];
    allTags.addAll(_enabledTags);
    allTags.addAll(elementTags);

    final commonElements = allTags.fold<Set>(
      allTags.first.toSet(),
      (a, b) => a.intersection(b.toSet()),
    );

    final matchingTagsNum = commonElements.length;

    return matchingTagsNum;
  }
}
