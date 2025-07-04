// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_memories/views/pages/onboarding.dart';
import 'package:smart_memories/views/pages/storageManager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_manager/file_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Storage(context),
            externalStorage(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(  
        child: Icon(Icons.question_mark_rounded),  
        mini: true,
        shape: CircleBorder(),
        backgroundColor: Colors.green,  
        foregroundColor: Colors.white,  
        onPressed: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("About Smart Memories"),
                content: Text("Smart Memories is a mobile application that helps you manage your photos. It allows you to view and organize your media files.\n\n\nIf you like to go again throught the tutorial press 'Yes' else press 'No' to continue."),
                actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No"),
              ),
            ],
              );
            }
          ).then((value) => {
            if(value!=null && value == true ){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnBoardingPage(),
                ),
              )
            }
          })
        },  
      ),  
    );
  }

  Widget Storage(BuildContext context) {
    return gestureDetectorMethod(
        context,
        Colors.lightBlueAccent.withOpacity(0.3),
        "assets/icons/internalDrive.svg",
        "Internal Storage");
  }

  Widget externalStorage(BuildContext context) {
    return gestureDetectorMethod(context, Colors.limeAccent.withOpacity(0.3),
        "assets/icons/externalDrive.svg", "External Storage");
  }

  Widget gestureDetectorMethod(
      BuildContext context, Color color, String asset, String name) {
    /** Creates a GestureDetector widget with specified parameters.
   This widget represents an interactive area that detects gestures.
   When tapped, it requests external storage permission and navigates to a specified screen.
   
   Parameters:
     context: The BuildContext of the widget.
     color: The background color of the container.
     asset: The path to the SVG asset to be displayed.
     name: The text to be displayed below the image.
     storage: The screen to navigate to on tap.
   
   Returns:
     GestureDetector: A GestureDetector widget configured with the specified parameters.
  */

    return Container(
      height: 200,
      width: 300,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: SvgPicture.asset(
                        asset,
                        height: 110,
                        width: 110,
                      ))),
              Text(name),
            ],
          ),
          onTap: () async {
            var status = await Permission.manageExternalStorage.request();
            final storage = await FileManager.getStorageList();
            if (name == "External Storage") {
              try {
                String s = storage[1].path;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StorageManager(base_path: s)),
                );
                //Navigator.pop(context);
              } catch (e) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("SD Card"),
                        content: Text("Not Inserted!"),
                      );
                    });
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StorageManager(base_path: storage[0].path)),
              );
              //Navigator.pop(context);
            }
          }),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Smart Memories',
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}
