import 'package:flutter/material.dart';
import 'package:roman/presentation/features/home/widgets/session_summary_item.dart';

class SessionSummary extends StatelessWidget {
  const SessionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SessionSummaryItem(),SessionSummaryItem(),SessionSummaryItem(),SessionSummaryItem(),SessionSummaryItem(),],
      ),
    );
  }
}
