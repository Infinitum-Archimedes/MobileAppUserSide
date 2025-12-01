// packages
import 'package:flutter/material.dart';
import 'package:student_health_tracker/startup/welcome_page.dart';

// pages
import '../globals/database.dart';
import '../globals/static/static_pages/static_load.dart';
import 'home_page.dart';

/*
Page to redirect users to the appropriate page depending on the initial auth state.
- Ensures auth, if not, forces auth, which improves security. Also allows for RLS to be implemented properly.

Pushes users to app if have a current session, otherwise, need to go to login / sign in page

Page is called in main

 */

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  // redirects based on auth state
  Future<void> _redirect() async {

    // await for for the widget to mount
    await Future.delayed(Duration.zero);

    // get session from supabase
    final session = supabase.auth.currentSession;

    if (session == null) {
      if(mounted){
        Navigator.of(context)
            .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false);
      }
    } else {
      await DataBase.init();
      if(mounted){
        Navigator.of(context)
            .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StaticLoad();
  }

}