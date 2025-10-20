import 'package:hive/hive.dart';

import '../model/work_session.dart';

class WorkRepository {
  final _box = Hive.box('workBox');

  void setName(String name) {
    _box.put('name', name);
  }

  String getName() {
    final name = _box.get('name');
    if (name == null) {
      setName('Roman');
      return 'Roman';
    }
    return name;
  }

  void setHourlyRate(double rate) {
    _box.put('rate', rate);
  }

  double getHourlyRate() {
    final rate = _box.get('rate');
    if (rate == null) {
      setHourlyRate(10.0);
      return 10.0;
    }
    return rate;
  }

  void addSession(WorkSession session) {
    _box.add(session.toMap());
  }

  List<WorkSession> getAllSessions() {
    final values = _box.values.cast<Map>().toList();
    return values.map((map) => WorkSession.fromMap(map)).toList();
  }
}
