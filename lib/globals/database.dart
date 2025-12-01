import 'package:supabase_flutter/supabase_flutter.dart';

/*
Database is just used to store various functions used throughout the app
- just a helper class to prevent having to remake code for basic database functionality
- also centralizes major interactions with the supabase
- central file for reused database interactions

THIS FILE COMMUNICATES WITH SUPABASE DATABASE SOLELY
 */

// create variable for database which will be accessed later
final SupabaseClient supabase = Supabase.instance.client;

class DataBase {
  // sample: can define a peice of data that is consistent, and then update the variable
  // static List<Map<String, dynamic>> ideas = [];

  static Future<void> init() async {
    await _tryInitialize();
  }

  // init supabase
  static Future<bool> _tryInitialize() async {
    try {
      await Supabase.initialize(
        // url and anonkey of supabase db
        url: 'https://ssafurcuoaffmzvmfiez.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzYWZ1cmN1b2FmZm16dm1maWV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ0MzY0OTUsImV4cCI6MjA4MDAxMjQ5NX0.FU5eF5oSVcJKARbTnb6aIP2OYT-kE2I2VrbFZ-P-pMw',
      );
      return false;
    } catch (e) {
      return true;
    }
  }

  // sample db function

  // report error to supabase table
  static Future<void> reportError(
    String description,
    String type,
    String reference,
  ) async {
    String? uuid = (await supabase.auth.getUser()).user?.id;
    await supabase.from("errors").insert({
      'description': description,
      'type': type,
      'reference': reference,
      'uuid': uuid,
    });
  }

  // sample supabase edge invocation
  //   final res = await supabase.functions.invoke('gpt-description', body: {'idea': context});
}
