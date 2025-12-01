import 'package:url_launcher/url_launcher.dart';

/*

Used for any methods which are re-used or could be re-used.

Provides a central location for all of these methods to go, particularly if they get complex with theming and whatnot.

 */

class GlobalMethods {

  static void launchURL(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}