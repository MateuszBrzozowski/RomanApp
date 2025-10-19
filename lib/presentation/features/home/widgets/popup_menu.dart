import 'package:flutter/material.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert_outlined, color: Colors.white, size: 32),
      onSelected: (value) {
        if (value == 1) {
          print("Opcja 1 wybrana");
        } else if (value == 2) {
          print("Opcja 2 wybrana");
        }
      },
      color: Color(0xFF2A2A2C),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Zmień imię", style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "Ustaw stawkę godzinową",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
