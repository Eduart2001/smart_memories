import 'package:flutter/material.dart';
import 'package:smart_memories/pages/gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Smart Memories',
      debugShowCheckedModeBanner: false,
      home: Gallery(),
    );
  }
}
