import 'package:flutter/material.dart';
import 'package:flutter_blog_query/providers/filter_provider.dart';
import 'package:flutter_blog_query/providers/filtered_articles_provider.dart';
import 'package:flutter_blog_query/utils/colors.dart';
import 'package:flutter_blog_query/widgets/date_widget.dart';
import 'package:flutter_blog_query/widgets/exception_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'tag_widget.dart';

class ArticlesWidget extends ConsumerStatefulWidget {
  const ArticlesWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticlesWidgetState();
}

class _ArticlesWidgetState extends ConsumerState<ArticlesWidget> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(filteredArticlesProvider);
    final itemsCount = items.length;
    final selectedCount = items.where((element) => element.selected).length;

    if (items.isEmpty) {
      return ExceptionWidget(
          error: "No data found!",
          offerFilterReset: ref.read(filterProvider).isAnyFilterActive());
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        color: AppColors.background,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Article list ($itemsCount results, $selectedCount selected)",
              style: TextStyle(
                  color: AppColors.fontSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          TextButton(
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent)),
              child: Text("Select all articles",
                  style: TextStyle(color: AppColors.primary, fontSize: 14)),
              onPressed: () {
                setState(() {
                  items
                      .where((item) => !item.selected)
                      .forEach((element) => element.toggleSelected());
                });
              }),
        ]),
      ),
      Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return CheckboxListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: index.isEven
                        ? AppColors.background
                        : AppColors.backgroundAlternate,
                    key: ValueKey(item.title),
                    value: item.selected,
                    onChanged: (val) {
                      setState(() {
                        item.toggleSelected();
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(0)),
                                overlayColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) => states
                                                .contains(MaterialState.hovered)
                                            ? AppColors.primary
                                            : AppColors.fontPrimary),
                              ),
                              onPressed: () async => await launchUrl(
                                  items[index].link!,
                                  mode: LaunchMode.platformDefault,
                                  webViewConfiguration:
                                      const WebViewConfiguration(),
                                  webOnlyWindowName: "_blank"),
                              child: Text(items[index].title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                          Text(items[index].description!,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.fontSecondary)),
                          const SizedBox(height: 6),
                          Wrap(children: [
                            DateWidget(date: items[index].date!),
                            TagWidget(tags: items[index].categories!.toSet())
                          ])
                        ]));
              },
              itemCount: items.length))
    ]);
  }
}
