import 'package:flutter/material.dart';

// --- Your GreetingCard Widget (Stateless - Updated with Dynamic Text Color) ---

// Define Time of Day States (Keep as is)
enum TimeOfDayState { morning, day, night }

// Constants for Greeting Card (Keep as is)
const EdgeInsets _cardPadding = EdgeInsets.fromLTRB(20, 25, 20, 20);
const BorderRadius _cardBorderRadius = BorderRadius.all(Radius.circular(16.0));
const SizedBox _spacingH10 = SizedBox(height: 10);

// --- Define a subtle text shadow (Applied conditionally later or adjust if needed) ---
// --- Optional: Define shadows for light text on dark backgrounds ---
const List<Shadow> _lightTextShadows = [
  Shadow(
    // A very subtle dark shadow usually works well for light text
    blurRadius: 3.0,
    color: Colors.black45,
    offset: Offset(1.0, 1.0),
  ),
];

// --- Optional: Define shadows for dark text on light backgrounds ---
const List<Shadow> _darkTextShadows = [
  // Lighter shadow for dark text can provide a subtle lift
  Shadow(blurRadius: 2.0, color: Colors.white54, offset: Offset(1.0, 1.0)),
];

class GreetingCard extends StatelessWidget {
  final String userName;
  final String formattedTime;
  final String formattedDate;
  final DateTime currentTime; // Receive DateTime to determine state

  const GreetingCard({
    super.key,
    required this.userName,
    required this.formattedTime,
    required this.formattedDate,
    required this.currentTime, // Now receives DateTime
  });

  // Determine TimeOfDayState based on the passed currentTime (Keep as is)
  TimeOfDayState _getTimeOfDayState() {
    final hour = currentTime.hour;
    if (hour >= 5 && hour < 12) {
      // 5 AM to 11:59 AM
      return TimeOfDayState.morning;
    } else if (hour >= 12 && hour < 18) {
      // 12 PM to 5:59 PM
      return TimeOfDayState.day;
    } else {
      // 6 PM to 4:59 AM (includes evening)
      return TimeOfDayState.night;
    }
  }

  // Get gradient based on state (Keep as is)
  LinearGradient _getGradient(TimeOfDayState state) {
    switch (state) {
      case TimeOfDayState.morning:
        return const LinearGradient(
          // Lighter, softer morning gradient
          colors: [
            Color(0xFFFFE082),
            Color(0xFFBBDEFB),
          ], // Pale Yellow to Light Blue
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        );
      case TimeOfDayState.day:
        return const LinearGradient(
          // Brighter, clearer day gradient
          colors: [
            Color(0xFF64B5F6),
            Color.fromARGB(255, 54, 146, 238),
          ], // Light Blue to Blue
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case TimeOfDayState.night:
        return const LinearGradient(
          // Darker night gradient
          colors: [
            Color(0xFF0D0221),
            Color(0xFF1A237E),
          ], // Blue Grey to Very Dark Blue
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  // Get image asset path based on state (Keep as is)
  String? _getBackgroundImageAsset(TimeOfDayState state) {
    switch (state) {
      case TimeOfDayState.morning:
        return 'assets/images/sun_clear.png'; // Ensure this asset exists
      case TimeOfDayState.day:
        return 'assets/images/clouds.png'; // Ensure this asset exists
      case TimeOfDayState.night:
        return 'assets/images/moon_stars.png'; // Ensure this asset exists
    }
  }

  // Get image alignment based on state (Adjusted values from your last input)
  Alignment _getImageAlignment(TimeOfDayState state) {
    switch (state) {
      case TimeOfDayState.morning:
        return const Alignment(0.8, -0.5);
      case TimeOfDayState.day:
        // Keep clouds somewhat centered or slightly offset
        return const Alignment(0.9, -0.6); // Let's try centering top edge
      case TimeOfDayState.night:
        return const Alignment(0.7, -0.3);
    }
  }

  // Get image size based on state (Adjusted values from your last input)
  double _getImageSize(TimeOfDayState state) {
    switch (state) {
      case TimeOfDayState.morning:
        return 140.0;
      case TimeOfDayState.day:
        // Make clouds potentially wider if appropriate for the asset
        return 210.0; // Adjusted slightly from 280, check your asset
      case TimeOfDayState.night:
        return 160.0;
    }
  }

  // --- CORRECTED: Get base text color based on state ---
  Color _getTextColor(TimeOfDayState state) {
    switch (state) {
      case TimeOfDayState.morning:
        return Colors.black87;
      case TimeOfDayState.day:
        // Use dark text for lighter morning/day backgrounds
        return Colors.black; // Slightly off-black often looks better
      case TimeOfDayState.night:
        // Use light text for darker night background
        return Colors.white;
    }
  }

  // --- Optional: Get appropriate text shadows based on state ---
  List<Shadow> _getShadows(TimeOfDayState state) {
    switch (state) {
      case TimeOfDayState.morning:
        return _darkTextShadows;
      case TimeOfDayState.day:
        // Use lighter shadows for dark text
        return _lightTextShadows;
      case TimeOfDayState.night:
        // Use darker shadows for light text
        return _lightTextShadows; // Or your original _textShadows
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Determine state and derived properties
    final timeState = _getTimeOfDayState();
    final gradient = _getGradient(timeState);
    final bgImageAsset = _getBackgroundImageAsset(timeState);
    final imageAlignment = _getImageAlignment(timeState);
    final imageSize = _getImageSize(timeState);

    // --- CORRECTED: Assign text colors by calling the methods ---
    final Color textColor = _getTextColor(timeState);
    // Make subtitle slightly less prominent than the main text color
    final Color subTextColor = textColor.withAlpha(217);
    // Get appropriate shadows
    final List<Shadow> shadows = _getShadows(timeState);

    // --- Use Container instead of Card ---
    return Container(
      margin: EdgeInsets.zero, // Assuming parent provides padding/margin
      clipBehavior: Clip.antiAlias, // Apply clipping for border radius effect
      decoration: BoxDecoration(
        gradient: gradient, // Apply gradient directly to this Container
        borderRadius: _cardBorderRadius, // Apply border radius
        boxShadow: const [
          // Keep a generic shadow for the card itself
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Background Image Layer (Sun/Moon/Stars)
          if (bgImageAsset != null)
            Positioned.fill(
              child: Align(
                alignment: imageAlignment,
                child: Opacity(
                  opacity: 0.8, // Slightly reduced opacity for better blend
                  child: Image.asset(
                    bgImageAsset,
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Handle missing/error loading assets
                      // print("Error loading image: $bgImageAsset");
                      return SizedBox(height: imageSize, width: imageSize);
                    },
                  ),
                ),
              ),
            ),

          // 3. Content Layer (Text with Shadows)
          Padding(
            padding: _cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Important for Container sizing
              children: [
                Text(
                  'Welcome back!',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: subTextColor, // Use dynamic sub-color
                    shadows: shadows, // Use dynamic shadows
                  ),
                ),
                _spacingH10,
                Text(
                  userName,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor, // Use dynamic main color
                    shadows: shadows, // Use dynamic shadows
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  formattedDate,
                  style: textTheme.titleMedium?.copyWith(
                    color: subTextColor, // Use dynamic sub-color
                    shadows: shadows, // Use dynamic shadows
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formattedTime, // Display the continuously updated time
                  style: textTheme.bodyMedium?.copyWith(
                    color: subTextColor.withAlpha(229), // Slightly less opacity
                    shadows: shadows, // Use dynamic shadows
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
