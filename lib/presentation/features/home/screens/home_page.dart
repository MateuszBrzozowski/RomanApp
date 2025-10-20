import 'package:flutter/material.dart';
import 'package:roman/presentation/features/home/data/work_repository.dart';
import 'package:roman/presentation/features/home/widgets/boot.dart';
import 'package:roman/presentation/features/home/widgets/box.dart';
import 'package:roman/presentation/features/home/widgets/popup_menu.dart';
import 'package:roman/presentation/features/home/widgets/session_summary.dart';
import 'package:roman/presentation/features/home/widgets/summary.dart';

import '../logic/work_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WorkController controller;

  @override
  void initState() {
    controller = WorkController(WorkRepository());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenu(
            controller: controller,
            onRefresh: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 36),
            Box(
              child: Boot(
                controller: controller,
                onRefresh: () {
                  setState(() {});
                },
              ),
            ),
            Box(title: "Podsumowanie", child: Summary()),
            Box(title: 'Ostatnie sesje', child: SessionSummary()),
          ],
        ),
      ),
    );
  }
}
