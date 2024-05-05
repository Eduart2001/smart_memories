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
  Map<String, String> imageDetailsList = {};
  void imageDetailsListUpdate(Map<String, String> details) {
    imageDetailsList = details;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    imageDetailsMap(imageDetailsListUpdate, widget.imageFile);
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Image.file(widget.imageFile,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  0.6), // Utilisez widget.imageFile directement
          const Divider(),
          InformationTile(category: 'Image Details', details: imageDetailsList),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Image Details'),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
