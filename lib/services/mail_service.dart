import 'dart:convert';

import 'package:flutter_blog_query/models/rss_feed_dto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MailService {
  final String _cloudFunctionEndpoint =
      "https://sendemailwithbrevoapi-a5r726rr3q-ew.a.run.app";

  Future sendMail(List<RssFeedItem> articlesToSend, String recipient) async {
    if (articlesToSend.isEmpty) {
      throw Exception(
          "You did not select any articles. To send an email, you need to select at least one article!");
    }

    if (recipient.isEmpty) {
      throw Exception("Please enter a valid email address!");
    }

    if (DateTime.now().day == 1) {
      throw Exception(
          "Could not send an email because the daily email limit is reached. Please try again tomorrow!");
    }

    final content = _buildContent(articlesToSend, recipient);

    final headers = <String, String>{};
    headers["accept"] = "application/json";
    headers["content-type"] = "application/json";

    try {
      var resp = await http.post(Uri.parse(_cloudFunctionEndpoint),
          headers: headers, body: jsonEncode(content));

      if (resp.statusCode != 201 && resp.statusCode != 202) {
        throw Exception("${resp.statusCode}: ${resp.body}");
      }
    } on Exception {
      rethrow;
    }
  }

  Map<String, dynamic> _buildContent(
      List<RssFeedItem> articlesToSend, String recipient) {
    final res = <String, dynamic>{};

    res["sender"] = <String, dynamic>{};
    res["sender"]["name"] = "xeladu";
    res["sender"]["email"] = "xeladu@quickcoder.org";

    res["to"] = <Map<String, dynamic>>[];
    res["to"].add(<String, dynamic>{});
    res["to"].first["email"] = recipient;

    res["subject"] = "QuickCoder Article Search Results";
    res["htmlContent"] =
        "<html><head></head><body>${_insertContent(articlesToSend)}</body></html>";

    return res;
  }

  String _insertContent(List<RssFeedItem> articlesToSend) {
    String content = "";
    content = _addHeader(content);
    content = _addLinks(content, articlesToSend);
    content = _addFooter(content);

    return content;
  }

  String _addLinks(String content, List<RssFeedItem> articlesToSend) {
    return "$content<p><h1>Hey there,</h1>thank you for visiting my blog! Here are your requested results.</p>${articlesToSend.map((article) {
      return "<p>🔗 <a href=\"${article.link.toString()}\">${article.title}</a><br />${article.description}<br />📑 ${article.categories!.join(", ")}<br />⌚ ${DateFormat("dd. MMMM yyyy").format(article.date!)}";
    }).join("")}";
  }

  String _addHeader(String content) {
    const xeladuImage =
        "https://i0.wp.com/quickcoder.org/wp-content/uploads/2023/01/pachirisu200x200.png?resize=75%2C75&ssl=1";

    return "$content<p align=\"center\"><img src=\"$xeladuImage\" /></p>";
  }

  String _addFooter(String content) {
    return "$content<br /><br /><p align=\"center\">Follow me on <a href=\"https://xeladu.medium.com\">Medium</a>!<br />Visit <a href=\"https://quickcoder.org\">my QuickCoder blog</a>!<br />Check out <a href=\"https://xeladu.gumroad.com\">my shop</a>!</p><p align=\"center\">Made with ❤ by xeladu</p><p align=\"center\"><strong>QUICKCODER</strong></p><p align=\"center\">Quickcoder is a place to find coding tutorials and guides about Flutter, Firebase, .NET, Azure, and many other topics.</p>";
  }
}
