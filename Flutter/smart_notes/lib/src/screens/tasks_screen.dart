import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/providers/tasks.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();

  static const routeName = '/tasks';
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Flexible(child: FiltersWrap()),
              Flexible(child: TasksList()),
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
  }) : super(key: key);

  @override
  State<FiltersWrap> createState() => _FiltersWrapState();
}

class _FiltersWrapState extends State<FiltersWrap> {
  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context, listen: true);
    final tags = tasksData.tags;
    final enabledTags = tasksData.enabledTags;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Wrap(
        spacing: 2,
        runSpacing: -10,
        children: List.generate(
            tags.length,
            (index) => FilterChip(
                label: Text(tags[index]),
                selected: enabledTags.contains(tags[index]),
                onSelected: (val) {
                  if (val) {
                    tasksData.enableTag(tags[index]);
                  } else {
                    tasksData.disableTag(index);
                  }
                })),
      ),
    );
  }
}

class TasksList extends StatelessWidget {
  const TasksList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Tasks>(context);
    final tasks = taskData.tasks;

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
