import 'package:flutter/material.dart';

import '../home_widget.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickCoder Advanced Article Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 73, 115)),
          useMaterial3: true),
      home: const HomeWidget(),
    );
  }
}
