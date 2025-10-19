import 'package:flutter/material.dart';
import 'package:roman/presentation/features/home/widgets/summary_item.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SummaryItem(label: 'Dzisiaj', value: '9999.99', showDivider: true),
          SummaryItem(label: 'W tym tygodniu', value: '9999.99'),
          SummaryItem(
            label: 'W poprzednim tygodniu',
            value: '9999.99',
            showDivider: true,
          ),
          SummaryItem(label: 'W tym miesiącu', value: '9999.99'),
          SummaryItem(
            label: 'W poprzednim miesiącu',
            value: '9999.99',
            showDivider: true,
          ),
          SummaryItem(label: 'W tym roku', value: '9999.99'),
        ],
      ),
    );
  }
}
