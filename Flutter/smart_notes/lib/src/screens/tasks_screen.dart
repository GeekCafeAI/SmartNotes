import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/providers/tasks.dart';

import '../models/task_model.dart';
import '../settings/settings_controller.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  static const routeName = '/tasks';
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context, listen: true);
    final tasks = tasksData.items;
    return Scaffold(
      appBar: AppBar(),
      extendBody: true,
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              MaterialButton(onPressed: () {
                tasksData.addTask(
                  Task(id: 5, tags: "Test", text: "Test"),
                );
              }),
              Flexible(
                child: ListView.builder(
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
