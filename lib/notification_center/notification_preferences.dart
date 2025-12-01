import 'package:flutter/material.dart';
import '../../globals/static/custom_themes.dart';

/*
Initially select notification preferences before going to notification center.
Allows users to customize which types of notifications they want to receive.
*/

class NotificationPreferences extends StatefulWidget {
  const NotificationPreferences({super.key});

  @override
  _NotificationPreferencesState createState() => _NotificationPreferencesState();
}

class _NotificationPreferencesState extends State<NotificationPreferences> {
  bool generalNotifications = true;
  bool healthUpdates = true;
  bool locationAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomThemes.mainTheme.colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('Notification Center'),
        backgroundColor: CustomThemes.mainTheme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Information regarding common and\ncurrent health information.',
              style: TextStyle(
                fontSize: 14,
                color: CustomThemes.mainTheme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CustomThemes.mainTheme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'Location: ',
                    style: TextStyle(fontWeight: FontWeight.w500, color: CustomThemes.mainTheme.colorScheme.onSurface),
                  ),
                  Text(
                    'Blacksburg, VA',
                    style: TextStyle(
                      color: CustomThemes.mainTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'General Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomThemes.mainTheme.colorScheme.onSurface,
              ),
            ),
            SwitchListTile(
              title: const Text('General Notifications'),
              value: generalNotifications,
              onChanged: (bool value) {
                setState(() {
                  generalNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Health Updates'),
              value: healthUpdates,
              onChanged: (bool value) {
                setState(() {
                  healthUpdates = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Location Alerts'),
              value: locationAlerts,
              onChanged: (bool value) {
                setState(() {
                  locationAlerts = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}