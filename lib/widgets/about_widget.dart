import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_query/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: AppColors.backgroundAlternate,
        surfaceTintColor: AppColors.backgroundAlternate,
        content: Container(
            height: 420,
            width: 350,
            color: AppColors.backgroundAlternate,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("QuickCoder Advanced Article Search",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.fontPrimary)),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      foregroundImage:
                          ExactAssetImage("images/pachirisu200x200.png"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "You like this search app? Click ",
                            style: TextStyle(color: AppColors.fontPrimary)),
                        TextSpan(
                            text: "here",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(Uri.parse(
                                    "https://quickcoder.org/custom-search-function-for-wordpress-with-flutter-and-firebase/"));
                              },
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: " and learn how you can build your own!",
                            style: TextStyle(color: AppColors.fontPrimary))
                      ]),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Follow me on ",
                            style: TextStyle(color: AppColors.fontPrimary)),
                        TextSpan(
                            text: "Medium",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(
                                    Uri.parse("https://xeladu.medium.com"));
                              },
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "!",
                            style: TextStyle(color: AppColors.fontPrimary))
                      ]),
                      textAlign: TextAlign.center),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Visit my ",
                            style: TextStyle(color: AppColors.fontPrimary)),
                        TextSpan(
                            text: "QuickCoder",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(
                                    Uri.parse("https://quickcoder.org"));
                              },
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: " blog!",
                            style: TextStyle(color: AppColors.fontPrimary))
                      ]),
                      textAlign: TextAlign.center),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Check out my ",
                            style: TextStyle(color: AppColors.fontPrimary)),
                        TextSpan(
                            text: "shop",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(
                                    Uri.parse("http://shop.quickcoder.org"));
                              },
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "!",
                            style: TextStyle(color: AppColors.fontPrimary))
                      ]),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Made with ",
                            style: TextStyle(color: AppColors.fontPrimary)),
                        TextSpan(
                            text: "❤",
                            style: TextStyle(color: AppColors.primary)),
                        TextSpan(
                            text: " by xeladu",
                            style: TextStyle(color: AppColors.fontPrimary))
                      ]),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Text("QUICKCODER",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.fontPrimary)),
                  const SizedBox(height: 20),
                  Text(
                      "Quickcoder is a place to find coding tutorials and guides about Flutter, Firebase, .NET, Azure, and many other topics.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.fontPrimary))
                ])),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppColors.primary)),
              child:
                  Text("Close", style: TextStyle(color: AppColors.fontPrimary)),
              onPressed: () => Navigator.of(context).pop(false))
        ]);
  }
}
