import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/models/task_model.dart';
import 'package:smart_notes/src/providers/tasks.dart';
import 'package:smart_notes/src/repositories/task_service.dart';
import 'package:smart_notes/src/screens/settings_view.dart';

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
  final _deviceData = <String?>{};
  final background = const AssetImage("assets/images/backgrounds/00012.png");
  bool _buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    var snackBar = const SnackBar(
      content: Text('Task was added :)'),
    );

    final tasksProvider = Provider.of<Tasks>(context);
    tasksProvider.assignTags();

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          )),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.25),
          title: const Text('Main Menu', textScaleFactor: 1.5),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: background, fit: BoxFit.fill)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 30,
                  child: SizedBox(
                    height: 175,
                    width: 300,
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          _textController.text.isNotEmpty
                              ? _buttonEnabled = true
                              : _buttonEnabled = false;
                        });
                      },
                      controller: _textController,
                      maxLines: null,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _textController.clear();
                                setState(() => _buttonEnabled = false);
                              },
                              icon: const Icon(Icons.clear)),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          filled: true,
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.25),
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
                        color: Theme.of(context).primaryColor.withOpacity(0.25),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: _buttonEnabled
                            ? () {
                                createEntry(_textController.text, "Testing1")
                                    .then((result) {
                                  Task newTask = Task(
                                    note: result.note,
                                    message: _textController.text,
                                  );
                                  // insertNote(newTask.note);
                                  tasksProvider.addTask(newTask);
                                  tasksProvider.assignTags();
                                  _textController.clear();
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            : null,
                        child: const Center(child: Text('Submit')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
