import 'package:flutter/material.dart';
import 'package:smart_memories/theme/colors.dart';
import 'package:smart_memories/theme/textTheme.dart';

import 'package:smart_memories/views/pages/homePage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Memories',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primarySwatch: Colors.purple,
        textTheme: textTheme,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primarySwatch: Colors.purple,
        textTheme: textTheme,
        colorScheme: darkColorScheme,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
