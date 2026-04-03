import 'package:flutter/material.dart';

import 'custom_card_storybook.dart';

void main() {
  runApp(const StorybookDemoApp());
}

class StorybookDemoApp extends StatefulWidget {
  const StorybookDemoApp({super.key});

  @override
  State<StorybookDemoApp> createState() => _StorybookDemoAppState();
}

class _StorybookDemoAppState extends State<StorybookDemoApp> {
  ThemeData _appTheme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storybook DS — exemplo',
      theme: _appTheme,
      debugShowCheckedModeBanner: false,
      home: CustomCardStorybook(
        onThemeChanged: (ThemeData next) {
          setState(() => _appTheme = next);
        },
      ),
    );
  }
}
