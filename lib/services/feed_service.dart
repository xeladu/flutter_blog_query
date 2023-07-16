import 'package:flutter_blog_query/models/rss_feed_dto.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class FeedService {
  final String cloudFunctionsUrl =
      "https://redirecttoquickcoderfeed-a5r726rr3q-ew.a.run.app";

  Future<(List<RssFeedItem>, Set<String>)> getFeedItems() async {
    final feed = await _downloadFeed();
    final items = _adjustFeedContent(feed);

    return items;
  }

  Future<RssFeed> _downloadFeed() async {
    try {
      final headers = <String, String>{};
      headers["accept"] = "application/json";
      headers["content-type"] = "application/json";
      headers["Access-Control-Allow-Origin"] = "*";

      final response =
          await http.get(Uri.parse(cloudFunctionsUrl), headers: headers);

      if (response.statusCode != 200) {
        throw Exception("${response.statusCode}: ${response.body}");
      }

      return RssFeed.parse(response.body);
    } on Exception catch (ex) {
      throw Exception("Could not download and parse blog feed!\r\n$ex");
    }
  }

  (List<RssFeedItem>, Set<String>) _adjustFeedContent(RssFeed feed) {
    final result = <RssFeedItem>[];
    if (feed.items == null) {
      return (result, {});
    }

    final allCategories = <String>{};

    for (var element in feed.items!) {
      var categories = <String>[];
      var description = "";
      Uri? link;
      DateTime? date;

      if (element.title == null) {
        continue;
      }

      if (element.categories != null) {
        categories = element.categories!
            .where((element) =>
                !element.value.toLowerCase().contains("uncategorized"))
            .map((cat) => cat.value)
            .toList();
        allCategories.addAll(categories);
      }

      if (element.description != null) {
        var first = element.description!.indexOf("<p>") + 3;
        var second = element.description!.indexOf("</p>");
        description = element.description!.substring(first, second);
      }

      if (element.link != null) {
        link = Uri.parse(element.link!);
      }

      date = element.pubDate;

      result.add(
          RssFeedItem(element.title!, description, link, categories, date));
    }

    return (result, allCategories);
  }
}
