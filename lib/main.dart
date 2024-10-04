import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'travel_preferences.dart';
import 'preference_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TravelPreferences(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: PreferencePage(),
    );
  }
}
