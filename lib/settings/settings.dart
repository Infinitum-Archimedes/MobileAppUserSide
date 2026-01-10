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
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(title, style: TextStyle(color: colorScheme.onSurface)),
        content: Text("Coming Soon", style: TextStyle(color: colorScheme.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: colorScheme.secondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: GestureDetector(
        onTap: () => _showPopup(text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border.all(color: colorScheme.primary, width: 1.5),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: colorScheme.shadow.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    final colorScheme = Theme.of(context).colorScheme;
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.secondary, width: 1.5),
            borderRadius: BorderRadius.circular(15),
            color: colorScheme.secondaryContainer,
            boxShadow: [
              BoxShadow(color: colorScheme.shadow.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            "Notification Center",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: ListView(
        children: [
          // Top Bar
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              boxShadow: [
                BoxShadow(color: colorScheme.shadow, blurRadius: 4),
              ],
            ),
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
                              fontFamily: 'Georama',
                              color: colorScheme.onSurface)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.parse('https://docs.flutter.dev/tos');
                          await launchUrl(url);
                        },
                        child: Text(
                          'Read Terms and Conditions',
                          style: TextStyle(
                              fontSize: 16,
                              color: colorScheme.secondary,
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
          _buildNotificationButton(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
