import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/providers/tasks.dart';

import '../models/task_model.dart';
import 'menu_screen.dart';

class TasksScreen extends StatefulWidget {
  static const routeName = '/tasks';

  const TasksScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: const [
        MenuScreen(),
        TasksPage()
      ],
    );
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({
    Key? key,
  }) : super(key: key);


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
