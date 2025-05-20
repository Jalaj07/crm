import 'package:flutter/foundation.dart'; // For immutable annotation if desired

enum LeaveStatus { none, pending, approved, rejected }

@immutable // Good practice for model classes
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange(this.start, this.end);

  bool get isValid => !end.isBefore(start);
  int get durationInDays => isValid ? end.difference(start).inDays + 1 : 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

@immutable // Good practice for model classes
class LeaveRecord {
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final DateRange? additionalDates;
  final LeaveStatus status;
  final String? reason;

  // Removed the runtime assert from the const constructor
  const LeaveRecord({
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.additionalDates,
    required this.status,
    this.reason,
  });

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaveRecord &&
          runtimeType == other.runtimeType &&
          leaveType == other.leaveType &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          additionalDates == other.additionalDates && // Uses DateRange ==
          status == other.status &&
          reason == other.reason;

  @override
  int get hashCode =>
      leaveType.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      additionalDates.hashCode ^ // Uses DateRange hashCode
      status.hashCode ^
      reason.hashCode;
}
