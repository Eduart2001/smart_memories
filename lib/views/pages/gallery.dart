// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:smart_memories/controllers/galleryController.dart';
import 'package:smart_memories/views/pages/imageDetails.dart';
import '../../models/imageRenameModel.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<StatefulWidget> createState() =>_GalleryState();
}

class _GalleryState extends State<Gallery>{
 List <File>?imageFileList=[];

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: appBar(),
    //  floatingActionButton: testButton(), // pour tester le rename décommenter ce boutton et commencer celui d'en bas
     floatingActionButton: floatingActionButton(),
     body: Center(
       child : Column(
         children: <Widget>[
           Expanded(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: GridView.builder(
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 3,
                   ),
                   itemCount: imageFileList!.length,
                   itemBuilder: (BuildContext context, int index){
                     File f = imageFileList![index];
                     return GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => ImageDetails(imageFile: f),
                           ),
                         );
                       },
                       child: Image.file(
                         f,
                         fit: BoxFit.cover,
                       ),
                     );
                   }
               ),
             ),
           ),
         ],
       ),
     ),
   );
 }


 void updateGallery(File image) {
   setState(() {
     imageFileList!.add(image);
   });
 }

  AppBar appBar() {
    return AppBar(
      title: Text('Gallery'),
      elevation: 0.0,
      centerTitle: true,
    );
  }

 FloatingActionButton testButton() {
  return FloatingActionButton(
     onPressed: () {
     },
     tooltip: "Add a photo",
     child: Icon(Icons.add_photo_alternate_outlined),
   );
 }

 FloatingActionButton floatingActionButton() {
   return FloatingActionButton(
     onPressed: () {
       pickImage(updateGallery);
     },
     tooltip: "Add a photo",
     child: Icon(Icons.add_photo_alternate_outlined),
   );
 }
}