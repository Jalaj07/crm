import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isClockedIn = false;
  DateTime? _lastClockIn;
  DateTime? _lastClockOut;
  bool _isClockInLoading = false;
  bool _isClockOutLoading = false;

  bool get isClockedIn => _isClockedIn;
  DateTime? get lastClockIn => _lastClockIn;
  DateTime? get lastClockOut => _lastClockOut;
  bool get isClockInLoading => _isClockInLoading;
  bool get isClockOutLoading => _isClockOutLoading;

  void clockIn() async {
    if (_isClockedIn) return;
    _isClockInLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _isClockInLoading = false;
    _isClockedIn = true;
    _lastClockIn = DateTime.now();
    notifyListeners();
  }

  void clockOut() async {
    if (!_isClockedIn) return;
    _isClockOutLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _isClockOutLoading = false;
    _isClockedIn = false;
    _lastClockOut = DateTime.now();
    notifyListeners();
  }

  void reset() {
    _isClockedIn = false;
    _lastClockIn = null;
    _lastClockOut = null;
    _isClockInLoading = false;
    _isClockOutLoading = false;
    notifyListeners();
  }
}
