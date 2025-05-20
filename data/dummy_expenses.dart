// lib/data/dummy_expenses.dart
import 'package:flutter_development/models/hrms/myexpenses/myexpenses.dart';
import 'package:flutter_development/models/hrms/myexpenses/myexpenses_status.dart';

List<Expense> getDummyExpenses(String employeeName) {
  // Pass employeeName if it varies or is needed by model
  return [
    Expense(
      id: '3687550333999',
      expenseDate: DateTime(2025, 4, 29),
      description: 'Software Subscription Renewal',
      amount: 150.00,
      status: ExpenseStatus.submitted,
      employeeName: employeeName,
      expenseType: 'Office Supplies',
      visit: 'N/A',
      visitSchedule: 'N/A',
      distanceCovered: 0.0,
    ),
    // ... copy all other Expense objects from your _MyExpensesScreenState
    Expense(
      id: '1687850123456',
      expenseDate: DateTime.now().subtract(const Duration(days: 10)),
      description: 'Attend HR Seminar in City B',
      amount: 1250.00,
      status: ExpenseStatus.approved,
      employeeName: employeeName,
      expenseType: 'Domestic',
      visit: 'City B Seminar Hall',
      visitSchedule: 'N/A',
      distanceCovered: 55.0,
    ),
    Expense(
      id: '1687900987654',
      expenseDate: DateTime.now().subtract(const Duration(days: 15)),
      description: 'Global Marketing Conference 2024 Expenses',
      amount: 4850.00,
      status: ExpenseStatus.submitted,
      employeeName: employeeName,
      expenseType: 'International',
      visit: 'Conference Venue LA',
      visitSchedule: 'N/A',
      distanceCovered: 15000.0,
    ),
    Expense(
      id: '1687770555111',
      expenseDate: DateTime(2025, 4, 10),
      description: 'Team Lunch - Project Finalization',
      amount: 3500.00,
      status: ExpenseStatus.paid,
      employeeName: employeeName,
      expenseType: 'Meal',
      visit: 'Local Restaurant',
      visitSchedule: 'N/A',
      distanceCovered: 5.0,
    ),
    Expense(
      id: '1687660444222',
      expenseDate: DateTime.now().subtract(const Duration(days: 25)),
      description: 'Taxi for Client Visit - South Zone',
      amount: 580.00,
      status: ExpenseStatus.refused,
      employeeName: employeeName,
      expenseType: 'Transport',
      visit: 'Client Office South',
      visitSchedule: 'N/A',
      distanceCovered: 25.0,
    ),
  ];
}
