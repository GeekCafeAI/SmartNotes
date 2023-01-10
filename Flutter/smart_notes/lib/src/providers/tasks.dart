import 'package:flutter/foundation.dart';

import '../models/task_model.dart';

final Note myNote = Note(
    id: 2,
    userId: "Testing",
    status: "Testing",
    text: "Test",
    tags: "test, test, test",
    createdAt: "test",
    updatedAt: "test");

final Task myTask = Task(message: "This is a test", note: myNote);

class Tasks with ChangeNotifier {
  final List<Task> _tasks = [
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask,
    myTask
  ];

  final List<String> _tags = [
    "Gym",
    "Task",
    "Reminder",
    "goal",
    "Recurring",
    "Gym1",
    "Task1",
    "Reminder1",
    "goal1",
    "Recurring1",
    "Gym2",
    "Task2",
    "Reminder2",
    "goal2",
    "Recurring2",
    "Gym12",
    "Task12",
    "Reminder12",
    "goal12",
    "Recurring12",
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
    for (var element in _tasks) {
      var tagsList = element.note.tags.split(",");
      _tags.addAll(tagsList);
    }
  }
}
