import 'package:flutter/material.dart';

class SessionSummaryItem extends StatelessWidget {
  const SessionSummaryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '13.10.2025 - 24.10.2025',
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                Text('9999.99 zł', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SizedBox(height: 16,)
      ],
    );
  }
}
