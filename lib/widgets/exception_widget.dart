import 'package:flutter/material.dart';
import 'package:flutter_blog_query/providers/filter_provider.dart';
import 'package:flutter_blog_query/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExceptionWidget extends ConsumerStatefulWidget {
  final String error;
  final bool offerFilterReset;

  const ExceptionWidget(
      {required this.error, this.offerFilterReset = false, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExceptionWidgetState();
}

class _ExceptionWidgetState extends ConsumerState<ExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Center(
          child: Icon(
        Icons.error,
        size: 48,
        color: Colors.red,
      )),
      const SizedBox(height: 10),
      const Center(
          child: Text("Something went wrong",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),
      const SizedBox(height: 10),
      Center(
          child: Text(widget.error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white))),
      if (widget.offerFilterReset) ...[
        const SizedBox(height: 10),
        SizedBox(
            width: 200,
            child: TextButton(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.refresh, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text("Click to reset filters",
                      style: TextStyle(color: AppColors.primary))
                ]),
                onPressed: () {
                  setState(() {
                    ref.read(filterProvider.notifier).state =
                        ref.read(filterProvider.notifier).state.reset();
                  });
                }))
      ]
    ]);
  }
}
