// packages
import 'package:flutter/material.dart';
import 'package:student_health_tracker/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// pages
import '../globals/database.dart';
import '../globals/static/custom_themes.dart';
import 'home_page.dart';

/*
Login page for the application.
- logs in users, setting up the user as 'authed'
*/

class Login extends StatefulWidget {
  const Login({super.key});

  static bool logged = false;
  static bool account = false;
  static bool hideText = true;

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const Login());
  }

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  // Sign in user with email and password
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await DataBase.init();
      if (mounted) {
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
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    Login.logged = true;
    Login.account = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void tapAwayListener(FocusNode focusNode){
    focusNode.addListener((){
      if(!focusNode.hasFocus){
        setState(() {});
      }
    });
  }

  @override
  void initState(){
    super.initState();
    tapAwayListener(_emailFocus);
    tapAwayListener(_passwordFocus);
  }

  Widget _buildTextForm(
      TextEditingController controller,
      FocusNode? focus,
      String text,
      bool obscuretext,
      TextInputType? input,
      void Function(String?) onSubmit) {
    final ColorScheme colorScheme = CustomThemes.mainTheme.colorScheme;

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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final ColorScheme colorScheme = CustomThemes.mainTheme.colorScheme;

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
          child: Card(
            color: colorScheme.surface,
            margin: EdgeInsets.symmetric(horizontal: mediaQuery.size.width / 6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 30,
                        color: colorScheme.onSurface,
                        fontFamily: "Georama",
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  // Email input field
                  _buildTextForm(_emailController, _emailFocus, 'Email', false,
                      TextInputType.emailAddress, (text) {
                        _passwordFocus.requestFocus();
                      }),
                  const SizedBox(height: 15),
                  // Password input field
                  _buildTextForm(_passwordController, _passwordFocus,
                      'Password', true, null, (text) {
                        if (!_isLoading) {
                          _signIn();
                        }
                      }),
                  // Login button
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Opacity(
                        opacity: _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                            ? 1
                            : 0.75,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                            Size(mediaQuery.size.width * 2 / 3 - 60, 40),
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text('Sign In',
                              style: TextStyle(
                                  fontFamily: 'Pridi',
                                  fontSize: 20,
                                  color: colorScheme.onPrimary)),
                        ),
                      )),
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
                  //const SignInWithAppleButton(
                  //    onPressed: DataBase.signInWithApple)
                ],
              ),
            ),
          )),
    );
  }
}
