import 'package:flutter_blog_query/models/rss_feed_dto.dart';
import 'package:flutter_blog_query/providers/articles_provider.dart';
import 'package:flutter_blog_query/providers/filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredArticlesProvider = Provider<List<RssFeedItem>>((ref) {
  final allArticles = ref.watch(articlesProvider);
  final filterOptions = ref.watch(filterProvider);

  final activeFilters = filterOptions.categoryFilterStates.entries
      .where((element) => element.value)
      .toList();
  final filteredArticles = allArticles
      .where((element) => activeFilters
          .any((filter) => element.categories!.contains(filter.key)))
      .toList();

  return filterOptions.searchText.isEmpty
      ? filteredArticles
      : filteredArticles
          .where((element) =>
              element.title
                  .toLowerCase()
                  .contains(filterOptions.searchText.toLowerCase()) ||
              element.description!
                  .toLowerCase()
                  .contains(filterOptions.searchText.toLowerCase()))
          .toList();
});
