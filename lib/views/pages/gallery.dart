// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:smart_memories/controllers/galleryControler.dart';

//natif exif
//import 'package:xmp/xmp.dart';

import 'package:smart_memories/source/image-rename.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<StatefulWidget> createState() =>_GalleryState();
}

class _GalleryState extends State<Gallery>{
 List <File>?imageFileList=[];
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
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
                    return Image.file(f);
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Gallery',
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

 FloatingActionButton floatingActionButton() {
   return FloatingActionButton(
     onPressed: () => pickImage(imageFileList),
     tooltip: "Add a photo",
     child: Icon(Icons.add_a_photo_outlined),
   );
 }
}