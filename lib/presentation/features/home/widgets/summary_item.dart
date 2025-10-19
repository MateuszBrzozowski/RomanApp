import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final double spaceBottom;
  final bool showDivider;

  const SummaryItem({
    super.key,
    required this.label,
    required this.value,
    this.spaceBottom = 16,
    this.showDivider = false,
  });

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
                Text('$label:', style: TextStyle(color: Colors.grey[400])),
                Text('$value zł', style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
        SizedBox(height: spaceBottom),
        if (showDivider) ...[
          Divider(),
          SizedBox(height: spaceBottom),
        ]
      ],
    );
  }
}
