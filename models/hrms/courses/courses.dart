// lib/models/course.dart

// No Flutter import needed for this basic model.

class CourseResource {
  final String title;
  final String url;
  CourseResource({required this.title, required this.url});
}

class Course {
  final String id;
  final String title;
  final int views;
  final String duration;
  final int contents;
  final int attendees;
  final int finished;
  final String photoUrl;
  final String description;
  final List<CourseResource> resources;

  Course({
    required this.id,
    required this.title,
    required this.views,
    required this.duration,
    required this.contents,
    required this.attendees,
    required this.finished,
    required this.photoUrl,
    required this.description,
    required this.resources,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // Helper function local to factory for parsing
    int parseIntSafely(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Course(
      id: json['id']?.toString() ?? 'unknown_id',
      title: json['title'] as String? ?? 'No Title',
      views: parseIntSafely(json['views']),
      duration: json['duration'] as String? ?? '00:00',
      contents: parseIntSafely(json['contents']),
      attendees: parseIntSafely(json['attendees']),
      finished: parseIntSafely(json['finished']),
      photoUrl:
          json['photoUrl'] ??
          'https://via.placeholder.com/300x120.png?text=Course+Image',
      description: json['description'] ?? 'No description available.',
      resources:
          (json['resources'] as List<dynamic>? ?? [])
              .map(
                (r) => CourseResource(
                  title: r['title'] ?? 'Resource',
                  url: r['url'] ?? '',
                ),
              )
              .toList(),
    );
  }
}
