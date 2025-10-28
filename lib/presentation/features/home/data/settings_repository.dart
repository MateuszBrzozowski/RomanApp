import 'package:hive/hive.dart';

class SettingsRepository {
  final _box = Hive.box('settingsBox');

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

  void setStartTime(DateTime? time) {
    if (time == null) {
      _box.delete('startTime');
      return;
    }
    _box.put('startTime', time.toIso8601String());
  }

  DateTime? getStartTime() {
    final time = _box.get('startTime');
    if (time == null) {
      return null;
    }
    return DateTime.parse(time);
  }
}