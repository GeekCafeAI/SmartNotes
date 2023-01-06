import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  bool showWidget = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          showWidget
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      child: const Icon(Icons.ac_unit),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: const Icon(Icons.accessible),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: const Icon(Icons.backpack),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: const Icon(Icons.cached),
                    ),
                  ],
                )
              : Container(),
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
        ],
      ),
    );
  }
}
