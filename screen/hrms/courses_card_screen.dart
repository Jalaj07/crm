// lib/pages/courses_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_development/screen/hrms/courses_quiz_screen.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
// Use SharePlus
import 'package:share_plus/share_plus.dart';

// Import the new Quiz Page
import '../../models/hrms/courses/courses.dart'; // Adjust path if needed (e.g., ../../models/course.dart)
import '../../widgets/hrms/courses/courses_card.dart'; // Adjust path if needed
import '../../constants/courses_layout_constants.dart'; // Adjust path if needed

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));

      // --- FIX 1: Explicitly type mockData ---
      final List<Map<String, dynamic>> mockData = [
        {
          'id': '1',
          'title': 'Leadership Development',
          'views': 0,
          'duration': '00:00',
          'contents': 10,
          'attendees': 1,
          'finished': 3,
          'photoUrl':
              'https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=600', // Sample real URL
          'description': 'Learn the essentials of leadership.',
          'resources': [
            {
              'title': 'Syllabus PDF',
              'url': 'https://example.com/syllabus.pdf',
            }, // Ensure Maps within list are also compatible
            {'title': 'Slides', 'url': 'https://example.com/slides.pdf'},
          ],
        },
        {
          'id': '2',
          'title': 'Engineering Basics Curriculum For Skill Enhancement',
          'views': 0,
          'duration': '01:30',
          'contents': 15,
          'attendees': 1,
          'finished': 10,
          'photoUrl': '', // Test missing URL
          'description':
              'A foundational course covering key engineering principles and skills.',
          'resources': [],
        },
        {
          'id': '3',
          'title': 'Workflow Management',
          'views': 0,
          'duration': '00:45',
          'contents': 8,
          'attendees': 1,
          'finished': 8,
          'photoUrl': 'invalid-url', // Test invalid URL
          'description':
              'Streamline your processes and improve team productivity.',
          'resources': [
            {
              'title': 'Cheatsheet',
              'url': 'https://example.com/cheatsheet.pdf',
            },
          ],
        },
        {
          'id': '4',
          'title': 'Email and Communication Etiquette in the Workplace',
          'views': 0,
          'duration': '02:00',
          'contents': 12,
          'attendees': 1,
          'finished': 5,
          // No photoUrl provided, will use default from model
          'description':
              'Master professional communication via email and other channels.',
          'resources': [],
        },
        {
          'id': '5',
          'title': 'Advanced Flutter Techniques for High-Performance Apps',
          'views': 150,
          'duration': '05:00',
          'contents': 25,
          'attendees': 50,
          'finished': 20,
          'photoUrl':
              'https://images.pexels.com/photos/11035395/pexels-photo-11035395.jpeg?auto=compress&cs=tinysrgb&w=600', // Sample real URL
          'description':
              'Dive deep into Flutter internals, state management, and performance optimization.',
          'resources': [
            {'title': 'Source Code', 'url': 'https://example.com/repo.zip'},
            {
              'title': 'Performance Guide',
              'url': 'https://example.com/perf.pdf',
            },
          ],
        },
      ];

      // Check mounted *after* await
      if (!mounted) return;

      setState(() {
        // Pass the correctly typed mockData here
        _courses = mockData.map((data) => Course.fromJson(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      // Check mounted *after* await (implicitly)
      if (!mounted) return;
      setState(() {
        _error =
            "An error occurred loading courses: ${e.toString()}. Please try again.";
        _isLoading = false;
      });
    }
  }

  // Navigate to Quiz Page
  void _handleTakeQuiz() {
    if (!mounted) return; // Good practice even without await before push
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizPage()),
    );
  }

  void _handleViewCourse(Course course) {
    // Context usage before await is fine
    if (!mounted) return; // Added pre-check for safety before async modal show
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (modalContext) => Padding(
            // Use modalContext inside
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(
                    modalContext,
                  ).viewInsets.bottom, // Use modalContext
              left: 12,
              right: 12,
              top: 40,
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(modalContext).size.height *
                    0.85, // Use modalContext
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Course Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(modalContext),
                            tooltip: 'Close',
                          ), // Use modalContext
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8), // Spacing before image
                      // Course Photo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          // Consistent logic with CourseCard's image builder
                          course.photoUrl.isNotEmpty &&
                                  Uri.tryParse(
                                        course.photoUrl,
                                      )?.hasAbsolutePath ==
                                      true
                              ? course.photoUrl
                              : 'https://via.placeholder.com/300x120/cccccc/969696.png?text=No+Image',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 120,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey[600],
                                    size: 40,
                                  ),
                                ),
                              ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 120,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Course Title
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Course Description
                      Text(
                        course.description,
                        style: TextStyle(color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Resources Section (Conditional display)
                      if (course.resources.isNotEmpty) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Resources',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...course.resources.map<Widget>(
                          (resource) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.insert_drive_file_outlined,
                              color: Colors.blue,
                            ),
                            title: Text(resource.title),
                            trailing: IconButton(
                              icon: const Icon(Icons.download_rounded),
                              tooltip: 'Download ${resource.title}',
                              onPressed: () async {
                                final url = Uri.parse(resource.url);
                                // Store context and mounted status before await
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  modalContext,
                                ); // Use modal's context
                                final isStateMounted =
                                    mounted; // Page state's mounted status

                                try {
                                  bool canLaunch = await canLaunchUrl(url);
                                  // Check State's mounted status AFTER await
                                  if (!isStateMounted) return;

                                  if (canLaunch) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not launch ${resource.url}',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Check State's mounted status again in catch block
                                  if (!isStateMounted) return;
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Error launching URL: $e'),
                                    ),
                                  );
                                }
                              },
                            ),
                            onTap: () async {
                              // Make tile tappable
                              final url = Uri.parse(resource.url);
                              final scaffoldMessenger = ScaffoldMessenger.of(
                                modalContext,
                              );
                              final isStateMounted = mounted;
                              try {
                                bool canLaunch = await canLaunchUrl(url);
                                if (!isStateMounted) return;

                                if (canLaunch) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Could not launch ${resource.url}',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (!isStateMounted) return;
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Error launching URL: $e'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ] else ...[
                        Text(
                          'No additional resources provided for this course.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              // Added icon to Cancel
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed:
                                  () => Navigator.pop(
                                    modalContext,
                                  ), // Use modal context
                              label: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              // --- FIX 2 & 3: Use SharePlus ---
                              icon: const Icon(Icons.share_outlined),
                              label: const Text('Share'),
                              onPressed: () async {
                                // Store necessary info before potential async gaps or pop
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                ); // Use main page context
                                final isStateMounted = mounted;
                                final String shareText =
                                    'Check out this course: ${course.title}\n${course.description}\n';
                                final String shareSubject =
                                    'Course Recommendation: ${course.title}';

                                // Close modal before sharing potentially triggers external app
                                // Use modal context here as it's still valid before pop returns
                                Navigator.pop(modalContext);
                                // Brief delay might be needed if share needs modal fully gone, but often isn't.
                                // await Future.delayed(const Duration(milliseconds: 50));

                                // Check mounted status before the share *await*
                                if (!isStateMounted) return;

                                try {
                                  // Use SharePlus instance
                                  await SharePlus.instance.share(
                                    ShareParams(
                                      text: shareText,
                                      subject: shareSubject,
                                    ),
                                  );
                                  // Optional: Handle result if needed (ShareResult status)
                                  // e.g., print('Share status: ${result.status}');
                                } catch (e) {
                                  // Check mounted status again after await in catch block
                                  // Check if the main page context is still valid (if modal closed first)
                                  if (!isStateMounted) return;
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Could not initiate sharing.',
                                      ),
                                    ),
                                  );
                                }
                              }, // End of onPressed
                            ), // End of ElevatedButton.icon
                          ), // End of Expanded
                        ], // End of Row children
                      ), // End of Row
                    ], // End of Column children
                  ), // End of Column
                ), // End of SingleChildScrollView
              ), // End of ClipRRect
            ), // End of Container
          ), // End of Padding
    ); // End of showModalBottomSheet builder
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    // --- Loading State ---
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    }
    // --- Error State ---
    else if (_error != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(kPagePadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: kVerticalSpacerMedium),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: kVerticalSpacerLarge),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: _fetchCourses, // Re-fetch courses on retry
              ),
            ],
          ),
        ),
      );
    }
    // --- Empty State ---
    else if (_courses.isEmpty) {
      body = const Center(child: Text('No courses found.'));
    }
    // --- Content State ---
    else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Quiz Section Button ---
          Padding(
            padding: const EdgeInsets.fromLTRB(
              kPagePadding,
              kPagePadding,
              kPagePadding,
              kListItemSpacing,
            ),
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadius / 1.5),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withAlpha(76),
                ),
              ),
              child: InkWell(
                onTap: _handleTakeQuiz, // Navigates to QuizPage
                borderRadius: BorderRadius.circular(kBorderRadius / 1.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: kVerticalSpacerMedium),
                      const Expanded(
                        child: Text(
                          'Test Your Knowledge!',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: kVerticalSpacerSmall),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // --- Course List ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                kPagePadding,
                0,
                kPagePadding,
                kPagePadding,
              ),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                // Ensure CourseCard is imported and available
                return CourseCard(
                  course: course,
                  onViewCourse: () => _handleViewCourse(course),
                );
              },
              separatorBuilder:
                  (context, index) => const SizedBox(height: kListItemSpacing),
            ),
          ),
        ],
      );
    }

    // Return the appropriate body wrapped potentially by a Scaffold depending on app structure
    return body;
  }
}

// Make sure you have the following dependencies in your pubspec.yaml:
// dependencies:
//   flutter:
//     sdk: flutter
//   url_launcher: ^... # use latest version
//   share_plus: ^...  # use latest version

// And ensure these files exist with correct relative paths:
// import './quiz_page.dart';
// import '../models/course.dart';
// import '../widgets/course_card.dart';
// import '../constants/course_layout_constants.dart';
