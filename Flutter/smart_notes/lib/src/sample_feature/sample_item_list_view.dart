import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Items'),
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.invert_colors_on_sharp), Text("Water")],
              ),
              const Flexible(
                child: SizedBox(
                  height: 50,
                  child: Text("Please enter your tasks"),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 150,
                  width: 300,
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusColor: Colors.pink[700]?.withOpacity(0.2),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                      filled: true,
                      fillColor: Colors.pink[700]?.withOpacity(0.75),
                      hintText: "Suggestion: Cook pancakes tomorrow",
                    ),
                  ),
                ),
              )
            ],
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
