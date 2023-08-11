import 'package:flutter/material.dart';
import 'package:flutter_blog_query/utils/colors.dart';
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
              Icon(Icons.calendar_month,
                  size: 16, color: AppColors.fontSecondary),
              const SizedBox(width: 6),
              Text(DateFormat("dd. MMMM yyyy").format(date),
                  style:
                      TextStyle(fontSize: 14, color: AppColors.fontSecondary))
            ]));
  }
}
