// screen/hrms/survey_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/hrms/survey_model.dart';
import 'survey_form_modal.dart'; // Import the new modal
import '../../models/hrms/survey_question_model.dart'; // Import question models
// survey_details_screen.dart is no longer imported for onTap navigation

class SurveyListScreen extends StatefulWidget {
  const SurveyListScreen({super.key});

  @override
  State<SurveyListScreen> createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  // Mock data for surveys - updated with questions
  final List<Survey> _surveys = [
    // Made it non-final to allow modification
    Survey(
      id: 'survey001',
      title: 'Annual Employee Satisfaction Survey',
      description:
          'Share your feedback to help us improve our workplace. This survey has multiple pages.',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: SurveyStatus.open,
      isCompletedByUser: false,
      displayMode: SurveyDisplayMode.singleQuestionPerPage,
      questions: [
        TextInfoQuestion(
          id: 's1_info_welcome',
          questionText:
              'Welcome! Your feedback is important for improving our work environment. All responses are confidential.',
          page: 1,
        ),
        McqQuestion(
          id: 's1_q1_department',
          questionText: 'Which department do you primarily work in?',
          options: [
            SurveyOption(id: 'dept_hr', text: 'Human Resources'),
            SurveyOption(id: 'dept_it', text: 'Information Technology'),
            SurveyOption(id: 'dept_finance', text: 'Finance'),
            SurveyOption(id: 'dept_sales', text: 'Sales & Marketing'),
            SurveyOption(id: 'dept_ops', text: 'Operations'),
            SurveyOption(id: 'dept_other', text: 'Other'),
          ],
          isMandatory: true,
          page: 1,
        ),
        TextInputQuestion(
          id: 's1_q2_job_role',
          questionText: 'What is your current job role or title?',
          hintText: 'E.g., Software Engineer, HR Manager',
          isMandatory: true,
          page: 2,
        ),
        McqQuestion(
          id: 's1_q3_satisfaction',
          questionText:
              'Overall, how satisfied are you with your job at our company?',
          options: [
            SurveyOption(id: 'sat_very', text: 'Very Satisfied'),
            SurveyOption(id: 'sat_satisfied', text: 'Satisfied'),
            SurveyOption(id: 'sat_neutral', text: 'Neutral'),
            SurveyOption(id: 'sat_dissatisfied', text: 'Dissatisfied'),
            SurveyOption(id: 'sat_very_diss', text: 'Very Dissatisfied'),
          ],
          isMandatory: true,
          page: 2,
        ),
        MsqQuestion(
          id: 's1_q4_improvement_areas',
          questionText:
              'Which of the following areas do you think need improvement? (Select all that apply)',
          options: [
            SurveyOption(id: 'imp_communication', text: 'Communication'),
            SurveyOption(id: 'imp_worklife', text: 'Work-life Balance'),
            SurveyOption(
              id: 'imp_career_growth',
              text: 'Career Growth Opportunities',
            ),
            SurveyOption(id: 'imp_training', text: 'Training and Development'),
            SurveyOption(
              id: 'imp_compensation',
              text: 'Compensation and Benefits',
            ),
          ],
          isMandatory: false, // This is optional
          page: 3,
        ),
        TextInputQuestion(
          id: 's1_q5_comments',
          questionText:
              'Do you have any other comments or suggestions for improvement?',
          hintText: 'Type your anonymous feedback here...',
          isMandatory: false,
          page: 3,
        ),
      ],
    ),
    Survey(
      id: 'survey002',
      title: 'Work From Home Policy Feedback',
      description:
          'Help us refine our WFH policy. This is a single-page scrollable survey.',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      status: SurveyStatus.open,
      isCompletedByUser: true, // Example of an already completed survey
      displayMode: SurveyDisplayMode.scrollablePage,
      questions: [
        TextInfoQuestion(
          id: 'wfh_info',
          questionText:
              'This survey aims to gather your feedback on the current Work From Home policy to ensure it meets the needs of our employees and the company.',
        ),
        McqQuestion(
          id: 'wfh_q1_current_wfh',
          questionText: 'How often do you currently utilize the WFH option?',
          options: [
            SurveyOption(id: 'wfh_fulltime', text: 'Full-time WFH'),
            SurveyOption(
              id: 'wfh_hybrid_majority',
              text: 'Hybrid (Majority WFH)',
            ),
            SurveyOption(
              id: 'wfh_hybrid_minority',
              text: 'Hybrid (Majority Office)',
            ),
            SurveyOption(id: 'wfh_rarely', text: 'Rarely/Never'),
          ],
          isMandatory: true,
        ),
        TextInputQuestion(
          id: 'wfh_q2_productivity',
          questionText:
              'Describe your productivity level when working from home compared to the office.',
          hintText: 'e.g., More productive, less interruptions...',
          isMandatory: true,
        ),
        MsqQuestion(
          id: 'wfh_q3_tools',
          questionText:
              'Which tools or resources are most critical for your WFH success? (Select up to 3)',
          options: [
            SurveyOption(id: 'tool_vpn', text: 'Reliable VPN Access'),
            SurveyOption(
              id: 'tool_communication',
              text: 'Team Communication Platforms (Slack, Teams)',
            ),
            SurveyOption(
              id: 'tool_video_conf',
              text: 'Video Conferencing Software (Zoom, Google Meet)',
            ),
            SurveyOption(
              id: 'tool_project_mgmt',
              text: 'Project Management Tools (Jira, Asana)',
            ),
            SurveyOption(
              id: 'tool_ergonomic',
              text: 'Ergonomic Equipment Stipend/Support',
            ),
          ],
          isMandatory: false,
        ),
      ],
    ),
    Survey(
      id: 'survey003',
      title: 'Training Needs Assessment Q3',
      description: 'Identify key areas for upcoming training programs.',
      status: SurveyStatus.pending,
      questions: [], // This survey has no questions defined yet
    ),
    Survey(
      id: 'survey004',
      title: 'Q2 Performance Review Feedback',
      description: 'Your thoughts on the recent performance review cycle.',
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      status: SurveyStatus.closed,
      isCompletedByUser: true,
      questions: [
        TextInfoQuestion(
          id: "closed_info",
          questionText: "This survey is closed and was for Q2 feedback.",
        ),
      ],
    ),
    Survey(
      id: 'survey005',
      title: 'New Cafeteria Menu Suggestions',
      description: 'Let us know what you\'d like to see in the new menu!',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      status: SurveyStatus.open,
      isCompletedByUser: false,
      questions: [
        TextInputQuestion(
          id: 'cafe_q1',
          questionText:
              "What's your favorite dish you'd love to see in the cafeteria?",
          isMandatory: true,
          hintText: "e.g., Chicken Alfredo, Veggie Burgers",
        ),
        McqQuestion(
          id: 'cafe_q2',
          questionText: "What's your preferred cuisine type for daily lunches?",
          options: [
            SurveyOption(id: "c_italian", text: "Italian"),
            SurveyOption(id: "c_indian", text: "Indian"),
            SurveyOption(id: "c_mexican", text: "Mexican"),
            SurveyOption(id: "c_asian", text: "Asian (Chinese, Thai, etc.)"),
            SurveyOption(id: "c_continental", text: "Continental/Local"),
          ],
          isMandatory: true,
        ),
        MsqQuestion(
          id: 'cafe_q3',
          questionText:
              "What kind of snacks would you prefer? (Select all that apply)",
          options: [
            SurveyOption(id: "snack_fruit", text: "Fresh Fruits"),
            SurveyOption(id: "snack_healthy", text: "Healthy Bars/Nuts"),
            SurveyOption(id: "snack_savory", text: "Savory (Chips, Pretzels)"),
            SurveyOption(
              id: "snack_sweets",
              text: "Sweets (Cookies, Pastries)",
            ),
          ],
          isMandatory: false,
        ),
      ],
    ),
  ];

