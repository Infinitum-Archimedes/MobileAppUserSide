// packages
import 'package:flutter/material.dart';
import 'package:student_health_tracker/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// pages
import '../globals/database.dart';
import '../globals/static/custom_themes.dart';
import '../globals/static/global_methods.dart';
import '../globals/static/global_widgets.dart';
import 'home_page.dart';

/*
Register account page.
- From splash page, then creates account in supabase.
- also allows you to sign up anonymously
  - 'guest' session

 */

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final ColorScheme colorScheme = CustomThemes.mainTheme.colorScheme;

  String ppString = '';
  bool ppAgree = false;

  // text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _password2Focus = FocusNode();

  bool _confirmPassword(bool active) {
    if (_passwordController.text.isNotEmpty &&
        _password2Controller.text.isNotEmpty) {
      if (_passwordController.text == _password2Controller.text) {
        if (_passwordController.text.length >= 8) {
          if (RegExp(r'^[A-Za-z0-9_]{3,24}$')
              .hasMatch(_passwordController.text)) {
            return true;
          }
          if (active) {
            context.showSnackBar('Password must be alphanumeric.');
          }
        }
        if (active) {
          context.showSnackBar('Password must be at least 8 characters.');
        }
      }
      if (active) {
        context.showSnackBar('Passwords must match.');
      }
    }
    return false;
  }

  // send sign up to supabase
  Future<void> _signUp() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    try {
      await supabase.auth.signUp(email: email, password: password);
      await DataBase.init();
      if(mounted){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        context.showSnackBar(error.message);
      }
    }
  }

  Widget _buildTextForm(
      TextEditingController controller,
      FocusNode? focus,
      String text,
      bool obscuretext,
      TextInputType? input,
      void Function(String?) onSubmit) {
    return TextFormField(
      focusNode: focus,
      controller: controller,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
      obscureText: obscuretext,
      keyboardType: input,
    );
  }

  Widget _buildPP() {
    final ColorScheme colorScheme = CustomThemes.mainTheme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: ppAgree,
            activeColor: colorScheme.primary,
            checkColor: colorScheme.onPrimary,
            onChanged: (bool? value) {
              ppString =
              'Agreed to Privacy Policy on ${DateTime.now()}}';
              setState(() {
                ppAgree = value ?? false;
              });
            },
          ),
        ),
        Text(
          "I agree to ",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        TextButton(
          onPressed: () {
            GlobalMethods.launchURL("https://flutter.dev");
          },
          child: Text(
            "Privacy Policy",
            style: TextStyle(
              color: colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  bool autoprogress = false;
  int progress = 0;

  void tapAwayListener(FocusNode focusNode) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tapAwayListener(_nameFocus);
    tapAwayListener(_emailFocus);
    tapAwayListener(_passwordFocus);
    tapAwayListener(_password2Focus);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

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
        child: GlobalWidgets.progression(
            context: context,
            colorScheme: colorScheme,
            autoprogress: autoprogress,
            startPage: progress,
            endButton: (){
              _signUp();
            },
            methods: List<void Function()>.generate(3, (p) {
              return () {
                progress = p;
              };
            }),
            nextTexts: [
              'Continue',
              'Continue',
              'Register'
            ],
            conditions: [
                  (active) {
                if (supabase.auth.currentSession != null) {
                  return true;
                }
                if (_nameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty) {
                  return true;
                }
                if (active) {
                  context.showSnackBar('Name and eMail are required.');
                }
                return false;
              },
                  (active) {
                if (supabase.auth.currentSession != null) {
                  return true;
                }
                return _confirmPassword(active);
              },
                  (active) {
                return ppAgree;
              }
            ],
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 30,
                          color: colorScheme.onSurface,
                          fontFamily: "Georama",
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    // Email input field
                    _buildTextForm(
                        _nameController, _nameFocus, 'Name', false, null,
                            (text) {
                          setState(() {
                            autoprogress = true;
                            _emailFocus.requestFocus();
                          });
                        }),
                    const SizedBox(height: 15),
                    // Password input field
                    _buildTextForm(_emailController, _emailFocus, 'Email',
                        false, TextInputType.emailAddress, (text) {
                          setState(() {
                            autoprogress = true;
                          });
                        }),
                    SizedBox(
                      width: mediaQuery.size.width * 2 / 3 - 40,
                      height: 25,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                  height: 2.5, color: colorScheme.onSurface)),
                          Text(" or ",
                              style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 17,
                                  height: 0.5,
                                  fontFamily: 'ProstoOne')),
                          Expanded(
                              child: Container(
                                  height: 2.5, color: colorScheme.onSurface)),
                        ],
                      ),
                    ),
                    /// sign in with apple / other oath
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Set a Password",
                      style: TextStyle(
                          fontSize: 30,
                          color: colorScheme.onSurface,
                          fontFamily: "Georama",
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    // Email input field
                    _buildTextForm(_passwordController, _passwordFocus,
                        'Password', true, null, (text) {
                          setState(() {
                            autoprogress = true;
                            _password2Focus.requestFocus();
                          });
                        }),
                    const SizedBox(height: 15),
                    // Email input field
                    _buildTextForm(_password2Controller, _password2Focus,
                        'Confirm Password', true, null, (text) {
                          setState(() {
                            autoprogress = true;
                          });
                        }),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Confirm Registration",
                      style: TextStyle(
                          fontSize: 30,
                          color: colorScheme.onSurface,
                          fontFamily: "Georama",
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    _buildPP(),
                    const SizedBox(height: 10),
                    Divider(color: colorScheme.onSurface)
                  ],
                ),
              ),
            ],
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.transparent,
              Colors.transparent
            ]),
      ),
    );
  }
}
