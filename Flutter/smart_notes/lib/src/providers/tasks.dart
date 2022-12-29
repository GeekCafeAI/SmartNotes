import 'package:flutter/foundation.dart';

import '../models/task_model.dart';

class Tasks with ChangeNotifier {
  final List<Task> _items = [];

  List<Task> get items {
    return [..._items];
  }

  void addTask(Task value) {
    _items.add(value);
    notifyListeners();
  }
}
