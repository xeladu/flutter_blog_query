import 'dart:convert';

import 'package:flutter_blog_query/models/rss_feed_dto.dart';
import 'package:http/http.dart' as http;

class FeedService {
  final String articleEndpoint =
      "https://quickcoder.org/wp-json/wp/v2/posts?per_page=100&_fields=title,excerpt,date,link,status,type,tags";
  final String categoryEndpoint =
      "https://quickcoder.org/wp-json/wp/v2/tags?per_page=100&_fields=id,name&orderby=id";

  Future<(List<RssFeedItem>, Set<String>)> getFeedItems() async {
    final articles = await _downloadArticles();
    final categories = await _downloadCategories();
    final items = _adjustFeedContent(articles, categories);

    return items;
  }

  Future _downloadCategories() async {
    try {
      final headers = <String, String>{};
      headers["accept"] = "application/json";

      final response =
          await http.get(Uri.parse(categoryEndpoint), headers: headers);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode}: ${response.body}");
      }
      return _parseJsonMapToMap(jsonDecode(response.body));
    } on Exception catch (ex) {
      throw Exception("Could not download and parse blog feed!\r\n$ex");
    }
  }

  Future _downloadArticles() async {
    try {
      final headers = <String, String>{};
      headers["accept"] = "application/json";

      final response =
          await http.get(Uri.parse(articleEndpoint), headers: headers);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode}: ${response.body}");
      }
      return _parseJsonMapToMap(jsonDecode(response.body));
    } on Exception catch (ex) {
      throw Exception("Could not download and parse blog feed!\r\n$ex");
    }
  }

  dynamic _parseJsonMapToMap(dynamic data) {
    if (data is Map) {
      return Map.fromEntries(
        data.entries.map(
          (e) => MapEntry(
            e.key,
            _parseJsonMapToMap(e.value),
          ),
        ),
      );
    }
    if (data is List) {
      return List.from(
        data.map(
          (e) => _parseJsonMapToMap(e),
        ),
      );
    }
    return data;
  }

  (List<RssFeedItem>, Set<String>) _adjustFeedContent(
      List<dynamic> articles, List<dynamic> categories) {
    final result = <RssFeedItem>[];
    if (articles.isEmpty) {
      return (result, {});
    }

    final allCategories = <String>{};

    for (var element in articles) {
      if (element["type"] != "post") {
        continue;
      }

      if (element["status"] != "publish") {
        continue;
      }

      final String title =
          (element["title"] as Map<dynamic, dynamic>)["rendered"];

      final String description =
          ((element["excerpt"] as Map<dynamic, dynamic>)["rendered"] as String)
              .replaceAll("<p>", "")
              .replaceAll("</p>", "")
              .replaceAll("\r\n", "")
              .replaceAll("\n", "");

      final Uri link = Uri.parse(element["link"]);

      final DateTime date = DateTime.parse(element["date"]);

      final articleCategories = <String>[];
      for (var item in (element["tags"] as List<dynamic>)) {
        articleCategories.add(categories.firstWhere((category) =>
            (category as Map<dynamic, dynamic>)["id"] == item)["name"]);
      }

      result
          .add(RssFeedItem(title, description, link, articleCategories, date));

      allCategories.addAll(articleCategories);
    }

    return (result, allCategories);
  }
}
