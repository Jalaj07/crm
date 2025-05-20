import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  // You could add parameters here for notification count if needed
  // final int notificationCount;
  final VoidCallback? onTap; // Callback when the icon is tapped

  const NotificationIcon({
    super.key,
    this.onTap,
    // this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Example of a static notification count for demonstration
    const int staticNotificationCount = 3; // Change this to 0 to hide the badge
    final bool hasNotifications = staticNotificationCount > 0;

    return Stack(
      alignment: Alignment.center, // Center the stack content
      children: [
        // The main notification icon button
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onTap, // Use the provided onTap callback directly
          tooltip: 'Notifications',
        ),

        // Notification badge (shown only if there are notifications)
        if (hasNotifications)
          Positioned(
            right: 11, // Adjust position to fine-tune badge location
            top: 11, // Adjust position
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red, // Red badge color
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color:
                      Theme.of(
                        context,
                      ).scaffoldBackgroundColor, // Border color matches scaffold background
                  width: 1.5,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 14, // Minimum size for the badge
                minHeight: 14,
              ),
              child: Center(
                // Center the text inside the badge
                child: Text(
                  // Display count, or just a dot if count is too large/not needed
                  staticNotificationCount > 9
                      ? '9+'
                      : staticNotificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8, // Smaller font size for the badge count
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
