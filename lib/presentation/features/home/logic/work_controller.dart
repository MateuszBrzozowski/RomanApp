import 'package:logger/logger.dart';
import 'package:roman/presentation/features/home/data/work_repository.dart';

import '../model/work_session.dart';

class WorkController {
  final log = Logger();
  final WorkRepository repository;
  late double _hourlyRate;
  late String _name;
  DateTime? _startTime;

  WorkController(this.repository) {
    _name = repository.getName();
    _hourlyRate = repository.getHourlyRate();
  }

  String getName() => _name;

  double getHourlyRate() => _hourlyRate;

  DateTime? get startTime => _startTime;

  void setName(String name) {
    repository.setName(name);
  }

  void setHourlyRate(double hourlyRate) {
    repository.setHourlyRate(hourlyRate);
    _hourlyRate = hourlyRate;
  }

  void startWork() {
    _startTime = DateTime.now();
  }

  WorkSession? stopWork() {
    if (_startTime == null) return null;

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

    // repository.addSession(session);
    _startTime = null;
    return session;
  }

  void startStopButton() {
    if (_startTime == null) {
      startWork();
    } else {
      stopWork();
    }
  }
}
