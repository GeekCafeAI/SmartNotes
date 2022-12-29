import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/data/tasks_list.dart';
import 'package:smart_notes/src/models/task_model.dart';
import 'package:smart_notes/src/providers/tasks.dart';
import 'package:smart_notes/src/repositories/task_service.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
  });

  static const routeName = '/';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // Future<String?> initPlatformState() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     var deviceData = await deviceInfo.iosInfo;
  //   } else if (Platform.isAndroid) {
  //     var deviceData = await deviceInfo.androidInfo;
  //   }
  //
  //   setState(() {
  //     _deviceData = _deviceData;
  //   });
  // }

  // FutureBuilder<Task> buildFutureBuilder() {
  //   return FutureBuilder<Task>(
  //       future: _userPost,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return Text(snapshot.data!.title);
  //         } else if (snapshot.hasError) {
  //           return Text('${snapshot.error}');
  //         }
  //
  //         return const CircularProgressIndicator();
  //       });
  // }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final _textController = TextEditingController();
  var _addedText;
  var _addedTags;
  final _deviceData = <String?>{};
  final menuBackground = const NetworkImage("https://picsum.photos/412/892/");

  void splitTags(String tags) {
    final splitTags = tags.split(",");
    for (int i = 0; i < splitTags.length; i++) {
      tagsList.add(splitTags[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var snackBar = const SnackBar(
      content: Text('Task was added :)'),
    );

    final tasksProvider = Provider.of<Tasks>(context);

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          excludeHeaderSemantics: false,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
          title: const Text('Main Menu'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: menuBackground, fit: BoxFit.fill)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("$_addedText - $_addedTags"),
                Flexible(
                  flex: 30,
                  child: SizedBox(
                    height: 175,
                    width: 300,
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _textController.clear();
                              },
                              icon: const Icon(Icons.clear)),
                          border: InputBorder.none,
                          // focusedBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(30),
                          //     borderSide:
                          //         const BorderSide(color: Colors.black45)),
                          // enabledBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(30),
                          //     borderSide:
                          //         const BorderSide(color: Colors.black)),
                          filled: true,
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                          hintText: "Enter Your Thought\n\n\n\n\n",
                          hintStyle: const TextStyle(decorationThickness: 200)),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        minWidth: 200,
                        height: 50,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: () {
                          createEntry(_textController.text).then((result) {
                            Task newTask = Task(
                              tags: result.tags,
                              text: result.text,
                              id: result.id,
                            );
                            tasksProvider.addTask(newTask);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Center(child: Text('Submit')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )

        // Navigate to the details page. If the user leaves and returns to
        // the app after it has been killed while running in the
        // background, the navigation stack is restored.
        // Navigator.restorablePushNamed(
        //   context,
        //   SampleItemDetailsView.routeName,
        );
  }
}
