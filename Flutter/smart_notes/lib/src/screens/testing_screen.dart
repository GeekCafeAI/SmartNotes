import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_notes/src/screens/tasks_screen.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  bool showWidget = false;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          showWidget
              ? expanded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const FiltersWrap(),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                          child: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 300,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: FiltersWrap()),
                        ),
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                          child: const Icon(
                            Icons.expand_circle_down_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
              : Container(
                  color: Colors.purpleAccent,
                  child: const Text('This widget is Collapsed'),
                ),
          MaterialButton(
            onPressed: () {
              setState(() {
                showWidget = !showWidget;
              });
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: const Icon(
              Icons.expand_circle_down_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
