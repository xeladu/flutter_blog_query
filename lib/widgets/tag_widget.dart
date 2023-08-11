import 'package:flutter/material.dart';

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
              const Icon(Icons.local_offer, size: 16, color: Colors.white38),
              const SizedBox(width: 6),
              ...tags.map((tag) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(tag,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.white38))))
            ]));
  }
}
