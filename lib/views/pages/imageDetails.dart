import 'package:flutter/material.dart';
import 'dart:io';

import 'package:smart_memories/views/components/informationTile.dart';

class ImageDetails extends StatefulWidget {
  final String imagePath;

  const ImageDetails({super.key, required this.imagePath});

  @override
  State<StatefulWidget> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  List <File>?imageDetailsList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Expanded(
        child: Column(
          children: [
            Image.file(File(widget.imagePath)),
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
