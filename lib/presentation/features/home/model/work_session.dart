class WorkSession {
  final DateTime start;
  final DateTime end;
  final double hours;
  final double earned;

  WorkSession({
    required this.start,
    required this.end,
    required this.hours,
    required this.earned,
  });

  Map<String, dynamic> toMap() => {
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
    'hours': hours,
    'earned': earned,
  };

  factory WorkSession.fromMap(Map map) => WorkSession(
    start: DateTime.parse(map['start']),
    end: DateTime.parse(map['end']),
    hours: map['hours'],
    earned: map['earned'],
  );

  @override
  String toString() {
    return 'WorkSession{start: $start, end: $end, hours: $hours, '
        'earned: $earned}';
  }
}
