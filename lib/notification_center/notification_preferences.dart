import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text('Notification Settings', style: TextStyle(color: colorScheme.onSurfaceVariant)),
        backgroundColor: colorScheme.surfaceContainer,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customize which notifications you receive about health information in your area.',
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: colorScheme.shadow.withOpacity(0.2), blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: colorScheme.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Location: ',
                    style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSecondary),
                  ),
                  Text(
                    'Blacksburg, VA',
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Notification Types',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georama',
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              context,
              title: 'General Notifications',
              subtitle: 'App updates and announcements',
              value: generalNotifications,
              onChanged: (value) => setState(() => generalNotifications = value),
            ),
            _buildSwitchTile(
              context,
              title: 'Health Updates',
              subtitle: 'Disease outbreaks and health alerts',
              value: healthUpdates,
              onChanged: (value) => setState(() => healthUpdates = value),
            ),
            _buildSwitchTile(
              context,
              title: 'Location Alerts',
              subtitle: 'Health reports near your location',
              value: locationAlerts,
              onChanged: (value) => setState(() => locationAlerts = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.15), blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
        value: value,
        activeColor: colorScheme.primary,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}