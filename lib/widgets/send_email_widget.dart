import 'package:flutter/material.dart';
import 'package:flutter_blog_query/models/send_options.dart';
import 'package:flutter_blog_query/providers/filtered_articles_provider.dart';
import 'package:flutter_blog_query/services/mail_service.dart';
import 'package:flutter_blog_query/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendEmailWidget extends ConsumerStatefulWidget {
  const SendEmailWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendEmailWidgetState();
}

class _SendEmailWidgetState extends ConsumerState<SendEmailWidget> {
  Color _iconColor = Colors.green;
  Color _textColor = Colors.red;
  IconData _icon = Icons.check;
  String _status = "";
  bool _showDetails = false;
  bool _showLoading = false;
  bool _includeDescriptions = true;
  bool _includeTags = true;
  bool _includeDates = true;

  TextEditingController? _controller;
  String _recipient = "";

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _recipient);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: AppColors.backgroundAlternate,
        surfaceTintColor: AppColors.backgroundAlternate,
        content: Container(
            height: 450,
            width: 400,
            color: AppColors.backgroundAlternate,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Send articles by email",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontPrimary)),
              const SizedBox(height: 10),
              Text(
                  "Enter an address to send the selected ${ref.watch(filteredArticlesProvider).where((element) => element.selected).length} articles by mail.",
                  style: TextStyle(color: AppColors.fontPrimary)),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                onChanged: (val) {
                  _recipient = val;
                },
                style: TextStyle(color: AppColors.primary),
                decoration: InputDecoration(
                    labelText: "Enter email address",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.fontPrimary)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.fontPrimary))),
              ),
              const SizedBox(height: 10),
              Text("Send options",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontPrimary)),
              const SizedBox(height: 10),
              SwitchListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  value: _includeDescriptions,
                  onChanged: (val) {
                    setState(() {
                      _includeDescriptions = val;
                    });
                  },
                  title: Text("Include description",
                      style: TextStyle(color: AppColors.fontPrimary))),
              const SizedBox(height: 10),
              SwitchListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  value: _includeTags,
                  onChanged: (val) {
                    setState(() {
                      _includeTags = val;
                    });
                  },
                  title: Text("Include tags",
                      style: TextStyle(color: AppColors.fontPrimary))),
              const SizedBox(height: 10),
              SwitchListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  value: _includeDates,
                  onChanged: (val) {
                    setState(() {
                      _includeDates = val;
                    });
                  },
                  title: Text("Include date",
                      style: TextStyle(color: AppColors.fontPrimary))),
              if (_showDetails) ...[
                const SizedBox(height: 10),
                Center(
                    child: Icon(
                  _icon,
                  color: _iconColor,
                  size: 32,
                )),
                const SizedBox(height: 10),
                Center(
                    child: Text(_status,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(color: _textColor)))
              ],
              if (_showLoading) ...[
                const SizedBox(height: 10),
                const Center(child: CircularProgressIndicator())
              ]
            ])),
        actions: [
          TextButton(
              style: const ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)),
              child: Text("Cancel", style: TextStyle(color: AppColors.primary)),
              onPressed: () => Navigator.of(context).pop(false)),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.primary)),
              onPressed: () async {
                setState(() {
                  _showLoading = true;
                  _showDetails = false;
                });

                try {
                  await MailService().sendMail(
                      ref
                          .read(filteredArticlesProvider)
                          .where((element) => element.selected)
                          .toList(),
                      _recipient,
                      SendOptions(
                          _includeDescriptions, _includeTags, _includeDates));

                  _showLoading = false;
                  _showDetails = true;

                  _status = "Mail successfully sent!";
                  _icon = Icons.check;
                  _iconColor = Colors.green;
                  _textColor = Colors.green;

                  setState(() {});

                  await Future.delayed(const Duration(seconds: 1));

                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                } on Exception catch (ex) {
                  _showLoading = false;
                  _showDetails = true;

                  _status = ex.toString();
                  _icon = Icons.error;
                  _iconColor = Colors.red;
                  _textColor = Colors.red;

                  setState(() {});
                }
              },
              child:
                  Text("Send", style: TextStyle(color: AppColors.fontPrimary)))
        ]);
  }
}
