// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_memories/views/pages/externalStorageManager.dart';
import 'package:smart_memories/views/pages/gallery.dart';
import 'package:smart_memories/views/pages/internalStorageManager.dart';
import 'package:permission_handler/permission_handler.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_HomePageState();
  
}

class _HomePageState extends State<HomePage>{
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            internalStorage(context),
            //externalStorage(context),
          ],
        ),
      ),
    );
    }

 GestureDetector externalStorage(BuildContext context) {
   return GestureDetector(
            child: Container(
              
              height: 200,
              width: 300,
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(15),
                color: Colors.limeAccent.withOpacity(0.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child:Padding(
                      padding: EdgeInsets.all(30.0),
                      child:SvgPicture.asset("assets/icons/externalDrive.svg",height: 110,width: 110,)
                    )
                  ),
                  Text("External Storage"),
                ],
              ),
            ),
            onTap: ()async{
              //var status= await Permission.manageExternalStorage.request();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExternalStorage()),
                );
            }
          );
 }

 GestureDetector internalStorage(BuildContext context) {
   return GestureDetector(
            child:Container(
              
              height: 200,
              width: 300,
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.lightBlueAccent.withOpacity(0.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child:Padding(
                      padding: EdgeInsets.all(30.0),
                      child:SvgPicture.asset("assets/icons/internalDrive.svg",height: 110,width: 110,)
                    )
                  ),
                  Text("Internal Storage")],
                
              ),
              
            ),
            onTap: ()async{
              var status= await Permission.manageExternalStorage.request();
                if(status.isGranted){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InternalStorage()),
                  );
                }


            },
          );
    }
  }
  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Smart Memories',
        style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    );
  }
