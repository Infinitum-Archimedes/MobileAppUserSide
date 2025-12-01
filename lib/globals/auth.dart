import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:student_health_tracker/globals/static/global_widgets.dart';
import 'package:student_health_tracker/main.dart';
import 'package:student_health_tracker/startup/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Startup/home_page.dart';
import 'database.dart';

/*
Handles all auth functionalities (supabase auth)

Frequently referenced in account page and login/sign-in process
 */

class AuthService {
  // guest sign in
  Future<void> signUpAnon(BuildContext context) async {
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

  // log out of current session
  static void logOutAccount() async {
    await supabase.auth.signOut();
  }

  // remove account row from profiles
  static void resetAccount() async {
    await supabase
        .from('profiles')
        .delete()
        .eq('id', supabase.auth.currentUser!.id);
  }

  // deletes current user's account (based on the current session/user) and resets them to home
  // will work with both anonymous sessions and actual accounts to clear all of their data
  static Future<void> deleteAccount() async {
    try {
      if (supabase.auth.currentUser == null) {
        throw Error();
      }
      // call edge function
      await supabase.functions.invoke('delete-user');
    } catch (error) {
      print('Error when deleting a user.');
    } finally {
      // sign out, push back to home page
      await supabase.auth.signOut();
      GlobalWidgets.swipePage(const SplashPage());
    }
  }

  // send email to reset password
  // see : https://supabase.com/docs/reference/javascript/auth-resetpasswordforemail
  static void sendPasswordResetEmail(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  // update a user's password
  static void updatePassword(newPassword) async {
    await supabase.auth.updateUser(UserAttributes(
        email: supabase.auth.currentUser?.email, password: newPassword));
  }

  static void updateEmail(newEmail) async {
    await supabase.auth.updateUser(UserAttributes(email: newEmail));
  }

  // verifies email address
  static bool checkEmail() {
    final String? response = supabase.auth.currentUser?.email;
    return response != null;
  }

  // update account information
  static Future<void> updateAccount(int pkey, Map map) async {
    await supabase.auth.updateUser(map as UserAttributes);
  }

  /// Performs Apple sign in on iOS or macOS
  static Future<AuthResponse> signInWithApple() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }
}
