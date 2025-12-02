// packages
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

// pages
import '../notification_center/notification_page_router.dart'; // Add this import (update path as needed)

/// quick page which displays settings and other import info

/// viewable via top bar of the application
// Removed duplicate Flutter import.

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void _showPopup(String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: const Text("Coming Soon"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: GestureDetector(
        onTap: () => _showPopup(text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NotificationPageRouter(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(15),
            color: Colors.deepPurple[50],
          ),
          alignment: Alignment.center,
          child: const Text(
            "Notification Center",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // Top Bar
          Container(
            height: 80,
            color: Colors.deepPurpleAccent,
          ),
          const SizedBox(height: 20),

          // Title and Terms
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Settings',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.parse('https://docs.flutter.dev/tos');
                          await launchUrl(url);
                        },
                        child: Text(
                          'Read Terms and Conditions',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // All Buttons
          _buildSettingButton("General"),
          _buildSettingButton("Accessibility"),
          _buildSettingButton("Health Helper"),
          _buildSettingButton("Location"),
          _buildSettingButton("Privacy"),
          _buildSettingButton("Display"),
          _buildSettingButton("Passcode/Login"),
          _buildSettingButton("Location"),
          _buildNotificationButton(), 

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
