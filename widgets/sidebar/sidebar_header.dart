import 'package:flutter/material.dart';

//============================================================
// Sidebar Header Widget using the Image Asset
//============================================================
class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Primary color is used for the background container of the logo
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    // Remove: final Color logoColor = const Color(0xFFE67E22); // No longer needed

    // Define the path to your logo asset
    const String logoAssetPath = 'assets/images/company_logo.png';

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16, // Account for status bar
        bottom: 16,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          // Background container for the logo
          Container(
            padding: const EdgeInsets.all(
              6,
            ), // Adjust padding if needed for the image
            decoration: BoxDecoration(
              // You might want to adjust or remove the background color
              // depending on your logo image (e.g., if it has transparency)
              color: primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            // Use Image.asset to display the logo
            child: Image.asset(
              logoAssetPath, // Use the asset path variable
              width: 30, // Set desired width for the logo
              height: 30, // Set desired height for the logo
              fit:
                  BoxFit.contain, // Adjust fit as needed (contain, cover, etc.)
              // Optional: Add an error builder in case the image fails to load
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 24,
                ); // Placeholder icon
              },
            ),
          ),
          const SizedBox(width: 12), // Spacing between logo and title
          // App Title Text
          Text(
            'GainHub',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
              color:
                  isDarkMode
                      ? Colors.white
                      : Colors.blue, // Adjust text color for theme
            ),
          ),
        ],
      ),
    );
  }
}
