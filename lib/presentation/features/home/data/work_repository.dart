import 'package:hive/hive.dart';

import '../model/work_session.dart';

class WorkRepository {
  final _box = Hive.box('workBox');

  void addSession(WorkSession session) {
    _box.add(session.toMap());
  }

  List<WorkSession> getAllSessions() {
    final values = _box.values.cast<Map>().toList();
    return values.map((map) => WorkSession.fromMap(map)).toList();
  }
}
