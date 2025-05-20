// widgets/appbar/custom_app_bar.dart
import 'package:flutter/material.dart';
// Assuming CustomNotificationIcon is in this path
import 'appbar_custom_notification_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onLogout; // Existing callback for logout
  final VoidCallback? onProfileTap; // Callback for profile tap

  const CustomAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.onLogout,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    const String profileImageUrl =
        'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250';

    return AppBar(
      titleSpacing: 0.0,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(Icons.menu, color: colorScheme.onSurface),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      title: Row(
        children: [
          const SizedBox(width: 8),
          Icon(icon, size: 22, color: colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        NotificationIcon(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PlaceholderNotificationsScreen(),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: PopupMenuButton<String>(
            offset: const Offset(0, kToolbarHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (String item) {
              if (item == 'logout') {
                onLogout?.call();
              } else if (item == 'profile') {
                onProfileTap?.call();
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(width: 8),
                        Text('My Profile', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(width: 8),
                        Text('Log Out', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primary,
              backgroundImage: const NetworkImage(profileImageUrl),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Placeholder Screen for Notifications ---
class PlaceholderNotificationsScreen extends StatelessWidget {
  const PlaceholderNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: const Center(child: Text("Notifications Screen Content")),
    );
  }
}