  SurveyStatus? _selectedFilter;

  List<Survey> get _filteredSurveys {
    if (_selectedFilter == null) return _surveys;
    return _surveys.where((survey) {
      if (_selectedFilter == SurveyStatus.completed) {
        return survey.isCompletedByUser;
      }
      if (_selectedFilter == SurveyStatus.open) {
        return survey.status == SurveyStatus.open && !survey.isCompletedByUser;
      }
      return survey.status == _selectedFilter; // For closed, pending
    }).toList();
  }

  void _handleSurveyTap(Survey survey) {
    if (survey.isCompletedByUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have already completed "${survey.title}".'),
        ),
      );
      return;
    }
    if (survey.status != SurveyStatus.open) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${survey.title}" is currently ${survey.status.displayName.toLowerCase()} and not open for submissions.',
          ),
        ),
      );
      return;
    }
    if (survey.questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${survey.title}" has no questions defined yet.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false, // User must explicitly close or submit
      builder: (BuildContext context) {
        return SurveyFormModal(survey: survey);
      },
    ).then((submitted) {
      if (submitted == true && mounted) {
        setState(() {
          final index = _surveys.indexWhere((s) => s.id == survey.id);
          if (index != -1) {
            // Create a new Survey object with isCompletedByUser updated
            _surveys[index] = Survey(
              id: _surveys[index].id,
              title: _surveys[index].title,
              description: _surveys[index].description,
              dueDate: _surveys[index].dueDate,
              status: _surveys[index].status, // Original status
              isCompletedByUser: true, // Now completed
              questions: _surveys[index].questions,
              displayMode: _surveys[index].displayMode,
            );
          }
        });
      }
    });
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            FilterChip(
              label: const Text('All'),
              selected: _selectedFilter == null,
              onSelected:
                  (bool selected) => setState(() => _selectedFilter = null),
              selectedColor: Theme.of(
                context,
              ).colorScheme.primary.withAlpha(76),
            ),
            const SizedBox(width: 8),
            ...SurveyStatus.values
                .where(
                  (s) => s != SurveyStatus.pending,
                ) // Exclude 'pending' from quick filters if not desired or handled specifically elsewhere. Or include if desired.
                .map(
                  (status) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      avatar: Icon(status.icon, color: status.color, size: 18),
                      label: Text(
                        status == SurveyStatus.open
                            ? "To Do"
                            : status.displayName,
                      ), // "Open" filter usually means "To Do"
                      selected: _selectedFilter == status,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilter = selected ? status : null;
                        });
                      },
                      selectedColor: status.color.withAlpha(76),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFilteredSurveys = _filteredSurveys;

    return Scaffold(
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child:
                currentFilteredSurveys.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No surveys found for this filter.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_selectedFilter != null)
                            TextButton(
                              onPressed:
                                  () => setState(() => _selectedFilter = null),
                              child: const Text('Show all surveys'),
                            ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: currentFilteredSurveys.length,
                      itemBuilder: (context, index) {
                        final survey = currentFilteredSurveys[index];
                        final effectiveStatus =
                            survey.isCompletedByUser
                                ? SurveyStatus.completed
                                : survey.status;
                        bool canAttemptSurvey =
                            survey.status == SurveyStatus.open &&
                            !survey.isCompletedByUser &&
                            survey.questions.isNotEmpty;

                        return Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap:
                                () => _handleSurveyTap(
                                  survey,
                                ), // Use the updated tap handler
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          survey.title,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Chip(
                                        avatar: Icon(
                                          effectiveStatus.icon,
                                          color: effectiveStatus.color,
                                          size: 16,
                                        ),
                                        label: Text(
                                          effectiveStatus.displayName,
                                          style: TextStyle(
                                            color: effectiveStatus.color,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        backgroundColor: effectiveStatus.color
                                            .withAlpha(38),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 2.0,
                                        ),
                                        labelPadding: const EdgeInsets.only(
                                          left: 2,
                                          right: 6,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          side: BorderSide(
                                            color: effectiveStatus.color
                                                .withAlpha(127),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    survey.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey[700]),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        survey.dueDate != null
                                            ? 'Due: ${DateFormat.yMMMd().format(survey.dueDate!)}'
                                            : (survey.status ==
                                                    SurveyStatus.closed
                                                ? 'Ended'
                                                : 'No due date'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey[600]),
                                      ),
                                      const Spacer(),
                                      if (canAttemptSurvey)
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      if (survey.isCompletedByUser &&
                                          survey.status ==
                                              SurveyStatus
                                                  .open) // Completed but still "open"
                                        Icon(
                                          Icons.task_alt,
                                          size: 18,
                                          color: SurveyStatus.completed.color,
                                        ),
                                      if (!canAttemptSurvey &&
                                          !survey.isCompletedByUser &&
                                          survey.status !=
                                              SurveyStatus
                                                  .open) // Not attemptable (e.g. pending, closed)
                                        Icon(
                                          effectiveStatus.icon,
                                          size: 18,
                                          color: effectiveStatus.color
                                              .withAlpha(127),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
