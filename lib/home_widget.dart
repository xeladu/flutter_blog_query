import 'package:flutter/material.dart';
import 'package:flutter_blog_query/providers/load_articles_provider.dart';
import 'package:flutter_blog_query/utils/colors.dart';
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
      backgroundColor: Colors.black,
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: 800, maxHeight: double.infinity),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Advanced article search",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ref.watch(loadArticlesProvider).when(
                        error: (err, st) =>
                            ExceptionWidget(error: err.toString()),
                        loading: () => const LoadingWidget(
                            caption: "Preparing blog articles"),
                        data: (data) => const Expanded(
                                child:
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                  FilterWidget(),
                                  SizedBox(height: 10),
                                  Expanded(child: ArticlesWidget())
                                ])))
                  ]))),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async => await showDialog(
              barrierDismissible: true,
              context: context,
              builder: ((context) => const SendEmailWidget())),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.mail, color: Colors.white),
          label: const Text("Send by email",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}
