import 'myexpenses_status.dart'; // Import the status enum

// Make sure you have the uuid package dependency in pubspec.yaml
// uuid: ^4.x.x or similar

class Expense {
  String id;
  DateTime expenseDate;
  String description;
  double amount;
  ExpenseStatus status;
  String employeeName;
  String expenseType;
  String visit;
  String visitSchedule;
  double distanceCovered;

  Expense({
    required this.id,
    required this.expenseDate,
    required this.description,
    required this.amount,
    required this.status,
    required this.employeeName,
    required this.expenseType,
    required this.visit,
    required this.visitSchedule,
    required this.distanceCovered,
  });
}
