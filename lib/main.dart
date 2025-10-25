// flutter libraries
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:student_health_tracker/Settings/settings.dart';
import 'package:student_health_tracker/map_page/map_page.dart';
import 'package:student_health_tracker/chat/chat.dart';

// in project pages
import 'package:student_health_tracker/global_content/static_content/custom_themes.dart';
import 'package:student_health_tracker/notification_center/notification_center.dart';
import 'package:student_health_tracker/notification_center/notification_page_router.dart';
import 'package:student_health_tracker/startup/splash_page.dart';
import 'global_content/dynamic_content/database.dart';
import 'global_content/dynamic_content/stream_signal.dart';
import 'package:student_health_tracker/startup/home_page.dart';

/*
Dart entrypoint for app.
Initializes app, and selects page to run.
In addition, initializes supabase instance for the whole application.

also is the dart entrypoint (for android studio setup).
 */

// Main Stream Controller for the application
final StreamController<StreamSignal> mainStream =
    StreamController<StreamSignal>();

Future<void> main() async {
  // set orientation to up
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // wait for local storage to init
  await initLocalStorage();

  // init supabase (database for the project)
  await DataBase.init();

  // ensure stream signal is started
  if (!mainStream.hasListener) {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application
  // inits the app, starts everything
  @override
  Widget build(BuildContext context) {
    // streambuilder helps with dynamic content
    return StreamBuilder(
        stream: mainStream.stream,
        initialData: StreamSignal(streamController: mainStream, newData: {
          'theme': localStorage.getItem('theme') ?? CustomThemes.mainTheme,
        }),
        builder: (context, snapshot) {
          // return app
          return MaterialApp(
              title: 'Student Health Tracker',
              theme: CustomThemes.themeData[snapshot.data?.data['theme']] ??
                  CustomThemes.mainTheme,
              home: FutureBuilder(
                  future: DataBase.init(),
                  builder: (context, snapshot) {
                    // starting page of the application
                    // set to splashpage
                    return const HomePage();
                  }));
        });
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, overflow: TextOverflow.fade),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}
