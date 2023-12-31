import 'package:flutter/material.dart';
import 'package:flutter_blog_query/utils/colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? caption;

  const LoadingWidget({
    this.caption,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Center(child: CircularProgressIndicator()),
      if (caption != null) ..._addCaption()
    ]);
  }

  List<Widget> _addCaption() {
    return <Widget>[
      const SizedBox(height: 10),
      Center(
          child: Text(caption!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontPrimary)))
    ];
  }
}
