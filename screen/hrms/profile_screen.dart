// lib/screens/profile_screen.dart
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import 'dart:convert'; // Fixed import for jsonDecode

// Adjust import paths based on your project structure
import '../../data/profile_data.dart'; // Your data service
import '../../constants/profile/profile_constants.dart'; // Screen layout constants
import '../../constants/profile/profile_modal_constants.dart'; // Modal styling constants (used for Snackbar etc)

// Import Widgets used on this screen
// Adjust paths as needed
import '../../widgets/profile/profile_error_state_view.dart';
import '../../widgets/profile/profile_no_data_view.dart';
import '../../widgets/profile/profile_header_section.dart';
import '../../widgets/profile/profile_info_section.dart';
import '../../widgets/profile/profile_generic_stat_section.dart';

// Import Modal Widgets and their necessary data classes
// Adjust paths as needed
import '../../widgets/profile/profile_form16_modal.dart';
import '../../widgets/profile/profile_assets_modal.dart'; // Also imports AssetItem
import '../../widgets/profile/profile_documents_modal.dart'; // Also imports DocumentItem

// --- Main Screen Widget ---
class ProfileScreen extends StatefulWidget {
  // Callback only needed for actions handled by the parent navigator
  final VoidCallback? onNavigateToAnnouncements;
  final VoidCallback? navigateToLeave;
  final VoidCallback? navigateToAnnouncedEvents;
  final VoidCallback? navigateToTimesheet;

  const ProfileScreen({
    super.key,
    this.onNavigateToAnnouncements,
    this.navigateToLeave,
    this.navigateToAnnouncedEvents,
    this.navigateToTimesheet,
  });

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late final ProfileData _profileData;
  late Future<Map<String, dynamic>> _profileFuture;
  Map<String, dynamic> _userData = {}; // Cache user data locally

  // Use the valid, real Form 16 URL from Income Tax India
  final String _validForm16Url =
      'https://drive.google.com/uc?export=download&id=1QLh-mCwLibiYJA0167JEBbf1m--vjHNK';
  // Example invalid URL for testing error states
  // final String _invalidForm16Url = 'https://example.invalid/nonexistent_form16.pdf';

  // Lists using color shades must be final, not const
  static final List<Map<String, dynamic>> _statsItems = [
    {
      'title': 'Form16',
      'key': 'form16',
      'icon': Icons.description_outlined,
      'color': Colors.blue.shade700,
    },
    {
      'title': 'Leave Balance',
      'key': 'leave',
      'icon': Icons.event_available_outlined,
      'color': Colors.green.shade700,
    },
    {
      'title': 'Assets',
      'key': 'assets',
      'icon': Icons.devices_other_outlined,
      'color': Colors.orange.shade700,
    },
    {
      'title': 'My Documents',
      'key': 'documents',
      'icon': Icons.folder_copy_outlined,
      'color': Colors.teal.shade700,
    },
  ];

  static final List<Map<String, dynamic>> _detailsItems = [
    {
      'title': 'Appraisal Letter',
      'key': 'appraisalLetter',
      'icon': Icons.emoji_events_outlined,
      'color': Colors.redAccent.shade400,
    },
    {
      'title': 'Announcements',
      'key': 'announcements',
      'icon': Icons.campaign_outlined,
      'color': Colors.indigo.shade400,
    },
    {
      'title': 'Timesheets',
      'key': 'timesheets',
      'icon': Icons.schedule_outlined,
      'color': Colors.cyan.shade600,
    },
    {
      'title': 'Loans & Advances',
      'key': 'loans',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Colors.lightBlue.shade600,
    },
  ];

  @override
  void initState() {
    super.initState();
    _profileData = ProfileData();
    _loadProfileData();
  }

