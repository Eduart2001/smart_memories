import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_memories/controllers/organiserController.dart';
import 'package:smart_memories/views/pages/gallery.dart';
class SplashScreen extends StatefulWidget {
  final FieldProvider fP;
  final List<FileSystemEntity> entities;

  const SplashScreen(
      {super.key,
      required this.fP,
      required this.entities,});
  @override

  _SplashScreenState createState() => _SplashScreenState(fP,entities);
}


class _SplashScreenState extends State<SplashScreen> {
  final FieldProvider fP;
  final List<FileSystemEntity> entities;
  _SplashScreenState(this.fP,this.entities);
  @override
  void initState() {
    super.initState();
    _computeStuff().then((_) {
      Navigator.of(context).pop();
    });
  }

  Future<void> _computeStuff() async {
    await fP.submitFormController(entities);
    // Simulating computation time with a Future delay
    return Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [ FlutterLogo(size: 200),
          Text("This operation may take some time since, we are computing : ${widget.entities.length} images")],
        )
        
      
      ),
    );
  }
}