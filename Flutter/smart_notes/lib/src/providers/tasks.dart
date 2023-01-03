import 'package:flutter/foundation.dart';

import '../models/task_model.dart';

class Tasks with ChangeNotifier {
  final List<Task> _tasks = [
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
    Task(text: "This a Test", tags: "Test, Test, Test", id: 0),
  ];
  final List<String> _tags = [
    "Gym",
    "Work",
    "Reminder",
    "Meditation",
    "criminal activity",
    "lame jokes",
    "stupid ideas",
  ];

  final List<String> _enabledTags = [];

  List<String> get enabledTags {
    return [..._enabledTags];
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
    return [..._tasks];
  }

  void addTask(Task value) {
    _tasks.add(value);
    notifyListeners();
  }

  List<String> get tags {
    return [..._tags.toSet().toList()];
  }

  void assignTags() {
    List<String> tagsList = [];
    for (var element in _tasks) {
      var tagsString = element.tags;
      tagsList.addAll(splitTags(tagsString));
    }

    _tags.addAll(tagsList);
  }

  // Converts comma separated string into a list
  List<String> splitTags(String tags) {
    final splitTags = tags.split(",");
    // final List<String> myTags = [];
    // for (int i = 0; i < splitTags.length; i++) {
    //   myTags.add(splitTags[i]);
    // }

    return splitTags;
  }
}
