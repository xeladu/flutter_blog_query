import 'package:flutter/material.dart';
import 'package:flutter_blog_query/widgets/app_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: AppWidget()));
}
