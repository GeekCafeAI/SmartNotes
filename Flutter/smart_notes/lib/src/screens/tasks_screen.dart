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
      extendBody: true,
      body: Builder(
        builder: (context) {
          return const CustomScrollView(
            slivers: [
              Flexible(
                  child: SliverAppBar(
                bottom: PreferredSize(
                    preferredSize: Size(double.infinity, 150),
                    child: FiltersWrap()),
              )),
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
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Tasks>(context);
    final tasks = taskData.tasks;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: tasks.length,
        (context, index) => Card(
          child: ListTile(
            textColor: Colors.black,
            title: Text(tasks[index].text),
            subtitle: Text(
              tasks[index].tags,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }
}
