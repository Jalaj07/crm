import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/central_app_theme_color.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // Function to launch URLs (email, website, phone)
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  Icons.support_agent,
                  'Contact Us',
                  () => _showContactOptions(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  Icons.live_help,
                  'FAQs',
                  () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const FAQScreen())),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  Icons.article_outlined,
                  'Guides',
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GuidesScreen()),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Common Issues Section
          Text(
            'Common Issues',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          _buildIssueCard(
            context,
            'Account & Login',
            'Resolve issues with logging in or account access.',
            Icons.account_circle_outlined,
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AccountHelpScreen()),
            ),
          ),

          _buildIssueCard(
            context,
            'App Performance',
            'Help with crashes, freezes or slow performance.',
            Icons.speed_outlined,
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PerformanceHelpScreen()),
            ),
          ),

          _buildIssueCard(
            context,
            'Feature Requests',
            'Suggest new features or improvements.',
            Icons.lightbulb_outline,
            () => _showFeatureRequestForm(context),
          ),

          const SizedBox(height: 24),

          // Additional Resources Section
          Text(
            'Additional Resources',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withAlpha(51),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.videocam_outlined,
                color: theme.colorScheme.tertiary,
              ),
            ),
            title: Text('Video Tutorials', style: theme.textTheme.titleSmall),
            subtitle: Text(
              'Step-by-step visual guides',
              style: theme.textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showVideoTutorialsModal(context),
          ),

          const Divider(),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withAlpha(51),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: theme.colorScheme.tertiary,
              ),
            ),
            title: Text('Knowledge Base', style: theme.textTheme.titleSmall),
            subtitle: Text(
              'Comprehensive documentation',
              style: theme.textTheme.bodyMedium,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showKnowledgeBaseModal(context),
          ),

          const Divider(),

          const SizedBox(height: 24),

          // Social Media Support
          Text(
            'Connect With Us',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.business),
                onPressed:
                    () =>
                        _launchUrl('https://www.linkedin.com/company/gainhub/'),
                iconSize: 28,
                color: theme.colorScheme.tertiary,
              ),
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: () => _launchUrl('https://gain-hub.com/'),
                iconSize: 28,
                color: theme.colorScheme.tertiary,
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.tertiary),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withAlpha(51),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.tertiary),
        ),
        title: Text(title, style: theme.textTheme.titleSmall),
        subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder:
                (_, controller) => Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text(
                      'Contact Support',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose how you\'d like to reach us',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildContactTile(
                            context,
                            'Email Support',
                            'Get help within 24 hours',
                            Icons.email_outlined,
                            theme.colorScheme.error.withAlpha(25),
                            theme.colorScheme.error,
                            () => _launchUrl('mailto:care@gain-hub.com'),
                          ),
                          const SizedBox(height: 16),
                          _buildContactTile(
                            context,
                            'Phone Support',
                            'Call our support team',
                            Icons.phone_outlined,
                            theme.colorScheme.primary.withAlpha(25),
                            theme.colorScheme.primary,
                            () => _launchUrl('tel:+18001234567'),
                          ),
                          const SizedBox(height: 16),
                          _buildContactTile(
                            context,
                            'Help Ticket',
                            'Create a support ticket',
                            Icons.assignment_outlined,
                            theme.colorScheme.secondary.withAlpha(25),
                            theme.colorScheme.secondary,
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TicketScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureRequestForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request a Feature',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (val) {},
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Please enter a title'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    minLines: 2,
                    maxLines: 5,
                    onChanged: (val) {},
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Please enter a description'
                                : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feature request submitted!'),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }

  void _showVideoTutorialsModal(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Video Tutorials',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildMediaCard(
                          title: 'How to use the app',
                          description:
                              'Learn the basic features and navigation',
                          imageUrl: 'assets/images/tutorial1.jpg',
                          isVideo: true,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading video tutorial...'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMediaCard(
                          title: 'Attendance Tracking',
                          description: 'Learn how to manage your attendance',
                          imageUrl: 'assets/images/tutorial2.jpg',
                          isVideo: true,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading video tutorial...'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMediaCard(
                          title: 'Submitting a Leave Request',
                          description: 'Step by step guide for leave requests',
                          imageUrl: 'assets/images/tutorial3.jpg',
                          isVideo: true,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading video tutorial...'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showKnowledgeBaseModal(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Knowledge Base',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildMediaCard(
                          title: 'Employee Handbook',
                          description: 'Complete guide for employees',
                          imageUrl: 'assets/images/handbook.jpg',
                          isVideo: false,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading PDF...'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMediaCard(
                          title: 'Leave Policy',
                          description: 'Detailed leave policy documentation',
                          imageUrl: 'assets/images/leave_policy.jpg',
                          isVideo: false,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading PDF...'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMediaCard(
                          title: 'Expense Guidelines',
                          description: 'Guidelines for expense claims',
                          imageUrl: 'assets/images/expense.jpg',
                          isVideo: false,
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading PDF...'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildMediaCard({
    required String title,
    required String description,
    required String imageUrl,
    required bool isVideo,
    required VoidCallback onDownload,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        if (!isVideo) {
          // Special layout for PDF documents
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.picture_as_pdf,
                        size: 32,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onDownload,
                            icon: const Icon(Icons.file_download, size: 18),
                            label: const Text(
                              'Download PDF',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Video tutorial layout
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/default_video.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 40,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withAlpha(127),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: onDownload,
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text(
                            'Download Video',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// Additional screens for navigation
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> faqItems = [
      {
        'question': 'How do I reset my password?',
        'answer':
            'To reset your password, go to the login screen and tap on "Forgot Password". Follow the instructions sent to your email to create a new password.',
      },
      {
        'question': 'How do I update my profile information?',
        'answer':
            'Go to Settings > Profile to update your personal information, including name, email, and profile picture.',
      },
      {
        'question': 'Is my data secure?',
        'answer':
            'Yes. We use industry-standard encryption to protect your data. We never share your personal information with third parties without your consent.',
      },
      {
        'question': 'How do I cancel my subscription?',
        'answer':
            'To cancel your subscription, go to Settings > Account > Subscription and tap "Cancel Subscription". Your subscription will remain active until the end of the current billing period.',
      },
      {
        'question': 'Can I use the app offline?',
        'answer':
            'Some features of the app are available offline, but full functionality requires an internet connection to sync your data.',
      },
      {
        'question': 'How do I delete my account?',
        'answer':
            'To delete your account, go to Settings > Account > Delete Account. Please note that this action is permanent and all your data will be lost.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Frequently Asked Questions')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          final item = faqItems[index];
          return _buildFaqCard(item['question'], item['answer']);
        },
      ),
    );
  }
}

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> guideItems = [
      {
        'question': 'How do I navigate the app?',
        'answer':
            'The app has a bottom navigation bar with main sections: Home, Report, Leave, and Profile. Tap on each icon to access different features.',
      },
      {
        'question': 'How to submit reports?',
        'answer':
            'Go to the Report section, click the + button, fill in the required details, and click Submit. You can track your submitted reports in the Report History tab.',
      },
      {
        'question': 'How to manage notifications?',
        'answer':
            'Go to Profile > Settings > Notifications to customize which notifications you want to receive. You can enable/disable different types of alerts.',
      },
      {
        'question': 'How to update my profile information?',
        'answer':
            'Navigate to the Profile section, tap on Edit Profile, make your changes, and tap Save to update your information.',
      },
      {
        'question': 'How to download documents?',
        'answer':
            'In relevant sections, look for the download icon or button. Tap it to start downloading. You can find downloaded files in your device\'s download folder.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('User Guides')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: guideItems.length,
        itemBuilder: (context, index) {
          final item = guideItems[index];
          return _buildFaqCard(item['question'], item['answer']);
        },
      ),
    );
  }
}

class AccountHelpScreen extends StatelessWidget {
  const AccountHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> accountItems = [
      {
        'question': 'How do I reset my password?',
        'answer':
            '1. Tap "Forgot Password" on the login screen\n2. Enter your email address\n3. Check your email for reset instructions\n4. Follow the link to create a new password',
      },
      {
        'question': 'Why am I getting login errors?',
        'answer':
            'Common reasons include:\n• Incorrect email/password\n• Caps Lock enabled\n• Network connectivity issues\n• Account might be locked after multiple failed attempts',
      },
      {
        'question': 'How to enable quick login?',
        'answer':
            '1. Successfully log in once with your credentials\n2. Enable "Remember Me" option\n3. Next time, use Quick Login button for faster access',
      },
      {
        'question': 'How to update my email address?',
        'answer':
            '1. Go to Profile Settings\n2. Select "Update Email"\n3. Enter new email address\n4. Verify through confirmation link sent to new email',
      },
      {
        'question': 'What to do if account is locked?',
        'answer':
            '• Wait for 30 minutes before trying again\n• Use password reset option\n• Contact support if issues persist',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Account Help')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: accountItems.length,
        itemBuilder: (context, index) {
          final item = accountItems[index];
          return _buildFaqCard(item['question'], item['answer']);
        },
      ),
    );
  }
}

