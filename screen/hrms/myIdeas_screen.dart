// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_development/constants/myideas_constants.dart';
import 'package:flutter_development/data/myideas_data.dart';
import 'package:flutter_development/models/hrms/myideas.dart';
import 'package:flutter_development/widgets/hrms/myideas/empty_myideas_view.dart';
import 'package:flutter_development/widgets/hrms/myideas/myideas_card.dart';
import 'package:flutter_development/widgets/hrms/myideas/new_myideas_form.dart';
import 'dart:async';

// Moved Enum here as it's specific to this screen's state management
enum ViewMode { current, newIdea }

class MyIdeasScreen extends StatefulWidget {
  const MyIdeasScreen({super.key});
  @override
  State<MyIdeasScreen> createState() => _MyIdeasScreenState();
}

class _MyIdeasScreenState extends State<MyIdeasScreen> {
  // Use final if the service instance doesn't change
  final IdeaService _ideaService = IdeaService();
  List<Idea> _ideas = [];
  bool _isLoading = true;
  ViewMode _selectedViewMode = ViewMode.current; // Default view

  @override
  void initState() {
    super.initState();
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedIdeas = await _ideaService.getIdeas();
      if (!mounted) return;
      setState(() {
        _ideas = fetchedIdeas;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading ideas: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Cancel any potential streams or long-running operations if needed
    super.dispose();
  }

  void _handleIdeaSubmission(Idea newIdea) async {
    try {
      await _ideaService.addIdea(newIdea);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Idea submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Refresh the list and switch back to the ideas view
        await _loadIdeas(); // Reload to get the updated list
        setState(() {
          _selectedViewMode = ViewMode.current;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting idea: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.itemSpacing,
                horizontal: AppConstants.screenPadding,
              ),
              child: SegmentedButton<ViewMode>(
                segments: const <ButtonSegment<ViewMode>>[
                  ButtonSegment<ViewMode>(
                    value: ViewMode.current,
                    label: Text('Current Ideas'),
                    icon: Icon(Icons.list_alt),
                  ),
                  ButtonSegment<ViewMode>(
                    value: ViewMode.newIdea,
                    label: Text('New Idea'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
                selected: <ViewMode>{_selectedViewMode},
                onSelectionChanged: (Set<ViewMode> newSelection) {
                  setState(() {
                    _selectedViewMode = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedForegroundColor: theme.colorScheme.onPrimary,
                  selectedBackgroundColor: theme.colorScheme.primary,
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: AppConstants.screenPadding,
              endIndent: AppConstants.screenPadding,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildSelectedView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedViewMode) {
      case ViewMode.current:
        return _buildMyIdeasTab(key: const ValueKey('ideas_list'));
      case ViewMode.newIdea:
        return NewIdeaForm(
          key: const ValueKey('new_idea_form'),
          onSubmit: _handleIdeaSubmission,
        );
    }
  }

  Widget _buildMyIdeasTab({Key? key}) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_ideas.isEmpty) {
      return const EmptyIdeasView(); // Use the public widget
    }

    return RefreshIndicator(
      onRefresh: _loadIdeas,
      child: ListView.separated(
        key: key,
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        itemCount: _ideas.length,
        itemBuilder: (context, index) {
          final idea = _ideas[index];
          // Pass necessary data or the whole object
          return IdeaCard(idea: idea);
        },
        separatorBuilder:
            (context, index) =>
                const SizedBox(height: AppConstants.sectionSpacing),
      ),
    );
  }
}
