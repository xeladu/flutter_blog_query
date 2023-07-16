import 'package:flutter_blog_query/models/filter_options.dart';
import 'package:flutter_blog_query/models/rss_feed_dto.dart';
import 'package:flutter_blog_query/providers/articles_provider.dart';
import 'package:flutter_blog_query/providers/filter_provider.dart';
import 'package:flutter_blog_query/services/feed_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadArticlesProvider =
    FutureProvider<(List<RssFeedItem>, Set<String>)>((ref) async {
  final data = await FeedService().getFeedItems();

  ref.read(articlesProvider.notifier).state = data.$1;
  ref.read(filterProvider.notifier).state = FilterOptions(data.$2);

  return data;
});