  // Method to load or reload profile data
  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() {
      _profileFuture = _profileData.getProfileData(); // Get the future
    });

    try {
      // Await OUTSIDE setState and cache the data
      final data = await _profileFuture;
      if (mounted) {
        setState(() {
          _userData = data; // Store data locally for handlers
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error loading profile in _loadProfileData: $e");
      }
      if (mounted) {
        // Clear potentially stale data on error
        setState(() {
          _userData = {};
        });
      }
      // FutureBuilder will show the error state UI
    }
  }

  // Safely gets a string value from the cached data map
  String _getStringValue(
    Map<String, dynamic> data,
    String key, {
    String defaultValue = kNotAvailable,
  }) {
    final value = data[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      return defaultValue;
    }
    return value.toString();
  }

  // --- Placeholder Data Fetching Helpers ---
  // Replace dummy data with logic to extract from _userData map
  List<DocumentItem> _getDocumentsForType(String typeKey) {
    switch (typeKey.toLowerCase()) {
      case 'my documents':
        return [
          DocumentItem(
            name: 'Offer Letter',
            description: 'Issued 01/01/2022',
            url:
                'https://drive.google.com/file/d/18n-fpN5jl3MHc4abOBcfzfh7kt3maWWu/view?usp=sharing',
            icon: Icons.description_outlined,
            color: Colors.purple.shade600,
          ),
          DocumentItem(
            name: 'ID Card Scan',
            description: 'Valid until 31/12/2025',
            url:
                'https://drive.google.com/file/d/18n-fpN5jl3MHc4abOBcfzfh7kt3maWWu/view?usp=sharing',
            icon: Icons.badge_outlined,
            color: Colors.orange.shade600,
          ),
        ];
      case 'appraisal letter':
        return [
          DocumentItem(
            name: 'Appraisal 2023',
            description: 'Effective 01/04/2023',
            url:
                'https://drive.google.com/file/d/1xiHD0VHgLm5zoebUjr4_mhJtR6Id7gcy/view?usp=sharing',
            icon: Icons.emoji_events_outlined,
            color: Colors.red.shade600,
          ),
          DocumentItem(
            name: 'Appraisal 2022',
            description: 'Effective 01/04/2022',
            url:
                'https://drive.google.com/file/d/1xiHD0VHgLm5zoebUjr4_mhJtR6Id7gcy/view?usp=sharing',
            icon: Icons.emoji_events_outlined,
            color: Colors.red.shade600,
          ),
        ];
      case 'loans & advances':
        return [
          DocumentItem(
            name: 'Car Loan Agreement',
            description: 'Approved 15/03/2023',
            url:
                'https://drive.google.com/file/d/1Ly_GWrJ6c2vnzcNh6YUMS5AEAfNbITzA/view?usp=sharing',
            icon: Icons.directions_car_filled_outlined,
            color: Colors.teal.shade600,
          ),
          DocumentItem(
            name: 'Salary Advance Agreement',
            description: 'Approved 01/06/2023',
            url:
                'https://drive.google.com/file/d/1Ly_GWrJ6c2vnzcNh6YUMS5AEAfNbITzA/view?usp=sharing',
            icon: Icons.payments_outlined,
            color: Colors.lightBlue.shade600,
          ),
        ];
      default:
        return [];
    }
  }

  List<AssetItem> _getAssets() {
    // Get assets from user data if available
    final assetsData = _userData['assets'];

    // Handle case where assets is a string (parse it if it's a JSON string)
    if (assetsData is String && assetsData.isNotEmpty) {
      try {
        final List<dynamic> parsedAssets = jsonDecode(assetsData);
        return parsedAssets.map((asset) {
          return AssetItem(
            name: asset['name']?.toString() ?? 'Unknown Asset',
            description:
                asset['description']?.toString() ?? 'No description available',
            icon: _getAssetIcon(asset['type']?.toString() ?? ''),
            color: _getAssetColor(asset['type']?.toString() ?? ''),
          );
        }).toList();
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing assets JSON: $e');
        }
      }
    }

    // Handle case where assets is a List
    if (assetsData is List && assetsData.isNotEmpty) {
      return assetsData.map((asset) {
        return AssetItem(
          name: asset['name']?.toString() ?? 'Unknown Asset',
          description:
              asset['description']?.toString() ?? 'No description available',
          icon: _getAssetIcon(asset['type']?.toString() ?? ''),
          color: _getAssetColor(asset['type']?.toString() ?? ''),
        );
      }).toList();
    }

    // Fallback to default assets if no data available or parsing failed
    return [
      AssetItem(
        name: 'Laptop',
        description: 'Dell XPS 15',
        icon: Icons.laptop_chromebook_outlined,
        color: Colors.blue.shade700,
      ),
      AssetItem(
        name: 'Monitor',
        description: 'Dell 24" U2419H',
        icon: Icons.desktop_windows_outlined,
        color: Colors.orange.shade700,
      ),
    ];
  }

  IconData _getAssetIcon(String type) {
    switch (type.toLowerCase()) {
      case 'laptop':
        return Icons.laptop_chromebook_outlined;
      case 'monitor':
        return Icons.desktop_windows_outlined;
      case 'phone':
        return Icons.phone_android_outlined;
      case 'tablet':
        return Icons.tablet_android_outlined;
      case 'desktop':
        return Icons.computer_outlined;
      default:
        return Icons.devices_other_outlined;
    }
  }

  Color _getAssetColor(String type) {
    switch (type.toLowerCase()) {
      case 'laptop':
        return Colors.blue.shade700;
      case 'monitor':
        return Colors.orange.shade700;
      case 'phone':
        return Colors.green.shade700;
      case 'tablet':
        return Colors.purple.shade700;
      case 'desktop':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _convertToDirectDownloadUrl(String url) {
    if (url.isEmpty) return url;

    // Check if it's a Google Drive URL
    RegExp driveRegex = RegExp(
      r'https://drive\.google\.com/file/d/([^/]+)/view',
    );
    var match = driveRegex.firstMatch(url);

    if (match != null) {
      String fileId = match.group(1)!;
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }

    return url;
  }

  // Handles tap actions on profile items
  void _handleItemTap(String title, String value) {
    if (!mounted || value == kNotAvailable || _userData.isEmpty) {
      return;
    }

    String documentModalTitle = 'My Documents';
    if (title.toLowerCase() == 'appraisal letter') {
      documentModalTitle = 'Appraisal Letters';
    } else if (title.toLowerCase() == 'loans & advances') {
      documentModalTitle = 'Loans & Advances Info';
    }

    switch (title.toLowerCase()) {
      // --- Cases Using Modals ---
      case 'form16':
        String formUrlFromData = _getStringValue(
          _userData,
          'form16ActualUrl',
          defaultValue: '',
        );
        String urlToShow =
            (formUrlFromData.isNotEmpty &&
                    Uri.tryParse(formUrlFromData)?.isAbsolute == true)
                ? _convertToDirectDownloadUrl(formUrlFromData)
                : _validForm16Url;
        // To test error state, uncomment this:
        // urlToShow = 'https://example.invalid/nonexistent_form16.pdf';
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Form16Modal(form16Url: urlToShow),
        );
        break;
      case 'assets':
        showDialog(
          context: context,
          builder: (context) => AssetsModal(assets: _getAssets()),
        );
        break;
      case 'my documents':
      case 'appraisal letter':
      case 'loans & advances': // Use modal for loans
        showDialog(
          context: context,
          builder:
              (context) => DocumentsModal(
                modalTitle: documentModalTitle, // Use the specific title
                documents: _getDocumentsForType(title.toLowerCase()),
              ),
        );
        break;

      // --- Cases Using Standard Navigation or Callbacks ---
      case 'leave balance':
        // Use the new callback if available, otherwise fallback to named route
        if (widget.navigateToLeave != null) {
          widget.navigateToLeave!();
        } else {
          try {
            Navigator.pushNamed(context, '/leave');
          } catch (e) {
            _showInfoSnackbar(
              "Could not navigate to Leave screen. Route '/leave' not defined?",
            );
            if (kDebugMode) {
              print("Error navigating to /leave: $e");
            }
          }
        }
        break;
      case 'announcements':
        // Use the new callback if available, otherwise fallback to named route
        if (widget.navigateToAnnouncedEvents != null) {
          widget.navigateToAnnouncedEvents!();
        } else if (widget.onNavigateToAnnouncements != null) {
          widget.onNavigateToAnnouncements!();
        } else {
          try {
            Navigator.pushNamed(context, '/announced_events');
          } catch (e) {
            _showInfoSnackbar(
              "Could not navigate to Announced Events screen. Route '/announced_events' not defined?",
            );
            if (kDebugMode) print("Error navigating to /announced_events: $e");
          }
        }
        break;
      case 'timesheets':
        if (widget.navigateToTimesheet != null) {
          widget.navigateToTimesheet!();
        } else {
          _showInfoSnackbar('Navigate to Timesheets (Not Implemented)');
        }
        break;

      default:
        _showInfoSnackbar('Action for: $title');
    }
  }

  // Handles tap on the profile picture edit button
  void _handleChangeProfilePicture() {
    if (!mounted) return;
    _showInfoSnackbar('TODO: Change Profile Picture');
    // Implement image picking and uploading logic
  }

  // Helper to show a consistent Info Snackbar
  void _showInfoSnackbar(String message) {
    if (!mounted) return;
    // Ensure context is still valid before showing snackbar
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 20), // Adjusted margin
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ModalConstants.buttonBorderRadius,
            ),
          ),
        ),
      );
    } else if (kDebugMode) {
      print("Snackbar suppressed: Context is not current. Message: $message");
    }
  }

  // Helper to get status color
  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade600;
      case 'on leave':
        return Colors.amber.shade700;
      case 'inactive':
      case 'disconnected':
      case 'not connected':
        return Colors.red.shade600;
      default:
        return colorScheme.secondary; // Fallback color
    }
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface, // Use surface color for background
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileFuture, // Use the stored future
          builder: (context, snapshot) {
            // 1. Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            // 2. Error State (Network error or explicit error from service)
            if (snapshot.hasError ||
                snapshot.data == null &&
                    snapshot.connectionState == ConnectionState.done) {
              return ErrorStateView(
                error:
                    snapshot.error ??
                    'Failed to load profile data. Please try again.',
                onRetry: _loadProfileData,
              );
            }

            // Use cached data (should be populated if snapshot.data is valid)
            final currentUserData = _userData;

            // 3. No Data State (Service returned success, but data is empty)
            if (currentUserData.isEmpty &&
                snapshot.connectionState == ConnectionState.done) {
              return NoDataView(onRefresh: _loadProfileData);
            }

            // 4. Success State: Build UI using currentUserData
            final name = _getStringValue(currentUserData, 'name');
            final jobTitle = _getStringValue(currentUserData, 'jobTitle');
            final department = _getStringValue(currentUserData, 'department');
            final jobTitleOrDept =
                (jobTitle != kNotAvailable)
                    ? jobTitle
                    : (department != kNotAvailable
                        ? department
                        : 'No Role Assigned');
            final status = _getStringValue(
              currentUserData,
              'status',
              defaultValue: 'Unknown',
            );
            final statusColor = _getStatusColor(status, colorScheme);
            final profileImageUrl = _getStringValue(
              currentUserData,
              'profileImageUrl',
              defaultValue: kDefaultProfileImageUrl,
            );

            return RefreshIndicator.adaptive(
              onRefresh: _loadProfileData,
              child: ListView(
                padding: const EdgeInsets.only(
                  top: kSectionPaddingVertical,
                  bottom: kSectionPaddingVertical * 4, // Extra bottom padding
                ),
                children: [
                  Padding(
                    // Header Section
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSectionPaddingHorizontal,
                    ),
                    child: ProfileHeaderSection(
                      name: name,
                      jobTitleOrDept: jobTitleOrDept,
                      status: status,
                      statusColor: statusColor,
                      profileImageUrl: profileImageUrl,
                      onEditProfileTap: _handleChangeProfilePicture,
                    ),
                  ),
                  const SizedBox(height: kSectionSpacing * 1.2),

                  ProfileInfoSection(
                    // Employee Info
                    userData: currentUserData,
                    onItemTap: _handleItemTap,
                  ),
                  const SizedBox(height: kSectionSpacing),

                  ProfileGenericStatSection(
                    // Documents & Resources
                    sectionTitle: 'Documents & Resources',
                    items: _statsItems,
                    userData: currentUserData,
                    onItemTap: _handleItemTap,
                  ),
                  const SizedBox(height: kSectionSpacing),

                  ProfileGenericStatSection(
                    // Actions & Updates
                    sectionTitle: 'Actions & Updates',
                    items: _detailsItems,
                    userData: currentUserData,
                    onItemTap: _handleItemTap,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
