import 'package:flutter/material.dart';

/*

Notification center.

Display any notifications sent out of the application.

Essentially need to locally store a list of all notifs sent out (can back up to supabase), and then display.
 */

class NotificationCenter extends StatefulWidget {
  const NotificationCenter({super.key});

	@override
	_NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
	List<Map<String, dynamic>> notifications = [];

	@override
	void initState() {
		super.initState();
		//fetchNotifications();
	}

/*
	Future<void> fetchNotifications() async {
		final response = await supabase.from('notifications').select().execute();
		if (response.error == null) {
			setState(() {
				notifications = List<Map<String, dynamic>>.from(response.data);
			});
		} else {
			// Handle error
			print('Error fetching notifications: ${response.error!.message}');
		}
	}

*/
	@override
	Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;
		return Scaffold(
			backgroundColor: colorScheme.primaryContainer,
			appBar: AppBar(
				title: Text('Notification Center', style: TextStyle(color: colorScheme.onSurfaceVariant)),
				backgroundColor: colorScheme.surfaceContainer,
				iconTheme: IconThemeData(color: colorScheme.onSurface),
			),
			body: notifications.isEmpty
					? Center(
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									Icon(Icons.notifications_off_outlined, size: 64, color: colorScheme.onSurface.withOpacity(0.5)),
									const SizedBox(height: 16),
									Text(
										'No notifications yet',
										style: TextStyle(
											fontSize: 18,
											color: colorScheme.onSurface.withOpacity(0.7),
										),
									),
								],
							),
						)
					: ListView.builder(
							padding: const EdgeInsets.all(12),
							itemCount: notifications.length,
							itemBuilder: (context, index) {
								final notification = notifications[index];
								return Card(
									margin: const EdgeInsets.only(bottom: 12),
									color: colorScheme.surface,
									elevation: 2,
									shadowColor: colorScheme.shadow,
									shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
									child: Padding(
										padding: const EdgeInsets.all(16.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Text(
													notification['title'] ?? 'No Title',
													style: TextStyle(
														fontWeight: FontWeight.bold,
														fontSize: 16,
														color: colorScheme.onSurface,
													),
												),
												const SizedBox(height: 8),
												Text(
													notification['message'] ?? 'No Message',
													style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
												),
												const SizedBox(height: 8),
												Text(
													notification['date'] != null
															? notification['date'].toString()
															: 'No Date',
													style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
												),
											],
										),
									),
								);
							},
						),
		);
	}
}