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
              TitlePanel(),
              FilterSearchPanel(),
              TasksList(),
            ],
          );
        },
      ),
    );
  }
}

class FilterSearchPanel extends StatelessWidget {
  const FilterSearchPanel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepPurple.shade300,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4, left: 4, right: 4),
                child: TextField(
                    decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).primaryColor.withOpacity(0.7),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const FiltersWrap(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitlePanel extends StatefulWidget {
  const TitlePanel({
    Key? key,
  }) : super(key: key);

  @override
  State<TitlePanel> createState() => _TitlePanelState();
}

class _TitlePanelState extends State<TitlePanel> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      )),
      floating: true,
      title: const Text(
        "Your Tasks",
        textScaleFactor: 1.5,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
                color: Colors.deepPurple, shape: BoxShape.circle),
            child: const Icon(
              Icons.search,
            ),
          ),
        )
      ],
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Wrap(
        spacing: 2,
        runSpacing: -10,
        children: List.generate(
            tags.length,
            (index) => FilterChip(
                backgroundColor: Colors.black.withOpacity(0.7),
                label: Text(tags[index]),
                checkmarkColor: Colors.white,
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
