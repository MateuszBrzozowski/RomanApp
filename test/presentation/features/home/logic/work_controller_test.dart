import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:roman/presentation/features/home/data/settings_repository.dart';
import 'package:roman/presentation/features/home/data/work_repository.dart';
import 'package:roman/presentation/features/home/logic/work_controller.dart';
import 'package:roman/presentation/features/home/model/work_session.dart';

import 'work_controller_test.mocks.dart';

@GenerateMocks([SettingsRepository, WorkRepository])
void main() {
  late WorkController controller;
  late MockSettingsRepository settingsRepo;
  late MockWorkRepository workRepo;

  var fixedNow = DateTime(2025, 11, 3, 12, 0); // Monday

  setUp(() {
    fixedNow = DateTime(2025, 11, 3, 12, 0);
    settingsRepo = MockSettingsRepository();
    workRepo = MockWorkRepository();
    when(settingsRepo.getName()).thenReturn('TestUser');
    when(settingsRepo.getHourlyRate()).thenReturn(100.0);
    when(settingsRepo.getStartTime()).thenReturn(null);
    when(workRepo.getAllSessions()).thenReturn([]);

    controller = WorkController(
      settingsRepository: settingsRepo,
      workRepository: workRepo,
    );
  });

  group('WorkController', () {
    test('Initial values are loaded from repository on creation', () {
      verify(settingsRepo.getName());
      verify(settingsRepo.getHourlyRate());
      verify(settingsRepo.getStartTime());
      expect(controller.getName(), 'TestUser');
      expect(controller.getHourlyRate(), 100.0);
      expect(controller.startTime, isNull);
    });

    test('refreshData re-loads all data from settings repository', () {
      when(settingsRepo.getName()).thenReturn('NewUser');
      when(settingsRepo.getHourlyRate()).thenReturn(200.0);
      final newStartTime = DateTime(2024, 1, 1);
      when(settingsRepo.getStartTime()).thenReturn(newStartTime);

      controller.refreshData();

      expect(controller.getName(), 'NewUser');
      expect(controller.getHourlyRate(), 200.0);
      expect(controller.startTime, newStartTime);
    });

    group('State modifications', () {
      test('setName updates name in repository', () {
        controller.setName('NewName');
        verify(settingsRepo.setName('NewName'));
      });

      test('setHourlyRate updates rate in repository and controller', () {
        controller.setHourlyRate(150.0);
        expect(controller.getHourlyRate(), 150.0);
        verify(settingsRepo.setHourlyRate(150.0));
      });

      test('startWork sets start time and saves it to repository', () {
        controller.startWork();
        expect(controller.startTime, isNotNull);
        verify(settingsRepo.setStartTime(any));
      });

      test('stopWork does nothing if work has not started', () {
        final session = controller.stopWork();
        expect(session, isNull);
        verifyNever(workRepo.addSession(any));
      });

      test(
        'stopWork creates session and clears start time if work has started',
        () {
          final startTime = fixedNow.subtract(const Duration(hours: 1));
          when(settingsRepo.getStartTime()).thenReturn(startTime);
          controller.refreshData();

          final session = controller.stopWork();

          expect(session, isA<WorkSession>());
          expect(session!.start, startTime);
          expect(controller.startTime, isNull);
          verify(workRepo.addSession(session));
          verify(settingsRepo.setStartTime(null));
        },
      );

      test('startStopButton starts work if not started', () {
        controller.startStopButton();
        expect(controller.startTime, isNotNull);
        verify(settingsRepo.setStartTime(any));
      });

      test('startStopButton stops work if started', () {
        when(settingsRepo.getStartTime()).thenReturn(DateTime.now());
        controller.refreshData();

        controller.startStopButton();

        expect(controller.startTime, isNull);
        verify(workRepo.addSession(any));
        verify(settingsRepo.setStartTime(null));
      });
    });

    group('UI Getters', () {
      test('getStartTimeAsString returns "00:00" when work is not started', () {
        expect(controller.getStartTimeAsString(), '00:00');
      });

      test(
        'getElapsedHoursSinceStart returns "(0h)" when work is not started',
        () {
          expect(controller.getElapsedHoursSinceStart(), '(0h)');
        },
      );

      test(
        'getEarnedForCurrentSession returns "0.00" when work is not started',
        () {
          expect(controller.getEarnedForCurrentSession(), '0.00');
        },
      );

      test(
        'getStartTimeAsString returns formatted date when work is started',
        () {
          when(
            settingsRepo.getStartTime(),
          ).thenReturn(DateTime(2023, 4, 1, 10, 0));
          controller.refreshData();
          expect(controller.getStartTimeAsString(), '01.04.2023r.');
        },
      );
    });

    group('Earnings Calculation', () {
      test('getEarnedToday returns sum of past sessions and current session', () {
        final pastSession = WorkSession(
          start: fixedNow.subtract(const Duration(hours: 4)),
          end: fixedNow.subtract(const Duration(hours: 3)),
          hours: 1,
          earned: 100,
        );
        when(workRepo.getAllSessions()).thenReturn([pastSession]);

        final currentSessionStart = fixedNow.subtract(
          const Duration(minutes: 30),
        );
        when(settingsRepo.getStartTime()).thenReturn(currentSessionStart);
        controller.refreshData();

        final result = controller.getEarnedToday(now: fixedNow);

        // Past session: 100.0 (ignored, earned is recalculated) -> 1h * 100.0/hr = 100.0
        // Current session: 0.5 hours * 100.0/hr = 50.0
        // Total: 150.0
        expect(result, '150.00');
      });

      test('getEarnedToday returns current session', () {
        final pastSession = WorkSession(
          start: fixedNow.subtract(const Duration(hours: 13)),
          end: fixedNow.subtract(const Duration(hours: 12)),
          hours: 1,
          earned: 100,
        );
        when(workRepo.getAllSessions()).thenReturn([pastSession]);

        final currentSessionStart = fixedNow.subtract(
          const Duration(minutes: 30),
        );
        when(settingsRepo.getStartTime()).thenReturn(currentSessionStart);
        controller.refreshData();

        final result = controller.getEarnedToday(now: fixedNow);

        expect(result, '50.00');
      });

      test(
        'getEarnedToday returns sum of past sessions with current session',
        () {
          final pastSession0 = WorkSession(
            start: fixedNow.subtract(const Duration(hours: 16)),
            end: fixedNow.subtract(const Duration(hours: 12)),
            hours: 4,
            earned: 400,
          );
          final pastSession1 = WorkSession(
            start: fixedNow.subtract(const Duration(hours: 14)),
            end: fixedNow.subtract(const Duration(hours: 10)),
            hours: 4,
            earned: 400,
          );
          final pastSession2 = WorkSession(
            start: fixedNow.subtract(const Duration(hours: 12)),
            end: fixedNow.subtract(const Duration(hours: 8)),
            hours: 4,
            earned: 400,
          );
          when(
            workRepo.getAllSessions(),
          ).thenReturn([pastSession0, pastSession1, pastSession2]);

          final currentSessionStart = fixedNow.subtract(
            const Duration(hours: 1),
          );
          when(settingsRepo.getStartTime()).thenReturn(currentSessionStart);
          controller.refreshData();

          final result = controller.getEarnedToday(now: fixedNow);

          expect(result, '700.00');
        },
      );

      test('getEarnedToday returns current session', () {
        // fixedNow is Monday 2025-11-03 12:00
        when(workRepo.getAllSessions()).thenReturn([]);

        final currentSessionStart = fixedNow.subtract(const Duration(hours: 13));
        when(settingsRepo.getStartTime()).thenReturn(currentSessionStart);
        controller.refreshData();

        final result = controller.getEarnedToday(now: fixedNow);

        expect(result, '1200.00');
      });

      test('getEarnedThisWeek returns earnings from Monday to now', () {
        // fixedNow is Friday.
        fixedNow = DateTime(2025, 11, 7, 12, 0);
        final sessionYesterday = WorkSession(
          start: fixedNow.subtract(const Duration(hours: 13)),
          end: fixedNow.subtract(const Duration(hours: 12)),
          hours: 1,
          earned: 100,
        );
        final sessionLastWeek = WorkSession(
          start: fixedNow.subtract(const Duration(days: 5)),
          end: fixedNow.subtract(const Duration(days: 5, hours: -1)),
          hours: 1,
          earned: 100,
        );
        when(
          workRepo.getAllSessions(),
        ).thenReturn([sessionYesterday, sessionLastWeek]);

        final result = controller.getEarnedThisWeek(now: fixedNow);

        // Only sessionYesterday should be counted
        expect(result, '100.00');
      });

      test('getEarnedLastWeek returns earnings from previous week', () {
        // fixedNow is Monday 2025-11-03. Last week was 2025-10-27 to 2025-11-02.
        final sessionInLastWeek = WorkSession(
          start: DateTime(2025, 10, 28, 10), // Last Tuesday
          end: DateTime(2025, 10, 28, 12),
          hours: 2,
          earned: 200,
        );
        final sessionOutside = WorkSession(
          start: DateTime(2025, 10, 26, 22, 59),
          end: DateTime(2025, 10, 26, 23, 59),
          hours: 1,
          earned: 100,
        );
        when(
          workRepo.getAllSessions(),
        ).thenReturn([sessionInLastWeek, sessionOutside]);

        final result = controller.getEarnedLastWeek(now: fixedNow);

        expect(result, '200.00');
      });

      test('getEarnedThisMonth returns earnings from this month', () {
        // fixedNow is 2025-11-03. "This month" is November 2025.
        final sessionInMonth = WorkSession(
          start: DateTime(2025, 11, 2, 10),
          end: DateTime(2025, 11, 2, 12),
          hours: 2,
          earned: 200,
        );
        final sessionOutside = WorkSession(
          start: DateTime(2025, 10, 31, 10),
          end: DateTime(2025, 10, 31, 11),
          hours: 1,
          earned: 100,
        );
        when(
          workRepo.getAllSessions(),
        ).thenReturn([sessionInMonth, sessionOutside]);
        final result = controller.getEarnedThisMonth(now: fixedNow);
        expect(result, '200.00');
      });

      test('getEarnedLastMonth returns earnings from last month', () {
        // fixedNow is 2025-11-03. "Last month" is October 2025.
        final sessionInLastMonth = WorkSession(
          start: DateTime(2025, 10, 15, 10),
          end: DateTime(2025, 10, 15, 15), // 5 hours
          hours: 5,
          earned: 500,
        );
        final sessionThisMonth = WorkSession(
          start: DateTime(2025, 11, 1, 10),
          end: DateTime(2025, 11, 1, 11),
          hours: 1,
          earned: 100,
        );
        when(
          workRepo.getAllSessions(),
        ).thenReturn([sessionInLastMonth, sessionThisMonth]);
        final result = controller.getEarnedLastMonth(now: fixedNow);
        expect(result, '500.00');
      });

      test('getEarnedThisYear returns earnings from this year', () {
        final sessionThisYear = WorkSession(
          start: DateTime(2025, 1, 10, 10),
          end: DateTime(2025, 1, 10, 11),
          hours: 1,
          earned: 100,
        );
        final sessionLastYear = WorkSession(
          start: DateTime(2024, 12, 31, 23),
          end: DateTime(2025, 1, 1, 1), // Crosses year boundary
          hours: 2,
          earned: 200,
        );
        when(
          workRepo.getAllSessions(),
        ).thenReturn([sessionThisYear, sessionLastYear]);
        final result = controller.getEarnedThisYear(now: fixedNow);
        // sessionThisYear: 1h * 100 = 100
        // sessionLastYear: 1h in 2025 * 100 = 100
        // Total: 200
        expect(result, '200.00');
      });

      test('getEarnedLastYear returns earnings from last year', () {
        final sessionLastYear = WorkSession(
          start: DateTime(2024, 5, 5, 8),
          end: DateTime(2024, 5, 5, 18), // 10 hours
          hours: 10,
          earned: 1000,
        );
        final sessionThisYear = WorkSession(
          start: DateTime(2025, 1, 1, 8),
          end: DateTime(2025, 1, 1, 10),
          hours: 2,
          earned: 200,
        );
        when(
          workRepo.getAllSessions(),
        ).thenReturn([sessionLastYear, sessionThisYear]);
        final result = controller.getEarnedLastYear(now: fixedNow);
        expect(result, '1000.00');
      });

      test('returns null if total earned is zero', () {
        when(workRepo.getAllSessions()).thenReturn([]);
        when(settingsRepo.getStartTime()).thenReturn(null);
        controller.refreshData();

        final result = controller.getEarnedToday(now: fixedNow);

        expect(result, isNull);
      });
    });
  });
}
