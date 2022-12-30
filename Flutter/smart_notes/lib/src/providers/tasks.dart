import 'package:flutter/foundation.dart';

import '../models/task_model.dart';

class Tasks with ChangeNotifier {
  final List<Task> _items = [];
  final List<String> _tags = [];

  List<Task> get items {
    return [..._items];
  }

  List<String> get tags {
    return [..._tags.toSet().toList()];
  }

  void addTask(Task value) {
    _items.add(value);
    notifyListeners();
  }

  void assignTags() {
    List<String> tagsList = [];
    for (var element in _items) {
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
