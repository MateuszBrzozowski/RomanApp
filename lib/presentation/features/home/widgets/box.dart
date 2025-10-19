import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final String? title;
  final Widget child;

  const Box({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
          ],
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.white12,
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2A2A2C), // ciemny szary, ale już nie czarny
                  Color(0xFF3A3A3C),
                ],
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
