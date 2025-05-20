import 'package:flutter/material.dart';
import 'package:flutter_development/theme/central_app_theme_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            title: 'Settings Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: themeController.themeMode,
            home: const SettingsScreen(),
          );
        },
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Preferences
  bool _notificationsEnabled = true;
  double _textSize = 16.0;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _textSize = prefs.getDouble('textSize') ?? 16.0;
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setDouble('textSize', _textSize);
    await prefs.setString('language', _selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        children: [
          // Appearance Section
          _buildSectionCard([
            _buildSectionHeader('Appearance'),
            // Theme Mode Selection
            ListTile(
              title: const Text('Theme'),
              subtitle: const Text('Choose light, dark, or system theme'),
              leading: const Icon(Icons.brightness_4),
              trailing: DropdownButton<ThemeMode>(
                value: themeController.themeMode,
                items:
                    ThemeMode.values.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(mode.name.capitalize()),
                      );
                    }).toList(),
                onChanged: (ThemeMode? newMode) {
                  if (newMode != null) {
                    themeController.setThemeMode(newMode);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Text Size'),
              subtitle: Text('${_textSize.toInt()} px'),
              trailing: SizedBox(
                width: 160,
                child: Slider(
                  value: _textSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 6,
                  label: _textSize.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _textSize = value;
                      _savePreferences();
                    });
                  },
                ),
              ),
            ),
          ]),

          // Notifications Section
          _buildSectionCard([
            _buildSectionHeader('Notifications'),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Allow app to send you notifications'),
              secondary: const Icon(Icons.notifications),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  _savePreferences();
                });
              },
            ),
          ]),

          // Language Section
          _buildSectionCard([
            _buildSectionHeader('Language'),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('App Language'),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                  DropdownMenuItem(value: 'French', child: Text('French')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                      _savePreferences();
                    });
                  }
                },
              ),
            ),
          ]),

          // About Section
          _buildSectionCard([
            _buildSectionHeader('About'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navigation to terms of service'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigation to privacy policy')),
                );
              },
            ),
          ]),

          // Advanced Section
          _buildSectionCard([
            _buildSectionHeader('Advanced'),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear Cache'),
              onTap: () {
                _showClearCacheDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Reset All Settings'),
              onTap: () {
                _showResetSettingsDialog();
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cache'),
            content: const Text(
              'Are you sure you want to clear the app cache?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared')),
                  );
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset Settings'),
            content: const Text(
              'Are you sure you want to reset all settings to default?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _notificationsEnabled = true;
                    _textSize = 16.0;
                    _selectedLanguage = 'English';
                    _savePreferences();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings reset to default')),
                  );
                },
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
