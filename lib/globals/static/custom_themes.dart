import 'package:flutter/material.dart';


/*
Themes page
Allows for changing color scheme.
Referenced in the settings page, and throughout the app to determine colors to be used.
 */
class CustomThemes {

  /// main theme which is both the starting theme, and the theme for the opening pages of the app
  static ThemeData mainTheme = ThemeData(
    colorScheme: const ColorScheme(
      // Button background, tile colors
      primary: Color(0xffeef4ff), // Light lavender/blue for buttons
      // Button text color
      onPrimary: Color(0xff000000), // Black for readability
      // Primary background color
      primaryContainer: Color(0xffffffff), // Clean white background
      // Links and accent colors
      secondary: Color(0xff6a5acd), // Medium purple for links and highlights
      // Text color on secondary
      onSecondary: Color(0xffffffff), // White text on secondary
      // Secondary background color
      secondaryContainer: Color(0xffe8eaf6), // Slightly darker lavender for containers
      // Button outline or inactive button color
      tertiary: Color(0xffdfe4fc), // Very light blue
      // Tertiary text color
      onTertiary: Color(0xff000000), // Black for tertiary text
      // Appbar and navbar
      surface: Color(0xffffffff), // Pure white
      // Shadow color for elevated elements
      shadow: Color(0xffd0d0d0), // Light gray for subtle shadows
      // Default text color
      onSurface: Color(0xff000000), // Black for general text
      // Decorations (rounded shapes)
      surfaceContainer: Color(0xffeef4ff), // Same as button background
      // Link text color
      onSurfaceVariant: Color(0xff6a5acd), // Purple for links
      error: Color(0xffff6f6f), // Light red for error
      onError: Color(0xffffffff), // White for text on error
      brightness: Brightness.light,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xffeef4ff), // Light blue for buttons
      textTheme: ButtonTextTheme.primary, // Ensures button text matches the primary color
    ),
  );


  static Map<String, ThemeData> themeData = {
    // follow formatting
    "Lavender": ThemeData(
      colorScheme: const ColorScheme(
        //Tile color, Logo Color, button/switch color
        primary: Color.fromRGBO(247, 237, 219, 1),
        //Tile text color
        onPrimary: Color(0xff000000),
        //Primary background color
        primaryContainer: Color(0xffd9cbda),
        //Secondary color
        secondary: Color(0xfff6f1f1),
        //Secondary text color
        onSecondary: Color(0xff000000),
        //Secondary background color
        secondaryContainer: Color(0xffdfd5e0),
        //Zesty button color
        tertiary: Color(0xff443454),
        //Tertiary button text
        onTertiary: Colors.white,
        //Top bar on HomePage
        tertiaryContainer: Colors.white,
        //Container/Detail color
        surface: Color(0xffeeeeee),
        //Darker Container color
        shadow: Color(0xffdcdcdc),
        //Container Text
        onSurface: Color(0xff21141d),
        //Appbar, navbar
        surfaceContainer: Color(0xfffff2fb),
        //Text color on surfaceContainer
        onSurfaceVariant: Colors.black,
        error: Colors.transparent,
        onError: Colors.transparent,
        brightness: Brightness.light,
      ),
    ),
    "Red": ThemeData(
      colorScheme: const ColorScheme(
        primary: Color(0xffec6464),
        onPrimary: Colors.white,
        secondary: Color(0xfffdc5c5),
        onSecondary: Color(0xffef3530),
        tertiary: Color(0xffb04141),
        onTertiary: Colors.white,
        tertiaryContainer: Colors.white,
        primaryContainer: Color(0xfff3cbcb),
        secondaryContainer: Color(0xfff1dddd),
        surface: Color(0xffeeeeee),
        onSurface: Color(0xff21141d),
        shadow: Color(0xffdcdcdc),
        surfaceContainer: Color(0xffffeeee),
        onSurfaceVariant: Colors.black,
        error: Colors.transparent,
        onError: Colors.transparent,
        brightness: Brightness.light,
      ),
    ),
    "Monochrome": ThemeData(
      colorScheme: const ColorScheme(
        primary: Color(0xffc4c4c4),
        onPrimary: Colors.black,
        secondary: Color(0xff949494),
        onSecondary: Colors.black,
        tertiary: Color(0xff2a2a2a),
        onTertiary: Colors.white,
        tertiaryContainer: Colors.white,
        primaryContainer: Color(0xffe8e8e8),
        secondaryContainer: Color(0xffdedede),
        surface: Color(0xffffffff),
        onSurface: Color(0xff1e1e1e),
        shadow: Color(0xffdcdcdc),
        surfaceContainer: Color(0xffeeeeee),
        onSurfaceVariant: Colors.black,
        error: Colors.transparent,
        onError: Colors.transparent,
        brightness: Brightness.light,
      ),
    ),
    "Dark": ThemeData(
      colorScheme: const ColorScheme(
        primary: Color(0xff2a2a2a),
        onPrimary: Color(0xffc5c5c5),
        primaryContainer: Color(0xff565656),
        secondary: Color(0xff484848),
        onSecondary: Color(0xffa9a9a9),
        secondaryContainer: Color(0xff6b6b6b),
        tertiary: Colors.black,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xff2a2a2a),
        surface: Color(0xff3a3a3a),
        onSurface: Color(0xffbbbbbb),
        shadow: Color(0xff313131),
        surfaceContainer: Color(0xff313131),
        onSurfaceVariant: Color(0xffcccccc),
        error: Colors.transparent,
        onError: Colors.transparent,
        brightness: Brightness.light,
      ),
    ),
    "Aquamarine": ThemeData(
      colorScheme: const ColorScheme(
        //Tile color, Logo Color, button/switch color
        primary: Color(0xff5178ad),
        //Tile text color
        onPrimary: Color(0xffdde8f3),
        //Primary background color
        primaryContainer: Color(0xffbecadc),
        //Secondary color
        secondary: Color(0xffbdd7cf),
        //Secondary text color
        onSecondary: Color(0xff37455b),
        //Secondary background color
        secondaryContainer: Color(0xffddecff),
        //Zesty button color
        tertiary: Color(0xff002472),
        //Tertiary button text
        onTertiary: Colors.white,
        //Top bar on HomePage
        tertiaryContainer: Color(0xfff2f6ff),
        //Container/Detail color
        surface: Color(0xffeeeeee),
        //Darker Container color
        shadow: Color(0xffdcdcdc),
        //Container Text
        onSurface: Color(0xff141821),
        //Appbar, navbar
        surfaceContainer: Color(0xffc6e5e3),
        //Text color on surfaceContainer
        onSurfaceVariant: Colors.black,
        error: Colors.transparent,
        onError: Colors.transparent,
        brightness: Brightness.light,
      ),
    ),
  };
}
