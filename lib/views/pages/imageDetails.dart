import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_memories/models/imageDetailsGetter.dart';

class ImageDetails extends StatefulWidget {
  final File imageFile;
  const ImageDetails({Key? key, required this.imageFile}) : super(key: key);

  @override
  _ImageDetailsState createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  Map<String, String> imageDetailsList = {};

  @override
  void initState() {
    super.initState();
    getImageDetails();
  }

  Future<void> getImageDetails() async {
    Map details = await imageExifDetailsGetter(widget.imageFile) as Map;
    setState(() {
      imageDetailsList = details.map((key, value) => MapEntry(key.toString(), value.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Details'),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Image.file(
            widget.imageFile,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: imageDetailsList.keys.length,
              itemBuilder: (context, index) {
                String key = imageDetailsList.keys.elementAt(index);
                return ListTile(
                  title: Text('$key: ${imageDetailsList[key]}'),
                );
              },
            ),
          ),
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