class PerformanceHelpScreen extends StatelessWidget {
  const PerformanceHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> performanceItems = [
      {
        'question': 'Why is the app running slowly?',
        'answer':
            'Try these steps:\n1. Clear app cache\n2. Check internet connection\n3. Close other apps\n4. Restart the app\n5. Update to latest version',
      },
      {
        'question': 'How to fix app crashes?',
        'answer':
            '1. Update to the latest version\n2. Clear app data and cache\n3. Check device storage space\n4. Reinstall the app if issues persist',
      },
      {
        'question': 'How to improve app performance?',
        'answer':
            '• Keep app updated\n• Clear cache regularly\n• Maintain good internet connection\n• Free up device storage\n• Close unused apps',
      },
      {
        'question': 'Why are images not loading?',
        'answer':
            'Common causes:\n• Poor internet connection\n• Cache issues\n• Storage space full\n• Try clearing cache or restarting the app',
      },
      {
        'question': 'How to report performance issues?',
        'answer':
            '1. Go to Help & Support\n2. Select "Report Issue"\n3. Describe the problem\n4. Include steps to reproduce\n5. Submit report',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Performance Help')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: performanceItems.length,
        itemBuilder: (context, index) {
          final item = performanceItems[index];
          return _buildFaqCard(item['question'], item['answer']);
        },
      ),
    );
  }
}

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Support Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit a Support Ticket',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please provide details about your issue and we\'ll get back to you as soon as possible.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Issue Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items:
                  [
                        'Account',
                        'Payment',
                        'Technical',
                        'Feature Request',
                        'Other',
                      ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support ticket submitted successfully!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Submit Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help & Support',
      theme: ThemeController.lightTheme,
      darkTheme: ThemeController.darkTheme,
      themeMode: ThemeMode.system,
      home: const HelpSupportScreen(),
    );
  }
}

void main() {
  runApp(const MyApp());
}

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
    return Course(
      id: json['id']?.toString() ?? 'unknown_id',
      title: json['title'] as String? ?? 'No Title',
      views: int.tryParse(json['views'].toString()) ?? 0,
      duration: json['duration'] as String? ?? '00:00',
      contents: int.tryParse(json['contents'].toString()) ?? 0,
      attendees: int.tryParse(json['attendees'].toString()) ?? 0,
      finished: int.tryParse(json['finished'].toString()) ?? 0,
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

final mockData = [
  {
    'id': '1',
    'title': 'Leadership Development',
    'views': 0,
    'duration': '00:00',
    'contents': 10,
    'attendees': 1,
    'finished': 3,
    'photoUrl': 'https://via.placeholder.com/300x120.png?text=Leadership',
    'description': 'Learn the essentials of leadership.',
    'resources': [
      {'title': 'Syllabus PDF', 'url': 'https://example.com/syllabus.pdf'},
      {'title': 'Slides', 'url': 'https://example.com/slides.pdf'},
    ],
  },
  // ... more courses
];

Widget _buildFaqCard(String question, String answer) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            question,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    },
  );
}
