import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/providers/tasks.dart';

import '../models/task_model.dart';

// class TasksScreen extends StatefulWidget {
//   static const routeName = '/tasks';
//
//   const TasksScreen({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _TasksScreenState createState() => _TasksScreenState();
// }
//
// class _TasksScreenState extends State<TasksScreen> {
//   final PageController _controller = PageController(
//     initialPage: 0,
//   );
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller: _controller,
//       children: const [MenuScreen(), TasksPage()],
//     );
//   }
//
//   final _filters = [];
// }

class TasksScreen extends StatefulWidget {
  TasksScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();

  static const routeName = '/tasks';
  final _filters = [];
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context, listen: true);
    final tasks = tasksData.items;
    final tags = tasksData.tags;

    return Scaffold(
      appBar: AppBar(
        excludeHeaderSemantics: false,
        backgroundColor: Colors.black.withOpacity(0.5),
        title: const Text('List of your tasks'),
      ),
      extendBody: true,
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              Flexible(child: FiltersWrap(tags: tags)),
              Flexible(child: TasksList(tasks: tasks)),
            ],
          );
        },
      ),
    );
  }
}

class FiltersWrap extends StatefulWidget {
  const FiltersWrap({
    Key? key,
    required this.tags,
  }) : super(key: key);

  final List<String> tags;

  @override
  State<FiltersWrap> createState() => _FiltersWrapState();
}

class _FiltersWrapState extends State<FiltersWrap> {
  final List<String> _filters = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2,
      runSpacing: -10,
      children: List.generate(
          widget.tags.length,
          (index) => FilterChip(
              label: Text(widget.tags[index]),
              selected: _filters.contains(widget.tags[index]),
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _filters.add(widget.tags[index]);
                  } else {
                    _filters.removeWhere((title) {
                      return title == widget.tags[index];
                    });
                  }
                });
              })),
    );
  }
}

class TasksList extends StatelessWidget {
  const TasksList({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: tasks.length,
      itemBuilder: (context, itemListIndex) {
        return Card(
          child: ListTile(
            textColor: Colors.black,
            title: Text(tasks[itemListIndex].text),
            subtitle: Text(
              tasks[itemListIndex].tags,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}
