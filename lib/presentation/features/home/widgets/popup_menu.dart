import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roman/presentation/features/home/logic/work_controller.dart';

class PopupMenu extends StatefulWidget {
  final WorkController controller;
  final VoidCallback onRefresh;

  const PopupMenu({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert_outlined, color: Colors.white, size: 32),
      onSelected: (value) {
        if (value == 1) {
          _showChangeNameDialog();
        } else if (value == 2) {
          _showChangeHourlyRateDialog();
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

  void _showChangeNameDialog() {
    final TextEditingController textController = TextEditingController(
      text: widget.controller.getName(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2C),
          title: const Text(
            "Zmień imię",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: textController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Wpisz nowe imię",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Anuluj", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                widget.controller.setName(textController.text.trim());
                Navigator.pop(context);
                widget.onRefresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Zmieniono imię na ${widget.controller.getName()}",
                    ),
                  ),
                );
              },
              child: const Text("Zapisz", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showChangeHourlyRateDialog() {
    final TextEditingController textController = TextEditingController(
      text: widget.controller.getHourlyRate().toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2C),
          title: const Text(
            "Zmień stawke godzinową",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: textController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              hintText: "Wpisz stawkę godzinową",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Anuluj", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                final input = textController.text.trim();
                if (input.isEmpty) return;
                final parsed = double.tryParse(input);
                if (parsed == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Podaj poprawną liczbę")),
                  );
                  return;
                }
                widget.controller.setHourlyRate(parsed);
                Navigator.pop(context);
                widget.onRefresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Zmieniono stawkę na ${parsed.toStringAsFixed(2)} zł/h",
                    ),
                  ),
                );
              },
              child: const Text("Zapisz", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
