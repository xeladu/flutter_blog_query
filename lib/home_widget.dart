import 'package:flutter/material.dart';
import 'package:flutter_blog_query/providers/load_articles_provider.dart';
import 'package:flutter_blog_query/utils/colors.dart';
import 'package:flutter_blog_query/widgets/about_widget.dart';
import 'package:flutter_blog_query/widgets/articles_widget.dart';
import 'package:flutter_blog_query/widgets/filter_widget.dart';
import 'package:flutter_blog_query/widgets/loading_widget.dart';
import 'package:flutter_blog_query/widgets/exception_widget.dart';
import 'package:flutter_blog_query/widgets/send_email_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 1200, maxHeight: double.infinity),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            color: AppColors.background,
                            constraints: const BoxConstraints(minWidth: 800),
                            child: Text("Advanced article search",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: AppColors.fontPrimary,
                                    fontWeight: FontWeight.bold))),
                        Container(height: 10, color: AppColors.background),
                        ref.watch(loadArticlesProvider).when(
                            error: (err, st) =>
                                ExceptionWidget(error: err.toString()),
                            loading: () => const LoadingWidget(
                                caption: "Preparing blog articles"),
                            data: (data) => Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      const FilterWidget(),
                                      Container(
                                          height: 10,
                                          color: AppColors.background),
                                      const Expanded(child: ArticlesWidget())
                                    ])))
                      ]))),
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                  extendedIconLabelSpacing: 8,
                  extendedPadding: const EdgeInsets.fromLTRB(16, 0, 24, 0),
                  onPressed: () async => await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: ((context) => const AboutWidget())),
                  backgroundColor: AppColors.primary,
                  icon: Icon(Icons.info, color: AppColors.fontPrimary),
                  label: Text("About",
                      style: TextStyle(
                          color: AppColors.fontPrimary,
                          fontWeight: FontWeight.bold))),
            )),
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async => await showDialog(
              barrierDismissible: true,
              context: context,
              builder: ((context) => const SendEmailWidget())),
          backgroundColor: AppColors.primary,
          icon: Icon(Icons.mail, color: AppColors.fontPrimary),
          label: Text("Send by email",
              style: TextStyle(
                  color: AppColors.fontPrimary, fontWeight: FontWeight.bold))),
    );
  }
}
