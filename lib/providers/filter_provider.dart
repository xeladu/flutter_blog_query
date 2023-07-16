import 'package:flutter_blog_query/models/filter_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = StateProvider<FilterOptions>((ref) {
  return FilterOptions({});
});
