import 'package:flutter/material.dart';
import 'views/pages/home_page.dart';
import 'utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // navigatorKey: Catcher.navigatorKey,
      theme: FeedReaderTheme.feedReaderTheme,
      home:HomeScreen(),
    );
  }
}

