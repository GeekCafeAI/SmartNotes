import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/providers/settings/settings_controller.dart';
import 'package:smart_notes/src/providers/widget_visibility.dart';
import 'package:smart_notes/src/screens/menu_screen.dart';
import 'package:smart_notes/src/screens/tasks_screen.dart';
import 'package:smart_notes/src/screens/testing_screen.dart';
import 'package:smart_notes/src/theme.dart';

import './providers/tasks.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  final PageController _controller = PageController(
    initialPage: 0,
  );

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<WidgetVisibility>(
                create: (_) => WidgetVisibility()),
            ChangeNotifierProvider<Tasks>(create: (_) => Tasks()),
          ],
          child: MaterialApp(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: myThemeLight,
            darkTheme: myThemeDark,
            themeMode: settingsController.themeMode,

            home: PageView(
              pageSnapping: true,
              controller: _controller,
              children: const [TestingScreen(), MenuScreen(), TasksScreen()],
            ),
          ),
        );
      },
    );
  }
}
