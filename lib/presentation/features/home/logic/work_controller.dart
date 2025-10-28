import 'package:logger/logger.dart';
import 'package:roman/presentation/features/home/data/settings_repository.dart';
import 'package:roman/presentation/features/home/data/work_repository.dart';

import '../model/work_session.dart';

class WorkController {
  final log = Logger();
  final WorkRepository workRepository;
  final SettingsRepository settingsRepository;

  late double _hourlyRate;
  late String _name;
  DateTime? _startTime;

  WorkController({
    required this.workRepository,
    required this.settingsRepository,
  }) {
    refreshData();
  }

  String getName() => _name;

  double getHourlyRate() => _hourlyRate;

  DateTime? get startTime => _startTime;

  refreshData() {
    _name = settingsRepository.getName();
    _hourlyRate = settingsRepository.getHourlyRate();
    _startTime = settingsRepository.getStartTime();
  }

  void setName(String name) {
    settingsRepository.setName(name);
  }

  void setHourlyRate(double hourlyRate) {
    settingsRepository.setHourlyRate(hourlyRate);
    _hourlyRate = hourlyRate;
  }

  void startWork() {
    _startTime = DateTime.now();
    settingsRepository.setStartTime(_startTime!);
  }

  WorkSession? stopWork() {
    if (_startTime == null) {
      return null;
    }
    final end = DateTime.now();
    final hours = end.difference(_startTime!).inMinutes / 60.0;
    final earned = hours * _hourlyRate;

    final session = WorkSession(
      start: _startTime!,
      end: end,
      hours: hours,
      earned: earned,
    );
    log.i('$session');

    workRepository.addSession(session);
    _startTime = null;
    settingsRepository.setStartTime(null);
    return session;
  }

  void startStopButton() {
    if (_startTime == null) {
      startWork();
    } else {
      stopWork();
    }
  }

  String getStartTimeAsString() {
    if (_startTime == null) {
      return '00:00';
    }
    return '${_startTime!.day.toString().padLeft(2, '0')}.'
        '${_startTime!.month.toString().padLeft(2, '0')}.'
        '${_startTime!.year.toString()}r.';
  }

  String getElapsedHoursSinceStart() {
    if (_startTime == null) {
      return '(0h)';
    }
    final now = DateTime.now();
    final difference = now.difference(_startTime!);
    final hours = difference.inMinutes / 60;

    return '(${hours.toStringAsFixed(1)}h)';
  }

  String getEarnedForCurrentSession() {
    if (_startTime == null) {
      return '0.00';
    }
    final now = DateTime.now();
    final hours = now.difference(_startTime!).inMinutes / 60.0;
    final earned = hours * _hourlyRate;
    return earned.toStringAsFixed(2);
  }

  String? getEarnedToday() => _getEarnedInRange(
    DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0),
    DateTime.now(),
  );

  String? getEarnedThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now
        .subtract(Duration(days: now.weekday - 1))
        .copyWith(hour: 0, minute: 0);
    return _getEarnedInRange(startOfWeek, now);
  }

  String? getEarnedLastWeek() {
    final now = DateTime.now();
    final startOfThisWeek = now
        .subtract(Duration(days: now.weekday - 1))
        .copyWith(hour: 0, minute: 0);
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));
    final endOfLastWeek = startOfThisWeek.subtract(const Duration(seconds: 1));
    return _getEarnedInRange(startOfLastWeek, endOfLastWeek);
  }

  String? getEarnedThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return _getEarnedInRange(startOfMonth, now);
  }

  String? getEarnedLastMonth() {
    final now = DateTime.now();
    final startOfThisMonth = DateTime(now.year, now.month, 1);
    final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
    final endOfLastMonth = startOfThisMonth.subtract(
      const Duration(seconds: 1),
    );
    return _getEarnedInRange(startOfLastMonth, endOfLastMonth);
  }

  String? getEarnedThisYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    return _getEarnedInRange(startOfYear, now);
  }

  String? getEarnedLastYear() {
    final now = DateTime.now();
    final startOfThisYear = DateTime(now.year, 1, 1);
    final startOfLastYear = DateTime(now.year - 1, 1, 1);
    final endOfLastYear = startOfThisYear.subtract(const Duration(seconds: 1));
    return _getEarnedInRange(startOfLastYear, endOfLastYear);
  }

  String? _getEarnedInRange(DateTime from, DateTime to) {
    final sessions = workRepository.getAllSessions();
    double total = 0.0;

    for (final s in sessions) {
      if (s.end.isAfter(from) && s.start.isBefore(to)) {
        total += s.earned;
      }
    }

    if (_startTime != null && _startTime!.isBefore(to)) {
      final now = DateTime.now();
      final hours = now.difference(_startTime!).inMinutes / 60.0;
      total += hours * _hourlyRate;
    }

    return total == 0 ? null : total.toStringAsFixed(2);
  }
}
