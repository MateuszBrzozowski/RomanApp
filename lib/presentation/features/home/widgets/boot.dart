import 'package:flutter/material.dart';

class Boot extends StatelessWidget {
  const Boot({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Witaj, Roman',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Text(
            'Rozpocznij kolejną sesje!',
            style: TextStyle(color: Colors.grey[400]),
          ),
          Text('Obecna sesja'),
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
                    'od 20.06.2023 (45h)',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                  Text('9999.99 zł', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SizedBox(height: 36),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 2 / 3,
              height: 50,
              child: FilledButton(
                onPressed: () {},
                child: Text("Start", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
