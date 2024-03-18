import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:smart_memories/views/components/informationTile.dart';
import 'package:smart_memories/controllers/imageDetailsController.dart';


class ImageDetails extends StatefulWidget {
  final File imageFile;
  const ImageDetails({super.key, required this.imageFile});
  
  
  
  @override
  State<StatefulWidget> createState() => _ImageDetailsState();
}


class _ImageDetailsState extends State<ImageDetails> {
  List <Map<String,String>>?imageDetailsList=[];
  void imageDetailsListUpdate(Map<String,String>details){
    setState(() {
      imageDetailsList!.add(details);
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(),
      body: Expanded(
        child: Column(
          children: [
            Image.file(widget.imageFile), // Utilisez widget.imageFile directement
            const Divider(),
            ListView(
              children: const [ 
                //InformationTile(category: 'category', details: null),
              ],
              //todo: Lister toutes les propriétés de la photo dans le ImageDetailsController
            )
          ],
        ),
      ),
    );
  }
  AppBar appBar() {
    return AppBar(
      title: Text('Image Details'),
      elevation: 0.0,
      centerTitle: true,
    );
  }
}


