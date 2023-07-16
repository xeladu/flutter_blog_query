import 'package:flutter_blog_query/models/rss_feed_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final articlesProvider = StateProvider<List<RssFeedItem>>((ref) {
  return <RssFeedItem>[];
});
