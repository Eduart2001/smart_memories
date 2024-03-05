// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';


class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_GalleryState();
  
}

class _GalleryState extends State<Gallery>{
 List <XFile>?imageFileList=[];
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
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
                    return Image.file(File(imageFileList![index].path));
                  }
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            MaterialButton(
              onPressed: () => _pickImage(context),
              child: Text(
                'Add images',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  AppBar appBar(BuildContext context) {
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
  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images!.isNotEmpty) {
      imageFileList!.addAll(images);
    }
    setState(() {

    });
  }

}





