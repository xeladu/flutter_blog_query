import 'dart:convert';

import 'package:flutter_blog_query/models/rss_feed_dto.dart';
import 'package:http/http.dart' as http;

class FeedService {
  // how many records are to be fetched with every request (1-100)
  final int _pageSizeToQuery = 100;

  // this value is set after the first request when the REST API tells us
  // how many article pages there are
  // https://developer.wordpress.org/rest-api/using-the-rest-api/pagination/
  int _totalArticlePageCountReturnedByWordPress = 0;

  // the name of the header field that contains the information from the
  // REST API how many pages with the given page size there are
  final String _pageCountHeaderField = "x-wp-totalpages";

  final String _articleEndpoint =
      "https://quickcoder.org/wp-json/wp/v2/posts?page=%page%&per_page=%pageSize%&_fields=title,excerpt,date,link,status,type,tags";
  final String _categoryEndpoint =
      "https://quickcoder.org/wp-json/wp/v2/tags?per_page=%pageSize%&_fields=id,name&orderby=id";

  Future<(List<RssFeedItem>, Set<String>)> getFeedItems() async {
    var pageCounter = 0;
    final allArticles = [];
    var newArticles = [];

    // get articles from all pages
    do {
      pageCounter++;
      newArticles = (await _downloadArticlePage(pageCounter)) as List;
      allArticles.addAll(newArticles);
    } while (pageCounter < _totalArticlePageCountReturnedByWordPress);

    final categories = await _downloadCategories();
    final items = _adjustFeedContent(allArticles, categories);

    return items;
  }

  Future _downloadCategories() async {
    try {
      final headers = <String, String>{};
      headers["accept"] = "application/json";

      final response = await http.get(
          Uri.parse(_categoryEndpoint.replaceFirst(
              "%pageSize%", _pageSizeToQuery.toString())),
          headers: headers);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode}: ${response.body}");
      }
      return _parseJsonMapToMap(jsonDecode(response.body));
    } on Exception catch (ex) {
      throw Exception("Could not download and parse blog feed!\r\n$ex");
    }
  }

  Future _downloadArticlePage(int page) async {
    try {
      final headers = <String, String>{};
      headers["accept"] = "application/json";

      final response = await http.get(
          Uri.parse(_articleEndpoint
              .replaceFirst("%page%", page.toString())
              .replaceFirst("%pageSize%", _pageSizeToQuery.toString())),
          headers: headers);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode}: ${response.body}");
      }

      // Find out how many article pages with the current page size there are
      _totalArticlePageCountReturnedByWordPress =
          response.headers.containsKey(_pageCountHeaderField)
              ? int.parse(response.headers[_pageCountHeaderField]!)
              : 0;

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
