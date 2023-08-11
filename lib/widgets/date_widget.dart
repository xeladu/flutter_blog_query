import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;
  const DateWidget({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.calendar_month, size: 16, color: Colors.white38),
              const SizedBox(width: 6),
              Text(DateFormat("dd. MMMM yyyy").format(date),
                  style: const TextStyle(fontSize: 14, color: Colors.white38))
            ]));
  }
}
