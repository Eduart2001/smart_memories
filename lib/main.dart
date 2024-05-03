import 'package:flutter/material.dart';
import 'package:smart_memories/theme/colors.dart';
import 'package:smart_memories/theme/textTheme.dart';
import 'package:get/get.dart';
import 'package:smart_memories/views/pages/homePage.dart';
import 'package:smart_memories/views/pages/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if(prefs.getBool('showOnboarding')==null){
    await prefs.setBool('showOnboarding', true);
  }
  
  bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  Future.delayed(Duration(microseconds: 1500), () => runApp(MyApp(showOnboarding: showOnboarding)));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      home: showOnboarding ? const OnBoardingPage(): const HomePage(),
    );
  }
}