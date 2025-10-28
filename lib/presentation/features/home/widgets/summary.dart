import 'package:flutter/material.dart';
import 'package:roman/presentation/features/home/logic/work_controller.dart';
import 'package:roman/presentation/features/home/widgets/summary_item.dart';

class Summary extends StatelessWidget {
  final WorkController workController;

  const Summary({super.key, required this.workController});

  @override
  Widget build(BuildContext context) {
    print('Work today:  ${workController.getEarnedToday()}');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryItem(
            label: 'Dzisiaj',
            value: workController.getEarnedToday() ?? '0.00',
            showDivider: true,
          ),
          SummaryItem(
            label: 'W tym tygodniu',
            value: workController.getEarnedThisWeek() ?? '0.00',
          ),
          SummaryItem(
            label: 'W poprzednim tygodniu',
            value: workController.getEarnedLastWeek() ?? '0.00',
            showDivider: true,
          ),
          SummaryItem(
            label: 'W tym miesiącu',
            value: workController.getEarnedThisMonth() ?? '0.00',
          ),
          SummaryItem(
            label: 'W poprzednim miesiącu',
            value: workController.getEarnedLastMonth() ?? '0.00',
            showDivider: true,
          ),
          SummaryItem(
            label: 'W tym roku',
            value: workController.getEarnedThisYear() ?? '0.00',
          ),
          SummaryItem(
            label: 'W poprzednim roku',
            value: workController.getEarnedLastYear() ?? '0.00',
          ),
        ],
      ),
    );
  }
}
