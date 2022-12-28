import 'package:flutter/material.dart';
import 'package:smart_notes/src/data/tasks_list.dart';

import '../models/task_model.dart';
import '../settings/settings_controller.dart';

/// Displays detailed information about a SampleItem.

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key, required this.settingsController})
      : super(key: key);

  static const routeName = '/todos';
  final SettingsController settingsController;

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _filters = [];
  List<Task> _sortedTasksList = tasksAndTagsList;
  bool _tagsSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sortedTasksList;
  }

  var myListOfTags = tagsList.toSet().toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        excludeHeaderSemantics: false,
        backgroundColor: Colors.black.withOpacity(0.5),
        title: const Text('List of your tasks'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Wrap(
              spacing: 2,
              runSpacing: -10,
              children: List.generate(
                  myListOfTags.length,
                  (index) => FilterChip(
                      label: Text(myListOfTags[index]),
                      selected: _filters.contains(myListOfTags[index]),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _filters.add(myListOfTags[index]);
                            _sortedTasksList =
                                sortTasks(_filters, _sortedTasksList);
                          } else {
                            _filters.removeWhere((title) {
                              _sortedTasksList =
                                  sortTasks(_filters, _sortedTasksList);
                              return title == myListOfTags[index];
                            });
                          }
                        });
                      })),
            ),
          ),
          Builder(
            builder: (context) {
              return Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: _sortedTasksList.length,
                  itemBuilder: (context, itemListIndex) {
                    return Card(
                      child: ListTile(
                        textColor: Colors.black,
                        title: Text(_sortedTasksList[itemListIndex].text),
                        subtitle: Text(
                          _sortedTasksList[itemListIndex].tags,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

List<Task> sortTasks(List<dynamic> filters, List<Task> items) {
  if (filters.isEmpty) {
    return tasksAndTagsList;
  }

  var it = items.iterator;
  int filterMatches = 0;
  List<List<Task>> sorted = [[], [], [], []];

  while (it.moveNext()) {
    var currentObject = it.current;
    var currentTags = currentObject.getTagsAsList();

    for (int index = 0; index < filters.length; index++) {
      var currentFilter = filters[index];

      if (currentTags.contains(currentFilter)) {
        filterMatches++;
      }
    }

    switch (filterMatches) {
      case 3:
        sorted[0].add(currentObject);
        break;
      case 2:
        sorted[1].add(currentObject);
        break;
      case 1:
        sorted[2].add(currentObject);
        break;
      case 0:
        sorted[3].add(currentObject);
        break;
    }
  }

  // flattens the nested list to be returned as regular list
  var flatSorted = sorted.expand((element) => element).toList();
  return flatSorted;
}
