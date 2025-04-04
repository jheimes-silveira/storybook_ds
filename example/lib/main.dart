import 'package:example/main.reflectable.dart';
import 'package:flutter/material.dart';

import 'custom_card_storybook.dart';

void main() {
   initializeReflectable();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = ThemeData.light();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: CustomCardStorybook(onChangeTheme: (ThemeData theme) {
        setState(() {
          this.theme = theme;
        });
      }),
    );
  }
}
