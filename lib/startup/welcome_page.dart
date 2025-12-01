// packages
import 'package:flutter/material.dart';
import 'package:student_health_tracker/main.dart';
import 'package:student_health_tracker/startup/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// pages
import '../globals/database.dart';
import '../globals/static/custom_themes.dart';
import '../globals/static/global_methods.dart';
import '../globals/static/global_widgets.dart';
import 'home_page.dart';
import 'login_page.dart';

/*
Main page for logins.

Sign in, sign up, or sign in as a guest.

 */
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ColorScheme colorScheme = CustomThemes.mainTheme.colorScheme;

    return Scaffold(
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: colorScheme.tertiary,
            gradient: RadialGradient(
                radius: 1,
                colors: [colorScheme.primary, colorScheme.tertiary])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: mediaQuery.size.width,
              height: mediaQuery.size.width,
              child: Image.asset('assets/image/logo2.png'),
            ),
            const SizedBox(height: 25),
            const Text("Create an account, sign in, or continue as a guest."),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                GlobalMethods.launchURL("https://flutter.dev");
              },
              child: Text(
                "Read Terms and Conditions",
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    GlobalWidgets.swipePage(const Login(), appBar: true));
              },
              style: ElevatedButton.styleFrom(
                  side: BorderSide(color: colorScheme.onSurface, width: 1),
                  fixedSize: Size(mediaQuery.size.width * 2 / 3, 50),
                  backgroundColor: colorScheme.secondary),
              child: Text('Sign In',
                  style: TextStyle(
                      fontFamily: 'Pridi',
                      fontSize: 20,
                      color: colorScheme.onSecondary)),
            ),
            SizedBox(
              width: mediaQuery.size.width / 2,
              height: 25,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child:
                      Container(height: 2.5, color: colorScheme.onSurface)),
                  Text(" or ",
                      style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 17,
                          height: 0.5,
                          fontFamily: 'ProstoOne')),
                  Expanded(
                      child:
                      Container(height: 2.5, color: colorScheme.onSurface)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, GlobalWidgets.swipePage(const Signup(), appBar: true));
              },
              style: ElevatedButton.styleFrom(
                  side: BorderSide(color: colorScheme.onSurface, width: 1),
                  fixedSize: Size(mediaQuery.size.width * 2 / 3, 50),
                  backgroundColor: colorScheme.primary),
              child: Text('Create Account',
                  style: TextStyle(
                      fontFamily: 'Pridi',
                      fontSize: 20,
                      color: colorScheme.onPrimary)),
            ),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  _signUpAnon(context);
                },
                child: Text(
                  "Continue as Guest",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: colorScheme.onPrimary,
                      decorationColor: colorScheme.onPrimary,
                      fontFamily: "Pridi",
                      fontWeight: FontWeight.w400,
                      fontSize: 17),
                ))
          ],
        ),
      ),
    );
  }

  // guest sign in
  Future<void> _signUpAnon(BuildContext context) async {
    try {
      await supabase.auth.signInAnonymously();
      await DataBase.init();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      }
    } on AuthException catch (error) {
      if (context.mounted) {
        context.showSnackBar(error.message);
      }
    }
  }

}
