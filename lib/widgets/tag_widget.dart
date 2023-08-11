import 'package:flutter/material.dart';
import 'package:flutter_blog_query/utils/colors.dart';

class TagWidget extends StatelessWidget {
  final Set<String> tags;
  const TagWidget({Key? key, required this.tags}) : super(key: key);

  @override
  build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.local_offer, size: 16, color: AppColors.fontSecondary),
              const SizedBox(width: 6),
              ...tags.map((tag) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(tag,
                      style: TextStyle(
                          fontSize: 14, color: AppColors.fontSecondary))))
            ]));
  }
}
